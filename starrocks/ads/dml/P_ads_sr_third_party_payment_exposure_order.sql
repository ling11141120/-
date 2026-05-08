insert into ads.ads_sr_third_party_payment_exposure_order
-- 曝光事件拆分
with exposure_explode as (
    select dt
          ,product_id
          ,user_id
          ,zffs_array[generate_series] as zffs_id
          ,generate_series as zffs_rank
          ,strategy_id
          ,app_core_ver
          ,shop_item
    from (
        select dt
              ,product_id
              ,user_id
              ,split(zffs_id_list, ',') as zffs_array
              ,array_length(split(zffs_id_list, ',')) as zffs_length
              ,strategy_id
              ,app_core_ver
              ,shop_item
        from (
            select dt
                  ,if(app_product_id = 0, product_id, app_product_id) as product_id
                  ,coalesce(identity_user_id, login_id) as user_id
                  ,zffs_id_list
                  ,case
                      when element_id = '100708' and element_type in ('0', '-1') then event_strategy_id
                      when element_id in ('100024', '100025', '100126', '100365') then event_strategy_id
                      when element_id = '100400' and split(pay_link, '_')[1] = 'returnrecommend' then split(pay_link, '_')[4]
                      when element_id = '100390' and split(pay_link, '_')[1] = 'popup' then split(pay_link, '_')[4]
                      when event_strategy_id > 0 then event_strategy_id
                      else activity_id
                  end as strategy_id
                  ,app_core_ver
                  ,recharge_type as shop_item
                  ,row_number() over(partition by dt, if(app_product_id = 0, product_id, app_product_id), coalesce(identity_user_id, login_id) order by event_tm) as rn
            from ads.ads_sensors_production_rechargeexposure_view
            where dt = '${bf_1_dt}'
              and element_id not in ('100647', '100651', '100107')
              and if(app_product_id = 0, product_id, app_product_id) is not null
              and coalesce(identity_user_id, login_id) is not null
              and zffs_id_list is not null
              and zffs_id_list != ''
        ) t where rn = 1
    ) t
    cross join generate_series(1, zffs_length)
)
-- 三方渠道表去重（同一ID可能对应多个PaymentWay，取max值）
-- 注意：此处不需要status=1条件，因为ads_sensors_production_rechargeexposure_view中的zffs_id_list
-- 已经是曝光时的实际渠道，即使渠道后来被禁用，历史曝光数据仍然存在且需要正确映射
,third_payment_dedup as (
    select Id
          ,max(PaymentWay) as PaymentWay
    from ods.ods_tidb_readernovel_tidb_tag_center_third_payment_rate
    group by Id
)
select a.dt
      ,a.product_id
      ,a.user_id
      ,a.zffs_id
      ,a.zffs_rank
      ,case
          when a.zffs_id = '0' and b.mt = 1 then 'AppStore'
          when a.zffs_id = '0' and b.mt = 4 then 'GooglePlay'
          else ifnull(c.PaymentWay, a.zffs_id)
      end as zffs
      ,a.strategy_id
      ,a.app_core_ver
      ,a.shop_item
      ,case when b.mt = 1 then 'iOS'
          when b.mt = 4 then 'Android'
          else '其他'
      end as mt
      ,b.user_type
      ,b.reg_country
      ,b.current_language2
      ,now() as etl_time
from exposure_explode a
left join dws.dws_user_wide_active_period_ed b on a.dt = b.dt and a.product_id = b.product_id and a.user_id = b.user_id and b.period_type = 'ctt'
left join third_payment_dedup c on a.zffs_id = c.Id
where a.zffs_id is not null and a.zffs_id != '';