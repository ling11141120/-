----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dwm_abtest_content_product_recommend_distinct_stat_hi
-- workflow_version : 15
-- create_user      : xixg
-- task_name        : dwm_abtest_content_en_recommend_distinct_stat_hi__consume_users
-- task_version     : 11
-- update_time      : 2025-05-24 11:00:22
-- sql_path         : \starrocks\tbl_dwm_abtest_content_product_recommend_distinct_stat_hi\dwm_abtest_content_en_recommend_distinct_stat_hi__consume_users
----------------------------------------------------------------
-- SQL语句
INSERT INTO dwm.dwm_abtest_content_product_recommend_distinct_stat_hi
(dt_hour, project_id, exp_id, exp_grp_id,product_id, consume_users, etl_time)
SELECT
        consume.dt_hour AS dt_hour,
        act_user.project_id AS project_id,
        act_user.exp_id AS exp_id,
        act_user.exp_grp_id AS exp_grp_id,
        act_user.product_id AS product_id,
        TO_BITMAP(consume.user_id) AS user_id,
        NOW()
FROM (
         SELECT
             exp_user.project_id AS project_id,
             exp_user.exp_id AS exp_id,
             exp_user.exp_grp_id AS exp_grp_id,
             exp_user.user_id AS user_id,
             exp_user.object_id AS object_id,
             act_event.product_id AS product_id
         FROM(
                 SELECT
                     project_id AS project_id,
                     exp_id AS exp_id,
                     exp_grp_id AS exp_grp_id,
                     user_id AS user_id,
                     object_id AS object_id,
                     UNIX_TIMESTAMP(event_time) AS reco_time
                 FROM dwd.dwd_abtest_content_recommend_p_hi
                 WHERE project_id = 1  -- 过滤出阅读项目的实验信息
                   AND exp_id = 90013
                   AND dt_hour >= '${dt}'
                   AND dt_hour < '${af_1_dt}'
                   AND vip_type = 0
                   AND position_index <  5
                 GROUP BY 1,2,3,4,5,6
             )exp_user
        INNER JOIN (
                     SELECT
                         identity_login_id AS user_id,
                         book_id AS object_id,  -- 书ID
                         app_product_id AS product_id,
                         MIN(UNIX_TIMESTAMP(event_tm)) act_time   -- 用户阅读的开始时间，取那个最小的开始时间
                     FROM ods_log.ods_sensors_production_startreadingchapter  -- 阅读业务 开始阅读章节事件
                     WHERE dt = '${dt}'
                     --   AND app_product_id = 3366
                       AND read_chapter_sort = '1'  -- 阅读页章节id序号
                     GROUP BY 1,2,3
                    )act_event
             ON act_event.user_id = exp_user.user_id
            AND act_event.object_id = exp_user.object_id
            AND act_event.act_time - exp_user.reco_time < 20
            AND act_event.act_time - exp_user.reco_time >= 0
     ) act_user
INNER JOIN(
            SELECT
                    DATE_FORMAT (dt_hour, '%Y-%m-%d %H') AS dt_hour,
                    user_id,
                    product_id AS product_id,
                    book_id AS object_id  -- 书ID或者剧ID
             FROM dws.dws_read_consume_user_consume_p_hi
            WHERE dt_hour >= '${dt}'
              AND dt_hour < '${af_1_dt}'
            --  AND product_id = 3366
              AND types IN(1, 2, 3)
              AND LENGTH(chapter_id) > 0
              AND book_id > 0
            GROUP BY 1,2,3,4
         )consume
 ON  act_user.user_id = consume.user_id
