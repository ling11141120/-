----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_content_book_score_month_p_da
-- workflow_version : 2
-- create_user      : xixg
-- task_name        : ads_content_book_score_month_p_da
-- task_version     : 2
-- update_time      : 2024-07-03 17:18:59
-- sql_path         : \starrocks\tbl_ads_content_book_score_month_p_da\ads_content_book_score_month_p_da
----------------------------------------------------------------
-- SQL语句
INSERT INTO ads.ads_content_book_score_month_p_da
SELECT
        '${bf_1_dt}' AS dt,
        a.BookId AS book_id,
        a.StatMonth AS stat_month,
        b.book_code AS book_code,
        a.ScoreType AS score_type,
        CASE a.ScoreType
            WHEN 0 THEN '未评级'
            WHEN 1 THEN 'S'
            WHEN 2 THEN 'A'
            WHEN 3 THEN 'B'
            WHEN 4 THEN 'C'
            ELSE ''
        END AS score_name,
        a.UpdateTime AS update_time,
        NOW() AS etl_time
 FROM ods.ods_tidb_ReaderNovel_tidb_tag_center_book_score_month a
LEFT JOIN dim.dim_shuangwen_book_read_consume_info b
 ON  a.BookId = b.book_id;
