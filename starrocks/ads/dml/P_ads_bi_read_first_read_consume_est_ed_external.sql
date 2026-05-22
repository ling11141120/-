----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_bi_read_first_read_consume_est_ed_export
-- workflow_version : 4
-- create_user      : yanxh
-- task_name        : ads_bi_read_first_read_consume_est_ed_external
-- task_version     : 4
-- update_time      : 2024-10-16 16:22:36
-- sql_path         : \starrocks\tbl_ads_bi_read_first_read_consume_est_ed_export\ads_bi_read_first_read_consume_est_ed_external
----------------------------------------------------------------
-- SQL语句
INSERT into ads.`ads_bi_read_first_read_consume_est_ed_external`
 select * from  ads.`ads_bi_read_first_read_consume_est_ed`  where dt='${bf_1_dt}';

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_bi_read_first_read_consume_est_ed_external
-- workflow_version : 6
-- create_user      : yanxh
-- task_name        : ads_bi_read_first_read_consume_est_ed_external
-- task_version     : 5
-- update_time      : 2025-01-09 14:33:21
-- sql_path         : \starrocks\tbl_ads_bi_read_first_read_consume_est_ed_external\ads_bi_read_first_read_consume_est_ed_external
----------------------------------------------------------------
-- SQL语句
INSERT into ads.`ads_bi_read_first_read_consume_est_ed_external`
 select * from  ads.`ads_bi_read_first_read_consume_est_ed`  where dt>=date_sub('${bf_1_dt}',interval 30 day);
