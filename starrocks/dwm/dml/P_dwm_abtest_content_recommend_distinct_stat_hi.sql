----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dwm_abtest_content_recommend_distinct_stat_hi
-- workflow_version : 10
-- create_user      : xixg
-- task_name        : dwm_abtest_content_recommend_distinct_stat_hi__video_consume_users
-- task_version     : 5
-- update_time      : 2025-05-24 10:56:23
-- sql_path         : \starrocks\tbl_dwm_abtest_content_recommend_distinct_stat_hi\dwm_abtest_content_recommend_distinct_stat_hi__video_consume_users
----------------------------------------------------------------
-- SQL语句
-- 海外短剧业务 进入实验组、且有观看行为、且有消费行为的用户ID
INSERT INTO dwm.dwm_abtest_content_recommend_distinct_stat_hi
(dt_hour, project_id, exp_id, exp_grp_id, consume_users, etl_time)
SELECT
        consume.dt_hour AS dt_hour,
        act_user.project_id AS project_id,
        act_user.exp_id AS exp_id,
        act_user.exp_grp_id AS exp_grp_id,
        TO_BITMAP(consume.user_id) AS user_id,
        NOW()
FROM (
         SELECT
             exp_user.project_id AS project_id,
             exp_user.exp_id AS exp_id,
             exp_user.exp_grp_id AS exp_grp_id,
             exp_user.user_id AS user_id,
             exp_user.object_id AS object_id
         FROM(
                 SELECT
                     login_id AS user_id,
                     shortplay_id AS object_id,  -- 书ID
                     MIN(UNIX_TIMESTAMP(event_tm)) act_time   -- 用户观看的开始时间，取那个最小的开始时间
                 FROM ods_log.ods_sensors_cd_video_startwatching -- 短剧开始观看事件表
                 WHERE dt = '${dt}'
                 GROUP BY 1,2
             )act_event
        INNER JOIN (
                     SELECT
                         project_id AS project_id,
                         exp_id AS exp_id,
                         exp_grp_id AS exp_grp_id,
                         user_id AS user_id,
                         object_id AS object_id,
                         UNIX_TIMESTAMP(event_time) AS reco_time
                     FROM dwd.dwd_abtest_content_recommend_p_hi
                     WHERE project_id = 3 -- 过滤出海剧项目的实验信息
                       AND dt_hour >= '${dt}'
                       AND dt_hour < '${af_1_dt}'
                       AND vip_type = 0
                       AND position_index <  5
                     GROUP BY 1,2,3,4,5,6
                    )exp_user
             ON act_event.user_id = exp_user.user_id
            AND act_event.object_id = exp_user.object_id
            AND act_event.act_time - exp_user.reco_time < 20
            AND act_event.act_time - exp_user.reco_time >= 0
     ) act_user
INNER JOIN(
            SELECT
                    con_view.dt_hour AS dt_hour,
                    con_view.user_id,
                    video_epis.series_id AS object_id   -- 书ID或者剧ID
             FROM (
                      SELECT
                          DATE_FORMAT (create_time, '%Y-%m-%d %H') dt_hour,
                          account_id AS user_id,
                          epis_id
                      FROM ads.ads_consume_short_video_consume_view
                      WHERE dt = '${dt}'
                  ) con_view
             LEFT JOIN (
                           SELECT
                                    series_id,
                                    epis_id
                            FROM dim.dim_short_video_epis_view  -- 关联表获取剧ID
                             GROUP BY 1,2
                        ) video_epis
               ON con_view.epis_id = video_epis.epis_id
            GROUP BY 1,2,3
            )consume
  ON  act_user.user_id = consume.user_id
 AND  act_user.object_id = consume.object_id;

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dwm_abtest_content_recommend_distinct_stat_hi
-- workflow_version : 10
-- create_user      : xixg
-- task_name        : dwm_abtest_content_recommend_distinct_stat_hi__video_read_read_or_watch_users
-- task_version     : 4
-- update_time      : 2025-05-24 10:56:23
-- sql_path         : \starrocks\tbl_dwm_abtest_content_recommend_distinct_stat_hi\dwm_abtest_content_recommend_distinct_stat_hi__video_read_read_or_watch_users
----------------------------------------------------------------
-- SQL语句
-- 海外短剧业务 进入实验组且有阅读行为的用户ID
INSERT INTO dwm.dwm_abtest_content_recommend_distinct_stat_hi
(dt_hour, project_id, exp_id, exp_grp_id, read_or_watch_users, etl_time)
SELECT
    exp_user.dt_hour AS dt_hour,
    exp_user.project_id AS project_id,
    exp_user.exp_id AS exp_id,
    exp_user.exp_grp_id AS exp_grp_id,
    TO_BITMAP(exp_user.user_id) AS user_id,
    NOW()
