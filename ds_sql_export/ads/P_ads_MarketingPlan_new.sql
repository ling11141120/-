----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : ads_MarketingPlan_new
-- workflow_version : 1
-- create_user      : xixg
-- task_name        : ads_MarketingPlan_new
-- task_version     : 1
-- update_time      : 2025-07-22 17:30:54
-- sql_path         : \starrocks\ads_MarketingPlan_new\ads_MarketingPlan_new
----------------------------------------------------------------
-- SQL语句
INSERT INTO ads.ads_MarketingPlan_new
with tmp_product AS (
    select
        distinct ProductId
    from  ods.ods_tidb_sharpengine_ads_global_ProjectProduct_da
    where  ProjectCode = 1
),

tmp_30_day_spend AS (
    select
        b.BookId AS book_id,
        sum(CostAmount) AS 30_day_spend
    from  ods.ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer a
left join ods.ods_tidb_sharpengine_ads_global_adext b
    on b.AdId = a.AdId
    and b.ProductId = a.ProductId
where a.CreateTime >= date_sub('${bf_1_dt}',30)
      and a.CreateTime <= '${bf_1_dt}'
  and a.ProductId in (select ProductId from tmp_product)
      and ifnull(b.BookId, '')!= ''
group by b.BookId
),

tmp_360_day_spend AS (
select
    b.BookId AS book_id,
    sum(CostAmount) AS 360_day_spend
from  ods.ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer a
left join ods.ods_tidb_sharpengine_ads_global_adext b
on b.AdId = a.AdId
    and b.ProductId = a.ProductId
where a.CreateTime >= date_sub('${bf_1_dt}',360)
  and a.CreateTime <= '${bf_1_dt}'
  and a.ProductId in (select ProductId from tmp_product)
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
       b.30_day_spend,
       c.360_day_spend,
       NOW()
FROM ods.ods_tidb_ad_sharpengine_ads_global_MarketingPlan a
LEFT JOIN tmp_30_day_spend b
  ON a.CodeId = b.book_id
LEFT JOIN tmp_360_day_spend c
          ON a.CodeId = c.book_id
WHERE a.ProjectCode = 1
  AND a.IsDel = 0;
