----------------------------------------------------------------
-- 程序功能： KOC订单信息
-- 程序名： P_ads_srsv_trade_koc_payorderinfo_di
-- 目标表： ads.ads_srsv_trade_koc_payorderinfo_di
-- 负责人： qhr
-- 开发日期： 2025-09-08
-- 版本号： v0.2.0
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
          ,a1.reg_dev_id                                                                                                   as reg_dev_id      -- 注册时设备id
          ,a1.reg_ip                                                                                                       as reg_ip          -- 注册IP
      from (select b1.productid              as product_id
                  ,b1.userid                 as user_id
                  ,b1.orderid                as order_id
                  ,0                         as status
                  ,1                         as project_type
                  ,cast(substring_index(substring_index(substring_index(substring_index(substring_index(packageid,'|',1)
                                                                                        , 'Ps_Half_', -1
                                                                                       )
                                                                        ,'Ps_Shop_half_',-1
                                                                       )
                                                        , '_', 1
                                                       )
                                        , '_', -1
                                       ) as int
                       )                     as book_id
                  ,b1.createtime             as create_time
                  ,b1.subpaytype             as sub_pay_type
                  ,b1.shopitem               as shop_item
                  ,b2.unique_cdreader_id     as reg_dev_id    -- 注册时设备id
                  ,b2.reg_ip                 as reg_ip        -- 注册IP
                  ,sum(b1.itemcount)         as item_count
                  ,sum(b1.baseamount)/100    as base_amount
              from dwd.dwd_sr_user_koc_payorder_view      as b1    -- 海阅的充值订单
              left join dim.dim_user_account_info_view    as b2
                on b1.userid = b2.id
             where b1.dt>='${bf_30_dt}'
               and b1.dt<='${dt}'
               and b1.createtime < date_sub(now(),interval 1 hour)
             group by 1,2,3,4,5,6,7,8,9,10,11
             union all
            select b3.product_id
                  ,b3.user_id
                  ,b3.order_id
                  ,b3.status
                  ,2                          as project_type
                  ,cast(substring_index(substring_index(substring_index(b3.package_id, 'Ps_Half_', -1)
                                                        , '_', 1
                                                       )
                                        , '_', -1
                                       ) as int
                       )                   as book_id
                  ,b3.create_time
                  ,b3.subpay_type             as sub_pay_type
                  ,b3.shop_item
                  ,b4.unique_cdreader_id      as reg_dev_id    -- 注册时设备id
                  ,b4.ip                      as reg_ip        -- 注册IP
                  ,sum(b3.item_count)         as item_count 
                  ,sum(b3.base_amount)/100    as base_amount
              from dwd.dwd_trade_short_video_payorder_view      as b3    -- 海剧的充值订单
              left join dim.dim_short_video_user_accountinfo    as b4
                on b3.user_id = b4.user_id
             where b3.dt >= '${bf_30_dt}'
               and b3.dt<='${dt}'
               and b3.create_time<date_sub(now(),interval 1 hour)
               and b3.product_id = 6833 
               and b3.test_flag = 0
               and b3.status = 0    -- 正常订单
             group by 1,2,3,4,5,6,7,8,9,10,11
           )                                                        as a1
    join dwd.dwd_srsv_advertisement_koc_attribution_record_view     as a2    -- 订单关联归因表，确认归属koc的订单
      on if(a2.product_id=6833,2,1) = a1.project_type
     and a2.user_id= a1.user_id
     and a1.create_time >= a2.begin_time
     and a1.create_time < a2.end_time
    left join (
               -- 关联口令和达人信息表，获取口令和达人等信息
               select b5.koccode
                     ,b5.projecttype    as project_type
                     ,b7.userid         as institution_user_id
                     ,b5.dataid
                     ,b6.userid         as star_user_id
                 from ods.ods_tidb_koc_codeinfo           as b5
                 left join ods.ods_tidb_koc_starinfo      as b6
                   on b5.institutionid = b6.institutionid
                  and b5.starid = b6.id
                 left join ods.ods_koc_institutioninfo    as b7
                   on b5.institutionid = b7.id
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
   group by 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23
)
select a1.ref_order_id                   as ref_order_id           -- 订单号
      ,a1.status                         as status                 -- 订单状态
      ,a1.dt                             as dt                     -- 日期
      ,a1.code                           as code                   -- 口令词
      ,a1.story_id                       as story_id               -- 故事
      ,a1.story_name                     as story_name             -- 故事名称
      ,a1.amount                         as amount                 -- 金额数
      ,a1.base_amount                    as base_amount            -- 分成后金额数
      ,a1.project_type                   as project_type           -- 项目类型
      ,a1.institution_user_id            as institution_user_id    -- 机构用户
      ,a1.star_user_id                   as star_user_id           -- 达人用户
      ,a1.create_time                    as create_time            -- 创建时间
      ,a1.etl_tm                         as etl_time               -- etl清洗时间
      ,a1.core                           as core                   -- core
      ,a1.current_language               as current_language       -- 投放语言
      ,a1.user_id                        as user_id                -- 用户id
      ,a1.mt                             as mt                     -- mt
      ,a1.sub_pay_type                   as sub_pay_type           -- 支付方式
      ,a1.shop_item                      as shop_item              -- 权益类型
      ,a1.activation_time                as activation_time        -- 激活时间
      ,a1.country                        as country                -- 国家
      ,case when a2.user_id is not null then 1
            else 0
        end                              as is_anom_ord            -- 是否异常订单
      ,a1.reg_dev_id                     as reg_dev_id             -- 注册时设备id
      ,a1.reg_ip                         as reg_ip                 -- 注册IP
  from koc_data                          as a1
  left join dim.dim_koc_anom_user_info    as a2
    on a1.user_id = a2.user_id
   and a2.anom_status_cd = 1
 where a1.core in (1,15)
