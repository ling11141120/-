----------------------------------------------------------------
-- 程序功能： 阅读广告位置收入数据(阅读真实收益)
-- 程序名： P_ads_bi_read_adv_income_report_advdata
-- 目标表： ads.ads_bi_read_adv_income_report_advdata
-- 负责人： qhr
-- 开发日期： 
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
       and product_id <> 6833
       and time_types = 1
     group by 1,2,3,4,5,6
)
-- 先关联开启状态的广告单元id配置数据
,amt_1 as (
    select amt.dt
          ,amt.product_id
          ,amt.mt
          ,amt.corever
          ,amt.ads_nmae
          ,b.ad_show_type
          ,b.ad_position                as position_id
          ,1                            as tps
          ,sum(amt.ad_amount)           as ad_amt
          ,sum(amt.ad_requests)         as ad_request_cnt
          ,sum(amt.matched_requests)    as matched_request_cnt
          ,sum(amt.impressions)         as impression_cnt
          ,sum(amt.clicks)              as click_cnt 
      from amt
      join (select product_id
                  ,unit_adid
                  ,ad_show_type
                  ,min(ad_position)     as ad_position
              from dim.dim_app_adplatform_unit_id_info    -- 海外阅读的广告单元id配置表
             where ad_plat_form = 1
               and status = 1
             group by 1,2,3
           )                            as b
        on amt.product_id = b.product_id
       and amt.ad_unit = b.unit_adid
     group by 1,2,3,4,5,6,7,8
)
, amt_2 as (
    select amt.dt
          ,amt.product_id
          ,amt.mt
          ,amt.corever
          ,amt.ads_nmae
          ,b.ad_show_type
          ,b.ad_position                as position_id
          ,1                            as tps
          ,sum(amt.ad_amount)           as ad_amt
          ,sum(amt.ad_requests)         as ad_request_cnt
          ,sum(amt.matched_requests)    as matched_request_cnt
          ,sum(amt.impressions)         as impression_cnt
          ,sum(amt.clicks)              as click_cnt 
      from amt
      join (select product_id
                  ,unit_adid
                  ,ad_show_type
                  ,min(ad_position)     as ad_position
              from dim.dim_app_adplatform_unit_id_info    -- 海外阅读的广告单元id配置表
             where ad_plat_form = 1
               and status = 0
             group by 1,2,3
           )                            as b
        on amt.product_id = b.product_id
       and amt.ad_unit=b.unit_adid
     where concat(amt.ad_unit,amt.product_id) not in (select distinct concat(unit_adid,product_id)
                                                        from dim.dim_app_adplatform_unit_id_info
                                                       where ad_plat_form=1
                                                         and status =1
                                                     )
     group by 1,2,3,4,5,6,7,8
)
select dt
      ,product_id
      ,mt
      ,corever
      ,ads_nmae
      ,ad_show_type
      ,position_id
      ,tps
      ,ad_amt
      ,ad_request_cnt
      ,matched_request_cnt
      ,impression_cnt
      ,click_cnt
      ,now() as etl_tm
  from amt_1
 union all
select dt
      ,product_id
      ,mt
      ,corever
      ,ads_nmae
      ,ad_show_type
      ,position_id
      ,tps
      ,ad_amt
      ,ad_request_cnt
      ,matched_request_cnt
      ,impression_cnt
      ,click_cnt
      ,now() as etl_tm
  from amt_2
;

insert into ads.ads_bi_read_adv_income_report_advdata
-- --------------------------------------- topon 和 rixengine 新增的广告-----------------------------
select dt
      ,product_id
      ,mt
      ,corever
      ,firm_name                as ads_name     -- 广告来源
      ,ad_format                as ad_show_type -- 广告类型
      ,placement_name           as position_id  -- 广告位置
      ,2                        as tps
      ,sum(ad_amount)           as ad_amt
      ,sum(request)             as ad_request_cnt
      ,sum(matched_requests)    as matched_requests
      ,sum(impressions)         as impression_cnt
      ,sum(clicks)              as click_cnt
      ,now()                    as etl_tm
  from dws.dws_advertisement_topon_rixengine_income_ed 
 where dt>= '${bf_4_dt}'   -- and   正式数据从dt>='2023-11-27' 开始
 group by 1,2,3,4,5,6,7,8
-- --------------------------------------- 新增max聚合广告数据-----------------------------
 union all
