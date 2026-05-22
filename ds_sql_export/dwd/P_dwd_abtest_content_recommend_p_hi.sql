----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dwd_abtest_content_recommend_p_hi
-- workflow_version : 34
-- create_user      : xixg
-- task_name        : dwd_abtest_content_recommend_p_hi__read_book____expother
-- task_version     : 2
-- update_time      : 2025-05-22 17:34:21
-- sql_path         : \starrocks\tbl_dwd_abtest_content_recommend_p_hi\dwd_abtest_content_recommend_p_hi__read_book____expother
----------------------------------------------------------------
-- SQL语句
INSERT INTO dwd.dwd_abtest_content_recommend_p_hi
 SELECT
     DATE_FORMAT (event_time, '%Y-%m-%d %H') dt_hour,
     project_id,
     exp_id,
     exp_grp_id,
     bookId AS object_id,
     CAST(userId AS BIGINT) user_id,
     event_time,
     exp_grp_type,
     IF(exp_type_id IS NULL,1,exp_type_id) AS exp_type_id,
     pageId AS exp_sub_type,
     vip_type,
     `index` AS position_index,
     traffic_allocation,
     project_name,
     exp_name,
     exp_create_time,
     exp_update_time,
     exp_grp_name,
      now() as etl_time
 FROM ods_log.ods_kafka_alg_log_book_reco
 WHERE dt = '${dt}'
 AND project_id != 'book_reco'
 AND exp_id not in  (30021,180001);

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dwd_abtest_content_recommend_p_hi
-- workflow_version : 34
-- create_user      : xixg
-- task_name        : dwd_abtest_content_recommend_p_hi__read_book__expid180001
-- task_version     : 10
-- update_time      : 2025-05-22 17:34:21
-- sql_path         : \starrocks\tbl_dwd_abtest_content_recommend_p_hi\dwd_abtest_content_recommend_p_hi__read_book__expid180001
----------------------------------------------------------------
-- 前置SQL语句
SET query_timeout = 600;

