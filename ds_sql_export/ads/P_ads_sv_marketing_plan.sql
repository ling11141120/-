----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_srsv_marketing_plan
-- workflow_version : 13
-- create_user      : chenmo
-- task_name        : ads_sv_marketing_plan
-- task_version     : 4
-- update_time      : 2025-02-18 15:29:42
-- sql_path         : \starrocks\tbl_ads_srsv_marketing_plan\ads_sv_marketing_plan
----------------------------------------------------------------
-- SQL语句
insert overwrite ads.ads_sv_marketing_plan
select
    source_chl,
    code_id,
    code_stage,
    code_lv,
    etl_time
from ads.ads_srsv_marketing_plan
where project_code = 2;
