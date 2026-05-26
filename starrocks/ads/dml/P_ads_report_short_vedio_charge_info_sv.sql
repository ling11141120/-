----------------------------------------------------------------
-- 程序功能： 短剧充值统计-海剧
-- 程序名： P_ads_report_short_vedio_charge_info
-- 目标表： ads.ads_report_short_vedio_charge_info
-- 负责人： qhr
-- 开发日期： 2026-03-24
----------------------------------------------------------------

-- 开启CTE复用
set cbo_cte_reuse = true;

insert into ads.ads_report_short_vedio_charge_info
with pay_data as (
select user_id
     , base_amount
     , create_time
  from dwd.dwd_trade_sharpenginepaycenter_payorder_view
 where create_time > date_trunc('month', date_sub(now(), interval 6 month))
   and test_flag = 0
   and product_id = 6833
   and Order_Status = 1
)
, pay_data_agg as (
    -- 今日
    select 1                as datetypes
         , sum(base_amount) as charge_money
         , sum(base_amount) * 6.5 as charge_money_rmb
         , count(1) as charge_order
         , count(distinct user_id) as charge_num
      from pay_data
     where create_time >= current_date
     union all
    -- 昨日
    select 2                       as datetypes
         , sum(base_amount)        as charge_money
         , sum(base_amount) * 6.5  as charge_money_rmb
         , count(1)                as charge_order
         , count(distinct user_id) as charge_num
      from pay_data
     where create_time >= date_add(current_date, interval -1 day)
       and create_time <= date_add(now(), interval -1 day)
      union all
    -- 本月
    select 3                       as datetypes
         , sum(base_amount)        as charge_money
         , sum(base_amount) * 6.5  as charge_money_rmb
         , count(1)                as charge_order
         , count(distinct user_id) as charge_num
      from pay_data
     where create_time >= date_trunc('month', now())
     union all
    -- 上月同期
    select 4                       as datetypes
         , sum(base_amount)        as charge_money
         , sum(base_amount) * 6.5  as charge_money_rmb
         , count(1)                as charge_order
         , count(distinct user_id) as charge_num
      from pay_data
     where create_time >= date_trunc('month', date_sub(current_date, interval 1 month))
       and create_time <= case when day(now()) > day(date_sub(now(), interval 1 month)) then date_format(date_sub(now(), interval 1 month), '%Y-%m-%d 23:59:59')
                               else date_sub(now(), interval 1 month)
                           end
     union all
    -- 本季度
    select 5                       as datetypes
         , sum(base_amount)        as charge_money
         , sum(base_amount) * 6.5  as charge_money_rmb
         , count(1)                as charge_order
         , count(distinct user_id) as charge_num
      from pay_data
     where create_time > date_sub(now(), interval 3 month)
       and create_time < now()
       and quarter(create_time) = quarter(now())
      union all
    -- 上季度同期
    select 6                       as datetypes
         , sum(base_amount)        as charge_money
         , sum(base_amount) * 6.5  as charge_money_rmb
         , count(1)                as charge_order
         , count(distinct user_id) as charge_num
      from pay_data
     where create_time > date_sub(now(), interval 6 month)
       and create_time <= date_sub(now(), interval 3 month)
       and quarter(Create_Time) = quarter(date_sub(now(), interval 3 month))
      union all
    -- 上季度完整
    select 21                       as datetypes
         , sum(base_amount)        as charge_money
         , sum(base_amount) * 6.5  as charge_money_rmb
         , count(1)                as charge_order
         , count(distinct user_id) as charge_num
      from pay_data
     where quarter(create_time) = quarter(date_sub(now(), interval 3 month))
       and year(Create_Time) = year(date_sub(now(), interval 3 month))
)
, tt_payorder as (
    select tsp.create_time
         , cast(svgv.price_title as decimal(10,2))*if(accinf.mt=4,0.85,0.7) as base_amount
         , tsp.account_id                                                   as user_id
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
     where tsp.trade_order_status = 2
       and ifnull(tvs.is_sandbox, 0) = 0
       and reo.trade_order_id is null
     union all
    select tpy.create_time                         as create_time
         , tpy.token_amount*(1-0.00966958)/100     as base_amount
         , tpy.account_id                          as user_id
      from ods.ods_tidb_short_video_tt_payorder    as tpy
     where tpy.trade_order_status = 2
)
, tt_payorder_agg as (
    -- 今日
    select 1                as datetypes
         , sum(base_amount) as charge_money
         , sum(base_amount) * 6.5 as charge_money_rmb
         , count(1) as charge_order
         , count(distinct user_id) as charge_num
      from tt_payorder
     where create_time >= current_date
     union all
    -- 昨日
    select 2                       as datetypes
         , sum(base_amount)        as charge_money
         , sum(base_amount) * 6.5  as charge_money_rmb
         , count(1)                as charge_order
         , count(distinct user_id) as charge_num
      from tt_payorder
     where create_time >= date_add(current_date, interval -1 day)
       and create_time <= date_add(now(), interval -1 day)
      union all
    -- 本月
    select 3                       as datetypes
         , sum(base_amount)        as charge_money
         , sum(base_amount) * 6.5  as charge_money_rmb
         , count(1)                as charge_order
         , count(distinct user_id) as charge_num
      from tt_payorder
     where create_time >= date_trunc('month', now())
     union all
    -- 上月同期
    select 4                       as datetypes
         , sum(base_amount)        as charge_money
         , sum(base_amount) * 6.5  as charge_money_rmb
         , count(1)                as charge_order
         , count(distinct user_id) as charge_num
      from tt_payorder
     where create_time >= date_trunc('month', date_sub(current_date, interval 1 month))
       and create_time <= case when day(now()) > day(date_sub(now(), interval 1 month)) then date_format(date_sub(now(), interval 1 month), '%Y-%m-%d 23:59:59')
                               else date_sub(now(), interval 1 month)
                           end
     union all
    -- 本季度
    select 5                       as datetypes
         , sum(base_amount)        as charge_money
         , sum(base_amount) * 6.5  as charge_money_rmb
         , count(1)                as charge_order
         , count(distinct user_id) as charge_num
      from tt_payorder
     where create_time > date_sub(now(), interval 3 month)
       and create_time < now()
       and quarter(create_time) = quarter(now())
      union all
    -- 上季度同期
    select 6                       as datetypes
         , sum(base_amount)        as charge_money
         , sum(base_amount) * 6.5  as charge_money_rmb
         , count(1)                as charge_order
         , count(distinct user_id) as charge_num
      from tt_payorder
     where create_time > date_sub(now(), interval 6 month)
       and create_time <= date_sub(now(), interval 3 month)
       and quarter(Create_Time) = quarter(date_sub(now(), interval 3 month))
      union all
    -- 上季度完整
    select 21                      as datetypes
         , sum(base_amount)        as charge_money
         , sum(base_amount) * 6.5  as charge_money_rmb
         , count(1)                as charge_order
         , count(distinct user_id) as charge_num
      from tt_payorder
     where quarter(create_time) = quarter(date_sub(now(), interval 3 month))
       and year(Create_Time) = year(date_sub(now(), interval 3 month))
)
select datetypes
     , sum(charge_money)           as charge_money
     , sum(charge_money_rmb)       as charge_money_rmb
     , sum(charge_order)           as charge_order
     , sum(charge_num)             as charge_num
     , now()                       as etl_time
  from (select datetypes           as datetypes
             , charge_money        as charge_money
             , charge_money_rmb    as charge_money_rmb
             , charge_order        as charge_order
             , charge_num          as charge_num
          from pay_data_agg
         union all
        select datetypes           as datetypes
             , charge_money        as charge_money
             , charge_money_rmb    as charge_money_rmb
             , charge_order        as charge_order
             , charge_num          as charge_num
          from tt_payorder_agg
       )                           as t
 group by 1
;
