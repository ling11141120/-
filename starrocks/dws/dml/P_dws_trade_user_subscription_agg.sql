----------------------------------------------------------------
-- 程序功能： 交易域-用户订阅聚合表
-- 程序名： P_dws_trade_user_subscription_agg
-- 目标表： dws.dws_trade_user_subscription_agg
-- 负责人： qhr
-- 开发日期： 2026-03-03
----------------------------------------------------------------

delete from dws.dws_trade_user_subscription_agg where dt = '${bf_1_dt}';
insert into dws.dws_trade_user_subscription_agg
with yes_data_tmp as (
    select dt
         , product_id
         , user_id
         , recharge_type_cd
         , item_id
         , count(1)                 as yesterday_cnt           -- 昨天新增的记录数
         , max(subscribe_status)    as yesterday_max_status    -- 昨天最大订阅状态
         , min(create_time)         as first_create_time       -- 第一次创建时间
    from dwd.dwd_trade_pay_succ_recharge_order_hi
   where dt = '${bf_1_dt}'
     and recharge_type_cd in ('840', '810', '860')
     and product_id = 6833
   group by 1, 2, 3, 4, 5
)
, yes_data as (
    select ydt.dt
         , ydt.product_id
         , ydt.user_id
         , ydt.recharge_type_cd
         , ydt.item_id
         , case when ydt.recharge_type_cd = '860' and y8c.yes_810_cnt > 0 then ydt.yesterday_cnt + y8c.yes_810_cnt
                else ydt.yesterday_cnt
            end                as yesterday_cnt
         , case when ydt.recharge_type_cd = '860' and y8c.yes_810_cnt > 0 then 2
                else ydt.yesterday_max_status
            end                as yesterday_max_status
         , ydt.first_create_time
      from yes_data_tmp        as ydt
      left join (select dt
                      , product_id
                      , user_id
                      , count(1)    as yes_810_cnt
                   from yes_data_tmp
                  where recharge_type_cd = '810'
                  group by 1, 2, 3
                )                   as y8c
        on ydt.dt = y8c.dt
       and ydt.product_id = y8c.product_id
       and ydt.user_id = y8c.user_id
)
, his_data as (
    select '${bf_1_dt}'        as dt
         , product_id
         , user_id
         , recharge_type_cd
         , item_id
         , subscribe_num       as history_sub_num
         , subscribe_status    as history_subscribe_status
         , first_subscribe_time
      from dws.dws_trade_user_subscription_agg
     where dt = '${bf_2_dt}'
)
-- 获取810历史数据
, his_810 as (
    select his.product_id
         , his.user_id
         , his.history_sub_num    as history_810_sub_num
      from his_data    as his
      join yes_data    as yes
        on his.product_id = yes.product_id
       and his.user_id = yes.user_id
     where his.recharge_type_cd = '810'
       and yes.recharge_type_cd = '860'
)
-- 获取860历史数据（用于860降级为810的计算）
, his_860 as (
    select his.product_id
         , his.user_id
         , his.history_sub_num    as history_860_sub_num
      from his_data    as his
      join yes_data    as yes
        on his.product_id = yes.product_id
       and his.user_id = yes.user_id
     where his.recharge_type_cd = '860'
       and yes.recharge_type_cd = '810'
)
select yes.dt                                              -- 分区日期
     , yes.product_id                                      -- 产品ID
     , yes.user_id                                         -- 用户ID
     , yes.recharge_type_cd     as recharge_type_cd        -- 充值类型编码
     , yes.item_id                                         -- 申请ID
     , case when yes.recharge_type_cd = '810' and his.history_sub_num is null then yes.yesterday_cnt
            when yes.recharge_type_cd = '810' and his.history_sub_num is not null then
                 case when h860.history_860_sub_num is not null then greatest(his.history_sub_num, h860.history_860_sub_num) + yes.yesterday_cnt
                      else his.history_sub_num + yes.yesterday_cnt
                  end
            when yes.recharge_type_cd = '860' and his.history_sub_num is null then coalesce(h810.history_810_sub_num,0) + yes.yesterday_cnt
            when yes.recharge_type_cd = '860' and his.history_sub_num is not null then his.history_sub_num + yes.yesterday_cnt
            else coalesce(his.history_sub_num, 0) + yes.yesterday_cnt
        end                     as subscribe_num           -- 订阅次数
     , case when yes.recharge_type_cd = '810' and his.history_sub_num is not null then 2
            when yes.recharge_type_cd = '860' and his.history_sub_num is not null then 2
            when yes.recharge_type_cd = '860' and his.history_sub_num is null then 2
            else greatest(coalesce(his.history_sub_num, 0), yes.yesterday_max_status)
        end                     as subscribe_status        -- 订阅状态
     , yes.first_create_time    as first_subscribe_time    -- 首次订阅时间
     , now()                    as etl_time                -- ETL时间
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
 union all
select his.dt                          as dt                      -- 分区日期
     , his.product_id                  as product_id              -- 产品ID
     , his.user_id                     as user_id                 -- 用户ID
     , his.recharge_type_cd            as recharge_type_cd        -- 充值类型编码
     , his.item_id                     as item_id                 -- 申请ID
     , his.history_sub_num             as shop_num                -- 订阅次数
     , his.history_subscribe_status    as subscribe_status        -- 订阅状态
     , his.first_subscribe_time        as first_subscribe_time    -- 首次订阅时间
     , now()                           as etl_time                -- ETL时间
  from his_data         as his
  left join yes_data    as yes
    on his.product_id = yes.product_id
   and his.user_id = yes.user_id
   and his.recharge_type_cd = yes.recharge_type_cd
   and his.item_id = yes.item_id
 where yes.user_id is null
;