delete from dws.dws_advertisement_admob_income_ed WHERE dt >= '${bf_4_dt}';

insert into dws.dws_advertisement_admob_income_ed
select a.dt
      ,a.product_id
      ,a.account
      ,a.ads_nmae
      ,a.ad_unit
      ,a.mt
      ,case when a.core in (0, 1) then 1 else a.core end as corever
      ,a.time_types
      ,sum(a.ad_requests)         as ad_requests
      ,sum(a.matched_requests)    as matched_requests
      ,sum(a.impressions)         as impressions
      ,sum(a.clicks)              as clicks
      ,sum(a.ad_amount)           as ad_amount
      ,now() AS etl_time
      ,a.appver
  FROM (SELECT a.dt
              ,c.product_id
              ,a.account
              ,a.name AS ads_nmae
              ,a.ad_unit
              ,c.mt
              ,c.core
              ,a.appver
              ,a.time_types
              ,sum(a.ad_requests)         AS ad_requests
              ,sum(a.matched_requests)    AS matched_requests
              ,sum(a.impressions)         AS impressions
              ,sum(a.clicks)              AS clicks
              ,sum(a.ad_amount)           AS ad_amount
          FROM dwd.dwd_advertisement_admob_income a
          JOIN dim.dim_admobapp_view c
            ON a.App = c.appid
         WHERE a.dt >= '${bf_4_dt}'
         GROUP BY 1, 2, 3, 4, 5, 6, 7, 8, 9
         UNION ALL
         -- -----------------从2024年7月1号起不再用这个表里的数据---------------------------
        SELECT a.dt
              ,c.product_id
              ,account
              ,name AS ads_nmae
              ,0 AS ad_unit
              ,c.mt
              ,c.core
              ,a.country AS appver
              ,1 AS time_types
              ,0 AS ad_requests
              ,0 AS matched_requests
              ,0 AS impressions
              ,0 AS clicks
              ,SUM(EstRevenue) AS ad_amount
          FROM dwd.dwd_advertisement_Mintegral_income_view a
          JOIN (SELECT Mt
                      ,Core
                      ,Product_Id
                      ,CASE WHEN Plat_form = 'IOS' THEN CONCAT('id', AppStore_Id) ELSE AppStore_Id END AS Package
                  FROM dim.dim_admobapp_view
               ) c ON a.App_Package = c.Package
         WHERE a.dt >= '${bf_4_dt}'
           AND a.dt < '2024-07-01'
         GROUP BY 1, 2, 3, 4, 5, 6, 7, 8, 9
       ) a
 GROUP BY 1, 2, 3, 4, 5, 6, 7, 8, 15
;