;

-- KOC退款订单信息清洗
insert into ads.ads_srsv_trade_koc_payorderinfo_di
select a2.ref_order_id           as ref_order_id           -- 订单号
      ,a1.status                 as status                 -- 订单状态
      ,date(a1.create_time)      as dt                     -- 日期
      ,a2.code                   as code                   -- 口令词
      ,a2.story_id               as story_id               -- 故事
      ,a2.story_name             as story_name             -- 故事名称
      ,a2.amount                 as amount                 -- 金额数
      ,a2.base_amount            as base_amount            -- 分成后金额数
      ,a2.project_type           as project_type           -- 项目类型
      ,a2.institution_user_id    as institution_user_id    -- 机构用户
      ,a2.star_user_id           as star_user_id           -- 达人用户
      ,a1.create_time            as create_time            -- 创建时间
      ,now()                     as etl_time               -- etl清洗时间
      ,a2.core                   as core                   -- core
      ,a2.current_language       as current_language       -- 投放语言
      ,a2.user_id                as user_id                -- 用户id
      ,a2.mt                     as mt                     -- mt
      ,a2.sub_pay_type           as sub_pay_type           -- 支付方式
      ,a2.shop_item              as shop_item              -- 权益类型
      ,a2.activation_time        as activation_time        -- 激活时间
      ,a2.country                as country                -- 国家
      ,case when a3.user_id is not null then 1
            else 0
        end                      as is_anom_ord            -- 是否异常订单
      ,a1.reg_dev_id             as reg_dev_id             -- 注册时设备id
      ,a1.reg_ip                 as reg_ip                 -- 注册IP
  from (select b1.ProductId              as product_id
              ,b1.UserId                 as user_id
              ,b1.OrderId                as order_id
              ,1                         as status
              ,1                         as project_type
              ,null                      as book_id
              ,b1.refund_time            as create_time          -- 取退款时间
              ,b2.unique_cdreader_id     as reg_dev_id
              ,b2.reg_ip                 as reg_ip
              ,sum(b1.ItemCount)         as item_count
              ,sum(b1.BaseAmount)/100    as base_amount
          from dwd.dwd_sr_trade_user_refund_order_di    as b1    -- 海阅的退款订单
          left join dim.dim_user_account_info_view      as b2
            on b1.UserId = b2.id
         where b1.dt>='${bf_30_dt}'
           and b1.dt<='${dt}'
         group by 1,2,3,4,5,6,7,8,9
         union all
         select b3.product_id              as product_id
               ,b3.user_id                 as user_id
               ,b3.order_id                as order_id
               ,b3.status                  as status
               ,2                          as project_type
               ,cast(substring_index(substring_index(substring_index(b3.package_id, 'Ps_Half_', -1)
                                                     , '_', 1
                                                    )
                                     , '_', -1
                                    ) as int
                    )                      as book_id
               ,b3.dt                      as create_time
               ,b4.unique_cdreader_id      as reg_dev_id
               ,b4.ip                      as reg_ip
               ,sum(b3.item_count)         as item_count
               ,sum(b3.base_amount)/100    as base_amount
           from dwd.dwd_trade_short_video_payorder_view      as b3    -- 海剧的退款订单
           left join dim.dim_short_video_user_accountinfo    as b4
             on b3.user_id = b4.user_id
          where b3.dt >= '${bf_30_dt}'
            and b3.dt <= '${dt}'
            and b3.product_id = 6833
            and b3.test_flag = 0
            and b3.status = 1    -- 退款订单
          group by 1,2,3,4,5,6,7,8,9
       )                                          as a1
  join ads.ads_srsv_trade_koc_payorderinfo_di     as a2    -- 退款订单关联koc订单
    on a1.order_id = a2.ref_order_id
   and a2.status = 0
  left join dim.dim_koc_anom_user_info             as a3    -- 异常用户
    on a1.user_id = a3.user_id
   and a3.anom_status_cd = 1
 where date(a1.create_time) >= '${bf_3_dt}'
;