----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dwm_abtest_user_operation_distinct_stat_hi
-- workflow_version : 8
-- create_user      : xixg
-- task_name        : dwm_abtest_user_operation_distinct_stat_hi__all_project__grp_users
-- task_version     : 5
-- update_time      : 2024-05-31 00:22:29
-- sql_path         : \starrocks\tbl_dwm_abtest_user_operation_distinct_stat_hi\dwm_abtest_user_operation_distinct_stat_hi__all_project__grp_users
----------------------------------------------------------------
-- SQL语句
-- 用户运营--所有业务的用户组ID都来自相同的源表，所以project_id不需要过滤
-- 所有实验进入实验组的用户ID
INSERT INTO dwm.dwm_abtest_user_operation_distinct_stat_hi
(dt_hour, project_id, exp_id, exp_grp_id, grp_users, etl_time)
SELECT
        DATE_FORMAT (dt_hour, '%Y-%m-%d %H') AS dt_hour,
        project_id,
        exp_id,
        exp_grp_id,
        TO_BITMAP(user_id) AS grp_users,
        now()
 FROM dwd.dwd_abtest_user_operation_p_hi
  WHERE dt_hour >= '${dt}'
  AND dt_hour < '${af_1_dt}';

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dwm_abtest_user_operation_distinct_stat_hi
-- workflow_version : 8
-- create_user      : xixg
-- task_name        : dwm_abtest_user_operation_distinct_stat_hi__read_consume_users
-- task_version     : 6
-- update_time      : 2024-05-31 00:22:29
-- sql_path         : \starrocks\tbl_dwm_abtest_user_operation_distinct_stat_hi\dwm_abtest_user_operation_distinct_stat_hi__read_consume_users
----------------------------------------------------------------
-- SQL语句
-- 阅读业务 进入实验组、且有消费行为的用户ID  字段consume_users
INSERT INTO dwm.dwm_abtest_user_operation_distinct_stat_hi
(dt_hour, project_id, exp_id, exp_grp_id, consume_users, etl_time)
SELECT
        consume.dt_hour AS dt_hour,
        exp_grp_user.project_id AS project_id,
        exp_grp_user.exp_id AS exp_id,
        exp_grp_user.exp_grp_id AS exp_grp_id,
        TO_BITMAP(consume.user_id) AS consume_users,
        NOW()
FROM (
         SELECT
                 project_id AS project_id,
                 exp_id AS exp_id,
                 exp_grp_id AS exp_grp_id,
                 user_id AS user_id
          FROM dwd.dwd_abtest_user_operation_p_hi
         WHERE project_id = 1  -- 过滤出阅读项目的实验信息
           AND dt_hour >= '${dt}'
           AND dt_hour < '${af_1_dt}'
         GROUP BY 1,2,3,4
        )exp_grp_user
INNER JOIN (
            SELECT
                DATE_FORMAT (dt_hour, '%Y-%m-%d %H') AS dt_hour,
                user_id
            FROM dws.dws_read_consume_user_consume_p_hi
            WHERE dt_hour >= '${dt}'
              AND dt_hour < '${af_1_dt}'
              AND types IN(1, 2, 3)
              AND book_id > 0
            )consume
 ON exp_grp_user.user_id = consume.user_id;

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dwm_abtest_user_operation_distinct_stat_hi
-- workflow_version : 8
-- create_user      : xixg
-- task_name        : dwm_abtest_user_operation_distinct_stat_hi__read_recharge_users
-- task_version     : 6
-- update_time      : 2024-05-31 00:22:29
-- sql_path         : \starrocks\tbl_dwm_abtest_user_operation_distinct_stat_hi\dwm_abtest_user_operation_distinct_stat_hi__read_recharge_users
----------------------------------------------------------------
-- SQL语句
-- 阅读业务 进入实验组且有交易行为的用户ID  字段recharge_users
INSERT INTO dwm.dwm_abtest_user_operation_distinct_stat_hi
(dt_hour, project_id, exp_id, exp_grp_id, recharge_users, etl_time)
SELECT
        trade.dt_hour AS dt_hour,
        exp_grp_user.project_id AS project_id,
        exp_grp_user.exp_id AS exp_id,
        exp_grp_user.exp_grp_id AS exp_grp_id,
        TO_BITMAP(trade.user_id) AS recharge_users,
        now()
 FROM(
         SELECT
                 project_id AS project_id,
                 exp_id AS exp_id,
                 exp_grp_id AS exp_grp_id,
                 user_id AS user_id
          FROM dwd.dwd_abtest_user_operation_p_hi
         WHERE project_id = 1  -- 过滤出阅读项目的实验信息
           AND dt_hour >= '${dt}'
           AND dt_hour < '${af_1_dt}'
         GROUP BY 1,2,3,4
      )exp_grp_user
 INNER JOIN (
                 SELECT
                         DATE_FORMAT (dt_hour, '%Y-%m-%d %H') AS dt_hour,
                         user_id
                  FROM dws.dws_read_trade_user_trade_p_hi
                 WHERE dt_hour >= '${dt}'
                   AND dt_hour < '${af_1_dt}'
            )trade
  ON exp_grp_user.user_id = trade.user_id;

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dwm_abtest_user_operation_distinct_stat_hi
-- workflow_version : 8
-- create_user      : xixg
-- task_name        : dwm_abtest_user_operation_distinct_stat_hi__video_consume_users
-- task_version     : 6
-- update_time      : 2024-07-19 15:40:11
-- sql_path         : \starrocks\tbl_dwm_abtest_user_operation_distinct_stat_hi\dwm_abtest_user_operation_distinct_stat_hi__video_consume_users
----------------------------------------------------------------
-- SQL语句
-- 海外短剧业务 进入实验组、且有消费行为的用户ID  字段consume_users
INSERT INTO dwm.dwm_abtest_user_operation_distinct_stat_hi
(dt_hour, project_id, exp_id, exp_grp_id, consume_users, etl_time)
SELECT
        consume.dt_hour AS dt_hour,
        exp_grp_user.project_id AS project_id,
        exp_grp_user.exp_id AS exp_id,
        exp_grp_user.exp_grp_id AS exp_grp_id,
        TO_BITMAP(consume.user_id) AS consume_users,
        NOW()
