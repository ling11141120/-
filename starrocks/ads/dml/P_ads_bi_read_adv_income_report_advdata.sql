----------------------------------------------------------------
-- 程序功能： 阅读广告位置收入数据(阅读真实收益)
-- 程序名： P_ads_bi_read_adv_income_report_advdata
-- 目标表： ads.ads_bi_read_adv_income_report_advdata
-- 负责人： xjc
-- 开发日期：2025-11-05
-- 版本号： v0.0.0
----------------------------------------------------------------

insert into ads.ads_bi_read_adv_income_report_advdata
with amt as (
    select dt
          ,product_id
          ,ads_nmae
          ,ad_unit
          ,mt
          ,corever
          ,sum(ad_requests)         as ad_requests
          ,sum(matched_requests)    as matched_requests
          ,sum(impressions)         as impressions
          ,sum(clicks)              as clicks
          ,sum(ad_amount)           as ad_amount
      from dws.dws_advertisement_admob_income_ed
     where dt >= '${bf_4_dt}'
       and product_id not in (6833)
       and time_types = 1
     group by 1, 2, 3, 4, 5, 6
)
-- 先关联开启状态的广告单元id配置数据
, amt_1 as (
    select a1.dt
          ,a1.product_id
          ,a1.mt
          ,a1.corever
          ,a1.ads_nmae
          ,a2.ad_show_type
          ,a2.ad_position              as position_id
          ,1                           as tps
          ,sum(a1.ad_amount)           as ad_amt
          ,sum(a1.ad_requests)         as ad_request_cnt
          ,sum(a1.matched_requests)    as matched_request_cnt
          ,sum(a1.impressions)         as impression_cnt
          ,sum(a1.clicks)              as click_cnt
      from amt    as a1
      join (select product_id
                  ,unit_adid
                  ,ad_show_type
                  ,min(ad_position)    as ad_position
             from dim.dim_app_adplatform_unit_id_info
            where ad_plat_form = 1
              and status = 1
            group by 1, 2, 3
           )      as a2
        on a1.product_id = a2.product_id
       and a1.ad_unit = a2.unit_adid
     group by 1, 2, 3, 4, 5, 6, 7, 8
)
, amt_2 as (
    select a1.dt
          ,a1.product_id
          ,a1.mt
          ,a1.corever
          ,a1.ads_nmae
          ,a2.ad_show_type
          ,a2.ad_position              as position_id
          ,1                           as tps
          ,sum(a1.ad_amount)           as ad_amt
          ,sum(a1.ad_requests)         as ad_request_cnt
          ,sum(a1.matched_requests)    as matched_request_cnt
          ,sum(a1.impressions)         as impression_cnt
          ,sum(a1.clicks)              as click_cnt
      from amt    as a1
      join (select product_id
                  ,unit_adid
                  ,ad_show_type
                  ,min(ad_position)    as ad_position
             from dim.dim_app_adplatform_unit_id_info
            where ad_plat_form = 1
              and status = 0
            group by 1, 2, 3
           )      as a2
        on a1.product_id = a2.product_id
       and a1.ad_unit = a2.unit_adid
     where concat(a1.ad_unit, a1.product_id) not in (select distinct concat(unit_adid, product_id)
                                                        from dim.dim_app_adplatform_unit_id_info
                                                       where ad_plat_form = 1
                                                         and status = 1
                                                    )
     group by 1, 2, 3, 4, 5, 6, 7, 8
)
select a1.dt                     as dt                     -- 日期，来自DATE字段
      ,a1.product_id             as product_id             -- 产品
      ,a1.mt                     as mt                     -- 平台
      ,a1.corever                as corever                -- 包体
      ,a1.ads_nmae               as ads_nmae               -- 广告来源
      ,a1.ad_show_type           as ad_show_type           -- 广告类型
      ,a1.position_id            as position_id            -- 广告位置id
      ,a1.tps                    as tps                    -- 1:admob 2:topon 3:max 4:starmobi
      ,a1.ad_amt                 as ad_amt                 -- AdMob 发布商的估算收入,单位，美元
      ,a1.ad_request_cnt         as ad_request_cnt         -- 请求的数量，该值是一个整数
      ,a1.matched_request_cnt    as matched_request_cnt    -- 响应请求而返回广告的次数，该值是一个整数
      ,a1.impression_cnt         as impression_cnt         -- 向用户展示的广告总数，该值是一个整数
      ,a1.click_cnt              as click_cnt              -- 用户点击广告的次数，该值是一个整数
      ,now()                     as etl_tm                 -- 数据清洗时间
  from amt_1    as a1
 union all
