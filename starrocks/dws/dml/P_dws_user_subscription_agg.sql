insert table tmp.dws_user_subscription_agg
with yes_data as (
    select product_id
         , user_id
         , recharge_type_cd
         , item_id
         , count(1)              as yesterday_cnt           -- 昨天新增的记录数
         , max(subscribe_status) as yesterday_max_status    -- 昨天最大订阅状态
         , min(create_time)      as first_create_time       -- 第一次创建时间
    from dwd.dwd_trade_pay_succ_recharge_order_hi
   where dt = '${bf_1_dt}'
     and recharge_type_cd in ('840', '810', '860')
     and product_id = 6833
   group by 1, 2, 3, 4
)
, his_data as (
    select product_id
         , user_id
         , recharge_type_cd
         , item_id
         , shop_num as history_shop_num
         , subscribe_status as history_subscribe_status
      from tmp.dws_user_subscription_agg
)
-- 获取810历史数据
, his_810 as (
    select his.product_id
         , his.user_id
         , his.shop_num as history_810_shop_num
      from tmp.dws_user_subscription_agg as his
      join yes_data                      as yes
        on his.product_id = yes.product_id
       and his.user_id = yes.user_id
     where his.recharge_type_cd = '810'
       and yes.recharge_type_cd = '860'
)
-- 获取860历史数据（用于860降级为810的计算）
, his_860 as (
    select his.product_id
         , his.user_id
         , his.shop_num as history_860_shop_num
      from tmp.dws_user_subscription_agg as his
      join yes_data                      as yes
        on his.product_id = yes.product_id
       and his.user_id = yes.user_id
     where his.recharge_type_cd = '860'
       and yes.recharge_type_cd = '810'
)
select yes.product_id
     , yes.user_id
     , yes.recharge_type_cd
     , yes.item_id
     , case when yes.recharge_type_cd = '810' and his.history_shop_num is null then yes.yesterday_cnt
            when yes.recharge_type_cd = '810' and his.history_shop_num is not null then
                 case when h860.history_860_shop_num is not null then max(his.history_shop_num, h860.history_860_shop_num) + yes.yesterday_cnt
                      else his.history_shop_num + yes.yesterday_cnt
                  end
            when yes.recharge_type_cd = '860' and his.history_shop_num is null then coalesce(h810.history_810_shop_num,0) + yes.yesterday_cnt
            when yes.recharge_type_cd = '860' and his.history_shop_num is not null then his.history_shop_num + yes.yesterday_cnt
            else coalesce(his.history_shop_num, 0) + yes.yesterday_cnt
        end    as shop_num
     , case when yes.recharge_type_cd = '810' and his.history_shop_num is not null then 2
            when yes.recharge_type_cd = '860' and his.history_shop_num is not null then 2
            when yes.recharge_type_cd = '860' and his.history_shop_num is null then 2
            else max(his.history_shop_num, yes.yesterday_max_status)
        end    as subscribe_status
  from yes_data         as yes
  left join his_data    as his
    on yes.product_id = his.product_id
   and yes.user_id = his.user_id
   and yes.recharge_type_cd = his.recharge_type_cd
   and yes.item_id = his.item_id
  left join his_810     as h810
    on yes.product_id = h810.product_id
   and yes.user_id = h810.user_id
   and yes.recharge_type_cd = '860'
  left join his_860     as h860
    on yes.product_id = h860.product_id
   and yes.user_id = h860.user_id
   and yes.recharge_type_cd = '810'
;