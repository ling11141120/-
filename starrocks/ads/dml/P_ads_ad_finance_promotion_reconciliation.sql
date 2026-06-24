----------------------------------------------------------------
-- 程序功能： 财务推广对账
-- 程序名： P_ads_ad_finance_promotion_reconciliation
-- 目标表： ads.ads_ad_finance_promotion_reconciliation
-- 负责人： xjc
-- 开发日期： 2026-06-09
----------------------------------------------------------------

delete from ads.ads_ad_finance_promotion_reconciliation
 where dt >= '${bf_1_month_1_dt}' and dt< '${af_1_month_dt}';

insert into ads.ads_ad_finance_promotion_reconciliation
with fb_account as (
    -- FbAccount
    select a2.dt
         , a1.level2
         , a1.fb_account
         , a2.country
         , a2.company_id
         , a2.ad_optimizer_uid
         , max(a1.account_source)  as account_source
         , max(a1.fb_account_name) as fb_account_name
         , max(a1.product_id)      as product_id
         , max(a1.mt)              as mt
         , max(a1.core)            as core
         , sum(a2.spend)           as spend
         , max(a2.ads_optimizer)   as ads_optimizer
      from (select 0                   as account_source
                 , b1.Account          as fb_account
                 , max(b1.ProductName) as fb_account_name
                 , max(b2.AgentId)     as level2
                 , max(b1.ProductId)   as product_id
                 , max(b1.Mt)          as mt
                 , max(b1.Core)        as core
              from dim.dim_FbAccount_view  as b1
              join (select Account
                         , AgentId
                      from ods.ods_ads_tidb_sharpengine_ads_global_AdAccountAgentRelation
                     where Level = 2
                   )                       as b2
                on b1.Account = b2.Account
             group by b1.Account
           )    as a1
      join (select b1.id
                 , b1.ad_id
                 , b1.ad_set_id
                 , b1.spend
                 , date(b1.date_start)    as dt
                 , b1.country
                 , b1.fb_account_id
                 , if(b1.date_start >= b2.BeginTime and b1.date_start <= b2.EndTime
                     , b2.CompanyId
                     , 0
                     )                    as company_id
                 , b3.ad_optimizer_uid
                 , b3.ads_optimizer
              from (select *
                      from dwd.dwd_advertisement_fbad_country_daily_insight_view
                     where date_start >= date_sub(date_trunc('month', '${dt}'), interval 1 month)
                       and date_start < date_add(date_trunc('month', '${dt}'), interval 1 month)
                   )                                                                    as b1
              left join ods.ods_ads_tidb_sharpengine_ads_global_CompanyInfoAccountMap   as b2
                on b1.fb_account_id = b2.Account
              left join dwd.dwd_advertisement_adext_view                                as b3
                on b1.ad_id = b3.ad_id
             where if(b1.date_start >= b2.BeginTime and b1.date_start <= b2.EndTime, b2.CompanyId, 0) > 0
           )    as a2
        on a1.fb_account = a2.fb_account_id
     group by a2.dt
            , a1.level2
            , a1.fb_account
            , a2.country
            , a2.company_id
            , a2.ad_optimizer_uid
)
, ads_account as (
    -- AdsAccount
    select a3.dt
         , a1.level2
         , a1.fb_account
         , a3.country
         , a3.company_id
         , a3.ad_optimizer_uid
         , max(a1.account_source)  as account_source
         , max(a1.fb_account_name) as fb_account_name
         , max(a1.product_id)      as product_id
         , max(a1.mt)              as mt
         , max(a1.core)            as core
         , sum(a3.spend)           as spend
         , max(a3.ads_optimizer)   as ads_optimizer
      from (select 1                   as account_source
                 , b1.Account          as fb_account
                 , max(b1.ProductName) as fb_account_name
                 , max(b2.AgentId)     as level2
                 , max(b1.ProductId)   as product_id
                 , max(b1.Mt)          as mt
                 , max(b1.Core)        as core
              from ods.ods_tidb_sharpengine_ads_global_adsaccount as b1
              join (select Account
                         , AgentId
                      from ods.ods_ads_tidb_sharpengine_ads_global_AdAccountAgentRelation
                     where Level = 2
                   )                                              as b2
                on b1.Account = b2.Account
             group by b1.Account
           )    as a1
      join ods.ods_ads_tidb_sharpengine_ads_global_AdsAdGroup as a2
        on a1.fb_account = a2.Account
      join (select b1.id
                 , b1.ad_id
                 , b1.ad_set_id
                 , b1.spend
                 , date(b1.date_start)    as dt
                 , b1.country
                 , b1.account
                 , if(b1.date_start >= b2.BeginTime and b1.date_start <= b2.EndTime, b2.CompanyId, 0) as company_id
                 , b3.ad_optimizer_uid
                 , b3.ads_optimizer
              from (select *
                      from dwd.dwd_advertisement_ltv_country_daily_insight_view
                     where date_start >= date_sub(date_trunc('month', '${dt}'), interval 1 month)
                       and date_start < date_add(date_trunc('month', '${dt}'), interval 1 month)
                   )                                                                    as b1
              left join ods.ods_ads_tidb_sharpengine_ads_global_CompanyInfoAccountMap   as b2
                on b1.Account = b2.Account
              left join dwd.dwd_advertisement_adext_view                                as b3
                on b1.ad_id = b3.ad_id
             where if(b1.date_start >= b2.BeginTime and b1.date_start <= b2.EndTime, b2.CompanyId, 0) > 0
           )     as a3
        on a2.AdGroupId = a3.ad_id
     group by a3.dt
            , a1.level2
            , a1.fb_account
            , a3.country
            , a3.company_id
            , a3.ad_optimizer_uid
)
, tiktok_ads_account as (
    -- TiktokAdsAccount
    select a3.dt
         , a1.level2
         , a1.fb_account
         , a3.country
         , a3.company_id
         , a3.ad_optimizer_uid
         , max(a1.account_source)  as account_source
         , max(a1.fb_account_name) as fb_account_name
         , max(a1.product_id)      as product_id
         , max(a1.mt)              as mt
         , max(a1.core)            as core
         , sum(a3.spend)           as spend
         , max(a3.ads_optimizer)   as ads_optimizer
      from (select 2                   as account_source
                 , b1.Account          as fb_account
                 , max(b1.ProductName) as fb_account_name
                 , max(b2.AgentId)     as level2
                 , max(b1.ProductId)   as product_id
                 , max(b1.Mt)          as mt
                 , max(b1.Core)        as core
              from ods.ods_tidb_sharpengine_ads_global_TiktokAdsAccount as b1
              join (select Account
                         , AgentId
                      from ods.ods_ads_tidb_sharpengine_ads_global_AdAccountAgentRelation
                     where Level = 2
                   )                                                    as b2
                on b1.Account = b2.Account
--        left join ods.ods_ads_tidb_sharpengine_ads_global_AdAccountAgent b3 on b2.AgentId = b3.Id
             group by b1.Account
           ) as a1
      join ods.ods_tidb_sharpengine_ads_global_TiktokAd as a2
        on a1.fb_account = a2.FbAccount
      join (select b1.id
                 , b1.ad_id
                 , b1.ad_set_id
                 , b1.spend
                 , date(b1.date_start)    as dt
                 , b1.country
                 , b1.account
                 , if(b1.date_start >= b2.BeginTime and b1.date_start <= b2.EndTime, b2.CompanyId, 0) as company_id
                 , b3.ad_optimizer_uid
                 , b3.ads_optimizer
              from (select *
                      from dwd.dwd_advertisement_ltv_country_daily_insight_view
                     where date_start >= date_sub(date_trunc('month', '${dt}'), interval 1 month)
                       and date_start < date_add(date_trunc('month', '${dt}'), interval 1 month)
                   )                                                                    as b1
              left join ods.ods_ads_tidb_sharpengine_ads_global_CompanyInfoAccountMap   as b2
                on b1.Account = b2.Account
              left join dwd.dwd_advertisement_adext_view                                as b3
                on b1.ad_id = b3.ad_id
             where if(b1.date_start >= b2.BeginTime and b1.date_start <= b2.EndTime, b2.CompanyId, 0) > 0
           )     as a3
        on a2.AdId = a3.ad_id
     group by a3.dt
            , a1.level2
            , a1.fb_account
            , a3.country
            , a3.company_id
            , a3.ad_optimizer_uid
)
, third_ad_account_not4 as (
    -- ThirdAdAccount !=4
    select a3.dt
         , a1.level2
         , a1.fb_account
         , a3.country
         , a3.company_id
         , a3.ad_optimizer_uid
         , max(a1.account_source)  as account_source
         , max(a1.fb_account_name) as fb_account_name
         , max(a1.product_id)      as product_id
         , max(a1.mt)              as mt
         , max(a1.core)            as core
         , sum(a3.spend)           as spend
         , max(a3.ads_optimizer)   as ads_optimizer
      from (select 3                    as account_source
                 , b1.account           as fb_account
                 , max(b1.product_name) as fb_account_name
                 , max(b2.AgentId)      as level2
                 , max(b1.product_id)   as product_id
                 , max(b1.mt)           as mt
                 , max(b1.core)         as core
              from (select account
                         , product_name
                         , product_id
                         , mt
                         , core
                      from dim.dim_advertisement_third_ad_account_view
                     where ad_platform_id != 4
                   ) as b1
              join (select Account
                         , AgentId
                      from ods.ods_ads_tidb_sharpengine_ads_global_AdAccountAgentRelation
                     where Level = 2
                   ) as b2
                on b1.account = b2.Account
             group by b1.account
           ) as a1
      join dim.dim_ads_thirdadset_view as a2
        on a1.fb_account = a2.fb_account
      join (select b1.id
                 , b1.ad_id
                 , b1.adset_id
                 , b1.spend
                 , date(b1.date_start)    as dt
                 , b1.country
                 , b1.account
                 , if(b1.date_start >= b2.BeginTime and b1.date_start <= b2.EndTime, b2.CompanyId, 0) as company_id
                 , b3.ad_optimizer_uid
                 , b3.ads_optimizer
              from (select *
                      from dwd.dwd_advertisement_ltv_daily_insight_view
                     where date_start >= date_sub(date_trunc('month', '${dt}'), interval 1 month)
                       and date_start < date_add(date_trunc('month', '${dt}'), interval 1 month)
                   )                                                                    as b1
              left join ods.ods_ads_tidb_sharpengine_ads_global_CompanyInfoAccountMap   as b2
                on b1.Account = b2.Account
              left join dwd.dwd_advertisement_adext_view                                as b3
                on b1.ad_id = b3.ad_id
             where if(b1.date_start >= b2.BeginTime and b1.date_start <= b2.EndTime, b2.CompanyId, 0) > 0
           )     as a3
        on a2.adset_id = a3.adset_id
     group by a3.dt
            , a1.level2
            , a1.fb_account
            , a3.country
            , a3.company_id
            , a3.ad_optimizer_uid
            , a2.adset_id
)
, third_ad_account_is4 as (
    -- ThirdAdAccount =4
    select a3.dt
         , a1.level2
         , a1.fb_account
         , a3.country
         , a3.company_id
         , a3.ad_optimizer_uid
         , max(a1.account_source)  as account_source
         , max(a1.fb_account_name) as fb_account_name
         , max(a1.product_id)      as product_id
         , max(a1.mt)              as mt
         , max(a1.core)            as core
         , sum(a3.spend)           as spend
         , max(a3.ads_optimizer)   as ads_optimizer
      from (select 5                    as account_source
                 , b1.account           as fb_account
                 , max(b1.product_name) as fb_account_name
                 , max(b2.AgentId)      as level2
                 , max(b1.product_id)   as product_id
                 , max(b1.mt)           as mt
                 , max(b1.core)         as core
              from (select account
                         , product_name
                         , product_id
                         , mt
                         , core
                      from dim.dim_advertisement_third_ad_account_view
                     where ad_platform_id = 4
                   ) as b1
              join (select Account
                         , AgentId
                      from ods.ods_ads_tidb_sharpengine_ads_global_AdAccountAgentRelation
                     where Level = 2
                   ) as b2
                on b1.account = b2.Account
             group by b1.account
           ) as a1
      join dim.dim_ads_thirdadset_view as a2
        on a1.fb_account = a2.fb_account
      join (select b1.id
                 , b1.ad_id
                 , b1.ad_set_id
                 , b1.spend
                 , date(b1.date_start)                                                                as dt
                 , b1.country
                 , b1.account
                 , if(b1.date_start >= b2.BeginTime and b1.date_start <= b2.EndTime, b2.CompanyId, 0) as company_id
                 , b3.ad_optimizer_uid
                 , b3.ads_optimizer
              from (select *
                      from dwd.dwd_advertisement_ltv_country_daily_insight_view
                     where date_start >= date_sub(date_trunc('month', '${dt}'), interval 1 month)
                       and date_start < date_add(date_trunc('month', '${dt}'), interval 1 month)
                   )                                                                    as b1
              left join ods.ods_ads_tidb_sharpengine_ads_global_CompanyInfoAccountMap   as b2
                on b1.Account = b2.Account
              left join dwd.dwd_advertisement_adext_view                                as b3
                on b1.ad_id = b3.ad_id
             where if(b1.date_start >= b2.BeginTime and b1.date_start <= b2.EndTime, b2.CompanyId, 0) > 0
           )    as a3
        on a2.adset_id = a3.ad_id
     group by a3.dt
            , a1.level2
            , a1.fb_account
            , a3.country
            , a3.company_id
            , a3.ad_optimizer_uid
)
, base_result as (
    select *
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
)
, relation_history as (
    select a1.id
         , a1.account_source
         , a1.account
         , a1.agent_id
         , a1.begin_date
         , a1.end_date
      from (select id
                 , account_source
                 , account
                 , agent_id
                 , begin_date
                 , end_date
                 , row_number() over ( partition by account_source, account, begin_date, end_date order by id desc ) as rn
              from dim.dim_ad_account_agent_relation_history_view
           ) as a1
     where a1.rn = 1
)
, result_with_history as (
    select a1.dt
         , coalesce(a2.agent_id, a1.level2) as level2
         , a1.fb_account
         , a1.country
         , a1.company_id
         , a1.ad_optimizer_uid
         , a1.account_source
         , a1.fb_account_name
         , a1.product_id
         , a1.mt
         , a1.core
         , a1.spend
         , a1.ads_optimizer
      from base_result as a1
      left join relation_history as a2
        on a1.account_source = a2.account_source
       and a1.fb_account = a2.account
       and a1.dt >= a2.begin_date
       and a1.dt <= a2.end_date
)
select a1.dt
     , a1.level2
     , a2.Name             as level2_name
     , a1.fb_account
     , a1.country
     , a1.company_id
     , a3.CompanyName
     , a1.account_source
     , case when a1.account_source = 0 then 'Facebook'
            when a1.account_source = 1 then 'adwords'
            when a1.account_source = 2 then 'TikTok'
            when a1.account_source = 3 then 'Appleadservice'
            when a1.account_source = 5 then 'kwai'
        end                as account_source_name
     , a1.fb_account_name
     , a1.product_id
     , a1.mt
     , a1.core
     , a1.spend
     , a1.ad_optimizer_uid
     , a4.NickName
     , now()               as etl_time
  from result_with_history as a1
  left join ods.ods_ads_tidb_sharpengine_ads_global_AdAccountAgent as a2
    on a1.level2 = a2.Id
  left join ods.ods_ads_tidb_sharpengine_ads_global_CompanyInfo as a3
    on a1.company_id = a3.Id
  left join ods.ods_tidb_sharpengine_kpi_b_userinfo_tb as a4
    on a1.ad_optimizer_uid = a4.Account
   and NickName not like '%离职%'
   and Delflag = 0
   and DingUserId is not null
 where company_id > 0
   and (a2.Name is null or trim(a2.Name) <> 'Click Tech Limited')
;
