----------------------------------------------------------------
-- 程序功能： KOC订单信息
-- 程序名： P_ads_srsv_trade_koc_payorderinfo_di
-- 目标表： ads.ads_srsv_trade_koc_payorderinfo_di
-- 负责人： qhr
-- 开发日期： 2025-09-08
-- 版本号： v0.0.1
----------------------------------------------------------------

-- KOC充值订单信息清洗
insert into ads.ads_srsv_trade_koc_payorderinfo_di
with koc_data as (
    select a1.order_id                                                                                                     as ref_order_id
          ,a1.status                                                                                                       as status
          ,date(a1.create_time)                                                                                            as dt
          ,ifnull(a2.koc_text,0)                                                                                           as code
          ,ifnull(a1.book_id,0)                                                                                            as story_id
          ,a4.book_name                                                                                                    as story_name
          ,a1.item_count                                                                                                   as amount
          ,a1.base_amount                                                                                                  as base_amount
          ,a3.project_type                                                                                                 as project_type    -- 1:海阅 2：海剧
          ,a3.institution_user_id                                                                                          as institution_user_id
          ,a3.star_user_id                                                                                                 as star_user_id
          ,a1.create_time                                                                                                  as create_time
          ,now()                                                                                                           as etl_tm
          ,cast(substring_index(substring_index(a2.ad_id, 'Core=', -1),'|',1) as int)                                      as core
          ,ifnull(a4.languageid,cast(substring_index(substring_index(a2.ad_id, 'CurrentLanguage2=', -1),'|',1) as int))    as current_language
          ,a1.user_id                                                                                                      as user_id
          ,cast(substring_index(substring_index(a2.ad_id, 'Mt=', -1),'|',1) as int)                                        as mt
          ,a1.sub_pay_type                                                                                                 as sub_pay_type
          ,a1.shop_item                                                                                                    as shop_item
          ,a2.begin_time                                                                                                   as activation_time
          ,a5.reg_country                                                                                                  as country
      from (select productid              as product_id
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
                  ,subpaytype             as sub_pay_type
                  ,shopitem               as shop_item
                  ,sum(itemcount)         as item_count
                  ,sum(baseamount)/100    as base_amount
              from dwd.dwd_sr_user_koc_payorder_view    as b1    -- 海阅的充值订单
              left join 
             where dt>='${bf_30_dt}'
               and dt<='${dt}'
               and createtime<date_sub(now(),interval 1 hour)
             group by 1,2,3,4,5,6,7,8,9
             union all
            select product_id
                  ,user_id
                  ,order_id
                  ,status
                  ,2                       as project_type
                  ,cast(substring_index(substring_index(substring_index(package_id, 'Ps_Half_', -1)
                                                        , '_', 1
                                                       )
                                        , '_', -1
                                       ) as int
                       )                   as book_id
                  ,create_time
                  ,subpay_type             as sub_pay_type
                  ,shop_item
                  ,sum(item_count)         as item_count 
                  ,sum(base_amount)/100    as base_amount
              from dwd.dwd_trade_short_video_payorder_view    -- 海剧的充值订单
             where dt >= '${bf_30_dt}'
               and dt<='${dt}'
               and create_time<date_sub(now(),interval 1 hour)
               and product_id = 6833 
               and test_flag = 0
               and status = 0    -- 正常订单
             group by 1,2,3,4,5,6,7,8,9
           )                                                        as a1
    join dwd.dwd_srsv_advertisement_koc_attribution_record_view     as a2    -- 订单关联归因表，确认归属koc的订单
      on if(a2.product_id=6833,2,1) = a1.project_type
     and a2.user_id= a1.user_id
     and a1.create_time >= a2.begin_time
     and a1.create_time < a2.end_time
    left join (
               -- 关联口令和达人信息表，获取口令和达人等信息
               select b1.koccode
                     ,b1.projecttype    as project_type
                     ,b3.userid         as institution_user_id
                     ,b1.dataid
                     ,b2.userid         as star_user_id
                 from ods.ods_tidb_koc_codeinfo           as b1
                 left join ods.ods_tidb_koc_starinfo      as b2
                   on b1.institutionid = b2.institutionid
                  and b1.starid = b2.id
                 left join ods.ods_koc_institutioninfo    as b3
                   on b1.institutionid = b3.id
              )                                                    as a3
      on a3.koccode = a2.koc_text
     and a3.dataid = a2.resource_id
    left join (
               -- 关联海阅、海剧维表，获取书名/剧名
               select 1    as project_type
                     ,book_id
                     ,book_name
                     ,languageid
                 from dim.dim_shuangwen_book_read_consume_info
                group by product_id,book_id,book_name,languageid
               union all
               select 2 as project_type
                     ,series_id      as book_id
                     ,series_name    as book_name
                     ,language       as languageid
                 from dim.dim_short_video_series_view
                group by series_id,series_name,language
              )                                                    as a4
      on a1.project_type=a4.project_type and a1.book_id = a4.book_id
    left join (select product_id
                     ,id                                    as user_id
                     ,create_time
                     ,coalesce(reg_country2,reg_country)    as reg_country
                 from dim.dim_user_account_info_view
                union all
                select product_id
                      ,user_id
                      ,create_time
                      ,reg_country
                  from dim.dim_short_video_user_accountinfo
              )                                                    as a5
      on a1.product_id = a5.product_id
     and a1.user_id = a5.user_id
   where date(a1.create_time)>='${bf_3_dt}'
     and a1.create_time>='2025-01-02'
   group by 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21
)
select a1.ref_order_id
      ,a1.status
      ,a1.dt
      ,a1.code
      ,a1.story_id
      ,a1.story_name
      ,a1.amount
      ,a1.base_amount
      ,a1.project_type
      ,a1.institution_user_id
      ,a1.star_user_id
      ,a1.create_time
      ,a1.etl_tm
      ,a1.core
      ,a1.current_language
      ,a1.user_id
      ,a1.mt
      ,a1.sub_pay_type
      ,a1.shop_item
      ,a1.activation_time
      ,a1.country
      ,case when a2.usr_id is not null then 1
            else 0
        end                              as is_anom_ord
  from koc_data                          as a1
  left join dim.dim_koc_anom_usr_info    as a2
    on a1.user_id = a2.usr_id
   and a2.anom_status_cd = 1
 where a1.core in (1,15)
