----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_content_quality_feedback
-- workflow_version : 14
-- create_user      : xixg
-- task_name        : ads_content_quality_feedback_1
-- task_version     : 9
-- update_time      : 2025-05-24 15:55:49
-- sql_path         : \starrocks\tbl_ads_content_quality_feedback\ads_content_quality_feedback_1
----------------------------------------------------------------
-- SQL语句
INSERT INTO ads.ads_content_quality_feedback
WITH tmp_data_1 AS (
SELECT
    DATE(CompletionTime) AS dt,
    a.SiteId,
    a.AuthorId,
    a.RoleType,
    1 AS check_model,
    a.AuthorName,
    a.CreateUserId AS check_person,
    a.AuthorName AS checked_person,
    a.BookName,
    a.ChapterName
FROM ods.ods_tidb_shuangwen_xx_qualityfeedback a
WHERE a.FeedBackType in (10,14)
)

SELECT
    md5(concat_ws('_',DATE(b.CreateTime),a.SiteId,a.AuthorId,a.RoleType,1,a.AuthorName,a.check_person,a.checked_person,c.BookName,d.ChapterName)) as md5_key,
     DATE(b.CreateTime) AS dt,
     a.SiteId,
     a.AuthorId,
     b.RoleType,
     1 AS check_model,
     a.AuthorName,
     a.check_person AS check_person,
     a.checked_person AS checked_person,
     b.bookId,
     c.BookName AS book_name,
     b.ChapterId,
     d.ChapterName AS chapter_name,
     NOW()
FROM tmp_data_1 a
INNER JOIN ods.ods_edit_book_RemunerationDetail b
ON a.AuthorId = b.AuthorId
LEFT JOIN ods.ods_tidb_shuangwen_en_objectbook c
    ON  b.productid = c.productid
    AND b.bookId = c.SwBookId
    AND b.ToLanguage = c.ToLanguage
    AND c.Status = 1
LEFT JOIN ods.ods_tidb_shuangwen_xx_objectchapter d
    ON  b.productid = d.productid
    AND c.id = d.ObjectBookId
    AND b.ChapterId = d.Id;

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_content_quality_feedback
-- workflow_version : 14
-- create_user      : xixg
-- task_name        : ads_content_quality_feedback_2
-- task_version     : 9
-- update_time      : 2025-05-24 15:55:49
-- sql_path         : \starrocks\tbl_ads_content_quality_feedback\ads_content_quality_feedback_2
----------------------------------------------------------------
-- SQL语句
INSERT INTO ads.ads_content_quality_feedback
with tmp_task_data1 AS (
    SELECT
            DATE(CreateTime) dt,
            ToLanguage AS SiteId,
            OptUsers AS checked_user,
            row_number() over (partition by TaskContent, OptUsers  order by  CreateTime  ) r_num
FROM ods.ods_shuangwen_tidb_xx_taskcenter
    WHERE TaskType = '低分重校章节'

),

tmp_data2 AS (
    SELECT  *
    FROM tmp_task_data1
    WHERE r_num  = 1
),

remuneration AS (
SELECT
    a.AuthorId,
    b.PenName AS AuthorName,
    b.ToLanguage AS site_id,
    DATE(a.CreateTime) dt ,
    a.RoleType,
    a.bookId,
    c.BookName AS book_name,
    a.ChapterId,
    d.ChapterName AS chapter_name
FROM ods.ods_edit_book_RemunerationDetail a
LEFT JOIN ods.ods_tidb_shuangwen_xx_objectauthor b
    ON  a.productid = b.productid
    AND a.AuthorId = b.AccountId
    AND a.ToLanguage = b.ToLanguage
LEFT JOIN ods.ods_tidb_shuangwen_en_objectbook c
    ON  a.productid = c.productid
    AND a.bookId = c.SwBookId
    AND a.ToLanguage = c.ToLanguage
    AND c.Status = 1
LEFT JOIN ods.ods_tidb_shuangwen_xx_objectchapter d
    ON  a.productid = d.productid
    AND c.id = d.ObjectBookId
    AND a.ChapterId = d.Id
)