FROM(
        SELECT
                project_id AS project_id,
                exp_id AS exp_id,
                exp_grp_id AS exp_grp_id,
                user_id AS user_id
         FROM dwd.dwd_abtest_user_operation_p_hi
        WHERE project_id = 3  -- 过滤出阅读项目的实验信息
          AND dt_hour >= '${dt}'
          AND dt_hour < '${af_1_dt}'
        GROUP BY 1,2,3,4
    )exp_grp_user
INNER JOIN (
                SELECT
                        DATE_FORMAT (dt_hour, '%Y-%m-%d %H') AS dt_hour,
                        user_id
                 FROM dws.dws_video_consume_user_consume_p_hi
                WHERE dt_hour >= '${dt}'
                  AND dt_hour < '${af_1_dt}'  -- 过滤短剧项目
                GROUP BY 1,2
            )consume
 ON exp_grp_user.user_id = consume.user_id;

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dwm_abtest_user_operation_distinct_stat_hi
-- workflow_version : 8
-- create_user      : xixg
-- task_name        : dwm_abtest_user_operation_distinct_stat_p_hi__video_recharge_users
-- task_version     : 6
-- update_time      : 2024-07-19 15:40:11
-- sql_path         : \starrocks\tbl_dwm_abtest_user_operation_distinct_stat_hi\dwm_abtest_user_operation_distinct_stat_p_hi__video_recharge_users
----------------------------------------------------------------
-- SQL语句
-- 海外短剧业务 进入实验组且有交易行为的用户ID  字段recharge_users
INSERT INTO dwm.dwm_abtest_user_operation_distinct_stat_hi
(dt_hour, project_id, exp_id, exp_grp_id, recharge_users, etl_time)
SELECT
        trade.dt_hour AS dt_hour,
        exp_grp_user.project_id AS project_id,
        exp_grp_user.exp_id AS exp_id,
        exp_grp_user.exp_grp_id AS exp_grp_id,
        TO_BITMAP(trade.user_id) AS recharge_users,
        NOW()
FROM(
        SELECT
                project_id AS project_id,
                exp_id AS exp_id,
                exp_grp_id AS exp_grp_id,
                user_id AS user_id
         FROM dwd.dwd_abtest_user_operation_p_hi
        WHERE project_id = 3  -- 过滤出阅读项目的实验信息
          AND dt_hour >= '${dt}'
          AND dt_hour < '${af_1_dt}'
        GROUP BY 1,2,3,4
    )exp_grp_user
