----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dws_abtest_content_recommend_accumulation_stat_hi
-- workflow_version : 13
-- create_user      : xixg
-- task_name        : dws_abtest_content_recommend_accumulation_stat_hi__video
-- task_version     : 8
-- update_time      : 2025-05-24 10:58:41
-- sql_path         : \starrocks\tbl_dws_abtest_content_recommend_accumulation_stat_hi\dws_abtest_content_recommend_accumulation_stat_hi__video
----------------------------------------------------------------
-- SQL语句
-- 内容推荐---海剧业务  可累加指标小时统计
INSERT INTO dws.dws_abtest_content_recommend_accumulation_stat_hi
-- 海剧业务   总观看集数
WITH video_series_tmp AS (
SELECT
    chapter.dt_hour,
    exp_grp.project_id,                                                         -- 项目ID
    exp_grp.exp_id,                                                             -- 实验ID
    exp_grp.exp_grp_id,                                                         -- 实验组ID
    MAX(exp_grp.exp_name) as exp_name,                                          -- 实验名称
    MAX(exp_grp.exp_grp_type) AS exp_grp_type,                                  -- 实验组类型
    MAX(exp_grp.exp_grp_name) AS exp_grp_name,                                  -- 实验组名称
    MAX(traffic.traffic_allocation) AS traffic_allocation,                      -- 流量占比
    SUM(chapter.act_cnt) AS ifd_reco_total_act_cnt                              -- 总阅读章节数（总观看集数）
FROM (
         SELECT
             project_id,
             exp_id,
             exp_grp_id,
             object_id,
             user_id,
             exp_grp_type,
             MAX(exp_name) AS exp_name,
             MAX(exp_grp_name) AS exp_grp_name
         FROM dwd.dwd_abtest_content_recommend_p_hi
         WHERE dt_hour >= '${dt}'
           AND dt_hour < '${af_1_dt}'
           AND project_id = 3
           AND vip_type = 0
           AND position_index < 5
         GROUP BY 1,2,3,4,5,6
     )exp_grp
LEFT JOIN(
            SELECT
                      reco_event.exp_id as exp_id,
                      act_event.user_id AS user_id,
                      act_event.object_id AS object_id                          -- 书ID
             FROM(
                    SELECT
                            login_id AS user_id,
                            shortplay_id AS object_id,                          -- 书ID
                            MIN(UNIX_TIMESTAMP(event_tm)) act_time              -- 用户阅读的开始时间，取那个最小的开始时间
                     FROM ods_log.ods_sensors_cd_video_startwatching
                    WHERE dt = '${dt}'
                    GROUP BY 1,2
                )act_event
             INNER JOIN (
                            SELECT
                                     exp_id,
                                     user_id,
                                     object_id,
                                     UNIX_TIMESTAMP(event_time) AS reco_time
                             FROM dwd.dwd_abtest_content_recommend_p_hi
                            WHERE dt_hour >= '${dt}'
                              AND dt_hour < '${af_1_dt}'
                               AND project_id = 3
                               AND vip_type = 0
                               AND position_index < 5
                             GROUP BY 1,2,3,4
                        )reco_event
                ON act_event.user_id = reco_event.user_id
               AND act_event.object_id = reco_event.object_id
               AND act_event.act_time - reco_event.reco_time < 20
               AND act_event.act_time - reco_event.reco_time >= 0
             GROUP BY 1,2,3
         )reco_acti_user
 ON  exp_grp.exp_id = reco_acti_user.exp_id
AND  exp_grp.object_id = reco_acti_user.object_id
AND  exp_grp.user_id = reco_acti_user.user_id
INNER JOIN(
            SELECT
                    DATE_FORMAT (event_tm, '%Y-%m-%d %H') AS dt_hour,
                    login_id AS user_id,
                    shortplay_id AS object_id,                              -- 书ID或者剧ID
                    COUNT(DISTINCT(episode_id)) AS act_cnt                  -- 阅读章节数（观看集数）
             FROM ods_log.ods_sensors_cd_video_endwatching
            WHERE dt = '${dt}'
            GROUP BY 1,2,3
         )chapter
 ON  reco_acti_user.object_id = chapter.object_id
AND  reco_acti_user.user_id = chapter.user_id
LEFT JOIN (
            SELECT
                project_id,
                exp_id,
                exp_grp_id,
                traffic_allocation
            FROM (
                     SELECT
                         project_id,
                         exp_id,
                         exp_grp_id,
                         traffic_allocation,
                         ROW_NUMBER() OVER(PARTITION BY project_id,exp_id,exp_grp_id ORDER BY exp_update_time DESC) AS rn -- 流量比例分配可能会修改，要到最新的值
                     FROM dwd.dwd_abtest_content_recommend_p_hi
                     WHERE dt_hour >= '${dt}'
                       AND dt_hour < '${af_1_dt}'
                       AND project_id = 3
                       AND vip_type = 0
                      AND position_index < 5
                ) tmp
          WHERE tmp.rn = 1
        )traffic
ON  exp_grp.project_id = traffic.project_id
AND  exp_grp.exp_id = traffic.exp_id
AND  exp_grp.exp_grp_id = traffic.exp_grp_id
GROUP BY 1,2,3,4),

