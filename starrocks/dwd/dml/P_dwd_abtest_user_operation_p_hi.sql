----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dwd_abtest_user_operation_p_hi
-- workflow_version : 6
-- create_user      : xixg
-- task_name        : dwd_abtest_user_operation_p_hi
-- task_version     : 6
-- update_time      : 2024-05-22 19:24:00
-- sql_path         : \starrocks\tbl_dwd_abtest_user_operation_p_hi\dwd_abtest_user_operation_p_hi
----------------------------------------------------------------
-- SQL语句
INSERT INTO dwd.dwd_abtest_user_operation_p_hi
-- 短剧业务相关实验信息
with short_video_exp_info AS (
SELECT
        DATE_FORMAT (event_time, '%Y-%m-%d %H') dt_hour,
        GET_JSON_STRING(extend_map, '$.project_id') AS project_id,
        GET_JSON_STRING(extend_map, '$.exp_id') AS exp_id,
        GET_JSON_STRING(extend_map, '$.exp_grp_id') AS exp_grp_id,
        CAST(account_id AS BIGINT) user_id,  -- 源表数据类型为 varchar(65533)
        event_time,
        GET_JSON_STRING(extend_map, '$.exp_grp_type') AS exp_grp_type,
        GET_JSON_STRING(reqstr, '$.predict') AS predict,
        GET_JSON_STRING(extend_map, '$.traffic_allocation') traffic_allocation,
        GET_JSON_STRING(extend_map, '$.project_name') project_name,
        GET_JSON_STRING(extend_map, '$.exp_name') exp_name,
        GET_JSON_STRING(extend_map, '$.exp_create_time') create_time,
        GET_JSON_STRING(extend_map, '$.exp_update_time') update_time,
        GET_JSON_STRING(extend_map, '$.exp_grp_name') exp_grp_name
 FROM ods_log.ods_alg_cd_video_shortvideo_user_predict  -- 算法 短剧业务 用户预测事件表
WHERE dt = '${dt}' -- 由于有8个小时的时差，所以原始数据的时间范围要扩大到昨天
  AND GET_JSON_STRING(extend_map, '$.project_id') != 'shortvideo_user_predict'  -- 加过滤条件是因为以下项目数据的project_id与exp_id都为字符串
),

read_exp_info AS (
SELECT
        DATE_FORMAT (event_time, '%Y-%m-%d %H') dt_hour,
        GET_JSON_STRING(extendMap, '$.project_id') AS project_id,
        GET_JSON_STRING(extendMap, '$.exp_id') AS exp_id,
        GET_JSON_STRING(extendMap, '$.exp_grp_id') AS exp_grp_id,
        CAST(userId AS BIGINT) user_id,  -- 源表数据类型为 varchar(65533)
        event_time,
        GET_JSON_STRING(extendMap, '$.exp_grp_type') AS exp_grp_type,
        GET_JSON_STRING(reqstr, '$.predict') AS predict,
        GET_JSON_STRING(extendMap, '$.traffic_allocation') traffic_allocation,
        GET_JSON_STRING(extendMap, '$.project_name') project_name,
        GET_JSON_STRING(extendMap, '$.exp_name') exp_name,
        GET_JSON_STRING(extendMap, '$.exp_create_time') create_time,
        GET_JSON_STRING(extendMap, '$.exp_update_time') update_time,
        GET_JSON_STRING(extendMap, '$.exp_grp_name') exp_grp_name
FROM `ods_log`.`ods_kafka_alg_log_user_predict`   -- 算法 阅读业务  用户预测事件表   这张是视图，源表是`ods_log`.`ods_kafka_alg_log_user_predict`
WHERE dt = '${dt}'
AND GET_JSON_STRING(extendMap, '$.project_id') != 'book_reco'
)

SELECT
        dt_hour,
        project_id,
        exp_id,
        exp_grp_id,
        user_id,
        event_time,
        exp_grp_type,
        predict,
        traffic_allocation,
        project_name,
        exp_name,
        create_time,
        update_time,
        exp_grp_name,
        now() as etl_time
FROM short_video_exp_info
UNION ALL
SELECT
        dt_hour,
        project_id,
        exp_id,
        exp_grp_id,
        user_id,
        event_time,
        exp_grp_type,
        predict,
        traffic_allocation,
        project_name,
        exp_name,
        create_time,
        update_time,
        exp_grp_name,
        now() as etl_time
FROM read_exp_info;