FROM(
        SELECT
        DATE_FORMAT (event_tm, '%Y-%m-%d %H') AS dt_hour,
        login_id AS user_id,
        shortplay_id AS object_id,  -- 书ID
        MIN(UNIX_TIMESTAMP(event_tm)) act_time   -- 用户观看的开始时间，取那个最小的开始时间
        FROM ods_log.ods_sensors_cd_video_startwatching -- 短剧开始观看事件表
        WHERE dt = '${dt}'
        GROUP BY 1,2,3
    )act_event
INNER JOIN (
            SELECT
                DATE_FORMAT (dt_hour, '%Y-%m-%d %H') AS dt_hour,
                project_id AS project_id,
                exp_id AS exp_id,
                exp_grp_id AS exp_grp_id,
                user_id AS user_id,
                object_id AS object_id,
                UNIX_TIMESTAMP(event_time) AS reco_time
            FROM dwd.dwd_abtest_content_recommend_p_hi
            WHERE project_id = 3 -- 过滤出海剧项目的实验信息
              AND dt_hour >= '${dt}'
              AND dt_hour < '${af_1_dt}'
              AND vip_type = 0
              AND position_index <  5
            GROUP BY 1,2,3,4,5,6,7
            )exp_user
  ON act_event.dt_hour = exp_user.dt_hour
 AND act_event.user_id = exp_user.user_id
 AND act_event.object_id = exp_user.object_id
 AND act_event.act_time - exp_user.reco_time < 20
 AND act_event.act_time - exp_user.reco_time >= 0;

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dwm_abtest_content_recommend_distinct_stat_hi
-- workflow_version : 10
-- create_user      : xixg
-- task_name        : dwm_abtest_content_recommend_distinct_stat_p_hi__all_project_grp_users
-- task_version     : 7
-- update_time      : 2025-05-24 10:56:23
-- sql_path         : \starrocks\tbl_dwm_abtest_content_recommend_distinct_stat_hi\dwm_abtest_content_recommend_distinct_stat_p_hi__all_project_grp_users
----------------------------------------------------------------
-- SQL语句
-- 内容推荐所有业务的用户组ID都来自相同的源表，所以project_id不需要过滤
-- 所有实验进入实验组的用户ID
INSERT INTO dwm.dwm_abtest_content_recommend_distinct_stat_hi
(dt_hour, project_id, exp_id, exp_grp_id, grp_users, etl_time)
    SELECT
            DATE_FORMAT (dt_hour, '%Y-%m-%d %H') AS dt_hour,
            project_id,
            exp_id,
            exp_grp_id,
            TO_BITMAP(user_id) AS user_id,
            NOW()
     FROM dwd.dwd_abtest_content_recommend_p_hi
    WHERE dt_hour >= '${dt}'
      AND dt_hour < '${af_1_dt}'
      AND vip_type = 0
      AND position_index < 5;

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dwm_abtest_content_recommend_distinct_stat_hi
-- workflow_version : 10
-- create_user      : xixg
-- task_name        : dwm_abtest_content_recommend_distinct_stat_p_hi__read_consume_users
-- task_version     : 9
-- update_time      : 2025-05-24 10:56:23
-- sql_path         : \starrocks\tbl_dwm_abtest_content_recommend_distinct_stat_hi\dwm_abtest_content_recommend_distinct_stat_p_hi__read_consume_users
----------------------------------------------------------------
-- SQL语句
-- 阅读业务 进入实验组、且有阅读行为、且有消费行为的用户ID
INSERT INTO dwm.dwm_abtest_content_recommend_distinct_stat_hi
(dt_hour, project_id, exp_id, exp_grp_id, consume_users, etl_time)
SELECT
        consume.dt_hour AS dt_hour,
        act_user.project_id AS project_id,
        act_user.exp_id AS exp_id,
        act_user.exp_grp_id AS exp_grp_id,
        TO_BITMAP(consume.user_id) AS user_id,
        NOW()
