----------------------------------------------------------------
-- 程序功能： admob广告收入事实表
-- 程序名： P_dwd_advertisement_admob_income
-- 目标表： dwd.dwd_advertisement_admob_income
-- 负责人： qhr
-- 开发日期： 
----------------------------------------------------------------

insert into dwd.dwd_advertisement_admob_income
select date(a.DATE)                       as dt
      ,a.Id                               as id
      ,1                                  as time_types
      ,a.AD_UNIT                          as ad_unit
      ,a.PLATFORM                         as plat_form
      ,a.AD_SOURCE                        as ad_source
      ,ifnull(b.name, 'AdMob Network')    as name
      ,a.APP                              as app
      ,a.AD_REQUESTS                      as ad_requests
      ,a.CLICKS                           as clicks
      ,a.ESTIMATED_EARNINGS / 1000000     as ad_amount
      ,a.IMPRESSIONS                      as impressions
      ,a.MATCHED_REQUESTS                 as matched_requests
      ,a.MATCH_RATE                       as match_rate
      ,a.OBSERVED_ECPM                    as observed_ecpm
      ,a.Account                          as account
      ,a.CreatedTime                      as create_time
      ,a.UpdatedTime                      as update_time
      ,now()                              as etl_time
      ,a.appver                           as appver
  from (select dt
              ,Id
              ,DATE
              ,AD_UNIT
              ,app_version_name           as appver
              ,PLATFORM
              ,AD_SOURCE
              ,APP
              ,AD_REQUESTS
              ,CLICKS
              ,ESTIMATED_EARNINGS
              ,IMPRESSIONS
              ,MATCHED_REQUESTS
              ,MATCH_RATE
              ,OBSERVED_ECPM
              ,Account
              ,CreatedTime
              ,UpdatedTime
          from ods.ods_tidb_qadata_admobmediationreportbyappver    as a
         where date >= '${bf_4_dt}'
       )                                                           as a
  left join ods.ods_tidb_sharpengine_ads_global_admobadsources     as b
    on a.AD_SOURCE = b.AdSourceId
;

insert into dwd.dwd_advertisement_admob_income
select date(a.DATE)                       as dt
      ,a.Id                               as id
      ,2                                  as time_types
      ,AD_UNIT                            as ad_unit
      ,PLATFORM                           as plat_form
      ,AD_SOURCE                          as ad_source
      ,ifnull(b.name, 'AdMob Network')    as name
      ,APP                                as app
      ,AD_REQUESTS                        as ad_requests
      ,CLICKS                             as clicks
      ,ESTIMATED_EARNINGS / 1000000       as ad_amount
      ,IMPRESSIONS                        as impressions
      ,MATCHED_REQUESTS                   as matched_requests
      ,MATCH_RATE                         as match_rate
      ,OBSERVED_ECPM                      as observed_ecpm
      ,Account                            as account
      ,a.CreatedTime                      as create_time
      ,a.UpdatedTime                      as update_time
      ,now()                              as etl_time
      ,appver                             as appver
  from (select dt
              ,Id
              ,DATE
              ,AD_UNIT
              ,COUNTRY                    as appver
              ,PLATFORM
              ,AD_SOURCE
              ,APP
              ,AD_REQUESTS
              ,CLICKS
              ,ESTIMATED_EARNINGS
              ,IMPRESSIONS
              ,MATCHED_REQUESTS
              ,MATCH_RATE
              ,OBSERVED_ECPM
              ,Account
              ,CreatedTime
              ,UpdatedTime
          from ods.ods_tidb_sharpengine_ads_global_admobmediationreportest    as a
         where date >= '${bf_4_dt}'
       )                                                                      as a
  left join ods.ods_tidb_sharpengine_ads_global_admobadsources                as b
    on a.AD_SOURCE = b.AdSourceId
;