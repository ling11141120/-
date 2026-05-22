----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : sch_ads_optimize
-- workflow_version : 95
-- create_user      : xixg
-- task_name        : ads_read_ad_cpm_dh
-- task_version     : 1
-- update_time      : 2025-04-14 15:58:23
-- sql_path         : \starrocks\sch_ads_optimize\ads_read_ad_cpm_dh
----------------------------------------------------------------
-- 后置SQL语句
insert into ads.ads_SyncBi_update_status
select 7 id, 'SyncBi_ads_read_ad_cpm_dh' TableName, current_timestamp() UpdateTime;

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_bi_user_book_arpu_tag_info
-- workflow_version : 12
-- create_user      : yanxh
-- task_name        : ads_bi_user_book_arpu_tag_info
-- task_version     : 7
-- update_time      : 2025-04-01 20:10:56
-- sql_path         : \starrocks\tbl_ads_bi_user_book_arpu_tag_info\ads_bi_user_book_arpu_tag_info
----------------------------------------------------------------
-- 后置SQL语句
update ads.ads_SyncBi_update_status set UpdateTime =CURRENT_TIMESTAMP() where TableName = 'ads_bi_user_book_arpu_tag_info';

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_bi_user_book_tag_info_today
-- workflow_version : 9
-- create_user      : yanxh
-- task_name        : update_time
-- task_version     : 3
-- update_time      : 2024-10-23 10:47:42
-- sql_path         : \starrocks\tbl_ads_bi_user_book_tag_info_today\update_time
----------------------------------------------------------------
-- SQL语句
update ads.ads_SyncBi_update_status set UpdateTime =CURRENT_TIMESTAMP() where TableName = 'ads_bi_user_book_tag_info';

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_bi_user_book_tag_info_yesterday
-- workflow_version : 7
-- create_user      : yanxh
-- task_name        : update_time
-- task_version     : 1
-- update_time      : 2024-06-07 16:00:17
-- sql_path         : \starrocks\tbl_ads_bi_user_book_tag_info_yesterday\update_time
----------------------------------------------------------------
-- SQL语句
update ads.ads_SyncBi_update_status set UpdateTime =CURRENT_TIMESTAMP() where TableName = 'ads_bi_user_book_tag_info';

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_book_read_consume
-- workflow_version : 27
-- create_user      : linq
-- task_name        : pre-sql
-- task_version     : 1
-- update_time      : 2025-12-11 16:02:19
-- sql_path         : \starrocks\tbl_ads_book_read_consume\pre-sql
----------------------------------------------------------------
-- SQL语句
insert into ads.ads_SyncBi_update_status
select 1 id, 'SyncBi_ads_book_read_consume' TableName, current_timestamp() UpdateTime;

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_edm_book_consume_l30d
-- workflow_version : 2
-- create_user      : yanxh
-- task_name        : ads_edm_book_consume_l30d_update_status
-- task_version     : 2
-- update_time      : 2023-10-27 14:07:34
-- sql_path         : \starrocks\tbl_ads_edm_book_consume_l30d\ads_edm_book_consume_l30d_update_status
----------------------------------------------------------------
-- SQL语句
insert into ads.ads_SyncBi_update_status
select 3 as id,'ads_edm_book_consume_l30d' as  TableName,max(etl_time) as update_time from ads.ads_edm_book_consume_l30d;

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_edm_userbook_info
-- workflow_version : 33
-- create_user      : linq
-- task_name        : table_status
-- task_version     : 2
-- update_time      : 2023-10-18 19:14:04
-- sql_path         : \starrocks\tbl_ads_edm_userbook_info\table_status
----------------------------------------------------------------
-- SQL语句
insert into ads.ads_SyncBi_update_status
select 2 as id,'ads_edm_user_info_ed' as  TableName,max(etl_time) as update_time from ads.ads_edm_user_info_ed;

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_read_ad_cpm_dh
-- workflow_version : 9
-- create_user      : linq
-- task_name        : ads_read_ad_cpm_dh
-- task_version     : 4
-- update_time      : 2024-06-05 11:01:40
-- sql_path         : \starrocks\tbl_ads_read_ad_cpm_dh\ads_read_ad_cpm_dh
----------------------------------------------------------------
-- 后置SQL语句
insert into ads.ads_SyncBi_update_status
select 7 id, 'SyncBi_ads_read_ad_cpm_dh' TableName, current_timestamp() UpdateTime;

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_sr_ad_read_toufang_tag_da
-- workflow_version : 11
-- create_user      : hufengju
-- task_name        : ads_sr_ad_read_toufang_tag_da
-- task_version     : 10
-- update_time      : 2025-01-03 15:12:31
-- sql_path         : \starrocks\tbl_ads_sr_ad_read_toufang_tag_da\ads_sr_ad_read_toufang_tag_da
----------------------------------------------------------------
-- SQL语句
--===============最新批清洗时间同步：海阅tag人群包标签【最新引流书籍】======================
insert into ads.ads_SyncBi_update_status
select 8 as id,'SyncBi_ads_sr_ad_read_toufang_tag_da' as TableName,max(etl_tm) as UpdateTime
from `ads`.`ads_sr_ad_read_toufang_tag_da`
;

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_tag_sr_pub_spnd_anal
-- workflow_version : 12
-- create_user      : qhr
-- task_name        : update_time
-- task_version     : 5
-- update_time      : 2025-09-22 17:23:31
-- sql_path         : \starrocks\tbl_ads_tag_sr_pub_spnd_anal\update_time
----------------------------------------------------------------
-- SQL语句
update ads.ads_SyncBi_update_status set UpdateTime = (select max(dt) from ads.ads_tag_sr_pub_spnd_anal)
where TableName = 'SyncBi_reader_ads_tag_sr_pub_spnd_anal'
;

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_tag_voiced_category_book_stat_da
-- workflow_version : 16
-- create_user      : xixg
-- task_name        : ads_tag_voiced_category_book_stat_da
-- task_version     : 11
-- update_time      : 2025-02-26 19:45:39
-- sql_path         : \starrocks\tbl_ads_tag_voiced_category_book_stat_da\ads_tag_voiced_category_book_stat_da
----------------------------------------------------------------
-- 前置SQL语句
insert into ads.ads_SyncBi_update_status
select 9 id, 'SyncBi_ads_tag_voiced_category_book_stat_da' TableName, current_timestamp() UpdateTime;
