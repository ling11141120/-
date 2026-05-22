----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : 审计测试-总_改
-- workflow_version : 11
-- create_user      : xiejc
-- task_name        : 关键表单备份
-- task_version     : 4
-- update_time      : 2026-05-12 14:20:57
-- sql_path         : \starrocks\审计测试-总_改\关键表单备份
----------------------------------------------------------------
-- SQL语句
-- 输出结果表数据备份，避免数据污染导致数据整体不可用

-- TODO 海阅
drop table if exists ads.ads_sr_finance_book_recharge_consume_info_1;

-- SQL语句
create table ads.ads_sr_finance_book_recharge_consume_info_1 like ads.ads_sr_finance_book_recharge_consume_info;

-- SQL语句
drop table if exists ads.ads_sr_finance_book_recharge_surplus_info_1;

-- SQL语句
create table ads.ads_sr_finance_book_recharge_surplus_info_1 like ads.ads_sr_finance_book_recharge_surplus_info;

-- SQL语句
-- TODO 海剧
drop table if exists ads.ads_sv_finance_series_recharge_consume_info_1;

-- SQL语句
create table ads.ads_sv_finance_series_recharge_consume_info_1 like ads.ads_sv_finance_series_recharge_consume_info;

-- SQL语句
insert into ads.ads_sv_finance_series_recharge_consume_info_1
select * from ads.ads_sv_finance_series_recharge_consume_info;

-- SQL语句
drop table if exists ads.ads_sv_finance_series_recharge_surplus_info_1;

-- SQL语句
create table ads.ads_sv_finance_series_recharge_surplus_info_1 like ads.ads_sv_finance_series_recharge_surplus_info;

-- SQL语句
drop table if exists ads.ads_srsv_sdk_recharge_summary_1;

-- SQL语句
create table ads.ads_srsv_sdk_recharge_summary_1 like ads.ads_srsv_sdk_recharge_summary;