-- 海剧业务   总解锁章节数（总解锁集数）  总消费
video_series_consum_tmp AS (
SELECT
        consume.dt_hour,
        exp_grp.project_id,                                                     -- 项目ID
        exp_grp.exp_id,                                                         -- 实验ID
        exp_grp.exp_grp_id,                                                     -- 实验组ID
        MAX(exp_grp.exp_name) as exp_name,                                      -- 实验名称
        MAX(exp_grp.exp_grp_type) AS exp_grp_type,                              -- 实验组类型
        MAX(exp_grp.exp_grp_name) AS exp_grp_name,                              -- 实验组名称
        MAX(traffic.traffic_allocation) AS traffic_allocation,                  -- 流量占比
        SUM(consume.unlock_act_cnt) AS ifd_reco_total_unlock_cnt,               -- 总解锁章节数（总解锁集数）
        ROUND(SUM(consume.consume_amount/100),0) AS ifd_reco_total_consume      -- 总消费
FROM (
         SELECT
                 project_id,
                 exp_id,
                 exp_grp_id,
                 object_id,
                 user_id,
                 exp_grp_type,
                 MAX(exp_name) AS exp_name,
                 MAX(exp_grp_name) AS exp_grp_name
         FROM dwd.dwd_abtest_content_recommend_p_hi
         WHERE dt_hour >= '${dt}'
           AND dt_hour < '${af_1_dt}'
           AND project_id = 3
           AND vip_type = 0
           AND position_index < 5
         GROUP BY 1,2,3,4,5,6
     )exp_grp
LEFT JOIN(
            SELECT
                      reco_event.exp_id as exp_id,
                      act_event.user_id AS user_id,
                      act_event.object_id AS object_id                      -- 书ID
             FROM(
                    SELECT
                            login_id AS user_id,
                            shortplay_id AS object_id,                      -- 书ID
                            MIN(UNIX_TIMESTAMP(event_tm)) act_time          -- 用户阅读的开始时间，取那个最小的开始时间
                     FROM ods_log.ods_sensors_cd_video_startwatching
                    WHERE dt = '${dt}'
                    GROUP BY 1,2
                )act_event
             INNER JOIN (
                            SELECT
                                     exp_id,
                                     user_id,
                                     object_id,
                                     UNIX_TIMESTAMP(event_time) AS reco_time
                             FROM dwd.dwd_abtest_content_recommend_p_hi
                            WHERE dt_hour >= '${dt}'
                              AND dt_hour < '${af_1_dt}'
                               AND project_id = 3
                               AND vip_type = 0
                               AND position_index < 5
                             GROUP BY 1,2,3,4
                        )reco_event
                ON act_event.user_id = reco_event.user_id
               AND act_event.object_id = reco_event.object_id
               AND act_event.act_time - reco_event.reco_time < 20
               AND act_event.act_time - reco_event.reco_time >= 0
             GROUP BY 1,2,3
         )reco_acti_user
 ON  exp_grp.exp_id = reco_acti_user.exp_id
AND  exp_grp.object_id = reco_acti_user.object_id
AND  exp_grp.user_id = reco_acti_user.user_id
INNER JOIN(
            SELECT
                    con_view.dt_hour AS dt_hour,
                    con_view.user_id,
                    video_epis.series_id AS object_id,                      -- 书ID或者剧ID
                    SUM(con_view.consume_value) AS consume_amount,          -- 消费总书币
                    COUNT(DISTINCT con_view.epis_id) AS unlock_act_cnt      -- 解锁章节数（解锁集数）
             FROM  (
                      SELECT
                            DATE_FORMAT (create_time, '%Y-%m-%d %H') AS dt_hour,
                            account_id AS user_id,
                            epis_id,
                            consume_value
                        FROM ads.ads_consume_short_video_consume_view
                       WHERE dt = '${dt}'
                    ) con_view
             LEFT JOIN (
                           SELECT
                                    series_id,
                                    epis_id
                            FROM dim.dim_short_video_epis_view              -- 关联表获取剧ID
                             GROUP BY 1,2
                        ) video_epis
               ON con_view.epis_id = video_epis.epis_id
            GROUP BY 1,2,3
         )consume
 ON  reco_acti_user.object_id = consume.object_id
AND  reco_acti_user.user_id = consume.user_id
LEFT JOIN (
            SELECT
                project_id,
                exp_id,
                exp_grp_id,
                traffic_allocation
            FROM (
                    SELECT
                            project_id,
                            exp_id,
                            exp_grp_id,
                            traffic_allocation,
                            ROW_NUMBER() OVER(PARTITION BY project_id,exp_id,exp_grp_id ORDER BY exp_update_time DESC) AS rn -- 流量比例分配可能会修改，要到最新的值
                     FROM dwd.dwd_abtest_content_recommend_p_hi
                    WHERE dt_hour >= '${dt}'
                    AND dt_hour < '${af_1_dt}'
                    AND project_id = 1
                    AND vip_type = 0
                    AND position_index < 5
                ) tmp
            WHERE tmp.rn = 1
    )traffic
ON  exp_grp.project_id = traffic.project_id
AND  exp_grp.exp_id = traffic.exp_id
AND  exp_grp.exp_grp_id = traffic.exp_grp_id
GROUP BY 1,2,3,4)

SELECT
       dt_hour,
       project_id,                                                      -- 项目ID
       exp_id,                                                          -- 实验ID
       exp_grp_id,                                                      -- 实验组ID
       exp_name,                                                        -- 实验名称
       exp_grp_type,                                                    -- 实验组类型
       exp_grp_name,                                                    -- 实验组名称
       MAX(traffic_allocation) AS traffic_allocation,                   -- 流量占比
       SUM(ifd_reco_total_act_cnt) AS ifd_reco_total_act_cnt,           -- 总阅读章节数（总观看集数）
       SUM (ifd_reco_total_unlock_cnt) AS ifd_reco_total_unlock_cnt,    -- 解锁章节数
       SUM (ifd_reco_total_consume) AS ifd_reco_total_consume,          -- 总消费
       MAX(NOW())
FROM
    (SELECT
            dt_hour,
            project_id,                         -- 项目ID
            exp_id,                             -- 实验ID
            exp_grp_id,                         -- 实验组ID
            exp_name,                           -- 实验名称
            exp_grp_type,                       -- 实验组类型
            exp_grp_name,                       -- 实验组名称
            traffic_allocation,                 -- 流量占比
            ifd_reco_total_act_cnt,             -- 总阅读章节数（总观看集数）
            0 AS ifd_reco_total_unlock_cnt,     -- 解锁章节数
            0 AS ifd_reco_total_consume         -- 总消费
    FROM video_series_tmp
    UNION ALL
    SELECT
            dt_hour,
            project_id,                         -- 项目ID
            exp_id,                             -- 实验ID
            exp_grp_id,                         -- 实验组ID
            exp_name,                           -- 实验名称
            exp_grp_type,                       -- 实验组类型
            exp_grp_name,                       -- 实验组名称
            traffic_allocation,                 -- 流量占比
            0 AS ifd_reco_total_act_cnt,        -- 总阅读章节数（总观看集数）
            ifd_reco_total_unlock_cnt,          -- 解锁章节数
            ifd_reco_total_consume              -- 总消费
    FROM video_series_consum_tmp
    )  a
