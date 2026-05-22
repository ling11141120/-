----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_content_external_buy_book_stat
-- workflow_version : 13
-- create_user      : xixg
-- task_name        : ads_content_external_buy_book_stat
-- task_version     : 13
-- update_time      : 2025-05-12 15:57:19
-- sql_path         : \starrocks\tbl_ads_content_external_buy_book_stat\ads_content_external_buy_book_stat
----------------------------------------------------------------
-- SQL语句
INSERT INTO ads.ads_content_external_buy_book_stat
-- 所有的外采书籍
WITH tmp_ext_book AS (
    SELECT
        BookId AS book_id,
        BookCode AS book_code,
        BookName AS book_name,
        CASE
            WHEN PriceType='人民币' THEN Price
            WHEN PriceType='美元' THEN Price * 6.5
            END AS copyright_cost_amount
    FROM ods.ods_tidb_shuangwen_en_TranslateExternalBook
),

-- 外采书籍所有的翻译书
     tmp_translate_book AS (
         SELECT
             a.book_id AS source_book_id,
             a.book_name AS source_book_name,
             b.SwBookId AS book_id,
             b.ToLanguage AS site_id
         FROM tmp_ext_book a
                  INNER JOIN ods.ods_content_custombooktobook b
                             ON a.book_id = b.BookId
     ),

-- 外采书籍所有的翻译书的上架时间
     tmp_translate_book_first_chapter AS (
         SELECT
             a.book_id,
             IFNULL(d.PublishTime,b.CreateTime) AS putaway_date
         FROM tmp_translate_book  a
                  LEFT JOIN ods.ods_edit_book b
                            ON a.book_id*1000+a.site_id = b.BookId*1000+b.SiteId
                  LEFT JOIN ods.ods_tidb_shuangwen_xx_chapter d
                            ON b.productid  = d.ProductId
                                AND b.BookId = d.BookId
                                AND d.DelStatus = 0
                                AND d.Status = 2
                                AND d.SequenceNum = 1
     ),
--外采书籍所有的翻译书的指标
     tmp_translate_book_info AS (
         SELECT
             '${bf_1_dt}' AS dt,
             a.book_id AS book_id,
             b.BookName AS book_name,
             b.BookCode AS book_code,
             0 AS story_type,
             a.site_id,
             CASE a.site_id
                 WHEN 445 THEN '菲律宾语'
                 WHEN 333 THEN '繁体'
                 WHEN 322 THEN '英语'
                 WHEN 375 THEN '西语'
                 WHEN 409 THEN '葡语'
                 WHEN 410 THEN '法语'
                 WHEN 418 THEN '俄语'
                 WHEN 419 THEN '日语'
                 WHEN 414 THEN '印尼语'
                 WHEN 433 THEN '泰语'
                 WHEN 436 THEN '韩语'
                 WHEN 0 THEN '简体'
                 ELSE ''
                 END AS language_name,
             a.source_book_id AS source_book_id,
             a.source_book_name AS source_book_name,
             c.public_fontlength AS published_words,
             d.putaway_date AS putaway_date,
             (e.amount/100)*6.5 AS read_coin_amount,
             f.toufang_cost_rmb AS ad_cost_amount,
             f.translate_cost_rmb AS translate_cost_amount,
             NULL AS copyright_cost_amount,
             NULL AS copyright_fc_amount,
             NOW()
         FROM tmp_translate_book  a
                  LEFT JOIN ods.ods_edit_book b
                            ON a.book_id*1000+a.site_id = b.BookId*1000+b.SiteId
                  LEFT JOIN dim.dim_shuangwen_book_read_consume_info c
                            ON c.book_id = a.book_id * 1000 + a.site_id
                  LEFT JOIN tmp_translate_book_first_chapter d
                            ON a.book_id  = d.book_id
                  LEFT JOIN dws.dws_consume_book_consume_ed e
                            ON e.book_id = a.book_id * 1000 + a.site_id
                                AND e.types = 1
                                AND e.dt = '${bf_1_dt}'
                  LEFT JOIN dws.dws_content_translate_book_cost_ed f
                            ON f.book_id = a.book_id * 1000 + a.site_id
                                AND  f.dt = '${bf_1_dt}'
     ),

