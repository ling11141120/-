----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_content_object_chapter_check
-- workflow_version : 3
-- create_user      : xixg
-- task_name        : ads_content_object_chapter_check
-- task_version     : 3
-- update_time      : 2025-04-25 17:28:58
-- sql_path         : \starrocks\tbl_ads_content_object_chapter_check\ads_content_object_chapter_check
----------------------------------------------------------------
-- SQL语句
-- 抽查状态 0:无法抽查、 1：未抽查、2:待审核、3：待修改、4：抽查完毕 、5:抽查中
INSERT INTO ads.ads_content_object_chapter_check
SELECT
    md5(concat_ws('_',CompletionTime,ToLanguage,AuthorId,AuditPenName,PenName,BookName,ChapterName)) as md5_key,
    DATE(CompletionTime),
    ToLanguage,
    AuthorId,
    AuditPenName,
    PenName,
    BookName,
    ChapterName,
    NOW()
FROM ods.ods_shuangwen_tidb_xx_ObjectChapterCheck
WHERE Status = 4;
