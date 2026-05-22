----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_srsv_marketing_plan
-- workflow_version : 13
-- create_user      : chenmo
-- task_name        : ads_srsv_marketing_plan
-- task_version     : 4
-- update_time      : 2025-02-18 14:32:00
-- sql_path         : \starrocks\tbl_ads_srsv_marketing_plan\ads_srsv_marketing_plan
----------------------------------------------------------------
-- SQL语句
insert overwrite ads.ads_srsv_marketing_plan
select
    project_code,
    source_chl,
    code_id,
    code_stage,
    code_lv,
    now() as etl_time
from (
    SELECT
        *,
        ROW_NUMBER () OVER ( PARTITION BY source_chl,code_id ORDER BY IF(code_stage = - 1, 4, code_stage) DESC, plan_round DESC) AS Rn
    FROM
        ads.ads_srsv_ads_marketing_plan_view
    WHERE is_del = 0 and source_chl != ''
    --  AND project_code = 2 -- 海剧
    --	AND source_chl = 'fb'  -- 媒体 fb tt adwords
) t where rn=1;

-- SQL语句
-- CodeStage 阶段 -1=最终阶段禁投;
