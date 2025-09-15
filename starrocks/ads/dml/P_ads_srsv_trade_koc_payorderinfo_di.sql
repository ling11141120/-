----------------------------------------------------------------
-- 程序功能： KOC订单信息
-- 程序名： P_ads_srsv_trade_koc_payorderinfo_di
-- 目标表： ads.ads_srsv_trade_koc_payorderinfo_di
-- 负责人： qhr
-- 开发日期： 2025-09-08
-- 版本号： v0.0.0
----------------------------------------------------------------

-- KOC充值订单信息清洗
insert into ads.ads_srsv_trade_koc_payorderinfo_di
select c.order_id                                                                                                     as ref_order_id
      ,c.status                                                                                                       as status
      ,date(c.create_time)                                                                                            as dt
      ,a.KocCode                                                                                                      as code
      ,c.book_id                                                                                                      as story_id
      ,d.book_name                                                                                                    as story_name
      ,c.item_count                                                                                                   as amount
      ,c.base_amount
      ,a.project_type                                                                                                 as project_type    -- 1:海阅 2：海剧
      ,a.institution_user_id                                                                                          as institution_user_id
      ,a.star_user_id                                                                                                 as star_user_id
      ,c.create_time                                                                                                  as create_time
      ,now()                                                                                                          as etl_tm
      ,cast(substring_index(substring_index(b.ad_id, 'Core=', -1),'|',1) as int )                                     as core
      ,ifnull(d.languageid,cast(substring_index(substring_index(b.ad_id, 'CurrentLanguage2=', -1),'|',1) as int ))    as current_language
  from (
        -- 海阅的充值订单
        select productid              as product_id
              ,userid                 as user_id
              ,orderid                as order_id
              ,0                      as status
              ,1                      as project_type
              ,cast(substring_index(substring_index(substring_index(substring_index(substring_index(packageid,'|',1), 'Ps_Half_'
                                                                                    , -1
                                                                                   )
                                                                                   ,'Ps_Shop_half_'
                                                                                   ,-1
                                                                   )
                                                                   , '_', 1
                                                   ), '_', -1
                                   ) as int
                   )                  as book_id
              ,createtime             as create_time
              ,sum(itemcount)         as item_count
              ,sum(baseamount)/100    as base_amount
          from dwd.dwd_sr_user_koc_payorder_view
         where dt >= '${bf_30_dt}'
           and dt <= '${dt}'
           and createtime < date_sub(now(),interval 1 hour)
           and (packageid like '%Ps_Half%' or packageid like '%Ps_Shop_half%')
         group by 1,2,3,4,5,6,7
         union all
        -- 海剧的充值订单
        select product_id              as product_id
              ,user_id                 as user_id
              ,order_id                as order_id
              ,status                  as status
              ,2                       as project_type
              ,cast(substring_index(substring_index(substring_index(package_id, 'Ps_Half_', -1)
                                                                   , '_', 1
                                                   ), '_', -1
                                   ) as int
                   )                   as book_id
              ,create_time             as create_time
              ,sum(item_count)         as item_count
              ,sum(base_amount)/100    as base_amount
          from dwd.dwd_trade_short_video_payorder_view
         where dt >= '${bf_30_dt}'
           and dt <= '${dt}'
           and create_time < date_sub(now(),interval 1 hour)
           and product_id = 6833
           and package_id like '%Ps_Half%'
           and test_flag = 0
           and status = 0    -- 正常订单
         group by 1,2,3,4,5,6,7
       )                                                         as c
  join dwd.dwd_srsv_advertisement_koc_attribution_record_view    as b    -- 订单关联归因表，确认归属koc的订单
    on b.product_id=c.product_id
   and b.user_id= c.user_id
   and b.resource_id=c.book_id
   and c.create_time>=b.begin_time
   and c.create_time<b.end_time
  left join (
             -- 关联口令和达人信息表，获取口令和达人等信息
             select a.koccode        as koccode
                   ,a.projecttype    as project_type
                   ,c.userid         as institution_user_id
                   ,a.dataid         as dataid
                   ,b.userid         as star_user_id
               from ods.ods_tidb_koc_codeinfo           as a
               left join ods.ods_tidb_koc_starinfo      as b
                 on a.institutionid = b.institutionid
                and a.starid = b.id
               left join ods.ods_koc_institutioninfo    as c
                 on a.institutionid = c.id
            )                                                    as a
    on a.koccode = b.koc_text and a.dataid = b.resource_id 
  left join (
             -- 关联海阅、海剧维表，获取书名/剧名
             select 1              as project_type
                   ,book_id        as book_id
                   ,book_name      as book_name
                   ,languageid     as languageid
               from dim.dim_shuangwen_book_read_consume_info
              group by 2,3,4
              union all
             select 2              as project_type
                   ,series_id      as book_id
                   ,series_name    as book_name
                   ,language       as languageid
               from dim.dim_short_video_series_view
              group by 2,3,4
            )                                                    as d
    on c.project_type=d.project_type
   and c.book_id = d.book_id
 where date(c.create_time) >= '${bf_3_dt}'
   and date(c.create_time) < '2024-12-11'
 union all