;

-- 调度：KOC退款订单信息清洗
insert into ads.ads_srsv_trade_koc_payorderinfo_di
select a2.ref_order_id           as ref_order_id
      ,a1.status                 as status
      ,date(a1.create_time)      as dt
      ,a2.code                   as code
      ,a2.story_id               as story_id
      ,a2.story_name             as story_name
      ,a2.amount                 as amount
      ,a2.base_amount
      ,a2.project_type           as project_type -- 1:海阅 2：海剧
      ,a2.institution_user_id    as institution_user_id
      ,a2.star_user_id           as star_user_id
      ,a1.create_time            as create_time
      ,now()                     as etl_tm
      ,a2.core                   as core
      ,a2.current_language       as current_language
      ,a2.user_id
      ,a2.mt
      ,a2.sub_pay_type
      ,a2.shop_item
      ,a2.activation_time
      ,a2.country
      ,case when a3.usr_id is not null then 1
            else 0
        end                      as is_anom_ord
  from(
       -- 海阅的退款订单
       select ProductId              as product_id
             ,UserId                 as user_id
             ,OrderId                as order_id
             ,1                      as status
             ,1                      as project_type
             ,null                   as book_id
             ,refund_time            as create_time  -- 取退款时间
             ,sum(ItemCount)         as item_count
             ,sum(BaseAmount)/100    as base_amount
         from dwd.dwd_sr_trade_user_refund_order_di
        where dt>='${bf_30_dt}'
          and dt<='${dt}'
        group by 1 ,2 ,3 ,4 ,5,6,7
        union all
        -- 海剧的退款订单
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
              ,dt                      as create_time
              ,sum(item_count)         as item_count
              ,sum(base_amount)/100    as base_amount
          from dwd.dwd_trade_short_video_payorder_view
         where dt >= '${bf_30_dt}'
           and dt<='${dt}'
           and product_id = 6833
           and test_flag = 0
           and status = 1 -- 退款订单
         group by 1,2,3,4,5,6,7
      )                                          as a1
  join ads.ads_srsv_trade_koc_payorderinfo_di    as a2    -- 退款订单关联koc订单
    on a1.order_id = a2.ref_order_id
   and a2.status = 0
  left join dim.dim_koc_anom_usr_info            as a3    -- 异常用户
    on a1.user_id = a3.usr_id
   and a3.anom_status_cd = 1
 where date(a1.create_time) >= '${bf_3_dt}'
;