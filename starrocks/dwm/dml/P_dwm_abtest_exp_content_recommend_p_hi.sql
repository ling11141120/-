----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dwm_abtest_exp_content_recommend_p_hi
-- workflow_version : 2
-- create_user      : xixg
-- task_name        : dwm_abtest_exp_content_recommend_p_hi
-- task_version     : 2
-- update_time      : 2024-05-18 17:47:13
-- sql_path         : \starrocks\tbl_dwm_abtest_exp_content_recommend_p_hi\dwm_abtest_exp_content_recommend_p_hi
----------------------------------------------------------------
-- SQL语句
INSERT INTO dwm.dwm_abtest_exp_content_recommend_p_hi
-- 阅读
with exp_tmp AS (
    SELECT
        dt_hour,
        project_id,
        exp_id,
        exp_grp_id,
        to_bitmap(user_id) AS user_id
    FROM dwd.dwd_abtest_exp_content_recommend_p_hi
    WHERE dt_hour = '${dt}'
),

read_users_tmp AS (

SELECT
      reco_event.dt_hour AS dt_hour,
      reco_event.project_id AS project_id,
      reco_event.exp_id AS exp_id,
      reco_event.exp_grp_id AS exp_grp_id,
      reco_event.object_id AS object_id,
      reco_event.user_id AS user_id
 FROM(
        SELECT
                DATE_FORMAT (event_tm, '%Y-%m-%d %H') AS dt_hour,
                identity_login_id AS user_id,
                book_id AS object_id,  -- 书ID
                MIN(UNIX_TIMESTAMP(event_tm)) act_time   -- 用户阅读的开始时间，取那个最小的开始时间
         FROM ads.ads_sensors_production_startreadingchapter_view
        WHERE dt = '${dt}'
          AND read_chapter_sort = '1'  -- 阅读页章节id序号
        GROUP BY 1,2,3
    )act_event
 INNER JOIN (
                SELECT
                         dt_hour AS dt_hour,
                         project_id AS project_id,
                         exp_id AS exp_id,
                         exp_grp_id AS exp_grp_id,
                         user_id AS user_id,
                         object_id AS object_id,
                         UNIX_TIMESTAMP(event_time) AS reco_time
                 FROM dwd.dwd_abtest_exp_content_recommend_p_hi
                 WHERE dt_hour = '${dt}'
                   AND vip_type = 0
                   AND position_index <  5
                 GROUP BY 1,2,3,4,5,6,7
            )reco_event
    ON act_event.dt_hour = reco_event.dt_hour
   AND act_event.user_id = reco_event.user_id
   AND act_event.object_id = reco_event.object_id
   AND act_event.act_time - reco_event.reco_time < 20
   AND act_event.act_time - reco_event.reco_time >= 0
),

consume_user AS (
SELECT
    act_user.dt_hour AS dt_hour,
    act_user.project_id AS project_id,
    act_user.exp_id AS exp_id,
    act_user.exp_grp_id AS exp_grp_id,
    act_user.object_id AS object_id,
    consume.user_id AS user_id
FROM read_users_tmp act_user
LEFT JOIN(
            SELECT
                    dt_hour,
                    user_id,
                    book_id AS object_id,  -- 书ID或者剧ID
                    SUM(CAST(con_chp_amount AS INT)) AS consume_amount,    -- 消费总书币
                    COUNT(DISTINCT chapter_id) AS unlock_act_cnt  -- 解锁章节数（解锁集数）
             FROM dwm.dwm_read_consume_user_consume_p_hi
            WHERE dt_hour = '${dt}'
              AND types IN(1, 2, 3)
              AND LENGTH(chapter_id) > 0
              AND book_id > 0
            GROUP BY 1,2,3
         )consume
 ON  act_user.dt_hour = consume.dt_hour
AND  act_user.object_id = consume.object_id
AND  act_user.user_id = consume.user_id
)

SELECT
    a.dt_hour,
    a.project_id,
    a.exp_id,
    a.exp_grp_id,
    a.user_id AS grp_users,
    to_bitmap(b.user_id) AS read_or_watch_users,
    to_bitmap(c.user_id) AS consume_users,
    now() AS etl_time
FROM exp_tmp a
LEFT JOIN read_users_tmp b
ON a.dt_hour = b.dt_hour
AND a.project_id = b.project_id
AND a.exp_id = b.exp_id
AND a.exp_grp_id = b.exp_grp_id
LEFT JOIN consume_user c
ON a.dt_hour = c.dt_hour
AND a.project_id = c.project_id
AND a.exp_id = c.exp_id
AND a.exp_grp_id = c.exp_grp_id;
