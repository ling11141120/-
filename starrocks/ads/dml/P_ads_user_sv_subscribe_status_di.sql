----------------------------------------------------------------
-- 程序功能： 用户短剧订阅类型状态日表
-- 程序名： P_ads_user_sv_subscribe_status_di
-- 目标表： ads.ads_user_sv_subscribe_status_di
-- 负责人：lwb
-- 开发日期： 2026-06-10
----------------------------------------------------------------
-- 1. 判断每天每个用户属于什么订阅类型，优先级：810 > 860 > 840 > 0 > 其他
-- 2. 订阅类：当天在订阅卡有效期内（create_time <= dt <= card_expire_time）
-- 3. 普通充值(0)：当天有充值记录，无订阅有效期概念
-- 4. 数据源：dwd.dwd_trade_pay_succ_recharge_order_hi，product_id = 6833
----------------------------------------------------------------

insert into ads.ads_user_sv_subscribe_status_di
with user_sub as (
    -- 订阅类：在订阅卡有效期内的
    select user_id
         , recharge_type_cd
      from dwd.dwd_trade_pay_succ_recharge_order_hi
     where product_id = 6833
       and recharge_type_cd != '0'
       and card_expire_time is not null
       and create_time >= date_sub('${bf_1_dt}', interval 365 day)
       and create_time <= '${bf_1_dt}'
       and card_expire_time >= '${bf_1_dt}'
     group by 1, 2
)
, user_normal as (
    -- 普通充值：当天有充值
    select user_id
         , '0' as recharge_type_cd
      from dwd.dwd_trade_pay_succ_recharge_order_hi
     where product_id = 6833
       and recharge_type_cd = '0'
       and dt = '${bf_1_dt}'
     group by 1
)
, user_all as (
    select user_id, recharge_type_cd from user_sub
    union all
    select user_id, recharge_type_cd from user_normal
)
, user_rank as (
    -- 按优先级排序：810 > 860 > 840 > 0 > 其他
    select user_id
         , recharge_type_cd
         , case when recharge_type_cd = '810' then 1
                when recharge_type_cd = '860' then 2
                when recharge_type_cd = '840' then 3
                when recharge_type_cd = '0'   then 4
                else 5
           end as priority
      from user_all
)
select '${bf_1_dt}'                      as dt
     , user_id
     , recharge_type_cd                  as subscribe_type_cd
     , now()                             as etl_time
  from (select user_id
             , recharge_type_cd
             , row_number() over (partition by user_id order by priority) as rn
          from user_rank
       ) t
 where rn = 1
;
