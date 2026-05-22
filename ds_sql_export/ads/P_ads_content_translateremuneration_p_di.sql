----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_content_translateremuneration_p_di
-- workflow_version : 7
-- create_user      : xixg
-- task_name        : ads_content_translateremuneration_p_di
-- task_version     : 7
-- update_time      : 2024-10-17 15:01:50
-- sql_path         : \starrocks\tbl_ads_content_translateremuneration_p_di\ads_content_translateremuneration_p_di
----------------------------------------------------------------
-- SQL语句
INSERT INTO ads.ads_content_translateremuneration_p_di
SELECT
    date(a.RemunerationTime),
    a.Id,
    a.ToLanguage,
    a.BookId,
    a.AuthorId,
    CASE
        WHEN BookType = 3 THEN  1
        WHEN BookType < 3 THEN  0
    END AS ObjectBookType,
    a.ObjectChapterId,
    a.AuthorType,
    a.RoleType,
    a.PenName,
    a.RealName,
    a.BookName,
    a.ChapterName,
    a.FontLength,
    a.Price,
    a.TotalPrice,
    a.CurrencyType,
    a.PayType,
    a.RemunerationTime,
    a.BillDate,
    a.Status,
    a.PayStatus,
    a.PayTime,
    a.RemarkByFirst,
    a.RemarkBySecond,
    a.RemarkByThird,
    a.RemarkByPay,
    a.CreateTime,
    a.UpdateTime,
    a.RemunerationType,
    a.PriceType,
    a.SourceBookName,
    a.FromLanguage,
    a.SourceBookId,
    a.PayAccount,
    a.BankName,
    a.AccountName,
    a.ReasonType,
    a.BankSubBranch,
    a.PaymentType,
    a.BookType,
    a.UndoReason
FROM ods.ods_tidb_shuangwen_en_translateremuneration a
WHERE a.RemunerationTime >= '${bf_1_dt}'
 AND a.RemunerationTime < '${dt}';
