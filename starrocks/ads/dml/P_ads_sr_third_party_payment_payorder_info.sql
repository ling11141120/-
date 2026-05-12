-- =====================================================================================
-- 表2-主SQL: 插入订单表数据
-- 说明: 曝光取最近4天数据，解决跨天曝光问题（如23:59曝光，次日0:02下单）
-- 优化: zffs_list从ID列表转换为渠道名称列表，关联三方渠道表
-- =====================================================================================
insert into ads.ads_sr_third_party_payment_payorder_info
with payorder_base as (
    select a.dt
          ,a.product_id
          ,a.user_id
          ,a.order_id
          ,a.create_time
          ,a.subpay_type
          ,lag(a.subpay_type) over(partition by a.product_id, a.user_id order by a.create_time) as last_subpay_type
          ,a.corever2 as core
          ,case when a.mt = 1 then 'iOS' when a.mt = 4 then 'Android' else '其他' end as mt
          ,a.shop_item
          ,a.package_id
          ,a.sensors_data
          ,get_json_int(a.cooorder_extinfo, '$.SubscribeStatus') as subscribe_status
    from ads.ads_trade_user_payorder_view a
    where a.test_flag = 0
      and a.dt = '${bf_1_dt}'
)
-- 曝光数据(保留原始zffs_id_list用于后续转换)
,exposure_data as (
    select if(app_product_id = 0, product_id, app_product_id) as product_id
          ,coalesce(identity_user_id, login_id) as user_id
          ,event_tm
          ,substring_index(zffs_id_list, ',', 3) as zffs_id_list  -- 原始ID列表
    from ads.ads_sensors_production_rechargeexposure_view
    where dt >= date_sub('${bf_1_dt}', interval 3 day)
      and dt <= '${bf_1_dt}'
      and element_id not in ('100647', '100651', '100107')
      and if(app_product_id = 0, product_id, app_product_id) is not null
      and coalesce(identity_user_id, login_id) is not null
      and zffs_id_list is not null
      and zffs_id_list != ''
)
-- 订单关联曝光
,payorder_with_exposure as (
    select a.*
          ,b.zffs_id_list
          ,row_number() over(
              partition by a.product_id, a.user_id, a.order_id
              order by b.event_tm desc
          ) as exposure_rn
    from payorder_base a
    left join exposure_data b
        on a.product_id = b.product_id
        and a.user_id = b.user_id
        and b.event_tm <= a.create_time
)
-- 取最近一条曝光
,payorder_filtered as (
    select * from payorder_with_exposure
    where exposure_rn = 1 or exposure_rn is null
)
-- 拆分zffs_id_list为多行
,zffs_explode as (
    select dt, product_id, user_id, order_id, create_time, subpay_type, last_subpay_type
          ,core, mt, shop_item, package_id, sensors_data, subscribe_status
          ,split(zffs_id_list, ',') as zffs_array
          ,array_length(split(zffs_id_list, ',')) as zffs_length
    from payorder_filtered
    where zffs_id_list is not null and zffs_id_list != ''
)
,zffs_rows as (
    select dt, product_id, user_id, order_id, create_time, subpay_type, last_subpay_type
          ,core, mt, shop_item, package_id, sensors_data, subscribe_status
          ,zffs_array[generate_series] as zffs_id
          ,generate_series as zffs_rank
    from zffs_explode
    cross join generate_series(1, zffs_length)
)
-- 三方渠道表去重（同一ID可能对应多个PaymentWay，取max值，不加status=1，历史曝光数据需要正确映射）
,third_payment_dedup as (
    select Id
          ,max(PaymentWay) as PaymentWay
    from ods.ods_tidb_readernovel_tidb_tag_center_third_payment_rate
    group by Id
)
-- 转换ID为名称
,zffs_with_name as (
    select a.dt, a.product_id, a.user_id, a.order_id, a.create_time
          ,a.subpay_type, a.last_subpay_type, a.core, a.mt, a.shop_item
          ,a.package_id, a.sensors_data, a.subscribe_status
          ,a.zffs_rank
          ,case
              when a.zffs_id = '0' and a.mt = 'iOS' then 'AppStore'
              when a.zffs_id = '0' and a.mt = 'Android' then 'GooglePlay'
              else ifnull(b.PaymentWay, a.zffs_id)
          end as zffs_name
    from zffs_rows a
    left join third_payment_dedup b on a.zffs_id = b.Id
)
-- 聚合回字符串得到zffs_list(渠道名称版)
,zffs_aggregated as (
    select dt, product_id, user_id, order_id, create_time
          ,subpay_type, last_subpay_type, core, mt, shop_item
          ,package_id, sensors_data, subscribe_status
          ,group_concat(zffs_name order by zffs_rank separator ',') as zffs_list
    from zffs_with_name
    group by dt, product_id, user_id, order_id, create_time
            ,subpay_type, last_subpay_type, core, mt, shop_item
            ,package_id, sensors_data, subscribe_status
)
-- 合并有曝光和无曝光的订单
,payorder_final as (
    select a.dt, a.product_id, a.user_id, a.order_id, a.create_time
          ,a.subpay_type, a.last_subpay_type, a.core, a.mt, a.shop_item
          ,a.package_id, a.sensors_data, a.subscribe_status
          ,b.zffs_list
    from payorder_filtered a
    left join zffs_aggregated b
        on a.dt = b.dt
        and a.product_id = b.product_id
        and a.user_id = b.user_id
        and a.order_id = b.order_id
)
-- 三方渠道表(用于zffs和last_zffs转换，同一PaymentId可能对应多个PaymentWay，取max值，需要status=1)
,third_payment_for_zffs as (
    select PaymentId
          ,max(PaymentWay) as PaymentWay
    from ods.ods_tidb_readernovel_tidb_tag_center_third_payment_rate
    where status = 1
    group by PaymentId
)
select a.dt
      ,a.product_id
      ,a.user_id
      ,a.order_id
      ,case
          when a.subpay_type = '0' and a.mt = 'iOS' then 'AppStore'
          when a.subpay_type = '0' and a.mt = 'Android' then 'GooglePlay'
          else ifnull(c1.PaymentWay, a.subpay_type)
      end as zffs
      ,case
          when a.last_subpay_type = '0' and a.mt = 'iOS' then 'AppStore'
          when a.last_subpay_type = '0' and a.mt = 'Android' then 'GooglePlay'
          else ifnull(c2.PaymentWay, a.last_subpay_type)
      end as last_zffs
      ,a.core
      ,a.mt
      ,a.shop_item
      ,a.package_id
      ,a.sensors_data
      ,a.subscribe_status
      ,b.reg_country
      ,b.user_type
      ,b.current_language2
      ,a.zffs_list  -- 已转换为渠道名称
      ,lead(a.zffs_list) over(partition by a.product_id, a.user_id order by a.create_time) as next_zffs_list
      ,now() as etl_time
