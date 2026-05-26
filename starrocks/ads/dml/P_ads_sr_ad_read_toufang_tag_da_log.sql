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
--===============记录每次清洗数据的日志：海阅tag人群包标签【最新引流书籍】======================
insert into ads.`ads_sr_ad_read_toufang_tag_da_log`
select * from `ads`.`ads_sr_ad_read_toufang_tag_da`;