GROUP BY 1,2,3,4,5,6,7;

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dws_abtest_content_recommend_accumulation_stat_hi
-- workflow_version : 13
-- create_user      : xixg
-- task_name        : dws_abtest_content_recommend_accumulation_stat_hi_read
-- task_version     : 11
-- update_time      : 2025-05-24 10:58:41
-- sql_path         : \starrocks\tbl_dws_abtest_content_recommend_accumulation_stat_hi\dws_abtest_content_recommend_accumulation_stat_hi_read
----------------------------------------------------------------
-- SQL语句
-- 内容推荐---阅读业务  可累加指标小时统计
INSERT INTO dws.dws_abtest_content_recommend_accumulation_stat_hi
-- 阅读业务   总阅读章节数
WITH read_chapter_tmp AS (
SELECT
        chapter.dt_hour,
        exp_grp.project_id,                                     -- 项目ID
        exp_grp.exp_id,                                         -- 实验ID
        exp_grp.exp_grp_id,                                     -- 实验组ID
        MAX(exp_grp.exp_name) as exp_name,                      -- 实验名称
        MAX(exp_grp.exp_grp_type) AS exp_grp_type,              -- 实验组类型
        MAX(exp_grp.exp_grp_name) AS exp_grp_name,              -- 实验组名称
        MAX(traffic.traffic_allocation) AS traffic_allocation,  -- 流量占比
        SUM(chapter.act_cnt) AS ifd_reco_total_act_cnt          -- 总阅读章节数（总观看集数）
FROM (
         SELECT
                 project_id,
                 exp_id,
                 exp_grp_id,
                 object_id,
                 user_id,
                 exp_grp_type,
                 MAX(exp_name) AS exp_name,
                 MAX(exp_grp_name) AS exp_grp_name
          FROM dwd.dwd_abtest_content_recommend_p_hi
         WHERE dt_hour >= '${dt}'
           AND dt_hour < '${af_1_dt}'
           AND project_id = 1
           AND vip_type = 0
           AND position_index < 5
         GROUP BY 1,2,3,4,5,6
     )exp_grp
LEFT JOIN(
            SELECT
                      reco_event.exp_id as exp_id,
                      act_event.user_id AS user_id,
                      act_event.object_id AS object_id                  -- 书ID
             FROM(
                    SELECT
                            identity_login_id AS user_id,
                            book_id AS object_id,                       -- 书ID
                            MIN(UNIX_TIMESTAMP(event_tm)) act_time      -- 用户阅读的开始时间，取那个最小的开始时间
                     FROM ods_log.ods_sensors_production_startreadingchapter
                    WHERE dt = '${dt}'
                      AND read_chapter_sort = '1'  -- 阅读页章节id序号
                    GROUP BY 1,2
                )act_event
             INNER JOIN (
                            SELECT
                                     exp_id,
                                     user_id,
                                     object_id,
                                     UNIX_TIMESTAMP(event_time) AS reco_time
                             FROM dwd.dwd_abtest_content_recommend_p_hi
                            WHERE dt_hour >= '${dt}'
                              AND dt_hour < '${af_1_dt}'
                               AND project_id = 1
                               AND vip_type = 0
                               AND position_index < 5
                             GROUP BY 1,2,3,4
                        )reco_event
                ON act_event.user_id = reco_event.user_id
               AND act_event.object_id = reco_event.object_id
               AND act_event.act_time - reco_event.reco_time < 20
               AND act_event.act_time - reco_event.reco_time >= 0
             GROUP BY 1,2,3
         )reco_acti_user
  ON  exp_grp.exp_id = reco_acti_user.exp_id
 AND  exp_grp.object_id = reco_acti_user.object_id
 AND  exp_grp.user_id = reco_acti_user.user_id
INNER JOIN (
                SELECT
                    DATE_FORMAT (event_tm, '%Y-%m-%d %H') AS dt_hour,
                    identity_login_id AS user_id,
                    book_id AS object_id,  -- 书ID
                    COUNT(DISTINCT(chapter_id)) AS act_cnt   -- 阅读章节数（观看集数）
                FROM ods_log.ods_sensors_production_startreadingchapter
                WHERE dt = '${dt}'
                GROUP BY 1,2,3
            ) chapter
  ON  reco_acti_user.object_id = chapter.object_id
 AND  reco_acti_user.user_id = chapter.user_id
LEFT JOIN (
            SELECT
                project_id,
                exp_id,
                exp_grp_id,
                traffic_allocation
            FROM (
                     SELECT
                         project_id,
                         exp_id,
                         exp_grp_id,
                         traffic_allocation,
                         ROW_NUMBER() OVER(PARTITION BY project_id,exp_id,exp_grp_id ORDER BY exp_update_time DESC) AS rn -- 流量比例分配可能会修改，要到最新的值
                     FROM dwd.dwd_abtest_content_recommend_p_hi
                     WHERE dt_hour >= '${dt}'
                       AND dt_hour < '${af_1_dt}'
                      AND project_id = 1
                      AND vip_type = 0
                      AND position_index < 5
                ) tmp
          WHERE tmp.rn = 1
        )traffic
 ON  exp_grp.project_id = traffic.project_id
AND  exp_grp.exp_id = traffic.exp_id
AND  exp_grp.exp_grp_id = traffic.exp_grp_id
GROUP BY 1,2,3,4),

