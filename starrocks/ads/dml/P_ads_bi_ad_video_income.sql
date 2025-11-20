----------------------------------------------------------------
-- 程序功能： 海外短剧广告收入统计表
-- 程序名： P_ads_bi_ad_video_income
-- 目标表： ads.ads_bi_ad_video_income
-- 负责人： xjc
-- 开发日期： 2025-11-05
-- 版本号： v0.0.0
----------------------------------------------------------------

-- admob的广告收入
insert into ads.ads_bi_ad_video_income
with us as (
    select dt
          ,product_id
          ,ads_nmae
          ,ad_unit
          ,mt
          ,corever
          ,appver
          ,sum(a1.ad_requests)         as ad_requests
          ,sum(a1.matched_requests)    as matched_requests
          ,sum(a1.impressions)         as impressions
          ,sum(a1.clicks)              as clicks
          ,sum(a1.ad_amount)           as ad_amount
      from dws.dws_advertisement_admob_income_ed    as a1
     where product_id = 6833
       and time_types = 1
       and dt >= '${bf_4_dt}'
     group by 1,2,3,4,5,6,7
)
-- 优先匹配开启的广告单元id  获取广告类型，广告位置等  只取配置表里有的收入数据
, p as (
    select a1.dt
          ,a1.product_id
          ,a1.ads_nmae
          ,a1.ad_unit
          ,a1.mt
          ,a1.corever
          ,a1.appver
          ,a1.ad_requests
          ,a1.matched_requests
          ,a1.impressions
          ,a1.clicks
          ,a1.ad_amount
          ,a2.ads_type
          ,a2.position_id
      from us                                             as a1
      left join dim.dim_short_video_ads_unit_adid_view    as a2
        on a1.ad_unit = a2.unit_adid
       and a2.status = 1
)
-- 再将没有匹配到的广告单元id 去匹配关闭的广告单元id
, n as (
    select a1.dt
          ,a1.product_id
          ,a1.ads_nmae
          ,a1.ad_unit
          ,a1.mt
          ,a1.corever
          ,a1.appver
          ,a1.ad_requests
          ,a1.matched_requests
          ,a1.impressions
          ,a1.clicks
          ,a1.ad_amount
          ,a2.ads_type
          ,a2.position_id
      from p                                         as a1
      join dim.dim_short_video_ads_unit_adid_view    as a2
        on a1.ad_unit = a2.unit_adid
       and a2.status in (0, 2)
     where a1.position_id is null
)
select a1.dt                       as dt                  -- 日期
      ,a1.product_id               as product_id          -- 产品id
      ,a1.ads_type                 as ad_show_type        -- 广告类型
      ,a1.position_id              as positions           -- 广告位置
      ,a1.ads_nmae                 as ads_name            -- 广告商名称
      ,a1.mt                       as mt                  -- 设备
      ,a1.corever                  as core                -- core
      ,a1.appver                   as appver              -- 应用版本
      ,sum(a1.ad_requests)         as ad_requests         -- 请求的数量,该值是一个整数
      ,sum(a1.matched_requests)    as matched_requests    -- 响应请求而返回广告的次数,该值是一个整数
      ,sum(a1.impressions)         as impressions         -- 向用户展示的广告总数,该值是一个整数
      ,sum(a1.clicks)              as clicks              -- 用户点击广告的次数,该值是一个整数
      ,sum(a1.ad_amount)           as ad_amount           -- 广告收入，以美元计,该值是一个浮点数
      ,1                           as tps                 -- 表示admob
      ,now()                       as etl_time            -- 数据清洗时间
  from (select dt
              ,product_id
              ,ads_nmae
              ,ad_unit
              ,mt
              ,corever
              ,appver
              ,ad_requests
              ,matched_requests
              ,impressions
              ,clicks
              ,ad_amount
              ,ads_type
              ,position_id
          from p
         where position_id is not null
         union all
        select dt
              ,product_id
              ,ads_nmae
              ,ad_unit
              ,mt
              ,corever
              ,appver
              ,ad_requests
              ,matched_requests
              ,impressions
              ,clicks
              ,ad_amount
              ,ads_type
              ,position_id
          from n
       )    as a1
 group by 1,2,3,4,5,6,7,8
;

-- max的广告收入
insert into ads.ads_bi_ad_video_income
select a1.dt                            as dt                  -- 日期
      ,a1.product_id                    as product_id          -- 产品id
      ,case
            when a1.ad_format = 'BANNER'  then 1               -- banner
            when a1.ad_format = 'NATIVE'  then 2               -- 原生广告
            when a1.ad_format = 'REWARD'  then 3               -- 激励视频
            when a1.ad_format = 'APPOPEN' then 4               -- 开屏广告
            when a1.ad_format = 'INTER'   then 5               -- 插屏广告
            else null
        end                             as ad_show_type        -- 广告类型
      ,a1.ad_position                   as positions           -- 广告位置
      ,a1.net_work                      as ads_name            -- 广告商名称
      ,a1.mt                            as mt                  -- 设备
      ,a1.corever                       as core                -- core
      ,null                             as appver              -- 应用版本
      ,0                                as ad_requests         -- 请求的数量,该值是一个整数
      ,0                                as matched_requests    -- 响应请求而返回广告的次数,该值是一个整数
      ,sum(a1.impressions_cnt)          as impression_cnt      -- 向用户展示的广告总数,该值是一个整数
      ,0                                as clicks              -- 用户点击广告的次数,该值是一个整数
      ,sum(a1.estimated_revenue_amt)    as ad_amount           -- 广告收入，以美元计,该值是一个浮点数
      ,3                                as tps                 -- 表示topon
      ,now()                            as etl_time            -- 数据清洗时间
  from dws.dws_advertisement_applovin_max_ad_amt_ed    as a1
 where dt >= '${bf_4_dt}'
   and product_id = 6833
 group by 1,2,3,4,5,6,7,8
