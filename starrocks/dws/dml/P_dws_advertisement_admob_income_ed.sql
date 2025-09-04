delete from dws.dws_advertisement_admob_income_ed where dt >= '${bf_4_dt}';

insert into dws.dws_advertisement_admob_income_ed
select a.dt
      ,a.product_id
      ,a.account
      ,a.ads_nmae
      ,a.ad_unit
      ,a.mt
      ,case when a.core in (0, 1) then 1 else a.core end    as corever
      ,a.time_types
      ,sum(a.ad_requests)                                   as ad_requests
      ,sum(a.matched_requests)                              as matched_requests
      ,sum(a.impressions)                                   as impressions
      ,sum(a.clicks)                                        as clicks
      ,sum(a.ad_amount)                                     as ad_amount
      ,now()                                                as etl_time
      ,a.appver
  from (select a.dt
              ,c.product_id
              ,a.account
              ,a.name                     as ads_nmae
              ,a.ad_unit
              ,c.mt
              ,c.core
              ,a.appver
              ,a.time_types
              ,sum(a.ad_requests)         as ad_requests
              ,sum(a.matched_requests)    as matched_requests
              ,sum(a.impressions)         as impressions
              ,sum(a.clicks)              as clicks
              ,sum(a.ad_amount)           as ad_amount
          from dwd.dwd_advertisement_admob_income a
          join dim.dim_admobapp_view c
            on a.App = c.appid
         where a.dt >= '${bf_4_dt}'
         group by 1, 2, 3, 4, 5, 6, 7, 8, 9
         union all
         -- 从2024年7月1号起不再用这个表里的数据
        select a.dt
              ,c.product_id
              ,account
              ,name               as ads_nmae
              ,0                  as ad_unit
              ,c.mt
              ,c.core
              ,a.country          as appver
              ,1                  as time_types
              ,0                  as ad_requests
              ,0                  as matched_requests
              ,0                  as impressions
              ,0                  as clicks
              ,SUM(EstRevenue)    as ad_amount
          from dwd.dwd_advertisement_Mintegral_income_view    as a
          join (select Mt
                      ,Core
                      ,Product_Id
                      ,case when Plat_form = 'IOS' then CONCAT('id', AppStore_Id)
                            else AppStore_Id
                        end                                   as Package
                  from dim.dim_admobapp_view
               )                                              as c
            on a.App_Package = c.Package
         where a.dt >= '${bf_4_dt}'
           and a.dt < '2024-07-01'
         group by 1, 2, 3, 4, 5, 6, 7, 8, 9
       ) a
 group by 1, 2, 3, 4, 5, 6, 7, 8, 15
;