read_consume_tmp AS (
SELECT
        consume.dt_hour,
        exp_grp.project_id,                                             -- 项目ID
        exp_grp.exp_id,                                                 -- 实验ID
        exp_grp.exp_grp_id,                                             -- 实验组ID
        MAX(exp_grp.exp_name) as exp_name,                              -- 实验名称
        MAX(exp_grp.exp_grp_type) AS exp_grp_type,                      -- 实验组类型
        MAX(exp_grp.exp_grp_name) AS exp_grp_name,                      -- 实验组名称
        MAX(traffic.traffic_allocation) AS traffic_allocation,          -- 流量占比
        SUM (consume.unlock_act_cnt) AS ifd_reco_total_unlock_cnt,      -- 解锁章节数
        SUM (consume.consume_amount) AS ifd_reco_total_consume          -- 总消费
 FROM (
         SELECT
                 project_id,
                 exp_id,
                 exp_grp_id,
                 object_id,
                 user_id,
                 exp_grp_type,
                 MAX(exp_name) AS exp_name,
                 MAX(exp_grp_name) AS exp_grp_name
          FROM dwd.dwd_abtest_content_recommend_p_hi
         WHERE dt_hour >= '${dt}' AND dt_hour < '${af_1_dt}'
           AND project_id = 1
           AND vip_type = 0
           AND position_index < 5
        GROUP BY 1,2,3,4,5,6
    ) exp_grp
LEFT JOIN (
            SELECT
                    reco_event.exp_id as exp_id,
                    act_event.user_id AS user_id,
                    act_event.object_id AS object_id                       -- 书ID
             FROM (
                    SELECT
                            identity_login_id AS user_id,
                            book_id AS object_id,                          -- 书ID
                            MIN (UNIX_TIMESTAMP(event_tm)) act_time        -- 用户阅读的开始时间，取那个最小的开始时间
                     FROM ods_log.ods_sensors_production_startreadingchapter
                    WHERE dt = '${dt}'
                      AND read_chapter_sort = '1'                          -- 阅读页章节id序号
                    GROUP BY 1,2
                ) act_event
            INNER JOIN (
                        SELECT
                                exp_id,
                                user_id,
                                object_id,
                                UNIX_TIMESTAMP(event_time) AS reco_time
                         FROM dwd.dwd_abtest_content_recommend_p_hi
                        WHERE dt_hour >= '${dt}'
                         AND dt_hour < '${af_1_dt}'
                         AND project_id = 1
                         AND vip_type = 0
                         AND position_index < 5
                        GROUP BY 1,2,3,4
                        ) reco_event
               ON act_event.user_id = reco_event.user_id
              AND act_event.object_id = reco_event.object_id
              AND act_event.act_time - reco_event.reco_time < 20
              AND act_event.act_time - reco_event.reco_time >= 0
            GROUP BY 1,2,3
        ) reco_acti_user
   ON exp_grp.exp_id = reco_acti_user.exp_id
  AND exp_grp.object_id = reco_acti_user.object_id
  AND exp_grp.user_id = reco_acti_user.user_id
INNER JOIN (
            SELECT
                    DATE_FORMAT (dt_hour, '%Y-%m-%d %H') dt_hour,
                    user_id,
                    book_id AS object_id,                                       -- 书ID或者剧ID
                    SUM (CAST (con_chp_amount AS INT)) AS consume_amount,       -- 消费总书币
                    COUNT (DISTINCT chapter_id) AS unlock_act_cnt               -- 解锁章节数（解锁集数）
             FROM dws.dws_read_consume_user_consume_p_hi
            WHERE dt_hour >= '${dt}'
              AND dt_hour < '${af_1_dt}'
              AND types IN (1, 2, 3)
              AND LENGTH (chapter_id) > 0
              AND book_id > 0
            GROUP BY 1, 2, 3
        ) consume
   ON reco_acti_user.object_id = consume.object_id
  AND reco_acti_user.user_id = consume.user_id
LEFT JOIN (
     SELECT
         project_id,
         exp_id,
         exp_grp_id,
         traffic_allocation
     FROM (
              SELECT
                  project_id,
                  exp_id,
                  exp_grp_id,
                  traffic_allocation,
                  ROW_NUMBER() OVER(PARTITION BY project_id,exp_id,exp_grp_id ORDER BY exp_update_time DESC) AS rn -- 流量比例分配可能会修改，要到最新的值
              FROM dwd.dwd_abtest_content_recommend_p_hi
              WHERE dt_hour >= '${dt}'
                AND dt_hour < '${af_1_dt}'
                AND project_id = 1
                AND vip_type = 0
                AND position_index < 5
          ) tmp
     WHERE tmp.rn = 1
 )traffic
ON  exp_grp.project_id = traffic.project_id
AND  exp_grp.exp_id = traffic.exp_id
AND  exp_grp.exp_grp_id = traffic.exp_grp_id
GROUP BY 1,2,3,4)

SELECT dt_hour,
       project_id,                                                      -- 项目ID
       exp_id,                                                          -- 实验ID
       exp_grp_id,                                                      -- 实验组ID
       exp_name,                                                        -- 实验名称
       exp_grp_type,                                                    -- 实验组类型
       exp_grp_name,                                                    -- 实验组名称
       MAX(traffic_allocation) AS traffic_allocation,                   -- 流量占比
       SUM(ifd_reco_total_act_cnt) AS ifd_reco_total_act_cnt,           -- 总阅读章节数（总观看集数）
       SUM (ifd_reco_total_unlock_cnt) AS ifd_reco_total_unlock_cnt,    -- 解锁章节数
       SUM (ifd_reco_total_consume) AS ifd_reco_total_consume,          -- 总消费
       MAX(NOW())
FROM
    (SELECT dt_hour,
            project_id,                         -- 项目ID
            exp_id,                             -- 实验ID
            exp_grp_id,                         -- 实验组ID
            exp_name,                           -- 实验名称
            exp_grp_type,                       -- 实验组类型
            exp_grp_name,                       -- 实验组名称
            traffic_allocation,                 -- 流量占比
            ifd_reco_total_act_cnt,             -- 总阅读章节数（总观看集数）
            0 AS ifd_reco_total_unlock_cnt,     -- 解锁章节数
            0 AS ifd_reco_total_consume         -- 总消费
     FROM read_chapter_tmp
     UNION ALL
     SELECT dt_hour,
            project_id,                         -- 项目ID
            exp_id,                             -- 实验ID
            exp_grp_id,                         -- 实验组ID
            exp_name,                           -- 实验名称
            exp_grp_type,                       -- 实验组类型
            exp_grp_name,                       -- 实验组名称
            traffic_allocation,                 -- 流量占比
            0 AS ifd_reco_total_act_cnt,        -- 总阅读章节数（总观看集数）
            ifd_reco_total_unlock_cnt,          -- 解锁章节数
            ifd_reco_total_consume              -- 总消费
     FROM read_consume_tmp
    )  a
