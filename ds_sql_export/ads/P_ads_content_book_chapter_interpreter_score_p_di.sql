----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_content_book_chapter_interpreter_score_p_di
-- workflow_version : 2
-- create_user      : xixg
-- task_name        : ads_content_book_chapter_interpreter_score_p_di
-- task_version     : 2
-- update_time      : 2024-10-12 16:08:35
-- sql_path         : \starrocks\tbl_ads_content_book_chapter_interpreter_score_p_di\ads_content_book_chapter_interpreter_score_p_di
----------------------------------------------------------------
-- SQL语句
INSERT INTO ads.ads_content_book_chapter_interpreter_score_p_di
WITH role_type_1 AS (
    SELECT
            date(a.CreateTime) AS dt,
            a.AuthorId AS author_id,
            a.BookId AS book_id,
            a.ObjectChapterId AS chapter_id,
            a.SiteId AS site_id,
            a.AuthorName AS author_name,
            a.RoleType AS role_type,
            a.FeedBackType AS feed_back_type,
            a.BookName AS book_name,
            a.ChapterName AS chapter_name,
            a.Sore AS score,
            a.CreateTime AS create_time,
            ROW_NUMBER() OVER (PARTITION BY BookId,SiteId,ObjectChapterId ORDER BY CreateTime DESC) rank_num
FROM ods.ods_tidb_shuangwen_xx_qualityfeedback a
WHERE date(a.CreateTime) = '${bf_1_dt}'
-- 角色为译员且反馈类型为质检抽查
  AND a.RoleType = 1
  AND a.FeedBackType = 1
),
role_type_2 AS (
SELECT
        date(a.CreateTime) AS dt,
        a.AuthorId AS author_id,
        a.BookId AS book_id,
        a.ObjectChapterId AS chapter_id,
        a.SiteId AS site_id,
        a.AuthorName AS author_name,
        a.RoleType AS role_type,
        a.FeedBackType AS feed_back_type,
        a.BookName AS book_name,
        a.ChapterName AS chapter_name,
        a.Sore AS score,
        a.CreateTime AS create_time,
        ROW_NUMBER() OVER (PARTITION BY BookId,SiteId,ObjectChapterId ORDER BY CreateTime DESC) rank_num
FROM ods.ods_tidb_shuangwen_xx_qualityfeedback a
WHERE date(a.CreateTime) = '${bf_1_dt}'
-- 角色为外籍一校且反馈类型为一校抽查
  AND a.RoleType = 2
  AND a.FeedBackType = 2
),

role_type_4 AS (
SELECT
        date(a.CreateTime) AS dt,
        a.AuthorId AS author_id,
        a.BookId AS book_id,
        a.ObjectChapterId AS chapter_id,
        a.SiteId AS site_id,
        a.AuthorName AS author_name,
        a.RoleType AS role_type,
        a.FeedBackType AS feed_back_type,
        a.BookName AS book_name,
        a.ChapterName AS chapter_name,
        a.Sore AS score,
        a.CreateTime AS create_time,
        ROW_NUMBER() OVER (PARTITION BY BookId,SiteId,ObjectChapterId ORDER BY CreateTime DESC) rank_num
FROM ods.ods_tidb_shuangwen_xx_qualityfeedback a
WHERE date(a.CreateTime) = '${bf_1_dt}'
-- 角色为三校一校且反馈类型为三校抽查
  AND a.RoleType = 4
  AND a.FeedBackType = 3
)

SELECT
        dt,
        author_id,
        book_id,
        chapter_id,
        site_id,
        author_name,
        role_type,
        feed_back_type,
        book_name,
        chapter_name,
        score,
        create_time,
        NOW()
FROM role_type_1
UNION ALL
SELECT
        dt,
        author_id,
        book_id,
        chapter_id,
        site_id,
        author_name,
        role_type,
        feed_back_type,
        book_name,
        chapter_name,
        score,
        create_time,
        NOW()
FROM role_type_2
UNION ALL
SELECT
        dt,
        author_id,
        book_id,
        chapter_id,
        site_id,
        author_name,
        role_type,
        feed_back_type,
        book_name,
        chapter_name,
        score,
        create_time,
        NOW()
FROM role_type_4;
