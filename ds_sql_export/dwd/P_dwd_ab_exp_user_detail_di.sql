----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dwd_ab_exp_user_detail_di
-- workflow_version : 3
-- create_user      : xixg
-- task_name        : dwd_ab_exp_user_detail_di
-- task_version     : 3
-- update_time      : 2025-03-21 17:01:02
-- sql_path         : \starrocks\tbl_dwd_ab_exp_user_detail_di\dwd_ab_exp_user_detail_di
----------------------------------------------------------------
-- SQL语句
INSERT INTO dwd.dwd_ab_exp_user_detail_di
SELECT
        create_time AS dt,
        ab_id AS exp_id,
        version_num AS exp_grp_id,
        version AS exp_grp_ver_id,
        user_id,
        min(create_time),
        now() as etl
FROM  ods.ods_ab_experiment_log
WHERE dt = '${dt}'
GROUP BY 1,2,3,4,5;
