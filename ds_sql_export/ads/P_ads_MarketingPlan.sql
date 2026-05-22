----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_MarketingPlan
-- workflow_version : 11
-- create_user      : xixg
-- task_name        : ads_MarketingPlan
-- task_version     : 11
-- update_time      : 2025-08-05 17:11:48
-- sql_path         : \starrocks\tbl_ads_MarketingPlan\ads_MarketingPlan
----------------------------------------------------------------
-- SQL语句
INSERT INTO ads.ads_MarketingPlan
with tmp_product AS (
    select
        distinct ProductId
    from  ods.ods_tidb_sharpengine_ads_global_ProjectProduct_da
    where  ProjectCode = 1
),

tmp_fbadroiinstallreferrer AS (
    select
        a.AdId,
        a.ProductId,
        a.CreateTime,
        CASE WHEN a.SourceChl = 'fbs2s' THEN 'fb' ELSE a.SourceChl END AS SourceChl,
        a.CostAmount
    FROM ods.ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer a
),

tmp_bf_1_dt_spend AS (
 select
     b.BookId AS book_id,
     a.SourceChl AS source_chl,
     sum(CostAmount) AS bf_1_dt_spend
 from  tmp_fbadroiinstallreferrer a
           left join ods.ods_tidb_sharpengine_ads_global_adext b
                     on b.AdId = a.AdId
                         and b.ProductId = a.ProductId
 where a.CreateTime = '${bf_1_dt}'
   and a.ProductId in (select ProductId from tmp_product)
   and ifnull(b.BookId, '')!= ''
group by b.BookId,a.SourceChl
    ),

tmp_7_day_spend AS (
 select
     b.BookId AS book_id,
     a.SourceChl AS source_chl,
     sum(CostAmount) AS 7_day_spend
 from  tmp_fbadroiinstallreferrer a
           left join ods.ods_tidb_sharpengine_ads_global_adext b
                     on b.AdId = a.AdId
                         and b.ProductId = a.ProductId
 where a.CreateTime >= date_sub('${bf_1_dt}',7)
   and a.CreateTime <= '${bf_1_dt}'
   and a.ProductId in (select ProductId from tmp_product)
   and ifnull(b.BookId, '')!= ''
group by b.BookId,a.SourceChl
    ),

tmp_30_day_spend AS (
 select
     b.BookId AS book_id,
     a.SourceChl AS source_chl,
     sum(CostAmount) AS 30_day_spend
 from  tmp_fbadroiinstallreferrer a
           left join ods.ods_tidb_sharpengine_ads_global_adext b
                     on b.AdId = a.AdId
                         and b.ProductId = a.ProductId
 where a.CreateTime >= date_sub('${bf_1_dt}',30)
   and a.CreateTime <= '${bf_1_dt}'
   and a.ProductId in (select ProductId from tmp_product)
   and ifnull(b.BookId, '')!= ''
group by b.BookId,a.SourceChl
    ),

tmp_360_day_spend AS (
    select
        b.BookId AS book_id,
        a.SourceChl AS source_chl,
        sum(CostAmount) AS 360_day_spend
    from  tmp_fbadroiinstallreferrer a
    left join ods.ods_tidb_sharpengine_ads_global_adext b
            on b.AdId = a.AdId
            and b.ProductId = a.ProductId
    where a.CreateTime >= date_sub('${bf_1_dt}',360)
      and a.CreateTime <= '${bf_1_dt}'
      and a.ProductId in (select ProductId from tmp_product)
      and ifnull(b.BookId, '')!= ''
    group by b.BookId,a.SourceChl
    ),
-- 进入第三阶段的书籍的时间
tmp_3_codestage AS (
SELECT
    a.CodeId as book_id,
    a.SourceChl AS source_chl,
    a.BeginDate as begin_date,
    a.EndDate as end_date
from  ods.ods_tidb_ad_sharpengine_ads_global_MarketingPlan a
where ProjectCode = 1
  AND IsDel = 0
  and CodeStage = 3
),

tmp_stage3_spend AS (
select
    b.BookId AS book_id,
    a.SourceChl AS source_chl,
    sum(CASE WHEN a.CreateTime>=c.begin_date then a.CostAmount else 0 end ) AS stage3_spend
from  tmp_fbadroiinstallreferrer a
    left join ods.ods_tidb_sharpengine_ads_global_adext b
        on b.AdId = a.AdId
        and b.ProductId = a.ProductId
    left join tmp_3_codestage c
        on b.BookId = c.book_id
        and c.source_chl = a.SourceChl
where a.ProductId in (select ProductId from tmp_product)
  and ifnull(b.BookId, '')!= ''
group by b.BookId,a.SourceChl
    )

SELECT
        '${bf_1_dt}',
        a.id,
        a.CodeId,
        a.Code,
        regexp_extract(a.Code, '^[A-Za-z]+', 0),
        CASE
            WHEN a.CurrentLanguage = 1 THEN '简体'
            WHEN a.CurrentLanguage = 2 THEN '繁体'
            WHEN a.CurrentLanguage = 3 THEN '英语'
            WHEN a.CurrentLanguage = 4 THEN '西语'
            WHEN a.CurrentLanguage = 5 THEN '葡语'
            WHEN a.CurrentLanguage = 6 THEN '法语'
            WHEN a.CurrentLanguage = 7 THEN '俄语'
            WHEN a.CurrentLanguage = 8 THEN '意大利语'
            WHEN a.CurrentLanguage = 9 THEN '日语'
            WHEN a.CurrentLanguage = 10 THEN '阿拉伯语'
            WHEN a.CurrentLanguage = 11 THEN '印尼语'
            WHEN a.CurrentLanguage = 12 THEN '泰语'
            WHEN a.CurrentLanguage = 13 THEN '越南语'
            WHEN a.CurrentLanguage = 14 THEN '韩语'
            WHEN a.CurrentLanguage = 15 THEN '菲律宾语'
            WHEN a.CurrentLanguage = 16 THEN '德语'
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
                   AND a.SourceChl = b.source_chl
         LEFT JOIN tmp_360_day_spend c
                   ON a.CodeId = c.book_id
                   AND a.SourceChl = c.source_chl
         LEFT JOIN tmp_7_day_spend d
                   ON a.CodeId = d.book_id
                   AND a.SourceChl = d.source_chl
         LEFT JOIN tmp_bf_1_dt_spend e
                   ON a.CodeId = e.book_id
                   AND a.SourceChl = e.source_chl
          LEFT JOIN tmp_3_codestage f
                   ON a.CodeId = f.book_id
                   AND a.SourceChl = f.source_chl
         LEFT JOIN tmp_stage3_spend g
                   ON a.CodeId = g.book_id
                   AND a.SourceChl = g.source_chl
WHERE ProjectCode = 1
    AND IsDel = 0;