-- SQL语句
INSERT INTO dwd.dwd_abtest_content_recommend_p_hi
 SELECT
     DATE_FORMAT (event_time, '%Y-%m-%d %H') dt_hour,
     project_id,
     exp_id,
     exp_grp_id,
     bookId AS object_id,
     CAST(userId AS BIGINT) user_id,
     event_time,
     exp_grp_type,
     IF(exp_type_id IS NULL,1,exp_type_id) AS exp_type_id,
     pageId AS exp_sub_type,
     vip_type,
     `index` AS position_index,
     traffic_allocation,
     project_name,
     exp_name,
     exp_create_time,
     exp_update_time,
     exp_grp_name,
      now() as etl_time
 FROM ods_log.ods_kafka_alg_log_book_reco
 WHERE dt = '${dt}'
 AND project_id != 'book_reco'
 AND exp_id = 180001;

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dwd_abtest_content_recommend_p_hi
-- workflow_version : 34
-- create_user      : xixg
-- task_name        : dwd_abtest_content_recommend_p_hi__read_book__expid30021__expgrpid458522
-- task_version     : 3
-- update_time      : 2025-05-22 17:34:21
-- sql_path         : \starrocks\tbl_dwd_abtest_content_recommend_p_hi\dwd_abtest_content_recommend_p_hi__read_book__expid30021__expgrpid458522
----------------------------------------------------------------
-- SQL语句
INSERT INTO dwd.dwd_abtest_content_recommend_p_hi
 SELECT
     DATE_FORMAT (event_time, '%Y-%m-%d %H') dt_hour,
     project_id,
     exp_id,
     exp_grp_id,
     bookId AS object_id,
     CAST(userId AS BIGINT) user_id,
     event_time,
     exp_grp_type,
     IF(exp_type_id IS NULL,1,exp_type_id) AS exp_type_id,
     pageId AS exp_sub_type,
     vip_type,
     `index` AS position_index,
     traffic_allocation,
     project_name,
     exp_name,
     exp_create_time,
     exp_update_time,
     exp_grp_name,
      now() as etl_time
 FROM ods_log.ods_kafka_alg_log_book_reco
 WHERE dt = '${dt}'
 AND project_id != 'book_reco'
 AND exp_id = 30021
 AND exp_grp_id = 458522;

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dwd_abtest_content_recommend_p_hi
-- workflow_version : 34
-- create_user      : xixg
-- task_name        : dwd_abtest_content_recommend_p_hi__read_book__expid30021__expgrpid965940
-- task_version     : 2
-- update_time      : 2025-05-22 17:34:21
-- sql_path         : \starrocks\tbl_dwd_abtest_content_recommend_p_hi\dwd_abtest_content_recommend_p_hi__read_book__expid30021__expgrpid965940
----------------------------------------------------------------
-- SQL语句
INSERT INTO dwd.dwd_abtest_content_recommend_p_hi
 SELECT
     DATE_FORMAT (event_time, '%Y-%m-%d %H') dt_hour,
     project_id,
     exp_id,
     exp_grp_id,
     bookId AS object_id,
     CAST(userId AS BIGINT) user_id,
     event_time,
     exp_grp_type,
     IF(exp_type_id IS NULL,1,exp_type_id) AS exp_type_id,
     pageId AS exp_sub_type,
     vip_type,
     `index` AS position_index,
     traffic_allocation,
     project_name,
     exp_name,
     exp_create_time,
     exp_update_time,
     exp_grp_name,
      now() as etl_time
 FROM ods_log.ods_kafka_alg_log_book_reco
 WHERE dt = '${dt}'
 AND project_id != 'book_reco'
 AND exp_id = 30021
 AND exp_grp_id = 965940;

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dwd_abtest_content_recommend_p_hi
-- workflow_version : 34
-- create_user      : xixg
-- task_name        : dwd_abtest_content_recommend_p_hi__read_book__expid30021__expgrpidother
-- task_version     : 2
-- update_time      : 2025-05-22 17:34:21
-- sql_path         : \starrocks\tbl_dwd_abtest_content_recommend_p_hi\dwd_abtest_content_recommend_p_hi__read_book__expid30021__expgrpidother
----------------------------------------------------------------
-- SQL语句
INSERT INTO dwd.dwd_abtest_content_recommend_p_hi
 SELECT
     DATE_FORMAT (event_time, '%Y-%m-%d %H') dt_hour,
     project_id,
     exp_id,
     exp_grp_id,
     bookId AS object_id,
     CAST(userId AS BIGINT) user_id,
     event_time,
     exp_grp_type,
     IF(exp_type_id IS NULL,1,exp_type_id) AS exp_type_id,
     pageId AS exp_sub_type,
     vip_type,
     `index` AS position_index,
     traffic_allocation,
     project_name,
     exp_name,
     exp_create_time,
     exp_update_time,
     exp_grp_name,
      now() as etl_time
 FROM ods_log.ods_kafka_alg_log_book_reco
 WHERE dt = '${dt}'
 AND project_id != 'book_reco'
 AND exp_id = 30021
 AND exp_grp_id not in (458522,965940);

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dwd_abtest_content_recommend_p_hi
-- workflow_version : 34
-- create_user      : xixg
-- task_name        : dwd_abtest_content_recommend_p_hi__short_video__expid180003_grp564860
-- task_version     : 23
-- update_time      : 2025-05-27 09:51:31
-- sql_path         : \starrocks\tbl_dwd_abtest_content_recommend_p_hi\dwd_abtest_content_recommend_p_hi__short_video__expid180003_grp564860
----------------------------------------------------------------
-- SQL语句
INSERT INTO dwd.dwd_abtest_content_recommend_p_hi
SELECT
        DATE_FORMAT (event_time, '%Y-%m-%d %H') dt_hour,
        project_id,
        exp_id,
        exp_grp_id,
        series_id AS object_id,
        CAST(account_id AS BIGINT) user_id,
        event_time,
        exp_grp_type,
        IF(exp_type_id IS NULL,1,exp_type_id),
        scene_id AS exp_sub_type,
        vip_type,
        index_i AS position_index,
        traffic_allocation,
        project_name,
        exp_name,
        exp_create_time,
        exp_update_time,
        exp_grp_name,
         now() as etl_time
    FROM ods_log.ods_alg_cd_video_shortvideo_reco
    WHERE dt = '${dt}'
    AND project_id != 'shortvideo_user_predict'
    AND exp_id = 180003
    AND exp_grp_id = 564860;

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dwd_abtest_content_recommend_p_hi
-- workflow_version : 34
-- create_user      : xixg
-- task_name        : dwd_abtest_content_recommend_p_hi__short_video__expid180003_grpid477185
-- task_version     : 10
-- update_time      : 2025-05-27 09:51:31
-- sql_path         : \starrocks\tbl_dwd_abtest_content_recommend_p_hi\dwd_abtest_content_recommend_p_hi__short_video__expid180003_grpid477185
----------------------------------------------------------------
-- SQL语句
INSERT INTO dwd.dwd_abtest_content_recommend_p_hi
SELECT
        DATE_FORMAT (event_time, '%Y-%m-%d %H') dt_hour,
        project_id,
        exp_id,
        exp_grp_id,
        series_id AS object_id,
        CAST(account_id AS BIGINT) user_id,
        event_time,
        exp_grp_type,
        IF(exp_type_id IS NULL,1,exp_type_id),
        scene_id AS exp_sub_type,
        vip_type,
        index_i AS position_index,
        traffic_allocation,
        project_name,
        exp_name,
        exp_create_time,
        exp_update_time,
        exp_grp_name,
         now() as etl_time
    FROM ods_log.ods_alg_cd_video_shortvideo_reco
    WHERE dt = '${dt}'
    AND project_id != 'shortvideo_user_predict'
    AND exp_id = 180003
    AND exp_grp_id = 477185;

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dwd_abtest_content_recommend_p_hi
-- workflow_version : 34
-- create_user      : xixg
-- task_name        : dwd_abtest_content_recommend_p_hi__short_video__expid_180003_expgrpid368996
-- task_version     : 16
-- update_time      : 2025-05-27 09:51:31
-- sql_path         : \starrocks\tbl_dwd_abtest_content_recommend_p_hi\dwd_abtest_content_recommend_p_hi__short_video__expid_180003_expgrpid368996
----------------------------------------------------------------
-- SQL语句
INSERT INTO dwd.dwd_abtest_content_recommend_p_hi
SELECT
        DATE_FORMAT (event_time, '%Y-%m-%d %H') dt_hour,
        project_id,
        exp_id,
        exp_grp_id,
        series_id AS object_id,
        CAST(account_id AS BIGINT) user_id,
        event_time,
        exp_grp_type,
        IF(exp_type_id IS NULL,1,exp_type_id),
        scene_id AS exp_sub_type,
        vip_type,
        index_i AS position_index,
        traffic_allocation,
        project_name,
        exp_name,
        exp_create_time,
        exp_update_time,
        exp_grp_name,
         now() as etl_time
    FROM ods_log.ods_alg_cd_video_shortvideo_reco
    WHERE dt = '${dt}'
    AND project_id != 'shortvideo_user_predict'
    AND exp_id = 180003
    AND exp_grp_id = 368996;

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dwd_abtest_content_recommend_p_hi
-- workflow_version : 34
-- create_user      : xixg
-- task_name        : dwd_abtest_content_recommend_p_hi__short_video__expid_other
-- task_version     : 14
-- update_time      : 2025-05-27 09:51:31
-- sql_path         : \starrocks\tbl_dwd_abtest_content_recommend_p_hi\dwd_abtest_content_recommend_p_hi__short_video__expid_other
----------------------------------------------------------------
-- SQL语句
INSERT INTO dwd.dwd_abtest_content_recommend_p_hi
SELECT
        DATE_FORMAT (event_time, '%Y-%m-%d %H') dt_hour,
        project_id,
        exp_id,
        exp_grp_id,
        series_id AS object_id,
        CAST(account_id AS BIGINT) user_id,
        event_time,
        exp_grp_type,
        IF(exp_type_id IS NULL,1,exp_type_id),
        scene_id AS exp_sub_type,
        vip_type,
        index_i AS position_index,
        traffic_allocation,
        project_name,
        exp_name,
        exp_create_time,
        exp_update_time,
        exp_grp_name,
         now() as etl_time
    FROM ods_log.ods_alg_cd_video_shortvideo_reco
    WHERE dt = '${dt}'
    AND project_id != 'shortvideo_user_predict'
    AND exp_id != 180003;
