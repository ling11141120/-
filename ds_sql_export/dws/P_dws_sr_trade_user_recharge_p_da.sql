----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dws_sr_trade_user_recharge_p_da
-- workflow_version : 3
-- create_user      : xixg
-- task_name        : dws_sr_trade_user_recharge_p_da
-- task_version     : 3
-- update_time      : 2024-08-05 11:28:30
-- sql_path         : \starrocks\tbl_dws_sr_trade_user_recharge_p_da\dws_sr_trade_user_recharge_p_da
----------------------------------------------------------------
-- SQL语句
INSERT INTO dws.dws_sr_trade_user_recharge_p_da
select
    DATE_FORMAT (dt_hour, '%Y-%m-%d') dt,
    user_id,
    sum(recharge_amount) AS recharge_amount,  -- 分成前的充值金额
    NOW()
from dws.dws_read_trade_user_trade_p_hi
WHERE DATE_FORMAT (dt_hour, '%Y-%m-%d') = '${dt}'
group by 1,2;