;

--  新增了一些抓取api的数据 starmobi
insert into ads.ads_bi_ad_video_income
select a1.dt                                                              as dt                -- 日期
      ,a1.product_id                                                      as product_id        -- 产品id
      ,a1.ad_show_type                                                    as ad_show_type      -- 广告类型
      ,a1.positions                                                       as positions         -- 广告位置
      ,a1.ads_name                                                        as ads_name          -- 广告商名称
      ,a1.mt                                                              as mt                -- 设备
      ,a1.core                                                            as core              -- core
      ,a1.appver                                                          as appver            -- 应用版本
      ,round(max(a2.ad_request) * (sum(cnt) / max(a2.all_cnt)), 0)        as ad_requests       -- 请求的数量,该值是一个整数
      ,round(max(a2.match_request) * (sum(cnt) / max(a2.all_cnt)), 0)     as match_request     -- 响应请求而返回广告的次数,该值是一个整数
      ,round(max(a2.ad_show_count) * (sum(cnt) / max(a2.all_cnt)), 0)     as ad_show_count     -- 向用户展示的广告总数,该值是一个整数
      ,round(max(a2.ad_click_count) * (sum(cnt) / max(a2.all_cnt)), 0)    as ad_click_count    -- 用户点击广告的次数,该值是一个整数
      ,sum(a1.amt)                                                        as ad_amount         -- 广告收入，以美元计,该值是一个浮点数
      ,case
            when a1.ads_name in ('MonKing', 'MobKing') then 5
            when a1.ads_name in ('Starmobi', 'H5') then 4
            when a1.ads_name in ('pengpai') then 6
            when a1.ads_name in ('Starmobi_2') then 7
            when a1.ads_name in ('synjoy') then 8
            else a1.ads_name
        end                                                               as tps               -- 标识
      ,now()                                                              as etl_time          -- 数据清洗时间
  from dws.dws_advertisement_user_position_amt_ed    as a1
  left join (select b1.dt
                   ,b1.ads_name       as ads_name
                   ,ad_request        as ad_request
                   ,match_request     as match_request
                   ,ad_show_count     as ad_show_count
                   ,ad_click_count    as ad_click_count
                   ,all_cnt           as all_cnt
               from (select date(day)              as dt
                           ,'Starmobi'             as ads_name
                           ,sum(ad_request)        as ad_request
                           ,sum(match_request)     as match_request
                           ,sum(ad_show_count)     as ad_show_count
                           ,sum(ad_click_count)    as ad_click_count
                       from dim.dim_sv_ad_advertise_info_view
                      where day >= '${bf_4_dt}'
                        and system_type = 2
                      group by 1,2
                      union all
                     select Date          as dt
                           ,'MobKing'     as ads_name
                           ,sum(AdReq)    as ad_request
                           ,sum(AdRes)    as match_request
                           ,sum(Imp)      as ad_show_count
                           ,sum(Click)    as ad_click_count
                       from ods.ods_tidb_mobkingaddata
                      where Date >= '${bf_4_dt}'
                        and ProjectType = 1
                      group by 1,2
                      union all
                     select Date             as dt
                           ,'pengpai'        as ads_name
                           ,0                as ad_request
                           ,0                as match_request
                           ,sum(Sessions)    as ad_show_count
                           ,sum(Clicks)      as ad_click_count
                       from ods.ods_tidb_SurgeAdData
                      where Date >= '${bf_4_dt}'
                        and UrlName = 'moboreels'
                      group by 1
                      union all
                     select date(day)         as dt
                           ,'Starmobi_2'      as ads_name
                           ,0                 as ad_request
                           ,0                 as match_request
                           ,0                 as ad_show_count
                           ,sum(page_view)    as ad_click_count
                       from ods.ods_tidb_short_video_log_firefly_income_report
                      where date(day) >= '${bf_4_dt}'
                        and system_type = 1
                      group by 1
                     union all
                     select dt
                          ,'synjoy'                as ads_name
                          ,sum(Requests)           as ad_request
                          ,sum(MatchedRequests)    as match_request
                          ,sum(Impressions)        as ad_show_count
                          ,sum(Clicks)             as ad_click_count
                     from ods.ods_tidb_readernovel_tidb_xx_synjoyaddata
                     where dt >= '${bf_4_dt}'
                       and ProjectType = 2
                     group by 1,2

               )          as b1
          left join (select dt
                          ,ads_name
                          ,sum(cnt)    as all_cnt
                     from dws.dws_advertisement_user_position_amt_ed
                     where dt >= '${bf_4_dt}'
                       and product_id <> 6833
                       and ads_name in('H5','MonKing','Starmobi','MobKing','pengpai','Starmobi_2','synjoy')
                     group by 1, 2
                    )     as b2
            on b1.ads_name = b2.ads_name
           and b1.dt = b2.dt
            )                                        as a2
    on a1.dt = a2.dt
   and a1.ads_name = a2.ads_name
 where product_id = 6833
   and a1.ads_name in ('H5', 'MonKing', 'Starmobi', 'MobKing', 'pengpai', 'Starmobi_2','synjoy')
   and a1.dt >= '${bf_4_dt}'
 group by 1,2,3,4,5,6,7,8
;



