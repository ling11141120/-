----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : 审计测试-总
-- workflow_version : 36
-- create_user      : chenmo
-- task_name        : 海剧上月数据是否与旧订单重复
-- task_version     : 2
-- update_time      : 2026-01-29 18:30:44
-- sql_path         : \starrocks\审计测试-总\海剧上月数据是否与旧订单重复
----------------------------------------------------------------
-- SQL语句
-- 验证数据唯一
insert overwrite ads.ads_sv_finance_series_recharge_consume_info_delete
select
    order_id
from ads.ads_sv_finance_series_recharge_consume_info
group by order_id
having count(1) > 1;

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : 审计测试-总_改
-- workflow_version : 11
-- create_user      : xiejc
-- task_name        : 海剧上月数据是否与旧订单重复
-- task_version     : 3
-- update_time      : 2026-04-01 16:24:12
-- sql_path         : \starrocks\审计测试-总_改\海剧上月数据是否与旧订单重复
----------------------------------------------------------------
-- SQL语句
-- 验证数据唯一
insert overwrite ads.ads_sv_finance_series_recharge_consume_info_delete
select
    order_id
from ads.ads_sv_finance_series_recharge_consume_info
group by order_id
having count(1) > 1;

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : 审计测试-总_改_补数
-- workflow_version : 20
-- create_user      : xiejc
-- task_name        : 海剧上月数据是否与旧订单重复
-- task_version     : 3
-- update_time      : 2026-05-07 18:01:08
-- sql_path         : \starrocks\审计测试-总_改_补数\海剧上月数据是否与旧订单重复
----------------------------------------------------------------
-- SQL语句
-- 验证数据唯一
insert overwrite ads.ads_sv_finance_series_recharge_consume_info_delete
select
    order_id
from tmp.tmp_xjc_ads_sv_finance_series_recharge_consume_info
group by order_id
having count(1) > 1;
