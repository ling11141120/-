----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_center_book_information
-- workflow_version : 1
-- create_user      : xixg
-- task_name        : ads_center_book_information
-- task_version     : 1
-- update_time      : 2025-05-26 17:21:35
-- sql_path         : \starrocks\tbl_ads_center_book_information\ads_center_book_information
----------------------------------------------------------------
-- SQL语句
INSERT INTO ads.ads_center_book_information
SELECT
    BookId ,
    Score,
    NOW()
FROM ods.`ods_tidb_readernovel_tidb_tag_center_book_information`;
