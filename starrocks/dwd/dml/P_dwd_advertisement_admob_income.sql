INSERT INTO dwd.dwd_advertisement_admob_income
SELECT DATE(a.DATE) AS dt
      ,a.Id
      ,1 AS time_types
      ,AD_UNIT
      ,PLATFORM
      ,AD_SOURCE
      ,IFNULL(b.name, 'AdMob Network') AS name
      ,APP
      ,AD_REQUESTS
      ,CLICKS
      ,ESTIMATED_EARNINGS / 1000000 AS ad_amount
      ,IMPRESSIONS
      ,MATCHED_REQUESTS
      ,MATCH_RATE
      ,OBSERVED_ECPM
      ,Account
      ,a.CreatedTime
      ,a.UpdatedTime
      ,NOW() AS etl_time
      ,appver
  FROM (SELECT dt
              ,Id
              ,DATE
              ,AD_UNIT
              ,app_version_name AS appver
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
          FROM ods.ods_tidb_qadata_admobmediationreportbyappver a
         WHERE date >= '${bf_4_dt}'
       ) a
  LEFT JOIN ods.ods_tidb_sharpengine_ads_global_admobadsources b
    ON a.AD_SOURCE = b.AdSourceId
;

INSERT INTO dwd.dwd_advertisement_admob_income
SELECT DATE(a.DATE) AS dt
      ,a.Id
      ,2 AS time_types
      ,AD_UNIT
      ,PLATFORM
      ,AD_SOURCE
      ,IFNULL(b.name, 'AdMob Network') AS name
      ,APP
      ,AD_REQUESTS
      ,CLICKS
      ,ESTIMATED_EARNINGS / 1000000 AS ad_amount
      ,IMPRESSIONS
      ,MATCHED_REQUESTS
      ,MATCH_RATE
      ,OBSERVED_ECPM
      ,Account
      ,a.CreatedTime
      ,a.UpdatedTime
      ,NOW() AS etl_time
      ,appver
  FROM (SELECT dt
              ,Id
              ,DATE
              ,AD_UNIT
              ,COUNTRY AS appver
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
          FROM ods.ods_tidb_sharpengine_ads_global_admobmediationreportest a
         WHERE date >= '${bf_4_dt}'
       ) a
  LEFT JOIN ods.ods_tidb_sharpengine_ads_global_admobadsources b
    ON a.AD_SOURCE = b.AdSourceId
;