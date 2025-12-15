-- =====================================================================================
-- =====================================================================================
-- 需求名称: 海剧表二优化 - ads_bi_user_ord_expo_info_di
-- 需求人员: 张心慧
-- 开发人员: 陈末
-- 开发日期: 2025-12-10
-- 原开发人员: roger
-- 需求说明: 参照海阅表二的逻辑，优化海剧订单曝光信息表
-- =====================================================================================
--
-- 【业务需求优化】
-- 1. zffs/last_zffs字段优化: 关联三方渠道表ods_tidb_short_video_third_payment_rate
--    将subpay_type(渠道ID)转换为pay_channel(渠道名称)
--
-- 【代码优化】
-- 1. 订单取数简化: 去掉union all合并历史订单的复杂逻辑，直接用lag()计算last_subpay_type
-- 2. 三方渠道表去重: 先group by pay_id, pay_channel避免笛卡尔积导致内存爆炸
-- 3. 曝光关联优化: 用row_number()取最近一条曝光，替代max_by函数，逻辑更清晰
-- 4. 增加回填逻辑: 回填历史next_zffs_list和当天last_zffs
--
-- 【Bug修复】
-- 1. next_zffs_list逻辑错误: 原代码用min_by(event_tm > createtime)取的是当前订单之后的曝光
--    正确逻辑应该是取下一笔订单匹配到的zffs_list，用lead()窗口函数实现
--
-- =====================================================================================
-- =====================================================================================


-- =====================================================================================
-- 海剧表二-主SQL: 插入订单表数据
-- =====================================================================================

insert into ads.ads_bi_user_ord_expo_info_di
with payorder_base as (
    select a.dt
          ,a.user_id
          ,a.order_id
          ,a.create_time
          ,a.subpay_type
          ,lag(a.subpay_type) over(partition by a.user_id order by a.create_time) as last_subpay_type
          ,a.corever2 as core
          ,case when a.mt = 1 then 'iOS' when a.mt = 4 then 'Android' else '其他' end as mt
          ,a.shop_item
          ,a.custom_data
          ,get_json_int(a.cooorder_extinfo, '$.SubscribeStatus') as subscribe_status
    from ads.ads_short_video_payorder_view a
    where a.test_flag = 0
      and a.product_id = 6833
      and a.dt = '${bf_1_dt}'
)
,exposure_data as (
    select login_id as user_id
          ,event_tm
          ,substring_index(zffs_list, ',', 3) as zffs_list
    from ads.ads_sensors_cd_video_rechargeexposure_view
    where dt >= date_sub('${bf_1_dt}', interval 3 day)
      and dt <= '${bf_1_dt}'
      and product_id = 6833
      and login_id is not null
      and zffs_list is not null
      and zffs_list != ''
)
,payorder_with_exposure as (
    select a.*
          ,b.zffs_list
          ,row_number() over(
              partition by a.user_id, a.order_id
              order by b.event_tm desc
          ) as exposure_rn
    from payorder_base a
    left join exposure_data b
        on a.user_id = b.user_id
        and b.event_tm <= a.create_time
)
-- 三方渠道表去重（pay_id可能不唯一）
,third_payment_dedup as (
    select pay_id
          ,pay_channel
    from ods.ods_tidb_short_video_third_payment_rate
    where status = 1
    group by pay_id, pay_channel
)
select a.dt
      ,a.user_id
      ,a.order_id
      ,ifnull(c1.pay_channel, a.subpay_type) as zffs
      ,ifnull(c2.pay_channel, a.last_subpay_type) as last_zffs
      ,a.core
      ,a.mt
      ,a.shop_item
      ,a.custom_data
      ,a.subscribe_status
      ,b.reg_country
      ,b.user_type
      ,b.current_language2
      ,d.cd_val_desc as current_language2_name
      ,a.zffs_list
      ,lead(a.zffs_list) over(partition by a.user_id order by a.create_time) as next_zffs_list
      ,now() as etl_tm
from payorder_with_exposure a
left join dws.dws_user_short_video_wide_active_period_ed b
    on a.dt = b.dt
    and a.user_id = b.user_id
    and b.period_type = 'ctt'
    and b.product_id = 6833
left join third_payment_dedup c1
    on a.subpay_type = c1.pay_id
left join third_payment_dedup c2
    on a.last_subpay_type = c2.pay_id
left join dim.dim_pub_code_mapping_dict d
    on d.app_plat = 'pub'
    and d.cd_col = 'lang_cd'
    and b.current_language2 = d.cd_val
where a.exposure_rn = 1 or a.exposure_rn is null;


-- =====================================================================================
-- 海剧表二-回填SQL1: 回填历史next_zffs_list为null的数据
-- 场景: 用户可能隔了好几天才有新订单，需要回填历史上next_zffs_list为null的记录
-- 例如: 8号有订单，9号无订单，10号有订单，需要用10号的zffs_list回填8号的next_zffs_list
-- =====================================================================================
insert into ads.ads_bi_user_ord_expo_info_di
select a.dt
      ,a.user_id
      ,a.order_id
      ,a.zffs
      ,a.last_zffs
      ,a.core
      ,a.mt
      ,a.shop_item
      ,a.custom_data
      ,a.subscribe_status
      ,a.reg_country
      ,a.user_type
      ,a.current_language2
      ,a.current_language2_name
      ,a.zffs_list
      ,b.zffs_list as next_zffs_list
      ,now() as etl_tm
from ads.ads_bi_user_ord_expo_info_di a
inner join (
    select user_id
          ,zffs_list
          ,row_number() over(partition by user_id order by order_id) as rn
    from ads.ads_bi_user_ord_expo_info_di
    where dt = '${bf_1_dt}'
) b on a.user_id = b.user_id and b.rn = 1
where a.dt >= date_sub('${bf_1_dt}', interval 30 day)
  and a.dt < '${bf_1_dt}'
  and a.next_zffs_list is null;


-- =====================================================================================
-- 海剧表二-回填SQL2: 回填当天第一条订单的last_zffs
-- 场景: 当天第一条订单的last_zffs为null，需要用历史最后一条订单的zffs来回填
-- 例如: 8号有订单，9号无订单，10号有订单，10号第一条订单的last_zffs应该是8号最后一条的zffs
-- =====================================================================================
insert into ads.ads_bi_user_ord_expo_info_di
select a.dt
      ,a.user_id
      ,a.order_id
      ,a.zffs
      ,b.zffs as last_zffs
      ,a.core
      ,a.mt
      ,a.shop_item
      ,a.custom_data
      ,a.subscribe_status
      ,a.reg_country
      ,a.user_type
      ,a.current_language2
      ,a.current_language2_name
      ,a.zffs_list
      ,a.next_zffs_list
      ,now() as etl_tm
from ads.ads_bi_user_ord_expo_info_di a
inner join (
    select user_id
          ,zffs
          ,row_number() over(partition by user_id order by dt desc, order_id desc) as rn
    from ads.ads_bi_user_ord_expo_info_di
    where dt >= date_sub('${bf_1_dt}', interval 30 day)
      and dt < '${bf_1_dt}'
) b on a.user_id = b.user_id and b.rn = 1
where a.dt = '${bf_1_dt}'
  and a.last_zffs is null;