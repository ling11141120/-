INSERT INTO ads.ads_MarketingPlan_new
with tmp_product as (
    select distinct ProductId
      from ods.ods_tidb_sharpengine_ads_global_ProjectProduct_da
     where ProjectCode = 1
)
,tmp_bf_1_dt_spend as (
    select b.BookId      as book_id
          ,sum(Spend)    as bf_1_dt_spend
      from ods.ods_tidb_sharpengine_ads_global_FbAdDailyInsight    as a
      left join ods.ods_tidb_sharpengine_ads_global_adext          as b
        on b.AdId = a.AdId
       and b.ProductId = a.ProductId
     where a.date_start = '${bf_1_dt}'
       and a.ProductId in (select ProductId from tmp_product)
       and ifnull(b.BookId, '') != ''
     group by b.BookId
)
,tmp_7_day_spend as (
    select b.BookId      as book_id
          ,sum(Spend)    as 7_day_spend
      from ods.ods_tidb_sharpengine_ads_global_FbAdDailyInsight    as a
      left join ods.ods_tidb_sharpengine_ads_global_adext          as b
        on b.AdId = a.AdId
       and b.ProductId = a.ProductId
     where a.date_start >= date_sub('${bf_1_dt}', 7)
       and a.date_start <= '${bf_1_dt}'
       and a.ProductId in (select ProductId from tmp_product)
       and ifnull(b.BookId, '') != ''
     group by b.BookId
)
,tmp_30_day_spend as (
    select b.BookId      as book_id
          ,sum(Spend)    as 30_day_spend
      from ods.ods_tidb_sharpengine_ads_global_FbAdDailyInsight    as a
      left join ods.ods_tidb_sharpengine_ads_global_adext          as b
        on b.AdId = a.AdId
       and b.ProductId = a.ProductId
     where a.date_start >= date_sub('${bf_1_dt}', 30)
       and a.date_start <= '${bf_1_dt}'
       and a.ProductId in (select ProductId from tmp_product)
       and ifnull(b.BookId, '') != ''
     group by b.BookId
)
,tmp_360_day_spend as (
    select b.BookId      as book_id
          ,sum(Spend)    as 360_day_spend
      from ods.ods_tidb_sharpengine_ads_global_FbAdDailyInsight    as a
      left join ods.ods_tidb_sharpengine_ads_global_adext          as b
        on b.AdId = a.AdId
       and b.ProductId = a.ProductId
     where a.date_start >= date_sub('${bf_1_dt}', 360)
       and a.date_start <= '${bf_1_dt}'
       and a.ProductId in (select ProductId from tmp_product)
       and ifnull(b.BookId, '') != ''
     group by b.BookId
)
-- 广告计划的第3个阶段的时间
,tmp_3_codestage as (
    select a.CodeId       as book_id
          ,a.BeginDate    as begin_date
          ,a.EndDate      as end_date
      from ods.ods_tidb_ad_sharpengine_ads_global_MarketingPlan    as a
     where ProjectCode = 1
       and IsDel = 0
       and CodeStage = 3
       and SourceChl = 'fb'
)
,tmp_stage3_spend as (
    select b.BookId as book_id
          ,sum(case when a.date_start >= c.begin_date and a.date_start < c.end_date then a.Spend
                    else 0
                end
              )     as stage3_spend
      from ods.ods_tidb_sharpengine_ads_global_FbAdDailyInsight    as a
      left join ods.ods_tidb_sharpengine_ads_global_adext          as b
        on b.AdId = a.AdId
       and b.ProductId = a.ProductId
      left join tmp_3_codestage                                    as c
        on b.BookId = c.book_id
     where a.ProductId in (select ProductId from tmp_product)
       and ifnull(b.BookId, '') != ''
     group by b.BookId
)
select '${bf_1_dt}'
      ,a.id
      ,a.CodeId
      ,a.Code
      ,regexp_extract(a.Code, '^[A-Za-z]+', 0)
      ,case when a.CurrentLanguage = 1  then '英文'
            when a.CurrentLanguage = 2  then '中文'
            when a.CurrentLanguage = 3  then '韩文'
            when a.CurrentLanguage = 4  then '日文'
            when a.CurrentLanguage = 5  then '法文'
            when a.CurrentLanguage = 6  then '德文'
            when a.CurrentLanguage = 7  then '俄文'
            when a.CurrentLanguage = 8  then '阿拉伯文'
            when a.CurrentLanguage = 9  then '中文'
            when a.CurrentLanguage = 10 then '葡萄牙文'
            when a.CurrentLanguage = 11 then '印尼文'
            when a.CurrentLanguage = 12 then '土耳其文'
            when a.CurrentLanguage = 13 then '俄文'
            when a.CurrentLanguage = 14 then '中文'
            when a.CurrentLanguage = 15 then '越南文'
            when a.CurrentLanguage = 16 then '泰文'
            else ''
        end              as current_language
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
      ,f.begin_date      as stage3_date
      ,g.stage3_spend    as stage3_spend
      ,now()
  from ods.ods_tidb_ad_sharpengine_ads_global_MarketingPlan    as a
  left join tmp_30_day_spend                                   as b
    on a.CodeId = b.book_id
  left join tmp_360_day_spend                                  as c
    on a.CodeId = c.book_id
  left join tmp_7_day_spend                                    as d
    on a.CodeId = d.book_id
  left join tmp_bf_1_dt_spend                                  as e
    on a.CodeId = e.book_id
  left join tmp_3_codestage                                    as f
    on a.CodeId = f.book_id
  left join tmp_stage3_spend                                   as g
    on a.CodeId = g.book_id
 where ProjectCode = 1
   and IsDel = 0
;