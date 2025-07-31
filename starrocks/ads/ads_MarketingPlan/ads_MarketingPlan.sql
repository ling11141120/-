INSERT INTO ads.ads_MarketingPlan
with tmp_product AS (
    select
        distinct ProductId
    from  ods.ods_tidb_sharpengine_ads_global_ProjectProduct_da
    where  ProjectCode = 1
),

tmp_bf_1_dt_spend AS (
 select
     b.BookId AS book_id,
     sum(Spend) AS bf_1_dt_spend
 from  ods.ods_tidb_sharpengine_ads_global_FbAdDailyInsight a
           left join ods.ods_tidb_sharpengine_ads_global_adext b
                     on b.AdId = a.AdId
                         and b.ProductId = a.ProductId
 where a.date_start = '${bf_1_dt}'
   and a.ProductId in (select ProductId from tmp_product)
   and ifnull(b.BookId, '')!= ''
group by b.BookId
),

tmp_7_day_spend AS (
 select
     b.BookId AS book_id,
     sum(Spend) AS 7_day_spend
 from  ods.ods_tidb_sharpengine_ads_global_FbAdDailyInsight a
           left join ods.ods_tidb_sharpengine_ads_global_adext b
                     on b.AdId = a.AdId
                         and b.ProductId = a.ProductId
 where a.date_start >= date_sub('${bf_1_dt}',7)
   and a.date_start <= '${bf_1_dt}'
   and a.ProductId in (select ProductId from tmp_product)
   and ifnull(b.BookId, '')!= ''
group by b.BookId
),


tmp_30_day_spend AS (
 select
     b.BookId AS book_id,
     sum(Spend) AS 30_day_spend
 from  ods.ods_tidb_sharpengine_ads_global_FbAdDailyInsight a
           left join ods.ods_tidb_sharpengine_ads_global_adext b
                     on b.AdId = a.AdId
                         and b.ProductId = a.ProductId
 where a.date_start >= date_sub('${bf_1_dt}',30)
   and a.date_start <= '${bf_1_dt}'
   and a.ProductId in (select ProductId from tmp_product)
   and ifnull(b.BookId, '')!= ''
group by b.BookId
),

tmp_360_day_spend AS (
    select
        b.BookId AS book_id,
        sum(Spend) AS 360_day_spend
    from  ods.ods_tidb_sharpengine_ads_global_FbAdDailyInsight a
    left join ods.ods_tidb_sharpengine_ads_global_adext b
            on b.AdId = a.AdId
            and b.ProductId = a.ProductId
    where a.date_start >= date_sub('${bf_1_dt}',360)
      and a.date_start <= '${bf_1_dt}'
      and a.ProductId in (select ProductId from tmp_product)
      and ifnull(b.BookId, '')!= ''
    group by b.BookId
),
-- ½øÈëµÚÈı½×¶ÎµÄÊé¼®µÄÊ±¼ä
tmp_3_codestage AS (
SELECT
    a.CodeId as book_id,
    a.BeginDate as begin_date,
    a.EndDate as end_date
from  ods.ods_tidb_ad_sharpengine_ads_global_MarketingPlan a
where ProjectCode = 1
  AND IsDel = 0
  and CodeStage = 3
  and SourceChl = 'fb'
),

tmp_stage3_spend AS (
select
    b.BookId AS book_id,
    sum(CASE WHEN a.date_start>=c.begin_date and a.date_start<c.end_date then a.Spend else 0 end ) AS stage3_spend
from  ods.ods_tidb_sharpengine_ads_global_FbAdDailyInsight a
    left join ods.ods_tidb_sharpengine_ads_global_adext b
        on b.AdId = a.AdId
        and b.ProductId = a.ProductId
    left join tmp_3_codestage c
        on b.BookId = c.book_id
where a.ProductId in (select ProductId from tmp_product)
  and ifnull(b.BookId, '')!= ''
group by b.BookId
)

SELECT
        '${bf_1_dt}',
        a.id,
        a.CodeId,
        a.Code,
        regexp_extract(a.Code, '^[A-Za-z]+', 0),
        CASE
            WHEN a.CurrentLanguage = 1 THEN '¼òÌå'
            WHEN a.CurrentLanguage = 2 THEN '·±Ìå'
            WHEN a.CurrentLanguage = 3 THEN 'Ó¢Óï'
            WHEN a.CurrentLanguage = 4 THEN 'Î÷Óï'
            WHEN a.CurrentLanguage = 5 THEN 'ÆÏÓï'
            WHEN a.CurrentLanguage = 6 THEN '·¨Óï'
            WHEN a.CurrentLanguage = 7 THEN '¶íÓï'
            WHEN a.CurrentLanguage = 8 THEN 'Òâ´óÀûÓï'
            WHEN a.CurrentLanguage = 9 THEN 'ÈÕÓï'
            WHEN a.CurrentLanguage = 10 THEN '°¢À­²®Óï'
            WHEN a.CurrentLanguage = 11 THEN 'Ó¡ÄáÓï'
            WHEN a.CurrentLanguage = 12 THEN 'Ì©Óï'
            WHEN a.CurrentLanguage = 13 THEN 'Ô½ÄÏÓï'
            WHEN a.CurrentLanguage = 14 THEN 'º«Óï'
            WHEN a.CurrentLanguage = 15 THEN '·ÆÂÉ±öÓï'
            WHEN a.CurrentLanguage = 16 THEN 'µÂÓï'
            ELSE  ''
            END AS current_language,
        a.SourceChl,
        a.TestStatus,
        a.CodeLv,
        a.CodeStage,
        a.PlanRound,
        a.BeginDate,
        a.EndDate,
        e.bf_1_dt_spend,
        d.7_day_spend,
        b.30_day_spend,
        c.360_day_spend,
        f.begin_date AS stage3_date,
        g.stage3_spend AS stage3_spend,
        NOW()
FROM ods.ods_tidb_ad_sharpengine_ads_global_MarketingPlan a
         LEFT JOIN tmp_30_day_spend b
                   ON a.CodeId = b.book_id
         LEFT JOIN tmp_360_day_spend c
                   ON a.CodeId = c.book_id
         LEFT JOIN tmp_7_day_spend d
                   ON a.CodeId = d.book_id
         LEFT JOIN tmp_bf_1_dt_spend e
                   ON a.CodeId = e.book_id
          LEFT JOIN tmp_3_codestage f
                   ON a.CodeId = f.book_id
         LEFT JOIN tmp_stage3_spend g
                   ON a.CodeId = g.book_id
WHERE ProjectCode = 1
    AND IsDel = 0;