FROM (
         SELECT
             exp_user.project_id AS project_id,
             exp_user.exp_id AS exp_id,
             exp_user.exp_grp_id AS exp_grp_id,
             exp_user.user_id AS user_id,
             exp_user.object_id AS object_id
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
                         MIN(UNIX_TIMESTAMP(event_tm)) act_time   -- 用户阅读的开始时间，取那个最小的开始时间
                     FROM ods_log.ods_sensors_production_startreadingchapter  -- 阅读业务 开始阅读章节事件
                     WHERE dt = '${dt}'
                       AND read_chapter_sort = '1'  -- 阅读页章节id序号
                     GROUP BY 1,2
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
                    book_id AS object_id  -- 书ID或者剧ID
             FROM dws.dws_read_consume_user_consume_p_hi
            WHERE dt_hour >= '${dt}'
              AND dt_hour < '${af_1_dt}'
              AND types IN(1, 2, 3)
              AND LENGTH(chapter_id) > 0
              AND book_id > 0
            GROUP BY 1,2,3
         )consume
 ON  act_user.user_id = consume.user_id
AND  act_user.object_id = consume.object_id;

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dwm_abtest_content_recommend_distinct_stat_hi
-- workflow_version : 10
-- create_user      : xixg
-- task_name        : dwm_abtest_content_recommend_distinct_stat_p_hi__read_read_or_watch_users
-- task_version     : 6
-- update_time      : 2025-05-24 10:56:23
-- sql_path         : \starrocks\tbl_dwm_abtest_content_recommend_distinct_stat_hi\dwm_abtest_content_recommend_distinct_stat_p_hi__read_read_or_watch_users
----------------------------------------------------------------
-- SQL语句
-- 阅读业务 进入实验组且有阅读行为的用户ID
INSERT INTO dwm.dwm_abtest_content_recommend_distinct_stat_hi
(dt_hour, project_id, exp_id, exp_grp_id, read_or_watch_users, etl_time)
SELECT
      exp_user.dt_hour AS dt_hour,
      exp_user.project_id AS project_id,
      exp_user.exp_id AS exp_id,
      exp_user.exp_grp_id AS exp_grp_id,
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
                     MIN(UNIX_TIMESTAMP(event_tm)) act_time   -- 用户阅读的开始时间，取那个最小的开始时间
                 FROM ods_log.ods_sensors_production_startreadingchapter  -- 阅读业务 开始阅读章节事件
                 WHERE dt = '${dt}'
                   AND read_chapter_sort = '1'  -- 阅读页章节id序号
                 GROUP BY 1,2,3
            )act_event
    ON act_event.dt_hour = exp_user.dt_hour
   AND act_event.user_id = exp_user.user_id
   AND act_event.object_id = exp_user.object_id
   AND act_event.act_time - exp_user.reco_time < 20
   AND act_event.act_time - exp_user.reco_time >= 0;

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dwm_abtest_content_recommend_distinct_stat_hi_yesterday
-- workflow_version : 3
-- create_user      : xixg
-- task_name        : dwm_abtest_content_recommend_distinct_stat_hi__video_consume_users
-- task_version     : 3
-- update_time      : 2024-06-03 21:01:27
-- sql_path         : \starrocks\tbl_dwm_abtest_content_recommend_distinct_stat_hi_yesterday\dwm_abtest_content_recommend_distinct_stat_hi__video_consume_users
----------------------------------------------------------------
-- SQL语句
-- 海外短剧业务 进入实验组、且有观看行为、且有消费行为的用户ID
INSERT INTO dwm.dwm_abtest_content_recommend_distinct_stat_hi
(dt_hour, project_id, exp_id, exp_grp_id, consume_users, etl_time)
SELECT
        consume.dt_hour AS dt_hour,
        act_user.project_id AS project_id,
        act_user.exp_id AS exp_id,
        act_user.exp_grp_id AS exp_grp_id,
        TO_BITMAP(consume.user_id) AS user_id,
        NOW()
