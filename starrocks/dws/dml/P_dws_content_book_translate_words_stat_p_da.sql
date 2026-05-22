----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dws_content_book_translate_words_stat_p_da
-- workflow_version : 1
-- create_user      : xixg
-- task_name        : dws_content_book_translate_words_stat_p_da
-- task_version     : 1
-- update_time      : 2024-08-07 17:37:08
-- sql_path         : \starrocks\tbl_dws_content_book_translate_words_stat_p_da\dws_content_book_translate_words_stat_p_da
----------------------------------------------------------------
-- SQL语句
INSERT INTO dws.dws_content_book_translate_words_stat_p_da
SELECT
        a.ToBookId*1000+a.ToLanguage AS book_id,
        a.ToLanguage AS site_id,
        a.BookCode AS book_code,
        a.ToBookName AS book_name,
        a.CNBookName AS cn_book_name,
        a.PublishLength AS publish_length,
        IF(50000 <= a.PublishLength AND a.PublishLength < 100000,a.dt,NULL) AS published_5w_date,
        IF(100000 <= a.PublishLength AND a.PublishLength < 150000,a.dt,NULL) AS published_10w_date,
        IF(150000 <= a.PublishLength AND a.PublishLength < 200000,a.dt,NULL) AS published_15w_date,
        IF(200000 <= a.PublishLength AND a.PublishLength < 250000,a.dt,NULL) AS published_20w_date,
        IF(250000 <= a.PublishLength AND a.PublishLength < 300000,a.dt,NULL) AS published_25w_date,
        IF(300000 <= a.PublishLength AND a.PublishLength < 350000,a.dt,NULL) AS published_30w_date,
        IF(350000 <= a.PublishLength ,a.dt,NULL) AS published_35w_date,
        NOW()
FROM ods.ods_tidb_shuangwen_en_bookcapacitymonitoring a
WHERE a.dt = '${bf_1_dt}';
