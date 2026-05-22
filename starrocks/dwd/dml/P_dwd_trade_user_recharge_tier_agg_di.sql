----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dwd_trade_user_recharge_tier_agg_di
-- workflow_version : 1
-- create_user      : qhr
-- task_name        : P_dwd_trade_user_recharge_tier_agg_di
-- task_version     : 1
-- update_time      : 2026-02-03 18:44:11
-- sql_path         : \starrocks\tbl_dwd_trade_user_recharge_tier_agg_di\P_dwd_trade_user_recharge_tier_agg_di
----------------------------------------------------------------
-- SQL语句
----------------------------------------------------------------
-- 程序功能： 交易域-用户充值档位聚合
-- 程序名： P_dwd_trade_user_recharge_tier_agg_di
-- 目标表： dwd.dwd_trade_user_recharge_tier_agg_di
-- 开发人： qhr
-- 开发日期： 2026-02-03
----------------------------------------------------------------

insert into dwd.dwd_trade_user_recharge_tier_agg_di
select product_id                                   -- product_id
     , user_id                                      -- 用户id
     , actual_recharge_amt    as recharge_tier      -- 充值档位
     , count(1)               as recharge_cnt       -- 充值次数
     , max(create_time)       as max_create_time    -- 最大创建时间
     , now()                  as etl_time           -- etl时间
  from dwd.dwd_trade_pay_succ_recharge_order_hi
 where dt = '${bf_1_dt}'
   and coalesce(actual_recharge_amt, 0) > 0
 group by 1, 2, 3
;
