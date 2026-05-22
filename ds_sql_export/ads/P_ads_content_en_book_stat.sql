----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_content_en_book_stat
-- workflow_version : 9
-- create_user      : xixg
-- task_name        : ads_content_en_book_stat
-- task_version     : 9
-- update_time      : 2025-07-08 18:28:53
-- sql_path         : \starrocks\tbl_ads_content_en_book_stat\ads_content_en_book_stat
----------------------------------------------------------------
-- SQL语句
INSERT INTO ads.ads_content_en_book_stat
WITH jt_book_bf_1_dt AS (
    select
        book_id,
        app_font_length
    from dim.dim_ft_book_info
    where dt = '${bf_1_dt}'
),

jt_book_bf_7_dt AS (
 select
     book_id,
     app_font_length
 from dim.dim_ft_book_info
 where dt = '${bf_7_dt}'
),

jt_book_7days_words AS (
    select
         a.book_id,
        (a.app_font_length - b.app_font_length)  AS 7days_words
    from jt_book_bf_1_dt a
    LEFT JOIN jt_book_bf_7_dt b
     ON a.book_id = b.book_id
),
en_book_chapter AS (
SELECT a.SwBookId AS book_id,
       a.ToLanguage AS site_id ,
       SUM(b.Length) AS source_chapter_words,
       SUM(b.EnLength) AS target_chapter_words
FROM   ods.ods_tidb_shuangwen_en_objectbook a
    LEFT JOIN ods.ods_tidb_shuangwen_xx_objectchapter b
    ON  a.productid = b.productid
    AND a.id = b.ObjectBookId
    AND b.ChapterNumber <= 10
WHERE a.ToLanguage = 322
    AND a.Status = 1
GROUP BY a.SwBookId,a.ToLanguage
)

SELECT a.dt,
       a.book_id,
       g.book_code,
       a.putaway_status,
       b.first_translate_day,
       b.proofread_length,
       c.target_chapter_words,
       c.source_chapter_words,
       e.app_font_length,
       d.7days_words,
       NOW()
FROM ads.ads_content_book_publish_mgr a
         LEFT JOIN  ads.ads_report_book_capacity_rate_stat b
                    ON  a.dt = b.dt
                        AND  a.book_id = b.book_id
         LEFT JOIN en_book_chapter c
                ON a.book_id = (c.book_id * 1000 + c.site_id )
         LEFT JOIN dwd.dwd_edit_book_languagebooktotal_da f
                   ON a.book_id  = f.to_book_id
                       AND f.dt = '${bf_1_dt}'
         LEFT JOIN jt_book_bf_1_dt e
                   ON f.from_book_id = e.book_id
         LEFT JOIN jt_book_7days_words d
            ON f.from_book_id = d.book_id
         LEFT JOIN dim.dim_shuangwen_book_read_consume_info g
            ON a.book_id = g.book_id
WHERE a.dt = '${bf_1_dt}'
  and a.language_name = '英语'
  AND a.book_code != '-';
