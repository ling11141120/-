----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_content_book_chapter_interpreter_p_di
-- workflow_version : 12
-- create_user      : xixg
-- task_name        : ads_content_book_chapter_interpreter_p_di
-- task_version     : 12
-- update_time      : 2024-09-02 11:20:54
-- sql_path         : \starrocks\tbl_ads_content_book_chapter_interpreter_p_di\ads_content_book_chapter_interpreter_p_di
----------------------------------------------------------------
-- SQL语句
INSERT INTO ads.ads_content_book_chapter_interpreter_p_di

WITH tmp_book_remuneration_detail AS (
    SELECT
         a.productid,
         a.AuthorId,
         a.bookId,
         a.ChapterId,
         a.ToLanguage,
         a.FontLength,
         a.CreateTime,
         a.RoleType,
         ROW_NUMBER() OVER (partition by productid,AuthorId,bookId,ChapterId order by CreateTime DESC) row_num
   FROM ods.ods_edit_book_RemunerationDetail a
    WHERE date(a.CreateTime) = '${bf_1_dt}'
    AND a.RoleType in (1,2,3)
)

SELECT
        date(a.CreateTime) AS dt,
        a.AuthorId AS author_id,
        a.bookId AS book_id,
        a.ChapterId AS chapter_id,
        a.ToLanguage AS site_id,
        c.ObjectBookType AS project_type,
        b.PenName AS author_name,
        a.RoleType AS role_type,
        c.BookCode AS book_code,
        c.BookName AS book_name,
        d.ChapterName AS chapter_name,
        a.FontLength AS font_length,
        a.CreateTime AS create_time,
        NOW()
FROM tmp_book_remuneration_detail a
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
WHERE a.row_num = 1;