select c.order_id                                                                                                     as ref_order_id
      ,c.status                                                                                                       as status
      ,date(c.create_time)                                                                                            as dt
      ,ifnull(b.koc_text,0)                                                                                           as code
      ,ifnull(c.book_id,0)                                                                                            as story_id
      ,d.book_name                                                                                                    as story_name
      ,c.item_count                                                                                                   as amount
      ,c.base_amount
      ,a.project_type                                                                                                 as project_type    -- 1:海阅 2：海剧
      ,a.institution_user_id                                                                                          as institution_user_id
      ,a.star_user_id                                                                                                 as star_user_id
      ,c.create_time                                                                                                  as create_time
      ,now()                                                                                                          as etl_tm
      ,cast(substring_index(substring_index(b.ad_id, 'Core=', -1),'|',1) as int )                                     as core
      ,ifnull(d.languageid,cast(substring_index(substring_index(b.ad_id, 'CurrentLanguage2=', -1),'|',1) as int ))    as current_language
  from (
        -- 海阅的充值订单
        select productid             as product_id
             ,userid                 as user_id
             ,orderid                as order_id
             ,0                      as status
             ,1                      as project_type
             ,cast(substring_index(substring_index(substring_index(substring_index(substring_index(packageid,'|',1)
                                                                                   , 'Ps_Half_', -1
                                                                                  )
                                                                   ,'Ps_Shop_half_',-1
                                                                  )
                                                   , '_', 1
                                                  )
                                   , '_', -1
                                  ) as int
                  )                  as book_id
             ,createtime             as create_time
             ,sum(itemcount)         as item_count
             ,sum(baseamount)/100    as base_amount
          from dwd.dwd_sr_user_koc_payorder_view
         where dt>='${bf_30_dt}'
           and dt<='${dt}'
           and createtime<date_sub(now(),interval 1 hour)
         group by 1,2,3,4,5,6,7
         union all
        -- 海剧的充值订单
        select product_id              as product_id
              ,user_id                 as user_id
              ,order_id                as order_id
              ,status                  as status
              ,2                       as project_type
              ,cast(substring_index(substring_index(substring_index(package_id, 'Ps_Half_', -1)
                                                    , '_', 1
                                                   )
                                    , '_', -1
                                   ) as int
                   )                   as book_id
              ,create_time             as create_time
              ,sum(item_count)         as item_count
              ,sum(base_amount)/100    as base_amount
          from dwd.dwd_trade_short_video_payorder_view
         where dt >= '${bf_30_dt}'
           and dt <= '${dt}'
           and create_time<date_sub(now(),interval 1 hour)
           and product_id = 6833
           and test_flag = 0
           and status = 0 -- 正常订单
         group by 1,2,3,4,5,6,7
       )                                                         as c
  join dwd.dwd_srsv_advertisement_koc_attribution_record_view    as b  -- 订单关联归因表，确认归属koc的订单
    on if(b.product_id=6833,2,1) =c.project_type
   and b.user_id= c.user_id
   and c.create_time>=b.begin_time
   and c.create_time<b.end_time
  left join (
             -- 关联口令和达人信息表，获取口令和达人等信息
             select a.koccode        as koccode
                   ,a.projecttype    as project_type
                   ,c.userid         as institution_user_id
                   ,a.dataid         as dataid
                   ,b.userid         as star_user_id
               from ods.ods_tidb_koc_codeinfo                    as a
               left join ods.ods_tidb_koc_starinfo               as b
                 on a.institutionid = b.institutionid
                and a.starid = b.id
               left join ods.ods_koc_institutioninfo             as c
                 on a.institutionid = c.id
            )                                                    as a
    on a.koccode = b.koc_text and a.dataid = b.resource_id 
  left join (
             -- 关联海阅、海剧维表，获取书名/剧名
             select 1              as project_type
                   ,book_id
                   ,book_name
                   ,languageid
               from dim.dim_shuangwen_book_read_consume_info
              group by 2,3,4
              union all
             select 2              as project_type
                   ,series_id      as book_id
                   ,series_name    as book_name
                   ,language       as languageid
               from dim.dim_short_video_series_view
              group by 2,3,4
            ) d
    on c.project_type=d.project_type
   and c.book_id = d.book_id
 where date(c.create_time)>='${bf_3_dt}'
   and (    (    date(c.create_time)>='2024-12-11'
             and date(c.create_time)<'2024-12-14'
            )
         or c.create_time>='2025-01-02'
       )
 group by 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
 union all