select a1.dt                     as dt                     -- 日期，来自DATE字段
      ,a1.product_id             as product_id             -- 产品
      ,a1.mt                     as mt                     -- 平台
      ,a1.corever                as corever                -- 包体
      ,a1.ads_nmae               as ads_nmae               -- 广告来源
      ,a1.ad_show_type           as ad_show_type           -- 广告类型
      ,a1.position_id            as position_id            -- 广告位置id
      ,a1.tps                    as tps                    -- 1:admob 2:topon 3:max 4:starmobi
      ,a1.ad_amt                 as ad_amt                 -- AdMob 发布商的估算收入,单位，美元
      ,a1.ad_request_cnt         as ad_request_cnt         -- 请求的数量，该值是一个整数
      ,a1.matched_request_cnt    as matched_request_cnt    -- 响应请求而返回广告的次数，该值是一个整数
      ,a1.impression_cnt         as impression_cnt         -- 向用户展示的广告总数，该值是一个整数
      ,a1.click_cnt              as click_cnt              -- 用户点击广告的次数，该值是一个整数
      ,now()                     as etl_tm                 -- 数据清洗时间
  from amt_2    as a1
;

insert into ads.ads_bi_read_adv_income_report_advdata
-- topon 和 rixengine 新增的广告
select a1.dt                       as dt                     -- 日期，来自DATE字段
      ,a1.product_id               as product_id             -- 产品
      ,a1.mt                       as mt                     -- 平台
      ,a1.corever                  as corever                -- 包体
      ,a1.firm_name                as ads_name               -- 广告来源
      ,a1.ad_format                as ad_show_type           -- 广告类型
      ,a1.placement_name           as position_id            -- 广告位置id
      ,2                           as tps                    -- 2:topon 4:rixengine
      ,sum(a1.ad_amount)           as ad_amt                 -- AdMob 发布商的估算收入,单位，美元
      ,sum(a1.request)             as ad_request_cnt         -- 请求的数量，该值是一个整数
      ,sum(a1.matched_requests)    as matched_request_cnt    -- 响应请求而返回广告的次数，该值是一个整数
      ,sum(a1.impressions)         as impression_cnt         -- 向用户展示的广告总数，该值是一个整数
      ,sum(a1.clicks)              as click_cnt              -- 用户点击广告的次数，该值是一个整数
      ,now()                       as etl_tm                 -- 数据清洗时间
  from dws.dws_advertisement_topon_rixengine_income_ed    as a1
 where dt >= '${bf_4_dt}'
 group by 1, 2, 3, 4, 5, 6, 7, 8
-- 新增max聚合广告数据
 union all
select a1.dt                             as dt                     -- 日期，来自DATE字段
      ,a1.product_id                     as product_id             -- 产品
      ,a1.mt                             as mt                     -- 平台
      ,a1.corever                        as corever                -- 包体
      ,a1.net_work                       as ads_name               -- 广告来源
      ,a1.ad_format                      as ad_show_type           -- 广告类型
      ,a1.ad_position                    as position_id            -- 广告位置
      ,3                                 as tps                    -- 3:max
      ,sum(a1.estimated_revenue_amt)     as ad_amt                 -- AdMob 发布商的估算收入,单位，美元
      ,0                                 as ad_request_cnt         -- 请求的数量，该值是一个整数
      ,0                                 as matched_request_cnt    -- 响应请求而返回广告的次数，该值是一个整数
      ,sum(a1.impressions_cnt)           as impression_cnt         -- 向用户展示的广告总数，该值是一个整数
      ,0                                 as click_cnt              -- 用户点击广告的次数，该值是一个整数
      ,now()                             as etl_tm                 -- 数据清洗时间
  from dws.dws_advertisement_applovin_max_ad_amt_ed       as a1
 where dt >= '${bf_4_dt}'
   and product_id != 6833
 group by 1, 2, 3, 4, 5, 6, 7, 8
;