GROUP BY 1,2,3,4,5,6,7;

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dws_abtest_content_recommend_accumulation_stat_hi_yesterday
-- workflow_version : 3
-- create_user      : xixg
-- task_name        : dws_abtest_content_recommend_accumulation_stat_hi__video
-- task_version     : 3
-- update_time      : 2024-06-03 21:04:56
-- sql_path         : \starrocks\tbl_dws_abtest_content_recommend_accumulation_stat_hi_yesterday\dws_abtest_content_recommend_accumulation_stat_hi__video
----------------------------------------------------------------
-- SQL语句
-- 内容推荐---海剧业务  可累加指标小时统计
INSERT INTO dws.dws_abtest_content_recommend_accumulation_stat_hi
-- 海剧业务   总观看集数
WITH video_series_tmp AS (
SELECT
    chapter.dt_hour,
    exp_grp.project_id,                                                         -- 项目ID
    exp_grp.exp_id,                                                             -- 实验ID
    exp_grp.exp_grp_id,                                                         -- 实验组ID
    MAX(exp_grp.exp_name) as exp_name,                                          -- 实验名称
    MAX(exp_grp.exp_grp_type) AS exp_grp_type,                                  -- 实验组类型
    MAX(exp_grp.exp_grp_name) AS exp_grp_name,                                  -- 实验组名称
    MAX(traffic.traffic_allocation) AS traffic_allocation,                      -- 流量占比
    SUM(chapter.act_cnt) AS ifd_reco_total_act_cnt                              -- 总阅读章节数（总观看集数）
FROM (
         SELECT
             project_id,
             exp_id,
             exp_grp_id,
             object_id,
             user_id,
             exp_grp_type,
             MAX(exp_name) AS exp_name,
             MAX(exp_grp_name) AS exp_grp_name
         FROM dwd.dwd_abtest_content_recommend_p_hi
         WHERE dt_hour >= '${bf_1_dt}'
           AND dt_hour < '${dt}'
           AND project_id = 3
           AND vip_type = 0
           AND position_index < 5
         GROUP BY 1,2,3,4,5,6
     )exp_grp
LEFT JOIN(
            SELECT
                      reco_event.exp_id as exp_id,
                      act_event.user_id AS user_id,
                      act_event.object_id AS object_id                          -- 书ID
             FROM(
                    SELECT
                            login_id AS user_id,
                            shortplay_id AS object_id,                          -- 书ID
                            MIN(UNIX_TIMESTAMP(event_tm)) act_time              -- 用户阅读的开始时间，取那个最小的开始时间
                     FROM ods_log.ods_sensors_cd_video_startwatching
                    WHERE dt = '${bf_1_dt}'
                    GROUP BY 1,2
                )act_event
             INNER JOIN (
                            SELECT
                                     exp_id,
                                     user_id,
                                     object_id,
                                     UNIX_TIMESTAMP(event_time) AS reco_time
                             FROM dwd.dwd_abtest_content_recommend_p_hi
                            WHERE dt_hour >= '${bf_1_dt}'
                              AND dt_hour < '${dt}'
                               AND project_id = 3
                               AND vip_type = 0
                               AND position_index < 5
                             GROUP BY 1,2,3,4
                        )reco_event
                ON act_event.user_id = reco_event.user_id
               AND act_event.object_id = reco_event.object_id
               AND act_event.act_time - reco_event.reco_time < 20
               AND act_event.act_time - reco_event.reco_time >= 0
             GROUP BY 1,2,3
         )reco_acti_user
 ON  exp_grp.exp_id = reco_acti_user.exp_id
AND  exp_grp.object_id = reco_acti_user.object_id
AND  exp_grp.user_id = reco_acti_user.user_id
INNER JOIN(
            SELECT
                    DATE_FORMAT (event_tm, '%Y-%m-%d %H') AS dt_hour,
                    login_id AS user_id,
                    shortplay_id AS object_id,                              -- 书ID或者剧ID
                    COUNT(DISTINCT(episode_id)) AS act_cnt                  -- 阅读章节数（观看集数）
             FROM ods_log.ods_sensors_cd_video_endwatching
            WHERE dt = '${bf_1_dt}'
            GROUP BY 1,2,3
         )chapter
 ON  reco_acti_user.object_id = chapter.object_id
AND  reco_acti_user.user_id = chapter.user_id
LEFT JOIN (
            SELECT
                project_id,
                exp_id,
                exp_grp_id,
                traffic_allocation
            FROM (
                     SELECT
                         project_id,
                         exp_id,
                         exp_grp_id,
                         traffic_allocation,
                         ROW_NUMBER() OVER(PARTITION BY project_id,exp_id,exp_grp_id ORDER BY exp_update_time DESC) AS rn -- 流量比例分配可能会修改，要到最新的值
                     FROM dwd.dwd_abtest_content_recommend_p_hi
                     WHERE dt_hour >= '${bf_1_dt}'
                       AND dt_hour < '${dt}'
                       AND project_id = 3
                       AND vip_type = 0
                      AND position_index < 5
                ) tmp
          WHERE tmp.rn = 1
        )traffic
ON  exp_grp.project_id = traffic.project_id
AND  exp_grp.exp_id = traffic.exp_id
AND  exp_grp.exp_grp_id = traffic.exp_grp_id
GROUP BY 1,2,3,4),