from payorder_final a
left join dws.dws_user_wide_active_period_ed b
    on a.dt = b.dt
    and a.product_id = b.product_id
    and a.user_id = b.user_id
    and b.period_type = 'ctt'
left join third_payment_for_zffs c1
    on a.subpay_type = c1.PaymentId
left join third_payment_for_zffs c2
    on a.last_subpay_type = c2.PaymentId;

-- =====================================================================================
-- 表2-回填SQL1: 回填历史next_zffs_list为null的数据
-- 场景: 用户可能隔了好几天才有新订单，需要回填历史上next_zffs_list为null的记录
-- 例如: 8号有订单，9号无订单，10号有订单，需要用10号的zffs_list回填8号的next_zffs_list
-- =====================================================================================
insert into ads.ads_sr_third_party_payment_payorder_info
select a.dt
      ,a.product_id
      ,a.user_id
      ,a.order_id
      ,a.zffs
      ,a.last_zffs
      ,a.core
      ,a.mt
      ,a.shop_item
      ,a.package_id
      ,a.sensors_data
      ,a.subscribe_status
      ,a.reg_country
      ,a.user_type
      ,a.current_language2
      ,a.zffs_list
      ,b.zffs_list as next_zffs_list
      ,now() as etl_time
from ads.ads_sr_third_party_payment_payorder_info a
inner join (
    select product_id
          ,user_id
          ,zffs_list
          ,row_number() over(partition by product_id, user_id order by order_id) as rn
    from ads.ads_sr_third_party_payment_payorder_info
    where dt = '${bf_1_dt}'
) b on a.product_id = b.product_id and a.user_id = b.user_id and b.rn = 1
where a.dt >= date_sub('${bf_1_dt}', interval 4 day)
  and a.dt < '${bf_1_dt}'
  and a.next_zffs_list is null;

-- =====================================================================================
-- 表2-回填SQL2: 回填当天第一条订单的last_zffs
-- 场景: 当天第一条订单的last_zffs为null，需要用历史最后一条订单的zffs来回填
-- 例如: 8号有订单，9号无订单，10号有订单，10号第一条订单的last_zffs应该是8号最后一条的zffs
-- =====================================================================================
insert into ads.ads_sr_third_party_payment_payorder_info
select a.dt
      ,a.product_id
      ,a.user_id
      ,a.order_id
      ,a.zffs
      ,b.zffs as last_zffs
      ,a.core
      ,a.mt
      ,a.shop_item
      ,a.package_id
      ,a.sensors_data
      ,a.subscribe_status
      ,a.reg_country
      ,a.user_type
      ,a.current_language2
      ,a.zffs_list
      ,a.next_zffs_list
      ,now() as etl_time
from ads.ads_sr_third_party_payment_payorder_info a
inner join (
    select product_id
          ,user_id
          ,zffs
          ,row_number() over(partition by product_id, user_id order by dt desc, order_id desc) as rn
    from ads.ads_sr_third_party_payment_payorder_info
    where dt >= date_sub('${bf_1_dt}', interval 4 day)
      and dt < '${bf_1_dt}'
) b on a.product_id = b.product_id and a.user_id = b.user_id and b.rn = 1
where a.dt = '${bf_1_dt}'
  and a.last_zffs is null;