-- 所有外采书籍的上架时间，发布字数
     tmp_ext_book_first_chapter AS (
         SELECT
             a.book_id,
             b.SiteBookId AS site_book_id,
             b.FontLength AS published_words,
             IFNULL(d.CreateTime,c.CreateTime) AS putaway_date
         FROM tmp_ext_book  a
                  LEFT JOIN ods.ods_tidb_shuangwen_en_custombook b
                            ON a.book_id = b.Id
                  LEFT JOIN ods.ods_tidb_shuangwen_en_customchapter c
                            ON b.Id = c.BookId
                                AND c.DelStatus = 0
                                AND c.Sort = 1
                  LEFT JOIN ods.ods_tidb_shuangwen_en_CustomChapterLog_da d
                            ON c.BookId = d.BookId
                                AND c.Id = d.ChapterId
                                AND d.LogType = 5
     ),

-- 所有外采书籍的英语翻译书的上架时间
     tmp_ext_book_en_first_chapter AS (
         SELECT
             a.book_id,
             d.PublishTime AS putaway_date
         FROM tmp_translate_book  a
                  LEFT JOIN ods.ods_edit_book b
                            ON a.book_id*1000+322 = b.BookId*1000+322
                  LEFT JOIN ods.ods_tidb_shuangwen_xx_chapter d
                            ON b.productid  = d.ProductId
                                AND b.BookId = d.BookId
                                AND d.DelStatus = 0
                                AND d.Status = 2
                                AND d.SequenceNum = 1
     ),

-- 所有外采书籍的版权分成金额，单位人民币
     tmp_ext_book_fc AS (
         SELECT
             a.book_id,
             SUM(b.RemunerationMoney * 6.5) AS copyright_fc_amount
         FROM tmp_ext_book a
                  LEFT JOIN ods.ods_tidb_shuangwen_xx_exclusiverewardnew b
                            ON a.book_id = b.BookId
                                AND b.dailytime = '${bf_1_dt}'
                                AND b.IsBanWithdrawl = 0
         GROUP BY a.book_id
     ),
-- 所有外采书籍的指标
     tmp_ext_book_info AS (
         SELECT
             '${bf_1_dt}' AS dt,
             a.book_id AS book_id,
             a.book_name AS book_name,
             a.book_code AS book_code,
             0 AS story_type,
             0,
             '简体' language_name,
             NULL AS source_book_id,
             NULL AS source_book_name,
             d.published_words AS published_words,
             IFNULL(c.putaway_date,d.putaway_date) AS putaway_date,
             (e.amount/100)*6.5 AS read_coin_amount,
             f.toufang_cost_rmb AS ad_cost_amount,
             f.translate_cost_rmb AS translate_cost_amount,
             a.copyright_cost_amount AS copyright_cost_amount,
             g.copyright_fc_amount AS copyright_fc_amount,
             NOW()
         FROM tmp_ext_book  a
                  LEFT JOIN tmp_ext_book_en_first_chapter c
                            ON a.book_id  = c.book_id
                  LEFT JOIN tmp_ext_book_first_chapter d
                            ON a.book_id  = d.book_id
                  LEFT JOIN dws.dws_consume_book_consume_ed e
                            ON e.book_id = d.site_book_id * 1000 + 446
                                AND e.types = 1
                                AND e.dt = '${bf_1_dt}'
                  LEFT JOIN dws.dws_content_translate_book_cost_ed f
                            ON f.book_id = d.site_book_id * 1000 + 446
                                AND  f.dt = '${bf_1_dt}'
                  LEFT JOIN tmp_ext_book_fc g
                            ON a.book_id  = g.book_id

     ),

-- 外采书籍的所有拆章书
     tmp_separate_chapter_book AS (
         SELECT
             a.book_id AS source_book_id,
             a.book_name AS source_book_name,
             b.BookId AS book_id,
             b.LanguageId AS language_id,
             c.book_langid AS site_id
         FROM tmp_ext_book a
                  INNER JOIN ods.ods_content_book_parent_book_relation b
                             ON a.book_id = b.RootParentBookId
                  INNER JOIN dim.DIM_ProductType c
                             ON b.LanguageId = c.langid
     ),

