----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : 审计测试-总
-- workflow_version : 36
-- create_user      : chenmo
-- task_name        : 海阅上月数据是否与旧订单重复
-- task_version     : 2
-- update_time      : 2026-01-29 18:30:44
-- sql_path         : \starrocks\审计测试-总\海阅上月数据是否与旧订单重复
----------------------------------------------------------------
-- SQL语句
-- 验证数据唯一
insert overwrite ads.ads_sr_finance_book_recharge_consume_info_delete
select
    order_id
from ads.ads_sr_finance_book_recharge_consume_info
group by order_id
having count(1) > 1;

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : 审计测试-总_改
-- workflow_version : 11
-- create_user      : xiejc
-- task_name        : 海阅上月数据是否与旧订单重复
-- task_version     : 1
-- update_time      : 2026-03-31 14:40:14
-- sql_path         : \starrocks\审计测试-总_改\海阅上月数据是否与旧订单重复
----------------------------------------------------------------
-- SQL语句
-- 验证数据唯一
insert overwrite ads.ads_sr_finance_book_recharge_consume_info_delete
select
    order_id
from ads.ads_sr_finance_book_recharge_consume_info
group by order_id
having count(1) > 1;

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : 审计测试-总_改_补数
-- workflow_version : 20
-- create_user      : xiejc
-- task_name        : 海阅上月数据是否与旧订单重复
-- task_version     : 3
-- update_time      : 2026-05-07 17:52:32
-- sql_path         : \starrocks\审计测试-总_改_补数\海阅上月数据是否与旧订单重复
----------------------------------------------------------------
-- SQL语句
-- 验证数据唯一
insert overwrite ads.ads_sr_finance_book_recharge_consume_info_delete
select
    order_id
from tmp.tmp_xjc_ads_sr_finance_book_recharge_consume_info
group by order_id
having count(1) > 1;
