----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : 审计测试-总
-- workflow_version : 36
-- create_user      : chenmo
-- task_name        : 海剧书籍明细
-- task_version     : 2
-- update_time      : 2026-02-16 11:47:07
-- sql_path         : \starrocks\审计测试-总\海剧书籍明细
----------------------------------------------------------------
-- SQL语句
-- TODO 海剧
drop table ads.ads_sv_finance_series_info_1;

-- SQL语句
create table ads.ads_sv_finance_series_info_1 like ads.ads_sv_finance_series_info;

-- SQL语句
insert into ads.ads_sv_finance_series_info_1
select * from ads.ads_sv_finance_series_info;

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : 审计测试-总_改
-- workflow_version : 11
-- create_user      : xiejc
-- task_name        : 海剧书籍明细
-- task_version     : 3
-- update_time      : 2026-04-08 11:46:36
-- sql_path         : \starrocks\审计测试-总_改\海剧书籍明细
----------------------------------------------------------------
-- SQL语句
-- TODO 海剧
drop table ads.ads_sv_finance_series_info_1;

-- SQL语句
create table ads.ads_sv_finance_series_info_1 like ads.ads_sv_finance_series_info;

-- SQL语句
insert into ads.ads_sv_finance_series_info_1
select * from ads.ads_sv_finance_series_info;
