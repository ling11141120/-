INSERT INTO ads.ads_MarketingPlan_new
WITH tmp_product AS (
    SELECT DISTINCT ProductId
      FROM ods.ods_tidb_sharpengine_ads_global_ProjectProduct_da
     WHERE ProjectCode = 1
)
,tmp_bf_1_dt_spend AS (
    SELECT b.BookId      AS book_id
          ,SUM(Spend)    AS bf_1_dt_spend
      FROM ods.ods_tidb_sharpengine_ads_global_FbAdDailyInsight a
      LEFT JOIN ods.ods_tidb_sharpengine_ads_global_adext b
        ON b.AdId = a.AdId
       AND b.ProductId = a.ProductId
     WHERE a.date_start = '${bf_1_dt}'
       AND a.ProductId IN (SELECT ProductId FROM tmp_product)
       AND IFNULL(b.BookId, '') != ''
     GROUP BY b.BookId
)
,tmp_7_day_spend AS (
    SELECT b.BookId      AS book_id
          ,SUM(Spend)    AS 7_day_spend
      FROM ods.ods_tidb_sharpengine_ads_global_FbAdDailyInsight a
      LEFT JOIN ods.ods_tidb_sharpengine_ads_global_adext b
        ON b.AdId = a.AdId
       AND b.ProductId = a.ProductId
     WHERE a.date_start >= DATE_SUB('${bf_1_dt}', 7)
       AND a.date_start <= '${bf_1_dt}'
       AND a.ProductId IN (SELECT ProductId FROM tmp_product)
       AND IFNULL(b.BookId, '') != ''
     GROUP BY b.BookId
)
,tmp_30_day_spend AS (
    SELECT b.BookId      AS book_id
          ,SUM(Spend)    AS 30_day_spend
      FROM ods.ods_tidb_sharpengine_ads_global_FbAdDailyInsight a
      LEFT JOIN ods.ods_tidb_sharpengine_ads_global_adext b
        ON b.AdId = a.AdId
       AND b.ProductId = a.ProductId
     WHERE a.date_start >= DATE_SUB('${bf_1_dt}', 30)
       AND a.date_start <= '${bf_1_dt}'
       AND a.ProductId IN (SELECT ProductId FROM tmp_product)
       AND IFNULL(b.BookId, '') != ''
     GROUP BY b.BookId
)
,tmp_360_day_spend AS (
    SELECT b.BookId      AS book_id
          ,SUM(Spend)    AS 360_day_spend
      FROM ods.ods_tidb_sharpengine_ads_global_FbAdDailyInsight a
      LEFT JOIN ods.ods_tidb_sharpengine_ads_global_adext b
        ON b.AdId = a.AdId
       AND b.ProductId = a.ProductId
     WHERE a.date_start >= DATE_SUB('${bf_1_dt}', 360)
       AND a.date_start <= '${bf_1_dt}'
       AND a.ProductId IN (SELECT ProductId FROM tmp_product)
       AND IFNULL(b.BookId, '') != ''
     GROUP BY b.BookId
)
-- 广告计划的第3个阶段的时间
,tmp_3_codestage AS (
    SELECT a.CodeId       AS book_id
          ,a.BeginDate    AS begin_date
          ,a.EndDate      AS end_date
      FROM ods.ods_tidb_ad_sharpengine_ads_global_MarketingPlan a
     WHERE ProjectCode = 1
       AND IsDel = 0
       AND CodeStage = 3
       AND SourceChl = 'fb'
)
,tmp_stage3_spend AS (
    SELECT b.BookId AS book_id
          ,SUM(CASE WHEN a.date_start >= c.begin_date AND a.date_start < c.end_date THEN a.Spend
                    ELSE 0
                END
              )     AS stage3_spend
      FROM ods.ods_tidb_sharpengine_ads_global_FbAdDailyInsight a
      LEFT JOIN ods.ods_tidb_sharpengine_ads_global_adext b
        ON b.AdId = a.AdId
       AND b.ProductId = a.ProductId
      LEFT JOIN tmp_3_codestage c
        ON b.BookId = c.book_id
     WHERE a.ProductId IN (SELECT ProductId FROM tmp_product)
       AND IFNULL(b.BookId, '') != ''
     GROUP BY b.BookId
)
SELECT '${bf_1_dt}'
      ,a.id
      ,a.CodeId
      ,a.Code
      ,REGEXP_EXTRACT(a.Code, '^[A-Za-z]+', 0)
      ,CASE WHEN a.CurrentLanguage = 1  THEN '英文'
            WHEN a.CurrentLanguage = 2  THEN '中文'
            WHEN a.CurrentLanguage = 3  THEN '韩文'
            WHEN a.CurrentLanguage = 4  THEN '日文'
            WHEN a.CurrentLanguage = 5  THEN '法文'
            WHEN a.CurrentLanguage = 6  THEN '德文'
            WHEN a.CurrentLanguage = 7  THEN '俄文'
            WHEN a.CurrentLanguage = 8  THEN '阿拉伯文'
            WHEN a.CurrentLanguage = 9  THEN '中文'
            WHEN a.CurrentLanguage = 10 THEN '葡萄牙文'
            WHEN a.CurrentLanguage = 11 THEN '印尼文'
            WHEN a.CurrentLanguage = 12 THEN '土耳其文'
            WHEN a.CurrentLanguage = 13 THEN '俄文'
            WHEN a.CurrentLanguage = 14 THEN '中文'
            WHEN a.CurrentLanguage = 15 THEN '越南文'
            WHEN a.CurrentLanguage = 16 THEN '泰文'
            ELSE ''
        END              AS current_language
      ,a.SourceChl
      ,a.TestStatus
      ,a.CodeLv
      ,a.CodeStage
      ,a.PlanRound
      ,a.BeginDate
      ,a.EndDate
      ,e.bf_1_dt_spend
      ,d.7_day_spend
      ,b.30_day_spend
      ,c.360_day_spend
      ,f.begin_date      AS stage3_date
      ,g.stage3_spend    AS stage3_spend
      ,NOW()
  FROM ods.ods_tidb_ad_sharpengine_ads_global_MarketingPlan    AS a
  LEFT JOIN tmp_30_day_spend                                   AS b
    ON a.CodeId = b.book_id
  LEFT JOIN tmp_360_day_spend                                  AS c
    ON a.CodeId = c.book_id
  LEFT JOIN tmp_7_day_spend                                    AS d
    ON a.CodeId = d.book_id
  LEFT JOIN tmp_bf_1_dt_spend                                  AS e
    ON a.CodeId = e.book_id
  LEFT JOIN tmp_3_codestage                                    AS f
    ON a.CodeId = f.book_id
  LEFT JOIN tmp_stage3_spend                                   AS g
    ON a.CodeId = g.book_id
 WHERE ProjectCode = 1
   AND IsDel = 0
;