select dt
      ,product_id
      ,mt
      ,corever
      ,net_work                      as ads_name     -- 广告来源
      ,ad_format                     as ad_show_type -- 广告类型
      ,ad_position                   as position_id  -- 广告位置
      ,3                             as tps
      ,sum(estimated_revenue_amt)    as ad_amt
      ,0                             as ad_request_cnt
      ,0                             as matched_requests
      ,sum(impressions_cnt)          as impression_cnt
      ,0                             as click_cnt
      ,now()                         as etl_tm
  from dws.dws_advertisement_applovin_max_ad_amt_ed 
 where dt>= '${bf_4_dt}' --  -- and   正式数据从dt>='2024-02-22' 开始
   and product_id !=6833
 group by 1,2,3,4,5,6,7,8
;

-- 阅读同步数据
insert into ads.ads_bi_read_adv_income_report_advdata
select a.dt
      ,product_id
      ,mt
      ,core                                                        as corever
      ,ads_name
      ,ad_show_type
      ,positions
      ,case when ads_name in('MonKing','MobKing') then 5
            when ads_name in('Starmobi','H5') then 4
            when ads_name in('pengpai') then 6
            when ads_name in('Starmobi_2') then 7
        end                                                        as tps
      ,sum(amt)                                                    as ad_amt
      ,round(max(b.ad_request)*(sum(cnt)/max(b.all_cnt)),0)        as ad_request
      ,round(max(b.match_request)*(sum(cnt)/max(b.all_cnt)),0)     as match_request
      ,round(max(b.ad_show_count)*(sum(cnt)/max(b.all_cnt)),0)     as ad_show_count
      ,round(max(b.ad_click_count)*(sum(cnt)/max(b.all_cnt)),0)    as ad_click_count
      ,now() as etl_time
  from dws.dws_advertisement_user_position_amt_ed         as a
  left join (select dt
                   ,sum(ad_request)                       as ad_request
                   ,sum(match_request)                    as match_request
                   ,sum(ad_show_count)                    as ad_show_count
                   ,sum(ad_click_count)                   as ad_click_count
                   ,sum(all_cnt)                          as all_cnt
               from (select date(day)                     as dt
                           ,sum(ad_request)               as ad_request
                           ,sum(match_request)            as match_request
                           ,sum(ad_show_count)            as ad_show_count
                           ,sum(ad_click_count)           as ad_click_count
                           ,0                             as all_cnt
                       from dim.dim_sv_ad_advertise_info_view
                      where day>='${bf_4_dt}' 
                        and system_type=2
                      group by 1
                      union all
                     select Date                          as dt
                           ,sum(AdReq)                    as ad_request
                           ,sum(AdRes)                    as match_request
                           ,sum(Imp)                      as ad_show_count
                           ,sum(Click)                    as ad_click_count
                           ,0                             as all_cnt
                       from ods.ods_tidb_mobkingaddata    as a
                      where Date>='${bf_4_dt}'
                        and ProjectType =0
                      group by 1
                      union all
                     select Date                          as dt
                           ,0                             as ad_request
                           ,0                             as match_request
                           ,sum(Sessions)                 as ad_show_count
                           ,sum(Clicks)                   as ad_click_count
                           ,0                             as all_cnt
                       from ods.ods_tidb_SurgeAdData
                      where Date>='${bf_4_dt}' 
                        and UrlName='moboreader'
                      group by 1
                      union all 
                     select date(day)                     as dt
                           ,0                             as ad_request
                           ,0                             as match_request
                           ,0                             as ad_show_count
                           ,sum(page_view)                as ad_click_count
                           ,0                             as all_cnt
                       from ods.ods_tidb_short_video_log_firefly_income_report
                      where date(day)>='${bf_4_dt}' 
                        and system_type=2
                      group by 1
                      union all
                     select dt
                           ,0                             as ad_request
                           ,0                             as match_request
                           ,0                             as ad_show_count
                           ,0                             as ad_click_count
                           ,sum(cnt)                      as all_cnt
                       from dws.dws_advertisement_user_position_amt_ed
                      where dt>='${bf_4_dt}'
                        and product_id <>6833
                        and ads_name in('H5','MonKing','Starmobi','MobKing','pengpai','Starmobi_2')
                      group by 1
                    )                                     as a
              group by 1
            ) b 
    on a.dt=b.dt
 where product_id <> 6833
   and a.ads_name in('H5','MonKing','Starmobi','MobKing','pengpai','Starmobi_2')
   and a.dt >='${bf_4_dt}'
 group by 1,2,3,4,5,6,7,8
;