-- 外采书籍的所有拆章书的上架时间
     tmp_separate_chapter_book_first_chapter AS (
         SELECT
             a.book_id,
             d.PublishTime AS putaway_date
         FROM tmp_separate_chapter_book  a
                  LEFT JOIN ods.ods_edit_book b
                            ON a.book_id*1000+a.site_id = b.BookId*1000+b.SiteId
                  LEFT JOIN ods.ods_tidb_shuangwen_xx_chapter d
                            ON b.productid  = d.ProductId
                                AND b.BookId = d.BookId
                                AND d.DelStatus = 0
                                AND d.Status = 2
                                AND d.SequenceNum = 1
     ),
-- 外采书籍的所有拆章书的指标
     tmp_separate_chapter_book_info AS (
         SELECT
             '${bf_1_dt}' AS dt,
             a.book_id AS book_id,
             c.book_name AS book_name,
             c.book_code AS book_code,
             0 AS story_type,
             a.site_id,
             CASE a.site_id
                 WHEN 445 THEN '菲律宾语'
                 WHEN 333 THEN '繁体'
                 WHEN 322 THEN '英语'
                 WHEN 375 THEN '西语'
                 WHEN 409 THEN '葡语'
                 WHEN 410 THEN '法语'
                 WHEN 418 THEN '俄语'
                 WHEN 419 THEN '日语'
                 WHEN 414 THEN '印尼语'
                 WHEN 433 THEN '泰语'
                 WHEN 436 THEN '韩语'
                 WHEN 0 THEN '简体'
                 ELSE ''
                 END AS language_name,
             a.source_book_id AS source_book_id,
             a.source_book_name AS source_book_name,
             c.public_fontlength AS published_words,
             d.putaway_date AS putaway_date,
             (e.amount/100)*6.5 AS read_coin_amount,
             f.toufang_cost_rmb AS ad_cost_amount,
             f.translate_cost_rmb AS translate_cost_amount,
             NULL AS copyright_cost_amount,
             NULL AS copyright_fc_amount,
             NOW()
         FROM tmp_separate_chapter_book  a
                  LEFT JOIN dim.dim_shuangwen_book_read_consume_info c
                            ON c.book_id = a.book_id * 1000 + a.site_id
                  LEFT JOIN tmp_separate_chapter_book_first_chapter d
                            ON a.book_id  = d.book_id
                  LEFT JOIN dws.dws_consume_book_consume_ed e
                            ON e.book_id = a.book_id * 1000 + a.site_id
                                AND e.types = 1
                                AND e.dt = '${bf_1_dt}'
                  LEFT JOIN dws.dws_content_translate_book_cost_ed f
                            ON f.book_id = a.book_id * 1000 + a.site_id
                                AND  f.dt = '${bf_1_dt}'
     ),

-- 外采书籍所有的翻译书的拆章书
     tmp_translate_separate_chapter_book AS (
         SELECT
             a.source_book_id AS source_book_id,
             a.source_book_name AS source_book_name,
             b.BookId AS book_id,
             b.LanguageId AS language_id,
             c.book_langid AS site_id
         FROM tmp_translate_book a
                  INNER JOIN ods.ods_content_book_parent_book_relation b
                             ON a.book_id = b.RootParentBookId
                  INNER JOIN dim.DIM_ProductType c
                             ON b.LanguageId = c.langid
     ),
-- 外采书籍的所有翻译书的拆章书的上架时间
     tmp_translate_separate_chapter_book_first_chapter AS (
         SELECT
             a.book_id,
             d.PublishTime AS putaway_date
         FROM tmp_translate_separate_chapter_book  a
                  LEFT JOIN ods.ods_edit_book b
                            ON a.book_id*1000+a.site_id = b.BookId*1000+b.SiteId
                  LEFT JOIN ods.ods_tidb_shuangwen_xx_chapter d
                            ON b.productid  = d.ProductId
                                AND b.BookId = d.BookId
                                AND d.DelStatus = 0
                                AND d.Status = 2
                                AND d.SequenceNum = 1
     ),

