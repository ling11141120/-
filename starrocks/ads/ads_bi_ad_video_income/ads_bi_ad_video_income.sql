-- -----------------admob的广告收入---------------------------------------
insert into ads.ads_bi_ad_video_income
with us as (select dt
                  ,product_id
                  ,ads_nmae
                  ,ad_unit
                  ,mt
                  ,corever
                  ,appver
                  ,sum(a.ad_requests)                       as ad_requests
                  ,sum(a.matched_requests)                  as matched_requests
                  ,sum(a.impressions)                       as impressions
                  ,sum(a.clicks)                            as clicks
                  ,sum(a.ad_amount)                         as ad_amount
              from dws.dws_advertisement_admob_income_ed    as a
             where product_id = 6833
               and time_types = 1
               and dt >= '${bf_4_dt}'
             group by 1,2,3,4,5,6,7
            )
-- ---------------------只取配置表里有的收入数据-------------------------------------
-- 优先匹配开启的广告单元id  获取广告类型，广告位置等
,p as (select us.dt
             ,us.product_id
             ,us.ads_nmae
             ,us.ad_unit
             ,us.mt
             ,us.corever
             ,us.appver
             ,us.ad_requests
             ,us.matched_requests
             ,us.impressions
             ,us.clicks
             ,us.ad_amount
             ,b.ads_type
             ,b.position_id
         from us
         left join dim.dim_short_video_ads_unit_adid_view b
           on us.ad_unit = b.unit_adid
          and b.status = 1
        )
-- 再将没有匹配到的广告单元id 去匹配关闭的广告单元id---
,n as (select p.dt
             ,p.product_id
             ,p.ads_nmae
             ,p.ad_unit
             ,p.mt
             ,p.corever
             ,p.appver
             ,p.ad_requests
             ,p.matched_requests
             ,p.impressions
             ,p.clicks
             ,p.ad_amount
             ,b.ads_type
             ,b.position_id
         from p
        inner join dim.dim_short_video_ads_unit_adid_view b
           on p.ad_unit = b.unit_adid
          and b.status in (0,2)
        where p.position_id is null 
      )
select a.dt
      ,a.product_id
      ,a.ads_type
      ,a.position_id
      ,a.ads_nmae
      ,a.mt
      ,a.corever
      ,a.appver
      ,sum(a.ad_requests)         as ad_requests
      ,sum(a.matched_requests)    as matched_requests
      ,sum(a.impressions)         as impressions
      ,sum(a.clicks)              as clicks
      ,sum(a.ad_amount)           as ad_amount
      ,1                          as tps                 -- 表示admob
      ,now()                      as etl_time
  from (select dt,product_id,ads_nmae,ad_unit,mt,corever,appver,ad_requests,matched_requests,impressions,clicks,ad_amount,ads_type,position_id from p where position_id is not null
        union all
        select dt,product_id,ads_nmae,ad_unit,mt,corever,appver,ad_requests,matched_requests,impressions,clicks,ad_amount,ads_type,position_id from n
       ) a
 group by 1,2,3,4,5,6,7,8
;


----------max的广告收入---------------
insert into ads.ads_bi_ad_video_income
select dt
      ,product_id
      ,case when ad_format = 'BANNER'  then 1 -- banner
            when ad_format = 'NATIVE'  then 2 -- 原生广告
            when ad_format = 'REWARD'  then 3 -- 激励视频
            when ad_format = 'APPOPEN' then 4 -- 开屏广告
            when ad_format = 'INTER'   then 5 -- 插屏广告
        end                          as ad_show_type    -- 广告类型
      ,ad_position                   as positions       -- 广告位置
      ,net_work                      as ads_name        -- 广告来源
      ,mt
      ,corever                       as core
      ,null                          as appver
      ,0                             as ad_request
      ,0                             as match_request
      ,sum(impressions_cnt)          as impression_cnt
      ,0                             as click_cnt
      ,sum(estimated_revenue_amt)    as ad_amount
      ,3                             as tps
      ,now()                         as etl_tm
  from dws.dws_advertisement_applovin_max_ad_amt_ed
 where dt >= '${bf_4_dt}'                               -- and 正式数据从dt>='2024-07-16' 开始
   and product_id = 6833
 group by 1,2,3,4,5,6,7,8