INNER JOIN (
                SELECT
                        DATE_FORMAT (create_time, '%Y-%m-%d %H') dt_hour,
                        user_id
                 FROM ads.ads_trade_sharpenginepaycenter_payorder_view
                WHERE dt = '${dt}'
                  AND product_id = '6833'  -- 过滤短剧项目
                  AND order_status = 1
                  AND test_flag = 0
                GROUP BY 1,2
            )trade
 ON exp_grp_user.user_id = trade.user_id;

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dwm_abtest_user_operation_distinct_stat_hi_yesterday
-- workflow_version : 2
-- create_user      : xixg
-- task_name        : dwm_abtest_user_operation_distinct_stat_hi__all_project__grp_users
-- task_version     : 2
-- update_time      : 2024-06-03 21:03:11
-- sql_path         : \starrocks\tbl_dwm_abtest_user_operation_distinct_stat_hi_yesterday\dwm_abtest_user_operation_distinct_stat_hi__all_project__grp_users
----------------------------------------------------------------
-- SQL语句
-- 1、用在sch_ab_exp_yesterday中  2、用户来重跑历史数据的
-- 用户运营--所有业务的用户组ID都来自相同的源表，所以project_id不需要过滤
-- 所有实验进入实验组的用户ID
INSERT INTO dwm.dwm_abtest_user_operation_distinct_stat_hi
(dt_hour, project_id, exp_id, exp_grp_id, grp_users, etl_time)
SELECT
        DATE_FORMAT (dt_hour, '%Y-%m-%d %H') AS dt_hour,
        project_id,
        exp_id,
        exp_grp_id,
        TO_BITMAP(user_id) AS grp_users,
        now()
 FROM dwd.dwd_abtest_user_operation_p_hi
  WHERE dt_hour >= '${bf_1_dt}'
  AND dt_hour < '${dt}';

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dwm_abtest_user_operation_distinct_stat_hi_yesterday
-- workflow_version : 2
-- create_user      : xixg
-- task_name        : dwm_abtest_user_operation_distinct_stat_hi__read_consume_users
-- task_version     : 2
-- update_time      : 2024-06-03 21:03:11
-- sql_path         : \starrocks\tbl_dwm_abtest_user_operation_distinct_stat_hi_yesterday\dwm_abtest_user_operation_distinct_stat_hi__read_consume_users
----------------------------------------------------------------
-- SQL语句
-- 阅读业务 进入实验组、且有消费行为的用户ID  字段consume_users
INSERT INTO dwm.dwm_abtest_user_operation_distinct_stat_hi
(dt_hour, project_id, exp_id, exp_grp_id, consume_users, etl_time)
SELECT
        consume.dt_hour AS dt_hour,
        exp_grp_user.project_id AS project_id,
        exp_grp_user.exp_id AS exp_id,
        exp_grp_user.exp_grp_id AS exp_grp_id,
        TO_BITMAP(consume.user_id) AS consume_users,
        NOW()
FROM (
         SELECT
                 project_id AS project_id,
                 exp_id AS exp_id,
                 exp_grp_id AS exp_grp_id,
                 user_id AS user_id
          FROM dwd.dwd_abtest_user_operation_p_hi
         WHERE project_id = 1  -- 过滤出阅读项目的实验信息
           AND dt_hour >= '${bf_1_dt}'
           AND dt_hour < '${dt}'
         GROUP BY 1,2,3,4
        )exp_grp_user
INNER JOIN (
            SELECT
                DATE_FORMAT (dt_hour, '%Y-%m-%d %H') AS dt_hour,
                user_id
            FROM dws.dws_read_consume_user_consume_p_hi
            WHERE dt_hour >= '${bf_1_dt}'
              AND dt_hour < '${dt}'
              AND types IN(1, 2, 3)
              AND book_id > 0
            )consume
 ON exp_grp_user.user_id = consume.user_id;

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dwm_abtest_user_operation_distinct_stat_hi_yesterday
-- workflow_version : 2
-- create_user      : xixg
-- task_name        : dwm_abtest_user_operation_distinct_stat_hi__read_recharge_users
-- task_version     : 2
-- update_time      : 2024-06-03 21:03:11
-- sql_path         : \starrocks\tbl_dwm_abtest_user_operation_distinct_stat_hi_yesterday\dwm_abtest_user_operation_distinct_stat_hi__read_recharge_users
----------------------------------------------------------------
-- SQL语句
-- 阅读业务 进入实验组且有交易行为的用户ID  字段recharge_users
INSERT INTO dwm.dwm_abtest_user_operation_distinct_stat_hi
(dt_hour, project_id, exp_id, exp_grp_id, recharge_users, etl_time)
SELECT
        trade.dt_hour AS dt_hour,
        exp_grp_user.project_id AS project_id,
        exp_grp_user.exp_id AS exp_id,
        exp_grp_user.exp_grp_id AS exp_grp_id,
        TO_BITMAP(trade.user_id) AS recharge_users,
        now()
 FROM(
         SELECT
                 project_id AS project_id,
                 exp_id AS exp_id,
                 exp_grp_id AS exp_grp_id,
                 user_id AS user_id
          FROM dwd.dwd_abtest_user_operation_p_hi
         WHERE project_id = 1  -- 过滤出阅读项目的实验信息
           AND dt_hour >= '${bf_1_dt}'
           AND dt_hour < '${dt}'
         GROUP BY 1,2,3,4
      )exp_grp_user
 INNER JOIN (
                 SELECT
                         DATE_FORMAT (dt_hour, '%Y-%m-%d %H') AS dt_hour,
                         user_id
                  FROM dws.dws_read_trade_user_trade_p_hi
                 WHERE dt_hour >= '${bf_1_dt}'
                   AND dt_hour < '${dt}'
            )trade
  ON exp_grp_user.user_id = trade.user_id;

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dwm_abtest_user_operation_distinct_stat_hi_yesterday
-- workflow_version : 2
-- create_user      : xixg
-- task_name        : dwm_abtest_user_operation_distinct_stat_hi__video_consume_users
-- task_version     : 2
-- update_time      : 2024-06-03 21:03:11
-- sql_path         : \starrocks\tbl_dwm_abtest_user_operation_distinct_stat_hi_yesterday\dwm_abtest_user_operation_distinct_stat_hi__video_consume_users
----------------------------------------------------------------
-- SQL语句
-- 海外短剧业务 进入实验组、且有消费行为的用户ID  字段consume_users
INSERT INTO dwm.dwm_abtest_user_operation_distinct_stat_hi
(dt_hour, project_id, exp_id, exp_grp_id, consume_users, etl_time)
SELECT
        consume.dt_hour AS dt_hour,
        exp_grp_user.project_id AS project_id,
        exp_grp_user.exp_id AS exp_id,
        exp_grp_user.exp_grp_id AS exp_grp_id,
        TO_BITMAP(consume.user_id) AS consume_users,
        NOW()
