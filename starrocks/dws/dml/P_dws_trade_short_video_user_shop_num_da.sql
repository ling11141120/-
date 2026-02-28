----------------------------------------------------------------
-- 程序功能： 海剧用户充值表
-- 程序名： P_dws_trade_short_video_user_shop_num_da
-- 目标表： dws.dws_trade_short_video_user_shop_num_da
-- 负责人： qhr
-- 开发日期： 2026-02-27
----------------------------------------------------------------

insert into dws.dws_trade_short_video_user_shop_num_da
with pay_order as (
    select product_id
         , user_id
         , recharge_type_cd    as shop_item
         , item_id
         , 1                   as shop_num
         , create_time         as first_time
         , create_time
      from dwd.dwd_trade_pay_succ_recharge_order_hi
     where dt = '${bf_1_dt}'
       and product_id = 6833
       and shop_item in ('840', '810', '860')
     union all
    select product_id          as product_id
         , user_id             as user_id
         , shop_item           as shop_item
         , item_id             as item_id
         , shop_num            as shop_num
         , first_time          as first_time
         , create_time         as create_time
      from dws.dws_trade_short_video_user_shop_num_da
     where dt = '${bf_2_dt}'
)
select '${bf_1_dt}'         as dt
     , product_id           as product_id
     , user_id              as user_id
     , shop_item            as shop_item
     , item_id              as item_id
     , sum(shop_num)        as shop_num
     , sum(shop_num) - 1    as autoRenew_times
     , min(first_time)      as first_time
     , max(create_time)     as create_time
     , now()                as etl_time
  from pay_order
 group by 1, 2, 3, 4
;