-- 海剧业务   总解锁章节数（总解锁集数）  总消费
video_series_consum_tmp AS (
SELECT
        consume.dt_hour,
        exp_grp.project_id,                                                     -- 项目ID
        exp_grp.exp_id,                                                         -- 实验ID
        exp_grp.exp_grp_id,                                                     -- 实验组ID
        MAX(exp_grp.exp_name) as exp_name,                                      -- 实验名称
        MAX(exp_grp.exp_grp_type) AS exp_grp_type,                              -- 实验组类型
        MAX(exp_grp.exp_grp_name) AS exp_grp_name,                              -- 实验组名称
        MAX(traffic.traffic_allocation) AS traffic_allocation,                  -- 流量占比
        SUM(consume.unlock_act_cnt) AS ifd_reco_total_unlock_cnt,               -- 总解锁章节数（总解锁集数）
        ROUND(SUM(consume.consume_amount/100),0) AS ifd_reco_total_consume      -- 总消费
FROM (
         SELECT
                 project_id,
                 exp_id,
                 exp_grp_id,
                 object_id,
                 user_id,
                 exp_grp_type,
                 MAX(exp_name) AS exp_name,
                 MAX(exp_grp_name) AS exp_grp_name
         FROM dwd.dwd_abtest_content_recommend_p_hi
         WHERE dt_hour >= '${bf_1_dt}'
           AND dt_hour < '${dt}'
           AND project_id = 3
           AND vip_type = 0
           AND position_index < 5
         GROUP BY 1,2,3,4,5,6
     )exp_grp
LEFT JOIN(
            SELECT
                      reco_event.exp_id as exp_id,
                      act_event.user_id AS user_id,
                      act_event.object_id AS object_id                      -- 书ID
             FROM(
                    SELECT
                            login_id AS user_id,
                            shortplay_id AS object_id,                      -- 书ID
                            MIN(UNIX_TIMESTAMP(event_tm)) act_time          -- 用户阅读的开始时间，取那个最小的开始时间
                     FROM ods_log.ods_sensors_cd_video_startwatching
                    WHERE dt = '${bf_1_dt}'
                    GROUP BY 1,2
                )act_event
             INNER JOIN (
                            SELECT
                                     exp_id,
                                     user_id,
                                     object_id,
                                     UNIX_TIMESTAMP(event_time) AS reco_time
                             FROM dwd.dwd_abtest_content_recommend_p_hi
                            WHERE dt_hour >= '${bf_1_dt}'
                              AND dt_hour < '${dt}'
                               AND project_id = 3
                               AND vip_type = 0
                               AND position_index < 5
                             GROUP BY 1,2,3,4
                        )reco_event
                ON act_event.user_id = reco_event.user_id
               AND act_event.object_id = reco_event.object_id
               AND act_event.act_time - reco_event.reco_time < 20
               AND act_event.act_time - reco_event.reco_time >= 0
             GROUP BY 1,2,3
         )reco_acti_user
 ON  exp_grp.exp_id = reco_acti_user.exp_id
AND  exp_grp.object_id = reco_acti_user.object_id
AND  exp_grp.user_id = reco_acti_user.user_id
INNER JOIN(
            SELECT
                    con_view.dt_hour AS dt_hour,
                    con_view.user_id,
                    video_epis.series_id AS object_id,                      -- 书ID或者剧ID
                    SUM(con_view.consume_value) AS consume_amount,          -- 消费总书币
                    COUNT(DISTINCT con_view.epis_id) AS unlock_act_cnt      -- 解锁章节数（解锁集数）
             FROM  (
                      SELECT
                            DATE_FORMAT (create_time, '%Y-%m-%d %H') AS dt_hour,
                            account_id AS user_id,
                            epis_id,
                            consume_value
                        FROM ads.ads_consume_short_video_consume_view
                       WHERE dt = '${bf_1_dt}'
                    ) con_view
             LEFT JOIN (
                           SELECT
                                    series_id,
                                    epis_id
                            FROM dim.dim_short_video_epis_view              -- 关联表获取剧ID
                             GROUP BY 1,2
                        ) video_epis
               ON con_view.epis_id = video_epis.epis_id
            GROUP BY 1,2,3
         )consume
 ON  reco_acti_user.object_id = consume.object_id
AND  reco_acti_user.user_id = consume.user_id
LEFT JOIN (
            SELECT
                project_id,
                exp_id,
                exp_grp_id,
                traffic_allocation
            FROM (
                    SELECT
                            project_id,
                            exp_id,
                            exp_grp_id,
                            traffic_allocation,
                            ROW_NUMBER() OVER(PARTITION BY project_id,exp_id,exp_grp_id ORDER BY exp_update_time DESC) AS rn -- 流量比例分配可能会修改，要到最新的值
                     FROM dwd.dwd_abtest_content_recommend_p_hi
                    WHERE dt_hour >= '${bf_1_dt}'
                    AND dt_hour < '${dt}'
                    AND project_id = 1
                    AND vip_type = 0
                    AND position_index < 5
                ) tmp
            WHERE tmp.rn = 1
    )traffic
ON  exp_grp.project_id = traffic.project_id
AND  exp_grp.exp_id = traffic.exp_id
AND  exp_grp.exp_grp_id = traffic.exp_grp_id
GROUP BY 1,2,3,4)

SELECT
       dt_hour,
       project_id,                                                      -- 项目ID
       exp_id,                                                          -- 实验ID
       exp_grp_id,                                                      -- 实验组ID
       exp_name,                                                        -- 实验名称
       exp_grp_type,                                                    -- 实验组类型
       exp_grp_name,                                                    -- 实验组名称
       MAX(traffic_allocation) AS traffic_allocation,                   -- 流量占比
       SUM(ifd_reco_total_act_cnt) AS ifd_reco_total_act_cnt,           -- 总阅读章节数（总观看集数）
       SUM (ifd_reco_total_unlock_cnt) AS ifd_reco_total_unlock_cnt,    -- 解锁章节数
       SUM (ifd_reco_total_consume) AS ifd_reco_total_consume,          -- 总消费
       MAX(NOW())
FROM
    (SELECT
            dt_hour,
            project_id,                         -- 项目ID
            exp_id,                             -- 实验ID
            exp_grp_id,                         -- 实验组ID
            exp_name,                           -- 实验名称
            exp_grp_type,                       -- 实验组类型
            exp_grp_name,                       -- 实验组名称
            traffic_allocation,                 -- 流量占比
            ifd_reco_total_act_cnt,             -- 总阅读章节数（总观看集数）
            0 AS ifd_reco_total_unlock_cnt,     -- 解锁章节数
            0 AS ifd_reco_total_consume         -- 总消费
    FROM video_series_tmp
    UNION ALL
    SELECT
            dt_hour,
            project_id,                         -- 项目ID
            exp_id,                             -- 实验ID
            exp_grp_id,                         -- 实验组ID
            exp_name,                           -- 实验名称
            exp_grp_type,                       -- 实验组类型
            exp_grp_name,                       -- 实验组名称
            traffic_allocation,                 -- 流量占比
            0 AS ifd_reco_total_act_cnt,        -- 总阅读章节数（总观看集数）
            ifd_reco_total_unlock_cnt,          -- 解锁章节数
            ifd_reco_total_consume              -- 总消费
    FROM video_series_consum_tmp
    )  a
