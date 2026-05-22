----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_short_book
-- workflow_version : 4
-- create_user      : xixg
-- task_name        : ads_short_book
-- task_version     : 4
-- update_time      : 2025-05-26 17:23:35
-- sql_path         : \starrocks\tbl_ads_short_book\ads_short_book
----------------------------------------------------------------
-- SQL语句
INSERT INTO ads.ads_short_book
SELECT
    BookID ,
    MAX(NOW())
FROM ods.`ods_book_novel_book_m`
WHERE  StoryType = 1
group by 1;
