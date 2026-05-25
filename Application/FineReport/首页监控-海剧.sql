------------------------------------------------
-- 业务：海剧
-- title：【沙盘海剧】-当日充值金额统计异常
-- level：P1
-- 指标：<= 1200
-- crontab：0 24,44 * * * ? *
------------------------------------------------
with tt_parorder as (
    select tsp.create_time
         , cast(svgv.price_title as decimal(10,2))*if(accinf.mt=4,0.85,0.7) as base_amount
      from ods.ods_tidb_short_video_tt_vip_subscription_payorder            as tsp
      left join (select item_id
                      , max(price_title)                                    as price_title
                      , max(Price)                                          as price
                   from dim.dim_short_video_goods_view
                  where core = 16
                    and is_remove = 0
                  group by 1
                )                                                           as svgv
        on tsp.tier_id = svgv.item_id
      left join dim.dim_short_video_user_accountinfo                        as accinf
        on accinf.user_id = tsp.account_id
      left join ods.ods_tidb_short_video_tt_vip_subscribe                   as tvs
        on tsp.subscription_record_id = tvs.id
      left join (select get_json_string(content, '$.trade_order_id')        as trade_order_id
                   from ods.ods_tidb_short_video_tt_vip_subscribe_event_log
                  where event_type in (9, 10)    -- 撤销、退款
                  group by 1
                )                                                           as reo
        on tsp.trade_order_id = reo.trade_order_id
     where tsp.create_time >= current_date
       and tsp.trade_order_status = 2
       and ifnull(tvs.is_sandbox, 0) = 0
       and reo.trade_order_id is null
     union all
    select tpy.create_time                         as create_time
         , tpy.token_amount*(1-0.00966958)/100     as base_amount
      from ods.ods_tidb_short_video_tt_payorder    as tpy
     where tpy.create_time >= current_date
       and tpy.trade_order_status = 2
)
, src_d as (
    select sum(base_amount) as charge_money
      from (select base_amount
              from dwd.dwd_trade_sharpenginepaycenter_payorder_view
             where dt >= current_date
               and test_flag = 0
               and product_id = 6833
               and Order_Status = 1
             union all
            select base_amount
              from tt_parorder
           ) as a
)
select src_d.charge_money - a1.charge_money as diff
  from ads.ads_report_short_vedio_charge_info as a1
      ,src_d
 where datetypes = 1
;

------------------------------------------------
-- 业务：海剧
-- title：【沙盘海剧】-hk_payorder同步延迟
-- level：P1
-- 指标：<= 1800
-- 频率：30min
------------------------------------------------
select unix_timestamp(now()) - max(unix_timestamp(CreateTime)) as diff
from ods.ods_tidb_sharpenginepaycenter_hk_payorder
where dt = current_date
and ProductId = 6833
;