FROM(
        SELECT
                project_id AS project_id,
                exp_id AS exp_id,
                exp_grp_id AS exp_grp_id,
                user_id AS user_id
         FROM dwd.dwd_abtest_user_operation_p_hi
        WHERE project_id = 3  -- 过滤出阅读项目的实验信息
          AND dt_hour >= '${bf_1_dt}'
          AND dt_hour < '${dt}'
        GROUP BY 1,2,3,4
    )exp_grp_user
INNER JOIN (
                SELECT
                        DATE_FORMAT (dt_hour, '%Y-%m-%d %H') AS dt_hour,
                        user_id,
                        -- 短剧消耗类型type值说明： 0货币,1赠币
                        SUM(consume_amt) consume_amount, -- 消费总书币（赠送+充值）
                        SUM(CASE WHEN types = 0 THEN consume_amt ELSE 0 END) AS consume_award -- 消费总礼券（充值）
                 FROM dws.dws_video_consume_user_consume_p_hi
                WHERE dt_hour >= '${bf_1_dt}'
                  AND dt_hour < '${dt}'  -- 过滤短剧项目
                GROUP BY 1,2
            )consume
 ON exp_grp_user.user_id = consume.user_id;

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dwm_abtest_user_operation_distinct_stat_hi_yesterday
-- workflow_version : 2
-- create_user      : xixg
-- task_name        : dwm_abtest_user_operation_distinct_stat_p_hi__video_recharge_users
-- task_version     : 2
-- update_time      : 2024-06-03 21:03:11
-- sql_path         : \starrocks\tbl_dwm_abtest_user_operation_distinct_stat_hi_yesterday\dwm_abtest_user_operation_distinct_stat_p_hi__video_recharge_users
----------------------------------------------------------------
-- SQL语句
-- 海外短剧业务 进入实验组且有交易行为的用户ID  字段recharge_users
INSERT INTO dwm.dwm_abtest_user_operation_distinct_stat_hi
(dt_hour, project_id, exp_id, exp_grp_id, recharge_users, etl_time)
SELECT
        trade.dt_hour AS dt_hour,
        exp_grp_user.project_id AS project_id,
        exp_grp_user.exp_id AS exp_id,
        exp_grp_user.exp_grp_id AS exp_grp_id,
        TO_BITMAP(trade.user_id) AS recharge_users,
        NOW()
FROM(
        SELECT
                project_id AS project_id,
                exp_id AS exp_id,
                exp_grp_id AS exp_grp_id,
                user_id AS user_id
         FROM dwd.dwd_abtest_user_operation_p_hi
        WHERE project_id = 3  -- 过滤出阅读项目的实验信息
          AND dt_hour >= '${bf_1_dt}'
          AND dt_hour < '${dt}'
        GROUP BY 1,2,3,4
    )exp_grp_user
INNER JOIN (
                SELECT
                        DATE_FORMAT (create_time, '%Y-%m-%d %H') dt_hour,
                        user_id,
                        SUM(base_amount) recharge_amount,  -- 充值金额
                        COUNT(1) recharge_times  -- 充值次数
                 FROM ads.ads_trade_sharpenginepaycenter_payorder_view
                WHERE dt = '${bf_1_dt}'
                  AND product_id = '6833'  -- 过滤短剧项目
                  AND order_status = 1
                  AND test_flag = 0
                GROUP BY 1,2
            )trade
 ON exp_grp_user.user_id = trade.user_id;