GROUP BY 1,2,3,4,5,6,7;

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dws_abtest_content_recommend_accumulation_stat_hi_yesterday
-- workflow_version : 3
-- create_user      : xixg
-- task_name        : dws_abtest_content_recommend_accumulation_stat_hi_read
-- task_version     : 3
-- update_time      : 2024-06-03 21:04:56
-- sql_path         : \starrocks\tbl_dws_abtest_content_recommend_accumulation_stat_hi_yesterday\dws_abtest_content_recommend_accumulation_stat_hi_read
----------------------------------------------------------------
-- SQL语句
-- 1、用在sch_ab_exp_yesterday中  2、用户来重跑历史数据的
-- 内容推荐---阅读业务  可累加指标小时统计
INSERT INTO dws.dws_abtest_content_recommend_accumulation_stat_hi
-- 阅读业务   总阅读章节数
WITH read_chapter_tmp AS (
SELECT
        chapter.dt_hour,
        exp_grp.project_id,                                     -- 项目ID
        exp_grp.exp_id,                                         -- 实验ID
        exp_grp.exp_grp_id,                                     -- 实验组ID
        MAX(exp_grp.exp_name) as exp_name,                      -- 实验名称
        MAX(exp_grp.exp_grp_type) AS exp_grp_type,              -- 实验组类型
        MAX(exp_grp.exp_grp_name) AS exp_grp_name,              -- 实验组名称
        MAX(traffic.traffic_allocation) AS traffic_allocation,  -- 流量占比
        SUM(chapter.act_cnt) AS ifd_reco_total_act_cnt          -- 总阅读章节数（总观看集数）
FROM (
         SELECT
                 project_id,
                 exp_id,
                 exp_grp_id,
                 object_id,
                 user_id,
                 exp_grp_type,
                 MAX(exp_name) AS exp_name,
                 MAX(exp_grp_name) AS exp_grp_name
          FROM dwd.dwd_abtest_content_recommend_p_hi
         WHERE dt_hour >= '${bf_1_dt}'
           AND dt_hour < '${dt}'
           AND project_id = 1
           AND vip_type = 0
           AND position_index < 5
         GROUP BY 1,2,3,4,5,6
     )exp_grp
LEFT JOIN(
            SELECT
                      reco_event.exp_id as exp_id,
                      act_event.user_id AS user_id,
                      act_event.object_id AS object_id                  -- 书ID
             FROM(
                    SELECT
                            identity_login_id AS user_id,
                            book_id AS object_id,                       -- 书ID
                            MIN(UNIX_TIMESTAMP(event_tm)) act_time      -- 用户阅读的开始时间，取那个最小的开始时间
                     FROM ods_log.ods_sensors_production_startreadingchapter
                    WHERE dt = '${bf_1_dt}'
                      AND read_chapter_sort = '1'  -- 阅读页章节id序号
                    GROUP BY 1,2
                )act_event
             INNER JOIN (
                            SELECT
                                     exp_id,
                                     user_id,
                                     object_id,
                                     UNIX_TIMESTAMP(event_time) AS reco_time
                             FROM dwd.dwd_abtest_content_recommend_p_hi
                            WHERE dt_hour >= '${bf_1_dt}'
                              AND dt_hour < '${dt}'
                               AND project_id = 1
                               AND vip_type = 0
                               AND position_index < 5
                             GROUP BY 1,2,3,4
                        )reco_event
                ON act_event.user_id = reco_event.user_id
               AND act_event.object_id = reco_event.object_id
               AND act_event.act_time - reco_event.reco_time < 20
               AND act_event.act_time - reco_event.reco_time >= 0
             GROUP BY 1,2,3
         )reco_acti_user
  ON  exp_grp.exp_id = reco_acti_user.exp_id
 AND  exp_grp.object_id = reco_acti_user.object_id
 AND  exp_grp.user_id = reco_acti_user.user_id
INNER JOIN (
                SELECT
                    DATE_FORMAT (event_tm, '%Y-%m-%d %H') AS dt_hour,
                    identity_login_id AS user_id,
                    book_id AS object_id,  -- 书ID
                    COUNT(DISTINCT(chapter_id)) AS act_cnt   -- 阅读章节数（观看集数）
                FROM ods_log.ods_sensors_production_startreadingchapter
                WHERE dt = '${bf_1_dt}'
                GROUP BY 1,2,3
            ) chapter
  ON  reco_acti_user.object_id = chapter.object_id
 AND  reco_acti_user.user_id = chapter.user_id
LEFT JOIN (
            SELECT
                project_id,
                exp_id,
                exp_grp_id,
                traffic_allocation
            FROM (
                     SELECT
                         project_id,
                         exp_id,
                         exp_grp_id,
                         traffic_allocation,
                         ROW_NUMBER() OVER(PARTITION BY project_id,exp_id,exp_grp_id ORDER BY exp_update_time DESC) AS rn -- 流量比例分配可能会修改，要到最新的值
                     FROM dwd.dwd_abtest_content_recommend_p_hi
                     WHERE dt_hour >= '${bf_1_dt}'
                       AND dt_hour < '${dt}'
                      AND project_id = 1
                      AND vip_type = 0
                      AND position_index < 5
                ) tmp
          WHERE tmp.rn = 1
        )traffic
 ON  exp_grp.project_id = traffic.project_id
AND  exp_grp.exp_id = traffic.exp_id
AND  exp_grp.exp_grp_id = traffic.exp_grp_id
GROUP BY 1,2,3,4),