-- 20241214开始书籍id不能为空
select c.order_id                                                                                                     as ref_order_id
      ,c.status                                                                                                       as status
      ,date(c.create_time)                                                                                            as dt
      ,ifnull(b.koc_text,0)                                                                                           as code
      ,ifnull(c.book_id,0)                                                                                            as story_id
      ,d.book_name                                                                                                    as story_name
      ,c.item_count                                                                                                   as amount
      ,c.base_amount
      ,a.project_type                                                                                                 as project_type  -- 1:海阅 2：海剧
      ,a.institution_user_id                                                                                          as institution_user_id
      ,a.star_user_id                                                                                                 as star_user_id
      ,c.create_time                                                                                                  as create_time
      ,now()                                                                                                          as etl_tm
      ,cast(substring_index(substring_index(b.ad_id, 'Core=', -1),'|',1) as int )                                     as core
      ,ifnull(d.languageid,cast(substring_index(substring_index(b.ad_id, 'CurrentLanguage2=', -1),'|',1) as int ))    as current_language
  from (
        -- 海阅的充值订单
        select productid             as product_id
              ,userid                 as user_id
              ,orderid                as order_id
              ,0                      as status
              ,1                      as project_type
              ,cast(substring_index(substring_index(substring_index(substring_index(substring_index(packageid,'|',1), 'Ps_Half_'
                                                                                    , -1
                                                                                   )
                                                                                   ,'Ps_Shop_half_'
                                                                                   ,-1
                                                                   )
                                                                   , '_', 1
                                                   ), '_', -1
                                   ) as int
                    )                 as book_id
              ,createtime             as create_time
              ,sum(itemcount)         as item_count
              ,sum(baseamount)/100    as base_amount
          from dwd.dwd_sr_user_koc_payorder_view
         where dt>='${bf_30_dt}'
           and dt<='${dt}'
           and createtime<date_sub(now(),interval 1 hour)
           and (packageid like '%Ps_Half%' or packageid like '%Ps_Shop_half%')
         group by 1,2,3,4,5,6,7
         union all
        -- 海剧的充值订单
        select product_id                                                                                                     as product_id
             ,user_id                                                                                                         as user_id
             ,order_id                                                                                                        as order_id
             ,status                                                                                                          as status
             ,2                                                                                                               as project_type
             ,cast(substring_index(substring_index(substring_index(package_id, 'Ps_Half_', -1), '_', 1), '_', -1) as int )    as book_id
             ,create_time                                                                                                     as create_time
             ,sum(item_count)                                                                                                 as item_count
             ,sum(base_amount)/100                                                                                            as base_amount
          from dwd.dwd_trade_short_video_payorder_view
         where dt>='${bf_30_dt}'
           and dt<='${dt}'
           and create_time<date_sub(now(),interval 1 hour)
           and product_id = 6833
           and package_id like '%Ps_Half%'
           and test_flag = 0
           and status = 0 -- 正常订单
         group by 1,2,3,4,5,6,7
       )                                                         as c
  join dwd.dwd_srsv_advertisement_koc_attribution_record_view    as b    -- 订单关联归因表，确认归属koc的订单
    on if(b.product_id=6833,2,1) = c.project_type
   and b.user_id = c.user_id
   and c.create_time >= b.begin_time
   and c.create_time < b.end_time
  left join (
             -- 关联口令和达人信息表，获取口令和达人等信息
             select a.koccode        as koccode
                   ,a.projecttype    as project_type
                   ,c.userid         as institution_user_id
                   ,a.dataid         as dataid
                   ,b.userid         as star_user_id
               from ods.ods_tidb_koc_codeinfo                    as a
               left join ods.ods_tidb_koc_starinfo               as b
                 on a.institutionid = b.institutionid
                and a.starid = b.id
               left join ods.ods_koc_institutioninfo             as c
                 on a.institutionid = c.id
            )                                                    as a
    on a.koccode = b.koc_text 
   and a.dataid = b.resource_id 
  left join (
             -- 关联海阅、海剧维表，获取书名/剧名
             select 1              as project_type
                   ,book_id        as book_id
                   ,book_name      as book_name
                   ,languageid     as languageid
               from dim.dim_shuangwen_book_read_consume_info
              group by 2,3,4
              union all
             select 2              as project_type
                   ,series_id      as book_id
                   ,series_name    as book_name
                   ,language       as languageid
               from dim.dim_short_video_series_view
              group by 2,3,4
            )                                                    as d
    on c.project_type = d.project_type
   and c.book_id = d.book_id
 where date(c.create_time) >= '${bf_3_dt}'
   and date(c.create_time) >= '2024-12-14'
   and c.book_id > 0
   and c.create_time < '2025-01-02'
 group by 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
