----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_report_user_dau_ed_external
-- workflow_version : 4
-- create_user      : yanxh
-- task_name        : ads_report_user_dau_ed_external
-- task_version     : 2
-- update_time      : 2024-10-16 11:53:34
-- sql_path         : \starrocks\tbl_ads_report_user_dau_ed_external\ads_report_user_dau_ed_external
----------------------------------------------------------------
-- SQL语句
INSERT into   ads.`ads_report_user_dau_ed_external`
 select * from  ads.`ads_report_user_dau_ed`   where dt>='${bf_1_dt}' and dt<='${dt}';