read_consume_tmp AS (
SELECT
        consume.dt_hour,
        exp_grp.project_id,                                             -- 项目ID
        exp_grp.exp_id,                                                 -- 实验ID
        exp_grp.exp_grp_id,                                             -- 实验组ID
        MAX(exp_grp.exp_name) as exp_name,                              -- 实验名称
        MAX(exp_grp.exp_grp_type) AS exp_grp_type,                      -- 实验组类型
        MAX(exp_grp.exp_grp_name) AS exp_grp_name,                      -- 实验组名称
        MAX(traffic.traffic_allocation) AS traffic_allocation,          -- 流量占比
        SUM (consume.unlock_act_cnt) AS ifd_reco_total_unlock_cnt,      -- 解锁章节数
        SUM (consume.consume_amount) AS ifd_reco_total_consume          -- 总消费
 FROM (
         SELECT
                 project_id,
                 exp_id,
                 exp_grp_id,
                 object_id,
                 user_id,
                 exp_grp_type,
                 MAX(exp_name) AS exp_name,
                 MAX(exp_grp_name) AS exp_grp_name
          FROM dwd.dwd_abtest_content_recommend_p_hi
         WHERE dt_hour >= '${bf_1_dt}' AND dt_hour < '${dt}'
           AND project_id = 1
           AND vip_type = 0
           AND position_index < 5
        GROUP BY 1,2,3,4,5,6
    ) exp_grp
LEFT JOIN (
            SELECT
                    reco_event.exp_id as exp_id,
                    act_event.user_id AS user_id,
                    act_event.object_id AS object_id                       -- 书ID
             FROM (
                    SELECT
                            identity_login_id AS user_id,
                            book_id AS object_id,                          -- 书ID
                            MIN (UNIX_TIMESTAMP(event_tm)) act_time        -- 用户阅读的开始时间，取那个最小的开始时间
                     FROM ods_log.ods_sensors_production_startreadingchapter
                    WHERE dt = '${bf_1_dt}'
                      AND read_chapter_sort = '1'                          -- 阅读页章节id序号
                    GROUP BY 1,2
                ) act_event
            INNER JOIN (
                        SELECT
                                exp_id,
                                user_id,
                                object_id,
                                UNIX_TIMESTAMP(event_time) AS reco_time
                         FROM dwd.dwd_abtest_content_recommend_p_hi
                        WHERE dt_hour >= '${bf_1_dt}'
                         AND dt_hour < '${dt}'
                         AND project_id = 1
                         AND vip_type = 0
                         AND position_index < 5
                        GROUP BY 1,2,3,4
                        ) reco_event
               ON act_event.user_id = reco_event.user_id
              AND act_event.object_id = reco_event.object_id
              AND act_event.act_time - reco_event.reco_time < 20
              AND act_event.act_time - reco_event.reco_time >= 0
            GROUP BY 1,2,3
        ) reco_acti_user
   ON exp_grp.exp_id = reco_acti_user.exp_id
  AND exp_grp.object_id = reco_acti_user.object_id
  AND exp_grp.user_id = reco_acti_user.user_id
INNER JOIN (
            SELECT
                    DATE_FORMAT (dt_hour, '%Y-%m-%d %H') dt_hour,
                    user_id,
                    book_id AS object_id,                                       -- 书ID或者剧ID
                    SUM (CAST (con_chp_amount AS INT)) AS consume_amount,       -- 消费总书币
                    COUNT (DISTINCT chapter_id) AS unlock_act_cnt               -- 解锁章节数（解锁集数）
             FROM dws.dws_read_consume_user_consume_p_hi
            WHERE dt_hour >= '${bf_1_dt}'
              AND dt_hour < '${dt}'
              AND types IN (1, 2, 3)
              AND LENGTH (chapter_id) > 0
              AND book_id > 0
            GROUP BY 1, 2, 3
        ) consume
   ON reco_acti_user.object_id = consume.object_id
  AND reco_acti_user.user_id = consume.user_id
LEFT JOIN (
     SELECT
         project_id,
         exp_id,
         exp_grp_id,
         traffic_allocation
     FROM (
              SELECT
                  project_id,
                  exp_id,
                  exp_grp_id,
                  traffic_allocation,
                  ROW_NUMBER() OVER(PARTITION BY project_id,exp_id,exp_grp_id ORDER BY exp_update_time DESC) AS rn -- 流量比例分配可能会修改，要到最新的值
              FROM dwd.dwd_abtest_content_recommend_p_hi
              WHERE dt_hour >= '${bf_1_dt}'
                AND dt_hour < '${dt}'
                AND project_id = 1
                AND vip_type = 0
                AND position_index < 5
          ) tmp
     WHERE tmp.rn = 1
 )traffic
ON  exp_grp.project_id = traffic.project_id
AND  exp_grp.exp_id = traffic.exp_id
AND  exp_grp.exp_grp_id = traffic.exp_grp_id
GROUP BY 1,2,3,4)

SELECT dt_hour,
       project_id,                                                      -- 项目ID
       exp_id,                                                          -- 实验ID
       exp_grp_id,                                                      -- 实验组ID
       exp_name,                                                        -- 实验名称
       exp_grp_type,                                                    -- 实验组类型
       exp_grp_name,                                                    -- 实验组名称
       MAX(traffic_allocation) AS traffic_allocation,                   -- 流量占比
       SUM(ifd_reco_total_act_cnt) AS ifd_reco_total_act_cnt,           -- 总阅读章节数（总观看集数）
       SUM (ifd_reco_total_unlock_cnt) AS ifd_reco_total_unlock_cnt,    -- 解锁章节数
       SUM (ifd_reco_total_consume) AS ifd_reco_total_consume,          -- 总消费
       MAX(NOW())
FROM
    (SELECT dt_hour,
            project_id,                         -- 项目ID
            exp_id,                             -- 实验ID
            exp_grp_id,                         -- 实验组ID
            exp_name,                           -- 实验名称
            exp_grp_type,                       -- 实验组类型
            exp_grp_name,                       -- 实验组名称
            traffic_allocation,                 -- 流量占比
            ifd_reco_total_act_cnt,             -- 总阅读章节数（总观看集数）
            0 AS ifd_reco_total_unlock_cnt,     -- 解锁章节数
            0 AS ifd_reco_total_consume         -- 总消费
     FROM read_chapter_tmp
     UNION ALL
     SELECT dt_hour,
            project_id,                         -- 项目ID
            exp_id,                             -- 实验ID
            exp_grp_id,                         -- 实验组ID
            exp_name,                           -- 实验名称
            exp_grp_type,                       -- 实验组类型
            exp_grp_name,                       -- 实验组名称
            traffic_allocation,                 -- 流量占比
            0 AS ifd_reco_total_act_cnt,        -- 总阅读章节数（总观看集数）
            ifd_reco_total_unlock_cnt,          -- 解锁章节数
            ifd_reco_total_consume              -- 总消费
     FROM read_consume_tmp
    )  a
GROUP BY 1,2,3,4,5,6,7;
