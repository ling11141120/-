----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_content_translators_book_score
-- workflow_version : 8
-- create_user      : xixg
-- task_name        : ads_content_translators_book_score
-- task_version     : 8
-- update_time      : 2024-12-09 19:21:26
-- sql_path         : \starrocks\tbl_ads_content_translators_book_score\ads_content_translators_book_score
----------------------------------------------------------------
-- SQL语句
INSERT INTO ads.ads_content_translators_book_score
WITH translators_tem AS (
    SELECT
        AccountId,
        ToLanguage
    FROM ods.ods_tidb_shuangwen_xx_objectauthor
    WHERE IsSpecial =  1
),

result_tem AS (
SELECT
     a.SiteId AS site_id,
     a.AuthorId AS translator_id,
     a.BookId AS book_id,
     a.ObjectChapterId AS chapter_id,
     a.AuthorName AS translator_name,
     a.BookName AS book_name,
     a.ChapterName AS chapter_name,
     replace(split(a.CreateUserId,'(')[2],')','') AS check_user_id,
     a.CreateUserId AS check_user_name,
     a.CreateTime AS check_date,
     c.CorrectTxtNum/c.FontLength AS check_correct_rate,
     a.Sore AS score
 FROM ods.ods_tidb_shuangwen_xx_qualityfeedback a
INNER JOIN translators_tem b
ON a.SiteId  = b.ToLanguage
AND a.AuthorId = b.AccountId
LEFT JOIN ods.ods_tidb_selffeedbackchapter c
ON a.SiteId = c.Tolanguage
and a.ObjectChapterId = c.ObjectChapterId
WHERE a.FeedBackType in (1,2,3)
)

SELECT
    site_id,
    translator_id,
    book_id,
    chapter_id,
    translator_name,
    book_name,
    chapter_name,
    check_user_id,
    check_user_name,
    check_date,
    check_date,
    check_correct_rate,
    score,
    CASE
        WHEN  check_correct_rate = 1 THEN 5
        WHEN 0.997 <= check_correct_rate AND check_correct_rate < 1 THEN 4.5
        WHEN 0.98 <= check_correct_rate  AND check_correct_rate < 0.997 THEN 4
        WHEN 0.96 <= check_correct_rate  AND check_correct_rate < 0.98 THEN 3.5
        WHEN 0.93 <= check_correct_rate  AND check_correct_rate < 0.96 THEN 3.25
        WHEN 0.90 <= check_correct_rate  AND check_correct_rate < 0.93 THEN 3
        WHEN 0.75 <= check_correct_rate  AND check_correct_rate < 0.90 THEN 2.5
        WHEN 0.65 <= check_correct_rate  AND check_correct_rate < 0.75 THEN 2
        WHEN 0.55 <= check_correct_rate  AND check_correct_rate < 0.65 THEN 1.5
        WHEN 0.45 <= check_correct_rate  AND check_correct_rate < 0.55 THEN 1
        WHEN 0.35 <= check_correct_rate  AND check_correct_rate < 0.45 THEN 0.5
        WHEN 0 <= check_correct_rate AND check_correct_rate < 0.35 THEN 0
    END AS new_score,
    NOW()
FROM result_tem;
