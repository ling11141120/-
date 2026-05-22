----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_user_currency_balance_info
-- workflow_version : 4
-- create_user      : yanxh
-- task_name        : ads_user_currency_balance_info
-- task_version     : 4
-- update_time      : 2023-12-05 14:24:23
-- sql_path         : \starrocks\tbl_ads_user_currency_balance_info\ads_user_currency_balance_info
----------------------------------------------------------------
-- SQL语句
insert into ads.ads_user_currency_balance_info
select '${bf_1_dt}' as dt,product_id, id as user_id,money,gift_money,jifen ,now() as etl_tm from
    dim.dim_user_account_info_view ;