-- 外采书籍的所有翻译书的拆章书的指标
     tmp_translate_separate_chapter_book_info AS (
         SELECT
             '${bf_1_dt}' AS dt,
             a.book_id AS book_id,
             c.book_name AS book_name,
             c.book_code AS book_code,
             0 AS story_type,
             a.site_id,
             CASE a.site_id
                 WHEN 445 THEN '菲律宾语'
                 WHEN 333 THEN '繁体'
                 WHEN 322 THEN '英语'
                 WHEN 375 THEN '西语'
                 WHEN 409 THEN '葡语'
                 WHEN 410 THEN '法语'
                 WHEN 418 THEN '俄语'
                 WHEN 419 THEN '日语'
                 WHEN 414 THEN '印尼语'
                 WHEN 433 THEN '泰语'
                 WHEN 436 THEN '韩语'
                 WHEN 0 THEN '简体'
                 ELSE ''
                 END AS language_name,
             a.source_book_id AS source_book_id,
             a.source_book_name AS source_book_name,
             c.public_fontlength AS published_words,
             IFNULL(d.putaway_date,c.create_time) AS putaway_date,
             (e.amount/100)*6.5 AS read_coin_amount,
             f.toufang_cost_rmb AS ad_cost_amount,
             f.translate_cost_rmb AS translate_cost_amount,
             NULL AS copyright_cost_amount,
             NULL AS copyright_fc_amount,
             NOW()
         FROM tmp_translate_separate_chapter_book  a
                  LEFT JOIN dim.dim_shuangwen_book_read_consume_info c
                            ON c.book_id = a.book_id * 1000 + a.site_id
                  LEFT JOIN tmp_translate_separate_chapter_book_first_chapter d
                            ON a.book_id  = d.book_id
                  LEFT JOIN dws.dws_consume_book_consume_ed e
                            ON e.book_id = a.book_id * 1000 + a.site_id
                                AND e.types = 1
                                AND e.dt = '${bf_1_dt}'
                  LEFT JOIN dws.dws_content_translate_book_cost_ed f
                            ON f.book_id = a.book_id * 1000 + a.site_id
                                AND  f.dt = '${bf_1_dt}'
     ),

tmp_novel_book AS (
    SELECT
        a.BookID AS book_id,
        a.SiteID AS site_id
    FROM ods.`ods_book_novel_book_m` a
    WHERE  a.StoryType = 1
    group by 1,2

),
-- 短篇书
short_book_info AS (
    SELECT
        '${bf_1_dt}' AS dt,
        a.book_id AS book_id,
        c.book_name AS book_name,
        c.book_code AS book_code,
        1 AS story_type,
        a.site_id,
        CASE a.site_id
            WHEN 445 THEN '菲律宾语'
            WHEN 333 THEN '繁体'
            WHEN 322 THEN '英语'
            WHEN 375 THEN '西语'
            WHEN 409 THEN '葡语'
            WHEN 410 THEN '法语'
            WHEN 418 THEN '俄语'
            WHEN 419 THEN '日语'
            WHEN 414 THEN '印尼语'
            WHEN 412 THEN '德语'
            WHEN 413 THEN '意大利语'
            WHEN 433 THEN '泰语'
            WHEN 436 THEN '韩语'
            WHEN 0 THEN '简体'
            ELSE ''
            END AS language_name,
        d.BookId AS source_book_id,
        d.BookName AS source_book_name,
        c.public_fontlength AS published_words,
        c.build_time AS putaway_date,
        (e.amount/100)*6.5 AS read_coin_amount,
        f.toufang_cost_rmb AS ad_cost_amount,
        f.translate_cost_rmb AS translate_cost_amount,
        NULL AS copyright_cost_amount,
        NULL AS copyright_fc_amount,
        NOW()
    FROM tmp_novel_book  a
             INNER JOIN dim.dim_shuangwen_book_read_consume_info c
                       ON c.book_id = a.book_id
             LEFT JOIN ods.`ods_tidb_shuangwen_en_objectbook` d
                       ON a.book_id  = (d.swbookid*1000 + d.tolanguage)
             LEFT JOIN dws.dws_consume_book_consume_ed e
                       ON e.book_id = a.book_id
                           AND e.types = 1
                           AND e.dt = '${bf_1_dt}'
             LEFT JOIN dws.dws_content_translate_book_cost_ed f
                       ON f.book_id = a.book_id
                           AND  f.dt = '${bf_1_dt}'

)

SELECT * FROM tmp_ext_book_info
UNION ALL
SELECT * FROM tmp_separate_chapter_book_info
UNION ALL
SELECT * FROM tmp_translate_book_info
UNION ALL
SELECT * FROM tmp_translate_separate_chapter_book_info
UNION ALL
SELECT * FROM short_book_info;