FROM (
         SELECT
             exp_user.project_id AS project_id,
             exp_user.exp_id AS exp_id,
             exp_user.exp_grp_id AS exp_grp_id,
             exp_user.user_id AS user_id,
             exp_user.object_id AS object_id
         FROM(
                 SELECT
                     login_id AS user_id,
                     shortplay_id AS object_id,  -- 书ID
                     MIN(UNIX_TIMESTAMP(event_tm)) act_time   -- 用户观看的开始时间，取那个最小的开始时间
                 FROM ods_log.ods_sensors_cd_video_startwatching -- 短剧开始观看事件表
                 WHERE dt = '${bf_1_dt}'
                 GROUP BY 1,2
             )act_event
        INNER JOIN (
                     SELECT
                         project_id AS project_id,
                         exp_id AS exp_id,
                         exp_grp_id AS exp_grp_id,
                         user_id AS user_id,
                         object_id AS object_id,
                         UNIX_TIMESTAMP(event_time) AS reco_time
                     FROM dwd.dwd_abtest_content_recommend_p_hi
                     WHERE project_id = 3 -- 过滤出海剧项目的实验信息
                       AND dt_hour >= '${bf_1_dt}'
                       AND dt_hour < '${dt}'
                       AND vip_type = 0
                       AND position_index <  5
                     GROUP BY 1,2,3,4,5,6
                    )exp_user
             ON act_event.user_id = exp_user.user_id
            AND act_event.object_id = exp_user.object_id
            AND act_event.act_time - exp_user.reco_time < 20
            AND act_event.act_time - exp_user.reco_time >= 0
     ) act_user
INNER JOIN(
            SELECT
                    con_view.dt_hour AS dt_hour,
                    con_view.user_id,
                    video_epis.series_id AS object_id   -- 书ID或者剧ID
             FROM (
                      SELECT
                          DATE_FORMAT (create_time, '%Y-%m-%d %H') dt_hour,
                          account_id AS user_id,
                          epis_id
                      FROM ads.ads_consume_short_video_consume_view
                      WHERE dt = '${bf_1_dt}'
                  ) con_view
             LEFT JOIN (
                           SELECT
                                    series_id,
                                    epis_id
                            FROM dim.dim_short_video_epis_view  -- 关联表获取剧ID
                             GROUP BY 1,2
                        ) video_epis
               ON con_view.epis_id = video_epis.epis_id
            GROUP BY 1,2,3
            )consume
  ON  act_user.user_id = consume.user_id
 AND  act_user.object_id = consume.object_id;

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dwm_abtest_content_recommend_distinct_stat_hi_yesterday
-- workflow_version : 3
-- create_user      : xixg
-- task_name        : dwm_abtest_content_recommend_distinct_stat_hi__video_read_read_or_watch_users
-- task_version     : 3
-- update_time      : 2024-06-03 21:01:27
-- sql_path         : \starrocks\tbl_dwm_abtest_content_recommend_distinct_stat_hi_yesterday\dwm_abtest_content_recommend_distinct_stat_hi__video_read_read_or_watch_users
----------------------------------------------------------------
-- SQL语句
-- 海外短剧业务 进入实验组且有阅读行为的用户ID
INSERT INTO dwm.dwm_abtest_content_recommend_distinct_stat_hi
(dt_hour, project_id, exp_id, exp_grp_id, read_or_watch_users, etl_time)
SELECT
    exp_user.dt_hour AS dt_hour,
    exp_user.project_id AS project_id,
    exp_user.exp_id AS exp_id,
    exp_user.exp_grp_id AS exp_grp_id,
    TO_BITMAP(exp_user.user_id) AS user_id,
    NOW()