-- 阅读同步数据
insert into ads.ads_bi_read_adv_income_report_advdata
select a1.dt                                                                 as dt                     -- 日期
      ,a1.product_id                                                         as product_id             -- 产品
      ,a1.mt                                                                 as mt                     -- 平台
      ,a1.core                                                               as corever                -- 包体
      ,a1.ads_name                                                           as ads_name               -- 广告来源
      ,a1.ad_show_type                                                       as ad_show_type           -- 广告类型
      ,a1.positions                                                          as position_id            -- 广告位置id
      ,case when a1.ads_name in('MonKing','MobKing') then 5
            when a1.ads_name in('Starmobi','H5') then 4
            when a1.ads_name in('pengpai') then 6
            when a1.ads_name in('Starmobi_2') then 7
            when a1.ads_name in('synjoy') then 8
            when a1.ads_name in('Bees') then 9
            else null
        end                                                                  as tps                    -- 标签
      ,sum(a1.amt)                                                           as ad_amt                 -- AdMob 发布商的估算收入,单位，美元
      ,round(max(a2.ad_request)*(sum(a1.cnt)/max(a2.ad_click_cnt)),0)        as ad_request_cnt         -- 请求的数量，该值是一个整数
      ,round(max(a2.match_request)*(sum(a1.cnt)/max(a2.ad_click_cnt)),0)     as matched_request_cnt    -- 响应请求而返回广告的次数，该值是一个整数
      ,round(max(a2.ad_show_count)*(sum(a1.cnt)/max(a2.ad_click_cnt)),0)     as impression_cnt         -- 向用户展示的广告总数，该值是一个整数
      ,round(max(a2.ad_click_count)*(sum(a1.cnt)/max(a2.ad_click_cnt)),0)    as click_cnt
      ,now()                                                                 as etl_time               -- 数据清洗时间
  from dws.dws_advertisement_user_position_amt_ed    as a1
  left join (select b1.dt
                   ,b1.ads_name
                   ,sum(b1.ad_request)             as ad_request
                   ,sum(b1.match_request)          as match_request
                   ,sum(b1.ad_show_count)          as ad_show_count
                   ,sum(b1.ad_click_count)         as ad_click_count
                   ,sum(b2.click_cnt)              as ad_click_cnt
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
                     select Date             as dt
                           ,'MobKing'        as ads_name
                           ,sum(AdReq)       as ad_request
                           ,sum(AdRes)       as match_request
                           ,sum(Imp)         as ad_show_count
                           ,sum(Click)       as ad_click_count
                       from ods.ods_tidb_mobkingaddata
                      where Date >= '${bf_4_dt}'
                        and ProjectType = 0
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
                        and UrlName = 'moboreader'
                      group by 1,2
                      union all
                     select date(day)         as dt
                           ,'Starmobi_2'      as ads_name
                           ,0                 as ad_request
                           ,0                 as match_request
                           ,0                 as ad_show_count
                           ,sum(page_view)    as ad_click_count
                       from ods.ods_tidb_short_video_log_firefly_income_report
                      where date(day) >= '${bf_4_dt}'
                        and system_type = 2
                      group by 1,2
                      union all
                     select dt
                           ,'synjoy'                as ads_name
                           ,sum(Requests)           as ad_request
                           ,sum(MatchedRequests)    as match_request
                           ,sum(Impressions)        as ad_show_count
                           ,sum(Clicks)             as ad_click_count
                       from ods.ods_tidb_readernovel_tidb_xx_synjoyaddata
                      where dt >= '${bf_4_dt}'
                        and ProjectType = 1
                      group by 1,2
                      union all
                     select dt
                           ,'Bees'                                        as ads_name
                           ,sum(totaladrequests)                          as ad_request
                           ,0                                             as match_request
                           ,sum(Impressions)                              as ad_show_count
                           ,sum(Clicks)                                   as ad_click_count
                       from ods.ods_tidb_readernovel_tidb_xx_beesadsdata
                      where dt >= '${bf_4_dt}'
                        and ProjectType = 1
                      group by 1,2
                      union all
                     select dt
                           ,'adjoe'    as ads_name
                           ,0          as ad_request
                           ,0          as match_request
                           ,0          as ad_show_count
                           ,0          as ad_click_count
                       from ods.ods_tidb_readernovel_tidb_xx_adjoedata
                      where dt >= '${bf_4_dt}'
                        and ProjectType = 1
                      group by 1,2
                    )          as b1
               left join (select dt
                                ,ads_name
                                ,sum(cnt)    as click_cnt
                            from dws.dws_advertisement_user_position_amt_ed
                           where dt >= '${bf_4_dt}'
                             and product_id <> 6833
                             and ads_name in('H5','MonKing','Starmobi','MobKing','pengpai','Starmobi_2','synjoy','Bees')
                           group by 1, 2
                         )    as b2
                 on b1.dt = b2.dt
                and b1.ads_name = b2.ads_name
              group by 1,2
            )    as a2
    on a1.dt = a2.dt
   and a1.ads_name = a2.ads_name
 where a1.product_id <> 6833
   and a1.ads_name in('H5','MonKing','Starmobi','MobKing','pengpai','Starmobi_2','synjoy','Bees')
   and a1.dt >= '${bf_4_dt}'
 group by 1, 2, 3, 4, 5, 6, 7, 8
;