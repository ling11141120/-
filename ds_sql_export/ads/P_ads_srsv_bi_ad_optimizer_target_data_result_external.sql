----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_srsv_bi_ad_optimizer_target_data_result_external
-- workflow_version : 3
-- create_user      : xixg
-- task_name        : ads_srsv_bi_ad_optimizer_target_data_result_external
-- task_version     : 3
-- update_time      : 2026-04-07 20:27:27
-- sql_path         : \starrocks\tbl_ads_srsv_bi_ad_optimizer_target_data_result_external\ads_srsv_bi_ad_optimizer_target_data_result_external
----------------------------------------------------------------
-- SQL语句
INSERT INTO ads.ads_srsv_bi_ad_optimizer_target_data_result_external
SELECT * FROM ads.ads_srsv_bi_ad_optimizer_target_data_result
where dt>='${bf_9_dt}'  and dt<='${dt}';
