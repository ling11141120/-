----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_content_remuneration_detail
-- workflow_version : 5
-- create_user      : xixg
-- task_name        : ads_content_remuneration_detail
-- task_version     : 5
-- update_time      : 2025-04-28 10:16:26
-- sql_path         : \starrocks\tbl_ads_content_remuneration_detail\ads_content_remuneration_detail
----------------------------------------------------------------
-- SQL语句
INSERT INTO ads.ads_content_remuneration_detail
SELECT
    md5(concat_ws('_',DATE(CreateTime),a.ToLanguage,a.AuthorId,a.RoleType,b.PenName,c.BookName,d.ChapterName)) as md5_key,
    DATE(CreateTime),
    a.ToLanguage,
    a.AuthorId,
    a.RoleType,
    b.PenName,
    a.bookId,
    c.BookName AS book_name,
    a.ChapterId,
    d.ChapterName AS chapter_name,
    NOW()
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
    AND a.ChapterId = d.Id;