SELECT
    md5(concat_ws('_',b.dt,b.site_id,b.AuthorId,b.RoleType,2,b.AuthorName,NULL,b.AuthorName,b.book_name,b.chapter_name)) as md5_key,
    b.dt,
    b.site_id,
    b.AuthorId,
    b.RoleType,
    2 AS check_model,
    b.AuthorName,
    NULL AS check_person,
    b.AuthorName AS checked_person,
    b.bookId,
    b.book_name AS book_name,
    b.ChapterId,
    b.chapter_name AS chapter_name,
    NOW()
FROM tmp_data2 a
INNER JOIN remuneration b
    ON a.checked_user = b.AuthorName;

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_content_quality_feedback
-- workflow_version : 14
-- create_user      : xixg
-- task_name        : ads_content_quality_feedback_3
-- task_version     : 7
-- update_time      : 2025-05-24 15:55:49
-- sql_path         : \starrocks\tbl_ads_content_quality_feedback\ads_content_quality_feedback_3
----------------------------------------------------------------
-- SQL语句
INSERT INTO ads.ads_content_quality_feedback
with tmp_data1  AS (
    SELECT
        DATE(CompletionTime) AS dt,
        productid,
        ChapterId,
        BookId,
        RoleType,
        ToLanguage AS site_id,
        AuthorId AS AuthorId,
        PenName AS AuthorName,
        BookName AS book_name,
        ChapterName AS chapter_name,
        row_number() over (partition by PenName, BookName, chapterName  order by  a.CompletionTime  ) r_num
FROM ods.ods_shuangwen_tidb_xx_ObjectChapterCheck a
WHERE RoleType = 2
),

tmp_data2 AS (
    SELECT  *
    FROM tmp_data1
    WHERE r_num  = 1
),

tmp_data3 AS (
    SELECT a.*
    FROM tmp_data2 a
     INNER JOIN ods.ods_tidb_shuangwen_xx_objectchapter d
               ON  a.productid = d.productid
                   AND a.ChapterId = d.Id
                   WHERE ROUND((d.ModifyLength/d.ForeignLength)* 100,2) >= 70
)

SELECT
    md5(concat_ws('_',a.dt,a.site_id,a.AuthorId,a.RoleType,3,a.AuthorName,NULL,a.AuthorName,a.book_name,a.chapter_name)) as md5_key,
    a.dt,
    a.site_id,
    a.AuthorId,
    a.RoleType,
    3 AS check_model,
    a.AuthorName,
    NULL AS check_person,
    a.AuthorName AS checked_person,
    a.BookId,
    a.book_name AS book_name,
    a.ChapterId,
    a.chapter_name AS chapter_name,
    NOW()
FROM tmp_data3 a;

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_content_quality_feedback
-- workflow_version : 14
-- create_user      : xixg
-- task_name        : ads_content_quality_feedback_4
-- task_version     : 7
-- update_time      : 2025-05-24 15:55:49
-- sql_path         : \starrocks\tbl_ads_content_quality_feedback\ads_content_quality_feedback_4
----------------------------------------------------------------
-- SQL语句
INSERT INTO ads.ads_content_quality_feedback
with tmp_data1  AS (
SELECT
    DATE(a.CreateTime) dt,
    a.BookId,
    a.ChapterId,
    a.ToLanguage AS site_id,
    NULL AS author_id,
    NULL AS author_name,
    2 as role_type,
    4 AS check_modle,
    a.OptUsers AS check_person,
    replace(split(a.TaskTitle,'：')[2],'章节名','') AS book_name,
    split(a.TaskTitle,'：')[3] AS chapter_name,
    NOW()
FROM ods.ods_shuangwen_tidb_xx_taskcenter a
WHERE TaskType = '外审评分审核'
)

SELECT
    md5(concat_ws('_',a.dt,a.site_id,a.author_id,a.role_type,4,a.author_name,a.check_person,NULL,a.book_name,a.chapter_name)) as md5_key,
    a.dt,
    a.site_id,
    a.author_id,
    a.role_type,
    4 AS check_model,
    a.author_name,
    a.check_person AS check_person,
    NULL AS checked_person,
    a.BookId,
    a.book_name AS book_name,
    a.ChapterId,
    a.chapter_name AS chapter_name,
    NOW()
