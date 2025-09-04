insert into dws.dws_advertisement_applovin_max_ad_amt_ed
-------------------获取带产品id的数据 ---------------------------------------
with amt as (select a.dt
                   ,a.store_id
                   ,b.product_id
                   ,b.mt
                   ,b.core                          as corever
                   ,a.ad_format
                   ,a.max_ad_unit_id
                   ,a.net_work
                   ,sum(a.ecpm)                     as ecpm
                   ,sum(a.estimated_revenue_amt)    as estimated_revenue_amt
                   ,sum(a.impressions_cnt)          as impressions_cnt
               from (select dt
                           ,country
                           ,ad_format
                           ,max_ad_unit_id
                           ,net_work
                           ,store_id
                           ,ecpm
                           ,estimated_revenue    as estimated_revenue_amt
                           ,impressions          as impressions_cnt
                       from dwd.dwd_advertisement_applovin_max_ad_revenue_view a
                      where dt>='${bf_4_dt}' and dt<='${dt}' --  and  max_ad_unit_id  ='057d117266e9cc21'
                    ) a
               left join (select product_id,appstore_id,mt,core
                            from (select product_id,appstore_id,mt,core,row_number() over(partition by appstore_id order by update_time desc) as rank_desc
                                    from dim.dim_admobapp_view
                                   where core > 0
                                 ) a
                           where rank_desc = 1
                         ) b
                 on a.store_id=b.appstore_id
              group by 1,2,3,4,5,6,7,8
            )
-- ==============================海剧的===========================================
-- -------------------获取海剧的数据且是匹配状态开启的广告数据-----------------------
,sv_1 as (select a.dt
                ,a.product_id
                ,a.mt,a.corever
                ,a.ad_format
                ,a.max_ad_unit_id
                ,a.net_work
                ,c.ad_position
                ,a.ecpm
                ,a.estimated_revenue_amt
                ,a.impressions_cnt
                ,now() as etl_tm
         from (select amt.dt
                     ,amt.store_id
                     ,amt.product_id
                     ,amt.mt
                     ,amt.corever
                     ,amt.ad_format
                     ,amt.max_ad_unit_id
                     ,amt.net_work
                     ,amt.ecpm
                     ,amt.estimated_revenue_amt
                     ,amt.impressions_cnt
                 from amt
                where product_id = 6833
              ) a
         --------关联是开启状态的广告数据---------------------
         left join (select unit_adid,status,ads_type,position_id as ad_position from dim.dim_short_video_ads_unit_adid_view where status=1) c
           on a.max_ad_unit_id=c.unit_adid
         )
-- -----------------将没有匹配到广告位置的数据筛选出来 与广告id状态是关闭的数据进行关联匹配 获取广告位置----------------
,sv_2 as (select sv_1.dt
                ,sv_1.product_id
                ,sv_1.mt
                ,sv_1.corever
                ,sv_1.ad_format
                ,sv_1.max_ad_unit_id
                ,sv_1.net_work
                ,c.ad_position
                ,sv_1.ecpm
                ,sv_1.estimated_revenue_amt
                ,sv_1.impressions_cnt
                ,sv_1.etl_tm
            from sv_1
           -- --------------------关联广告状态为关闭的数据--------------------------
           inner join (select unit_adid,status,ads_type,position_id as ad_position from dim.dim_short_video_ads_unit_adid_view where status in (0,2)) c
             on sv_1.max_ad_unit_id=c.unit_adid
          where sv_1.ad_position is null
         )
-- -----------------海剧的-------------------------------
select dt
      ,product_id
      ,mt
      ,corever
      ,ad_format
      ,max_ad_unit_id,
      net_work
      ,ad_position
      ,ecpm
      ,estimated_revenue_amt
      ,impressions_cnt
      ,etl_tm 
  from sv_1
 where ad_position is not null
 union all
select dt
      ,product_id
      ,mt
      ,corever
      ,ad_format
      ,max_ad_unit_id
      ,net_work
      ,ad_position
      ,ecpm
      ,estimated_revenue_amt
      ,impressions_cnt
      ,etl_tm
  from sv_2
-- ------------------------获取阅读的数据------------------------------------------
 union all
select a.dt
      ,a.product_id
      ,a.mt
      ,a.corever
      ,a.ad_format
      ,a.max_ad_unit_id
      ,a.net_work
      ,c.ad_position
      ,a.ecpm
      ,a.estimated_revenue_amt
      ,a.impressions_cnt
      ,now() as etl_tm
  from (select amt.dt
              ,amt.store_id
              ,amt.product_id
              ,amt.mt
              ,amt.corever
              ,amt.ad_format
              ,amt.max_ad_unit_id
              ,amt.net_work
              ,amt.ecpm
              ,amt.estimated_revenue_amt
              ,amt.impressions_cnt
          from amt
         where product_id != 6833
       ) a
  -- 关联阅读广告单元id的配置表 获取，位置广告位置id------------
 inner join (select product_id,unit_adid,min(ad_position) ad_position from dim.dim_app_adplatform_unit_id_info where status = 1 and ad_plat_form=104 group by 1,2) c
    on a.product_id=c.product_id
   and a.max_ad_unit_id=c.unit_adid
;