FROM(
        SELECT
        DATE_FORMAT (event_tm, '%Y-%m-%d %H') AS dt_hour,
        login_id AS user_id,
        shortplay_id AS object_id,  -- 书ID
        MIN(UNIX_TIMESTAMP(event_tm)) act_time   -- 用户观看的开始时间，取那个最小的开始时间
        FROM ods_log.ods_sensors_cd_video_startwatching -- 短剧开始观看事件表
        WHERE dt = '${bf_1_dt}'
        GROUP BY 1,2,3
    )act_event
INNER JOIN (
            SELECT
                DATE_FORMAT (dt_hour, '%Y-%m-%d %H') AS dt_hour,
                project_id AS project_id,
                exp_id AS exp_id,
                exp_grp_id AS exp_grp_id,
                user_id AS user_id,
                object_id AS object_id,
                UNIX_TIMESTAMP(event_time) AS reco_time
            FROM dwd.dwd_abtest_content_recommend_p_hi
            WHERE project_id = 3 -- 过滤出海剧项目的实验信息
              AND dt_hour >= '${bf_1_dt}'
              AND dt_hour < '${dt}'
              AND vip_type = 0
              AND position_index <  5
            GROUP BY 1,2,3,4,5,6,7
            )exp_user
  ON act_event.dt_hour = exp_user.dt_hour
 AND act_event.user_id = exp_user.user_id
 AND act_event.object_id = exp_user.object_id
 AND act_event.act_time - exp_user.reco_time < 20
 AND act_event.act_time - exp_user.reco_time >= 0;

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dwm_abtest_content_recommend_distinct_stat_hi_yesterday
-- workflow_version : 3
-- create_user      : xixg
-- task_name        : dwm_abtest_content_recommend_distinct_stat_p_hi__all_project_grp_users
-- task_version     : 2
-- update_time      : 2024-06-03 21:01:27
-- sql_path         : \starrocks\tbl_dwm_abtest_content_recommend_distinct_stat_hi_yesterday\dwm_abtest_content_recommend_distinct_stat_p_hi__all_project_grp_users
----------------------------------------------------------------
-- SQL语句
-- 1、用在sch_ab_exp_yesterday中  2、用户来重跑历史数据的
-- 内容推荐所有业务的用户组ID都来自相同的源表，所以project_id不需要过滤
-- 所有实验进入实验组的用户ID
INSERT INTO dwm.dwm_abtest_content_recommend_distinct_stat_hi
(dt_hour, project_id, exp_id, exp_grp_id, grp_users, etl_time)
    SELECT
            DATE_FORMAT (dt_hour, '%Y-%m-%d %H') AS dt_hour,
            project_id,
            exp_id,
            exp_grp_id,
            TO_BITMAP(user_id) AS user_id,
            NOW()
     FROM dwd.dwd_abtest_content_recommend_p_hi
    WHERE dt_hour >= '${bf_1_dt}'
      AND dt_hour < '${dt}'
      AND vip_type = 0
      AND position_index < 5;

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dwm_abtest_content_recommend_distinct_stat_hi_yesterday
-- workflow_version : 3
-- create_user      : xixg
-- task_name        : dwm_abtest_content_recommend_distinct_stat_p_hi__read_consume_users
-- task_version     : 2
-- update_time      : 2024-06-03 21:01:27
-- sql_path         : \starrocks\tbl_dwm_abtest_content_recommend_distinct_stat_hi_yesterday\dwm_abtest_content_recommend_distinct_stat_p_hi__read_consume_users
----------------------------------------------------------------
-- SQL语句
-- 阅读业务 进入实验组、且有阅读行为、且有消费行为的用户ID
INSERT INTO dwm.dwm_abtest_content_recommend_distinct_stat_hi
(dt_hour, project_id, exp_id, exp_grp_id, consume_users, etl_time)
SELECT
        consume.dt_hour AS dt_hour,
        act_user.project_id AS project_id,
        act_user.exp_id AS exp_id,
        act_user.exp_grp_id AS exp_grp_id,
        TO_BITMAP(consume.user_id) AS user_id,
        NOW()
