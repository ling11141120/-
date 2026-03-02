delete from dws.dws_trade_short_video_user_shop_num_da where dt = '${bf_1_dt}';

insert into dws.dws_trade_short_video_user_shop_num_da
with pay_order as (
    select product_id
         , user_id
         , recharge_type_cd as shop_item
         , item_id
         , 1                as shop_num
         , create_time      as first_time
         , create_time
      from dwd.dwd_trade_pay_succ_recharge_order_hi
     where dt = '${bf_1_dt}'
       and recharge_type_cd in ('840', '810', '860')
       and product_id = 6833
     union all
    select product_id
         , user_id
         , shop_item
         , item_id
         , shop_num
         , first_time
         , create_time
      from dws.dws_trade_short_video_user_shop_num_da
     where dt = '${bf_2_dt}'
)
select '${bf_1_dt}'      as dt
     , product_id
     , user_id
     , shop_item
     , item_id
     , sum(shop_num)     as shop_num
     , sum(shop_num) - 1 as autoRenew_times
     , min(first_time)   as first_time
     , max(create_time)  as create_time
     , now()             as etl_time
  from pay_order
 group by product_id, user_id, shop_item, item_id
;