AND  act_user.object_id = consume.object_id
AND  act_user.product_id = consume.product_id;

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dwm_abtest_content_product_recommend_distinct_stat_hi
-- workflow_version : 15
-- create_user      : xixg
-- task_name        : dwm_abtest_content_en_recommend_distinct_stat_hi__grp_users
-- task_version     : 11
-- update_time      : 2025-05-24 11:00:22
-- sql_path         : \starrocks\tbl_dwm_abtest_content_product_recommend_distinct_stat_hi\dwm_abtest_content_en_recommend_distinct_stat_hi__grp_users
----------------------------------------------------------------
-- SQL语句
INSERT INTO dwm.dwm_abtest_content_product_recommend_distinct_stat_hi
(dt_hour, project_id, exp_id, exp_grp_id,product_id, grp_users, etl_time)
    SELECT
            DATE_FORMAT (dt_hour, '%Y-%m-%d %H') AS dt_hour,
            project_id,
            exp_id,
            exp_grp_id,
            0 AS product_id,
            TO_BITMAP(user_id) AS user_id,
            NOW()
     FROM dwd.dwd_abtest_content_recommend_p_hi
    WHERE dt_hour >= '${dt}'
      AND dt_hour < '${af_1_dt}'
      AND project_id = 1
      AND exp_id = 90013
      AND vip_type = 0
      AND position_index < 5;

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dwm_abtest_content_product_recommend_distinct_stat_hi
-- workflow_version : 15
-- create_user      : xixg
-- task_name        : dwm_abtest_content_en_recommend_distinct_stat_hi__read_or_watch_users
-- task_version     : 10
-- update_time      : 2025-05-24 11:00:22
-- sql_path         : \starrocks\tbl_dwm_abtest_content_product_recommend_distinct_stat_hi\dwm_abtest_content_en_recommend_distinct_stat_hi__read_or_watch_users
----------------------------------------------------------------
-- SQL语句
-- 阅读业务 进入实验组且有阅读行为的用户ID
INSERT INTO dwm.dwm_abtest_content_product_recommend_distinct_stat_hi
(dt_hour, project_id, exp_id, exp_grp_id,product_id, read_or_watch_users, etl_time)
SELECT
      exp_user.dt_hour AS dt_hour,
      exp_user.project_id AS project_id,
      exp_user.exp_id AS exp_id,
      exp_user.exp_grp_id AS exp_grp_id,
      act_event.product_id AS product_id,
      TO_BITMAP(exp_user.user_id) AS user_id,
      NOW()
FROM(
         SELECT
             DATE_FORMAT (dt_hour, '%Y-%m-%d %H') AS dt_hour,
             project_id AS project_id,
             exp_id AS exp_id,
             exp_grp_id AS exp_grp_id,
             user_id AS user_id,
             object_id AS object_id,
             UNIX_TIMESTAMP(event_time) AS reco_time
         FROM dwd.dwd_abtest_content_recommend_p_hi
         WHERE project_id = 1  -- 过滤出阅读项目的实验信息
           AND exp_id = 90013
           AND dt_hour >= '${dt}'
           AND dt_hour < '${af_1_dt}'
           AND vip_type = 0
           AND position_index <  5
         GROUP BY 1,2,3,4,5,6,7
    )exp_user
 INNER JOIN (
                 SELECT
                     DATE_FORMAT (event_tm, '%Y-%m-%d %H') AS dt_hour,
                     identity_login_id AS user_id,
                     book_id AS object_id,  -- 书ID
                     app_product_id AS product_id,
                     MIN(UNIX_TIMESTAMP(event_tm)) act_time   -- 用户阅读的开始时间，取那个最小的开始时间
                 FROM ods_log.ods_sensors_production_startreadingchapter  -- 阅读业务 开始阅读章节事件
                 WHERE dt = '${dt}'
                 --  AND app_product_id = 3366
                   AND read_chapter_sort = '1'  -- 阅读页章节id序号
                 GROUP BY 1,2,3,4
            )act_event
    ON act_event.dt_hour = exp_user.dt_hour
   AND act_event.user_id = exp_user.user_id
   AND act_event.object_id = exp_user.object_id
   AND act_event.act_time - exp_user.reco_time < 20
   AND act_event.act_time - exp_user.reco_time >= 0;