FROM (
         SELECT
             exp_user.project_id AS project_id,
             exp_user.exp_id AS exp_id,
             exp_user.exp_grp_id AS exp_grp_id,
             exp_user.user_id AS user_id,
             exp_user.object_id AS object_id
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
                   AND dt_hour >= '${bf_1_dt}'
                   AND dt_hour < '${dt}'
                   AND vip_type = 0
                   AND position_index <  5
                 GROUP BY 1,2,3,4,5,6
             )exp_user
        INNER JOIN (
                     SELECT
                         identity_login_id AS user_id,
                         book_id AS object_id,  -- 书ID
                         MIN(UNIX_TIMESTAMP(event_tm)) act_time   -- 用户阅读的开始时间，取那个最小的开始时间
                     FROM ods_log.ods_sensors_production_startreadingchapter  -- 阅读业务 开始阅读章节事件
                     WHERE dt = '${bf_1_dt}'
                       AND read_chapter_sort = '1'  -- 阅读页章节id序号
                     GROUP BY 1,2
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
                    book_id AS object_id  -- 书ID或者剧ID
             FROM dws.dws_read_consume_user_consume_p_hi
            WHERE dt_hour >= '${bf_1_dt}'
              AND dt_hour < '${dt}'
              AND types IN(1, 2, 3)
              AND LENGTH(chapter_id) > 0
              AND book_id > 0
            GROUP BY 1,2,3
         )consume
 ON  act_user.user_id = consume.user_id
AND  act_user.object_id = consume.object_id;

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dwm_abtest_content_recommend_distinct_stat_hi_yesterday
-- workflow_version : 3
-- create_user      : xixg
-- task_name        : dwm_abtest_content_recommend_distinct_stat_p_hi__read_read_or_watch_users
-- task_version     : 2
-- update_time      : 2024-06-03 21:01:27
-- sql_path         : \starrocks\tbl_dwm_abtest_content_recommend_distinct_stat_hi_yesterday\dwm_abtest_content_recommend_distinct_stat_p_hi__read_read_or_watch_users
----------------------------------------------------------------
-- SQL语句
-- 阅读业务 进入实验组且有阅读行为的用户ID
INSERT INTO dwm.dwm_abtest_content_recommend_distinct_stat_hi
(dt_hour, project_id, exp_id, exp_grp_id, read_or_watch_users, etl_time)
SELECT
      exp_user.dt_hour AS dt_hour,
      exp_user.project_id AS project_id,
      exp_user.exp_id AS exp_id,
      exp_user.exp_grp_id AS exp_grp_id,
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
           AND dt_hour >= '${bf_1_dt}'
           AND dt_hour < '${dt}'
           AND vip_type = 0
           AND position_index <  5
         GROUP BY 1,2,3,4,5,6,7
    )exp_user
 INNER JOIN (
                 SELECT
                     DATE_FORMAT (event_tm, '%Y-%m-%d %H') AS dt_hour,
                     identity_login_id AS user_id,
                     book_id AS object_id,  -- 书ID
                     MIN(UNIX_TIMESTAMP(event_tm)) act_time   -- 用户阅读的开始时间，取那个最小的开始时间
                 FROM ods_log.ods_sensors_production_startreadingchapter  -- 阅读业务 开始阅读章节事件
                 WHERE dt = '${bf_1_dt}'
                   AND read_chapter_sort = '1'  -- 阅读页章节id序号
                 GROUP BY 1,2,3
            )act_event
    ON act_event.dt_hour = exp_user.dt_hour
   AND act_event.user_id = exp_user.user_id
   AND act_event.object_id = exp_user.object_id
   AND act_event.act_time - exp_user.reco_time < 20
   AND act_event.act_time - exp_user.reco_time >= 0;
