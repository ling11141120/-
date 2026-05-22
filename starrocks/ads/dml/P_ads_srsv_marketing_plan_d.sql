----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : sch_ads_srsv_marketing_plan
-- workflow_version : 4
-- create_user      : chenmo
-- task_name        : ads_srsv_marketing_plan_d
-- task_version     : 2
-- update_time      : 2025-03-28 15:41:24
-- sql_path         : \starrocks\sch_ads_srsv_marketing_plan\ads_srsv_marketing_plan_d
----------------------------------------------------------------
-- SQL语句
insert into ads.ads_srsv_marketing_plan_d
select
    '${dt}' as dt,
    project_code,
    source_chl,
    code_id,
    code_stage,
    code_lv,
    now() as etl_time
from ads.ads_srsv_marketing_plan
where  code_stage != -1
and (code_stage != 2 or code_lv != 'B') and
code_id in (
    select code_id from ads.ads_srsv_advance_streaming_consume_ed where dt >= '${bf_3_dt}' and dt <= '${bf_1_dt}'
    group by code_id having sum(spend) >= 500
);