;

-- 调度：KOC退款订单信息清洗
insert into ads.ads_srsv_trade_koc_payorderinfo_di
select c.ref_order_id           as ref_order_id
      ,a.status                 as status
      ,date(a.create_time)      as dt
      ,c.code                   as code
      ,c.story_id               as story_id
      ,c.story_name             as story_name
      ,c.amount                 as amount
      ,c.base_amount
      ,c.project_type           as project_type    -- 1:海阅 2：海剧
      ,c.institution_user_id    as institution_user_id
      ,c.star_user_id           as star_user_id
      ,a.create_time            as create_time
      ,now()                    as etl_tm
      ,c.core                   as core
      ,c.current_language       as current_language
  from (
        -- 海阅的退款订单
        select productid              as product_id
              ,userid                 as user_id
              ,orderid                as order_id
              ,1                      as status
              ,1                      as project_type
              ,null                   as book_id
              ,refund_time            as create_time    -- 取退款时间
              ,sum(itemcount)         as item_count
              ,sum(baseamount)/100    as base_amount
          from dwd.dwd_sr_trade_user_refund_order_di
         where dt>='${bf_30_dt}'
           and dt<='${dt}'
         group by 1,2,3,4,5,6,7
         union all
        -- 海剧的退款订单
        select product_id             as product_id
              ,user_id                as user_id
              ,order_id               as order_id
              ,status                 as status
              ,2                      as project_type
              ,cast(substring_index(substring_index(substring_index(package_id, 'Ps_Half_', -1)
                                                    , '_', 1
                                                   )
                                    , '_', -1
                                   ) as int) as book_id
              ,dt                     as create_time
              ,sum(item_count)        as item_count
              ,sum(base_amount)/100   as base_amount
          from dwd.dwd_trade_short_video_payorder_view
         where dt >= '${bf_30_dt}'
           and dt<='${dt}'
           and product_id = 6833
           and test_flag = 0
           and status = 1 -- 退款订单
         group by 1,2,3,4,5,6,7
       )                                         as a
  join ads.ads_srsv_trade_koc_payorderinfo_di    as c
    on a.order_id = c.ref_order_id
   and c.status = 0
 where date(a.create_time) >= '${bf_3_dt}'
;