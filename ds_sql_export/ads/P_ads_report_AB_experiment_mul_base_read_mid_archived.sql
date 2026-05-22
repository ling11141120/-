----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_report_AB_experiment_mul
-- workflow_version : 73
-- create_user      : linq
-- task_name        : ads_report_AB_experiment_mul_base_read_mid_archived
-- task_version     : 2
-- update_time      : 2025-03-25 21:45:45
-- sql_path         : \starrocks\tbl_ads_report_AB_experiment_mul\ads_report_AB_experiment_mul_base_read_mid_archived
----------------------------------------------------------------
-- SQL语句
insert into ads.ads_report_AB_experiment_mul_base_read_mid_archived
select dt, source_types, product_id, user_id, book_id, etl_time
from ads.ads_report_AB_experiment_mul_base_read_mid
where dt>=date_sub('${dt}',interval 20 day) and dt<date_sub('${dt}',interval 10 day);
