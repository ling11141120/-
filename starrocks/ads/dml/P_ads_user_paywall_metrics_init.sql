----------------------------------------------------------------
-- 程序功能： 付费墙用户充值指标初始化
-- 程序名： P_ads_user_paywall_metrics_init
-- 目标表： ads.ads_user_paywall_metrics_init
-- 负责人： xjc
-- 开发日期： 2026-05-27
-- 版本号： v0.0.0
----------------------------------------------------------------

insert into ads.ads_user_paywall_metrics_init
with payorder_base as (
    select product_id
          ,user_id
          ,order_id
          ,log_id
          ,create_time
          ,recharge_type_cd
          ,case when recharge_type_cd = '0' then 0
                when recharge_type_cd = '810' then 1
                when recharge_type_cd = '840' then 2
                when recharge_type_cd = '860' then 8
            end    as recharge_type
      from dwd.dwd_trade_pay_succ_recharge_order_hi
     where product_id = 6833
       and user_id > 0
       and create_time is not null
)
, first_recharge as (
    select product_id
          ,user_id
          ,unix_timestamp(create_time) * 1000    as first_recharge_time
          ,recharge_type  as first_recharge_type
      from (select product_id
                  ,user_id
                  ,create_time
                  ,recharge_type
                  ,row_number() over (
                       partition by product_id, user_id
                           order by create_time asc, order_id asc, log_id asc
                   )    as rn
              from payorder_base
           ) as a
     where rn = 1
)
, first_vip_recharge as (
    select product_id
          ,user_id
          ,unix_timestamp(create_time) * 1000    as first_vip_recharge_date
      from (select product_id
                  ,user_id
                  ,create_time
                  ,row_number() over (
                       partition by product_id, user_id
                           order by create_time asc, order_id asc, log_id asc
                   )    as rn
              from payorder_base
             where recharge_type_cd in ('810', '860')
           ) as a
     where rn = 1
)
, last_recharge as (
    select product_id
          ,user_id
          ,recharge_type    as last_recharge_type
      from (select product_id
                  ,user_id
                  ,recharge_type
                  ,row_number() over (
                       partition by product_id, user_id
                           order by create_time desc, order_id desc, log_id desc
                   )    as rn
              from payorder_base
           ) as a
     where rn = 1
)
select a.product_id
      ,a.user_id
      ,a.first_recharge_time
      ,a.first_recharge_type
      ,b.first_vip_recharge_date
      ,c.last_recharge_type
      ,now()    as etl_time
  from first_recharge as a
  left join first_vip_recharge as b
    on a.product_id = b.product_id
   and a.user_id = b.user_id
  left join last_recharge as c
    on a.product_id = c.product_id
   and a.user_id = c.user_id
;