FROM tmp_data1 a;

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_content_quality_feedback
-- workflow_version : 14
-- create_user      : xixg
-- task_name        : ads_content_quality_feedback_5
-- task_version     : 8
-- update_time      : 2025-05-24 15:55:49
-- sql_path         : \starrocks\tbl_ads_content_quality_feedback\ads_content_quality_feedback_5
----------------------------------------------------------------
-- SQL语句
INSERT INTO ads.ads_content_quality_feedback
with tmp_data1  AS (
    SELECT
        DATE(CompletionTime) AS dt,
        productid,
        RoleType,
        ToLanguage AS site_id,
        AuthorId AS AuthorId,
        PenName AS AuthorName,
        BookId,
        BookName AS book_name,
        ChapterId,
        ChapterName AS chapter_name,
        row_number() over (partition by PenName, BookName, chapterName  order by  a.CompletionTime  ) r_num
    FROM ods.ods_shuangwen_tidb_xx_ObjectChapterCheck a
    WHERE RoleType = 3
),

tmp_data2 AS (
 SELECT  *
 FROM tmp_data1
 WHERE r_num  = 1
),

tmp_data3 AS (
 SELECT a.*
 FROM tmp_data2 a
INNER JOIN ods.ods_tidb_shuangwen_xx_objectchapter d
        ON  a.productid = d.productid
            AND a.ChapterId = d.Id
 WHERE d.ForeignPercent <= 1
)

SELECT
    md5(concat_ws('_',a.dt,a.site_id,a.AuthorId,a.RoleType,5,a.AuthorName,NULL,a.AuthorName,a.book_name,a.chapter_name)) as md5_key,
    a.dt,
    a.site_id,
    a.AuthorId,
    a.RoleType,
    5 AS check_model,
    a.AuthorName,
    NULL AS check_person,
    a.AuthorName AS checked_person,
    a.BookId,
    a.book_name AS book_name,
    a.ChapterId,
    a.chapter_name AS chapter_name,
    NOW()
FROM tmp_data3 a;

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_content_quality_feedback
-- workflow_version : 14
-- create_user      : xixg
-- task_name        : ads_content_quality_feedback_6
-- task_version     : 6
-- update_time      : 2025-05-24 15:55:49
-- sql_path         : \starrocks\tbl_ads_content_quality_feedback\ads_content_quality_feedback_6
----------------------------------------------------------------
-- SQL语句
INSERT INTO ads.ads_content_quality_feedback
with tmp_data1  AS (
SELECT
    SiteId AS SiteId,
    RoleType,
    AuthorId AS AuthorId,
    AuthorName AS AuthorName
FROM ods.ods_tidb_shuangwen_en_viscauthorconfig a
WHERE CooperateMode in (1,3)
),

remuneration AS (
SELECT
    a.AuthorId,
    b.PenName AS AuthorName,
    b.ToLanguage AS site_id,
    DATE(a.CreateTime) dt ,
    a.RoleType,
    a.bookId,
    c.BookName AS book_name,
    a.ChapterId,
    d.ChapterName AS chapter_name
FROM ods.ods_edit_book_RemunerationDetail a
LEFT JOIN ods.ods_tidb_shuangwen_xx_objectauthor b
    ON  a.productid = b.productid
    AND a.AuthorId = b.AccountId
    AND a.ToLanguage = b.ToLanguage
LEFT JOIN ods.ods_tidb_shuangwen_en_objectbook c
    ON  a.productid = c.productid
    AND a.bookId = c.SwBookId
    AND a.ToLanguage = c.ToLanguage
    AND c.Status = 1
LEFT JOIN ods.ods_tidb_shuangwen_xx_objectchapter d
    ON  a.productid = d.productid
    AND c.id = d.ObjectBookId
    AND a.ChapterId = d.Id
)

SELECT
    md5(concat_ws('_',b.dt,a.SiteId,b.AuthorId,b.RoleType,6,b.AuthorName,NULL,b.AuthorName,b.book_name,b.chapter_name)) as md5_key,
    b.dt,
    a.SiteId,
    b.AuthorId,
    b.RoleType,
    6 AS check_model,
    b.AuthorName,
    NULL AS check_person,
    b.AuthorName AS checked_person,
    b.bookId,
    b.book_name AS book_name,
    b.ChapterId,
    b.chapter_name AS chapter_name,
    NOW()
FROM tmp_data1 a
 INNER JOIN remuneration b
    ON a.AuthorId = b.AuthorId;