;

--  新增了一些抓取api的数据 starmobi
insert into ads.ads_bi_ad_video_income
select a.dt
      ,product_id
      ,ad_show_type
      ,positions
      ,ads_name
      ,mt   as mt
      ,core as corever
      ,appver
      ,round(max(b.ad_request)*(sum(cnt)/max(b.all_cnt)),0)        as ad_request
      ,round(max(b.match_request)*(sum(cnt)/max(b.all_cnt)),0)     as match_request
      ,round(max(b.ad_show_count)*(sum(cnt)/max(b.all_cnt)),0)     as ad_show_count
      ,round(max(b.ad_click_count)*(sum(cnt)/max(b.all_cnt)),0)    as ad_click_count
      ,sum(a.amt) as ad_amt
      ,case when ads_name in('MonKing','MobKing') then 5
            when ads_name in('Starmobi','H5')     then 4
            when ads_name in('pengpai')           then 6
            when ads_name in('Starmobi_2')        then 7
        end                                                        as tps
      ,now()                                                       as etl_time
  from dws.dws_advertisement_user_position_amt_ed                  as a
  left join (select dt
                   ,sum(ad_request)                as ad_request
                   ,sum(match_request)             as match_request
                   ,sum(ad_show_count)             as ad_show_count
                   ,sum(ad_click_count)            as ad_click_count
                   ,sum(all_cnt)                   as all_cnt
               from (select date(day)              as dt
                           ,sum(ad_request)        as ad_request
                           ,sum(match_request)     as match_request
                           ,sum(ad_show_count)     as ad_show_count
                           ,sum(ad_click_count)    as ad_click_count
                           ,0                      as all_cnt
                       from dim.dim_sv_ad_advertise_info_view
                      where day >= '${bf_4_dt}'
                        and system_type = 2
                      group by 1
                      union all
                     select Date                  as dt
                           ,sum(AdReq)            as ad_request
                           ,sum(AdRes)            as match_request
                           ,sum(Imp)              as ad_show_count
                           ,sum(Click)            as ad_click_count
                           ,0 as all_cnt
                       from ods.ods_tidb_mobkingaddata a
                      where Date>='${bf_4_dt}'
                        and ProjectType =1
                      group by 1
                      union all
                     select Date                  as dt
                           ,0                     as ad_request
                           ,0                     as match_request
                           ,sum(Sessions)         as ad_show_count
                           ,sum(Clicks)           as ad_click_count
                           ,0                     as all_cnt
                      from ods.ods_tidb_SurgeAdData
                      where Date >= '${bf_4_dt}'
                        and UrlName = 'moboreels'
                      group by 1
                      union all
                     select date(day)             as dt
                            ,0                     as ad_request
                            ,0                     as match_request
                            ,0                     as ad_show_count
                            ,sum(page_view)        as ad_click_count
                            ,0                     as all_cnt
                       from ods.ods_tidb_short_video_log_firefly_income_report
                      where date(day) >= '${bf_4_dt}'
                        and system_type = 1
                      group by 1
                      union all
                     select dt
                           ,0                     as ad_request
                           ,0                     as match_request
                           ,0                     as ad_show_count
                           ,0                     as ad_click_count
                           ,sum(cnt)              as all_cnt
                       from dws.dws_advertisement_user_position_amt_ed
                      where dt >= '${bf_4_dt}'
                        and product_id = 6833
                        and ads_name in('H5','MonKing','Starmobi','MobKing','pengpai','Starmobi_2')
                      group by 1
                    ) a
              group by 1
            ) b
    on a.dt=b.dt
 where product_id = 6833
   and a.ads_name in('H5','MonKing','Starmobi','MobKing','pengpai','Starmobi_2')
   and a.dt >='${bf_4_dt}'
 group by 1,2,3,4,5,6,7,8
;