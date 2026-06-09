----------------------------------------------------------------
-- 程序功能： 财务推广对账
-- 程序名： P_ads_ad_finance_promotion_reconciliation
-- 目标表： ads.ads_ad_finance_promotion_reconciliation
-- 负责人： xjc
-- 开发日期： 2026-06-09
----------------------------------------------------------------

insert overwrite ads.ads_ad_finance_promotion_reconciliation
with fb_account as (
    -- FbAccount
    select b.dt
         , a.level2
         , a.fb_account
         , b.country
         , b.company_id
         , b.ad_optimizer_uid
         , max(a.account_source)  as account_source
         , max(a.fb_account_name) as fb_account_name
         , max(a.product_id)      as product_id
         , max(a.mt)              as mt
         , max(a.core)            as core
         , sum(b.spend)           as spend
         , max(b.ads_optimizer)   as ads_optimizer
      from (select 0                  as account_source
                 , a.Account          as fb_account
                 , max(a.ProductName) as fb_account_name
                 , max(b.AgentId)     as level2
                 , max(a.ProductId)   as product_id
                 , max(a.Mt)          as mt
                 , max(a.Core)        as core
              from dim.dim_FbAccount_view a
              join (select Account
                         , AgentId
                      from ods.ods_ads_tidb_sharpengine_ads_global_AdAccountAgentRelation
                     where Level = 2
                   ) b
                on a.Account = b.Account
             group by a.Account
           ) a
      join (select a.id
                 , a.ad_id
                 , a.ad_set_id
                 , a.spend
                 , date(a.date_start)                                                         as dt
                 , a.country
                 , a.fb_account_id
                 , if(a.date_start >= b.BeginTime and a.date_start <= b.EndTime, b.CompanyId, 0) as company_id
                 , c.ad_optimizer_uid
                 , c.ads_optimizer
              from (select *
                      from dwd.dwd_advertisement_fbad_country_daily_insight_view
                   ) a
              left join ods.ods_ads_tidb_sharpengine_ads_global_CompanyInfoAccountMap b
                on a.fb_account_id = b.Account
              left join dwd.dwd_advertisement_adext_view c
                on a.ad_id = c.ad_id
             where if(a.date_start >= b.BeginTime and a.date_start <= b.EndTime, b.CompanyId, 0) > 0
           ) b
        on a.fb_account = b.fb_account_id
     group by b.dt
            , a.level2
            , a.fb_account
            , b.country
            , b.company_id
            , b.ad_optimizer_uid
)
, ads_account as (
    -- AdsAccount
    select c.dt
         , a.level2
         , a.fb_account
         , c.country
         , c.company_id
         , c.ad_optimizer_uid
         , max(a.account_source)  as account_source
         , max(a.fb_account_name) as fb_account_name
         , max(a.product_id)      as product_id
         , max(a.mt)              as mt
         , max(a.core)            as core
         , sum(c.spend)           as spend
         , max(c.ads_optimizer)   as ads_optimizer
      from (select 1                  as account_source
                 , a.Account          as fb_account
                 , max(a.ProductName) as fb_account_name
                 , max(b.AgentId)     as level2
                 , max(a.ProductId)   as product_id
                 , max(a.Mt)          as mt
                 , max(a.Core)        as core
              from ods.ods_tidb_sharpengine_ads_global_adsaccount a
              join (select Account
                         , AgentId
                      from ods.ods_ads_tidb_sharpengine_ads_global_AdAccountAgentRelation
                     where Level = 2
                   ) b
                on a.Account = b.Account
             group by a.Account
           ) a
      join ods.ods_ads_tidb_sharpengine_ads_global_AdsAdGroup b
        on a.fb_account = b.Account
      join (select a.id
                 , a.ad_id
                 , a.ad_set_id
                 , a.spend
                 , date(a.date_start)                                                         as dt
                 , a.country
                 , a.account
                 , if(a.date_start >= b.BeginTime and a.date_start <= b.EndTime, b.CompanyId, 0) as company_id
                 , c.ad_optimizer_uid
                 , c.ads_optimizer
              from (select *
                      from dwd.dwd_advertisement_ltv_country_daily_insight_view
                   ) a
              left join ods.ods_ads_tidb_sharpengine_ads_global_CompanyInfoAccountMap b
                on a.Account = b.Account
              left join dwd.dwd_advertisement_adext_view c
                on a.ad_id = c.ad_id
             where if(a.date_start >= b.BeginTime and a.date_start <= b.EndTime, b.CompanyId, 0) > 0
           ) c
        on b.AdGroupId = c.ad_id
     group by c.dt
            , a.level2
            , a.fb_account
            , c.country
            , c.company_id
            , c.ad_optimizer_uid
)
, tiktok_ads_account as (
    -- TiktokAdsAccount
    select c.dt
         , a.level2
         , a.fb_account
         , c.country
         , c.company_id
         , c.ad_optimizer_uid
         , max(a.account_source)  as account_source
         , max(a.fb_account_name) as fb_account_name
         , max(a.product_id)      as product_id
         , max(a.mt)              as mt
         , max(a.core)            as core
         , sum(c.spend)           as spend
         , max(c.ads_optimizer)   as ads_optimizer
      from (select 2                  as account_source
                 , a.Account          as fb_account
                 , max(a.ProductName) as fb_account_name
                 , max(b.AgentId)     as level2
                 , max(a.ProductId)   as product_id
                 , max(a.Mt)          as mt
                 , max(a.Core)        as core
              from ods.ods_tidb_sharpengine_ads_global_TiktokAdsAccount a
              join (select Account
                         , AgentId
                      from ods.ods_ads_tidb_sharpengine_ads_global_AdAccountAgentRelation
                     where Level = 2
                   ) b
                on a.Account = b.Account
--        left join ods.ods_ads_tidb_sharpengine_ads_global_AdAccountAgent c on b.AgentId = c.Id
             group by a.Account
           ) a
      join ods.ods_tidb_sharpengine_ads_global_TiktokAd b
        on a.fb_account = b.FbAccount
      join (select a.id
                 , a.ad_id
                 , a.ad_set_id
                 , a.spend
                 , date(a.date_start)                                                         as dt
                 , a.country
                 , a.account
                 , if(a.date_start >= b.BeginTime and a.date_start <= b.EndTime, b.CompanyId, 0) as company_id
                 , c.ad_optimizer_uid
                 , c.ads_optimizer
              from (select *
                      from dwd.dwd_advertisement_ltv_country_daily_insight_view
                   ) a
              left join ods.ods_ads_tidb_sharpengine_ads_global_CompanyInfoAccountMap b
                on a.Account = b.Account
              left join dwd.dwd_advertisement_adext_view c
                on a.ad_id = c.ad_id
             where if(a.date_start >= b.BeginTime and a.date_start <= b.EndTime, b.CompanyId, 0) > 0
           ) c
        on b.AdId = c.ad_id
     group by c.dt
            , a.level2
            , a.fb_account
            , c.country
            , c.company_id
            , c.ad_optimizer_uid
)
, third_ad_account_not4 as (
    -- ThirdAdAccount !=4
    select c.dt
         , a.level2
         , a.fb_account
         , c.country
         , c.company_id
         , c.ad_optimizer_uid
         , max(a.account_source)  as account_source
         , max(a.fb_account_name) as fb_account_name
         , max(a.product_id)      as product_id
         , max(a.mt)              as mt
         , max(a.core)            as core
         , sum(c.spend)           as spend
         , max(c.ads_optimizer)   as ads_optimizer
      from (select 3                   as account_source
                 , a.account           as fb_account
                 , max(a.product_name) as fb_account_name
                 , max(b.AgentId)      as level2
                 , max(a.product_id)   as product_id
                 , max(a.mt)           as mt
                 , max(a.core)         as core
              from (select account
                         , product_name
                         , product_id
                         , mt
                         , core
                      from dim.dim_advertisement_third_ad_account_view
                     where ad_platform_id != 4
                   ) a
              join (select Account
                         , AgentId
                      from ods.ods_ads_tidb_sharpengine_ads_global_AdAccountAgentRelation
                     where Level = 2
                   ) b
                on a.account = b.Account
             group by a.account
           ) a
      join dim.dim_ads_thirdadset_view b
        on a.fb_account = b.fb_account
      join (select a.id
                 , a.ad_id
                 , a.adset_id
                 , a.spend
                 , date(a.date_start)                                                         as dt
                 , a.country
                 , a.account
                 , if(a.date_start >= b.BeginTime and a.date_start <= b.EndTime, b.CompanyId, 0) as company_id
                 , c.ad_optimizer_uid
                 , c.ads_optimizer
              from (select *
                      from dwd.dwd_advertisement_ltv_daily_insight_view
                   ) a
              left join ods.ods_ads_tidb_sharpengine_ads_global_CompanyInfoAccountMap b
                on a.Account = b.Account
              left join dwd.dwd_advertisement_adext_view c
                on a.ad_id = c.ad_id
             where if(a.date_start >= b.BeginTime and a.date_start <= b.EndTime, b.CompanyId, 0) > 0
           ) c
        on b.adset_id = c.adset_id
     group by c.dt
            , a.level2
            , a.fb_account
            , c.country
            , c.company_id
            , c.ad_optimizer_uid
            , b.adset_id
)
, third_ad_account_is4 as (
    -- ThirdAdAccount =4
    select c.dt
         , a.level2
         , a.fb_account
         , c.country
         , c.company_id
         , c.ad_optimizer_uid
         , max(a.account_source)  as account_source
         , max(a.fb_account_name) as fb_account_name
         , max(a.product_id)      as product_id
         , max(a.mt)              as mt
         , max(a.core)            as core
         , sum(c.spend)           as spend
         , max(c.ads_optimizer)   as ads_optimizer
      from (select 5                   as account_source
                 , a.account           as fb_account
                 , max(a.product_name) as fb_account_name
                 , max(b.AgentId)      as level2
                 , max(a.product_id)   as product_id
                 , max(a.mt)           as mt
                 , max(a.core)         as core
              from (select account
                         , product_name
                         , product_id
                         , mt
                         , core
                      from dim.dim_advertisement_third_ad_account_view
                     where ad_platform_id = 4
                   ) a
              join (select Account
                         , AgentId
                      from ods.ods_ads_tidb_sharpengine_ads_global_AdAccountAgentRelation
                     where Level = 2
                   ) b
                on a.account = b.Account
             group by a.account
           ) a
      join dim.dim_ads_thirdadset_view b
        on a.fb_account = b.fb_account
      join (select a.id
                 , a.ad_id
                 , a.ad_set_id
                 , a.spend
                 , date(a.date_start)                                                         as dt
                 , a.country
                 , a.account
                 , if(a.date_start >= b.BeginTime and a.date_start <= b.EndTime, b.CompanyId, 0) as company_id
                 , c.ad_optimizer_uid
                 , c.ads_optimizer
              from (select *
                      from dwd.dwd_advertisement_ltv_country_daily_insight_view
                   ) a
              left join ods.ods_ads_tidb_sharpengine_ads_global_CompanyInfoAccountMap b
                on a.Account = b.Account
              left join dwd.dwd_advertisement_adext_view c
                on a.ad_id = c.ad_id
             where if(a.date_start >= b.BeginTime and a.date_start <= b.EndTime, b.CompanyId, 0) > 0
           ) c
        on b.adset_id = c.ad_id
     group by c.dt
            , a.level2
            , a.fb_account
            , c.country
            , c.company_id
            , c.ad_optimizer_uid
)
select a.dt
     , a.level2
     , b.Name as level2_name
     , a.fb_account
     , a.country
     , a.company_id
     , c.CompanyName
     , a.account_source
     , case when a.account_source = 0 then 'Facebook'
            when a.account_source = 1 then 'adwords'
            when a.account_source = 2 then 'TikTok'
            when a.account_source = 3 then 'Appleadservice'
            when a.account_source = 5 then 'kwai'
        end as account_source_name
     , a.fb_account_name
     , a.product_id
     , a.mt
     , a.core
     , a.spend
     , a.ad_optimizer_uid
     , d.NickName
     , now() as etl_time
  from (select *
          from fb_account
         union all
        select *
          from ads_account
         union all
        select *
          from tiktok_ads_account
         union all
        select *
          from third_ad_account_not4
         union all
        select *
          from third_ad_account_is4
       ) a
  left join ods.ods_ads_tidb_sharpengine_ads_global_AdAccountAgent b
    on a.level2 = b.Id
  left join ods.ods_ads_tidb_sharpengine_ads_global_CompanyInfo c
    on a.company_id = c.Id
  left join ods.ods_tidb_sharpengine_kpi_b_userinfo_tb d
    on a.ad_optimizer_uid = d.Account
   and NickName not like '%离职%'
   and Delflag = 0
   and DingUserId is not null
 where company_id > 0
;
