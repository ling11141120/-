----------------------------------------------------------------
-- 程序功能： 海阅海剧koc用户回收数据结果表
-- 程序名： P_ads_srsv_ads_koc_attribution_result_data
-- 目标表： ads.ads_srsv_ads_koc_attribution_result_data
-- 负责人： qhr
-- 开发日期： 2025-09-11
-- 版本号： v1.0.0
----------------------------------------------------------------

insert into ads.ads_srsv_ads_koc_attribution_result_data
-- koc广告归因用户
with koc_ad_attr_user as (
    select a1.product_id
          ,a1.dt
          ,a1.ad_id
          ,a1.user_id
          ,if(minutes_diff(a4.create_time, a2.create_time) < 1440, 1, 0)     as is_new_user
          ,a1.begin_time
          ,a1.end_time
          ,a1.resource_id
          ,a1.create_time
          ,a1.koc_text
          ,a3.InstitutionId                                                  as institution_id
          ,a3.StarId                                                         as star_id
          ,case when a1.diff_time = 10080 and a1.end_time1 <= a1.end_time2 then a1.end_time1
                when a1.diff_time = 10080 and a1.end_time1 >  a1.end_time2 then a1.end_time2
                else a1.end_time
            end                                                              as end_time_14d
          ,a1.is_anom_user
      from (select b1.product_id
                  ,b1.user_id
                  ,date(b1.begin_time)                                       as dt
                  ,b1.ad_id
                  ,b1.begin_time
                  ,b1.end_time
                  ,b1.resource_id
                  ,b1.koc_text
                  ,case when b2.user_id is not null then 1
                        else 0
                    end                                                      as is_anom_user    -- 是否异常用户
                  ,min(b1.create_time)                                       as create_time
                  ,minutes_diff(b1.end_time, b1.begin_time)                  as diff_time
                  ,datediff(b1.end_time, b1.begin_time)
                  ,lead(b1.begin_time, 1, '2099-01-01 00:00:00')
                   over (partition by b1.product_id, b1.user_id
                             order by b1.begin_time, b1.end_time
                        )                                                    as end_time1
                  ,date_add(b1.begin_time, interval 14 day)                  as end_time2
              from dwd.dwd_srsv_advertisement_koc_attribution_record_view    as b1
              left join dim.dim_koc_anom_user_info                           as b2
                on b1.user_id = b2.user_id
             where b1.begin_time >= '${bf_30_dt}'
             group by 1, 2, 3, 4, 5, 6, 7, 8, 9
           )                                                                 as a1
      left join (select product_id                                           as product_id
                       ,id                                                   as user_id
                       ,create_time                                          as create_time
                   from dim.dim_user_account_info_view
                  where dt > '${bf_30_dt}'
                  union all
                 select product_id                                           as product_id
                       ,user_id                                              as user_id
                       ,create_time                                          as create_time
                   from dim.dim_short_video_user_accountinfo
                  where dt > '${bf_30_dt}'
                )                                                            as a2
        on a1.product_id = a2.product_id
       and a1.user_id = a2.user_id
      left join ods.ods_tidb_koc_codeinfo                                    as a3
        on a1.koc_text = a3.KocCode
      left join (select product_id
                       ,user_id
                       ,ad_id
                       ,date(begin_time)                                     as dt
                       ,min(create_time)                                     as create_time
                   from dwd.dwd_srsv_advertisement_koc_attribution_record_view
                  where begin_time >= '${bf_30_dt}' 
                  group by 1, 2, 3, 4
                )                                                            as a4
        on a1.dt = a4.dt
       and a1.product_id = a4.product_id
       and a1.user_id = a4.user_id
       and a1.ad_id = a4.ad_id
)
-- 活跃用户统计
, active_user as (
    select a1.product_id
          ,a1.dt
          ,a1.ad_id
          ,count(distinct a1.user_id)                                  as dev_unt
          ,count(distinct if(a1.is_new_user = 1, a1.user_id, null))    as new_dev_unt
          ,count(distinct if(a1.is_new_user = 0, a1.user_id, null))    as active_dev_unt
      from koc_ad_attr_user    as a1
     group by 1, 2, 3
)
-- 30天广告归因用户与作品信息
, dt_attr_user_book as (
    select a2.datestr                                                                         as dt
          ,a1.product_id
          ,a1.user_id
          ,a1.resource_id
          ,a1.begin_time
          ,a1.end_time
          ,a1.end_time_14d
          ,a1.ad_id
          ,cast(substring_index(substring_index(a1.ad_id, 'Mt=', -1), '|', 1) as int)         as mt
          ,cast(substring_index(substring_index(a1.ad_id, 'Chl2=', -1), '|', 1) as string)    as chl
          ,ifnull( a3.languageid
                  ,cast(substring_index(substring_index(a1.ad_id, 'CurrentLanguage2=', -1), '|', 1) as int)
                 )    as current_language
          ,cast(substring_index(substring_index(a1.ad_id, 'Core=', -1), '|', 1) as int)       as core
          ,a1.koc_text
          ,date(a1.create_time)                                                               as user_dt
          ,a1.is_new_user
          ,a1.is_anom_user
      from koc_ad_attr_user     as a1
      left join dim.dim_date    as a2
        on a2.datestr >= '${bf_30_dt}'
       and a2.datestr <= '${dt}'
      left join (select 6833         as product_id
                       ,series_id    as book_id
                       ,language     as languageid
                   from dim.dim_short_video_series_view
                  union all
                 select product_id
                       ,book_id
                       ,languageid
                   from dim.dim_shuangwen_book_read_consume_info
                )               as a3
        on a1.product_id = a3.product_id
       and a1.resource_id = a3.book_id
)
-- 海阅海剧koc充值订单
, srsv_koc_payord as (
    select a1.dt
          ,a1.ProductId              as product_id
          ,a1.UserId                 as user_id
          ,cast(substring_index(substring_index(substring_index(substring_index(substring_index(a1.packageid, '|', 1)
                                                                                , 'Ps_Half_', -1
                                                                               )
                                                                , 'Ps_Shop_half_', -1
                                                               )
                                                , '_', 1
                                               )
                                , '_', -1
                               ) as int
               )                     as book_id
          ,a1.CreateTime             as create_time
          ,a1.OrderId                as order_id
          ,sum(a1.ItemCount)         as item_count
          ,sum(a1.BaseAmount)/100    as base_amount
      from dwd.dwd_sr_user_koc_payorder_view          as a1    -- 海阅koc充值订单
     where a1.dt >= '${bf_30_dt}'
       and a1.dt <= '${dt}'
       and a1.CreateTime < date_sub(now(), interval 1 hour)
     group by 1, 2, 3, 4, 5, 6
     union all
    select a2.dt
          ,a2.product_id
          ,a2.user_id
          ,cast(substring_index(substring_index(substring_index(a2.package_id, 'Ps_Half_', -1)
                                                , '_', 1
                                               )
                                , '_', -1
                               ) as int
               )                      as book_id
          ,a2.create_time
          ,a2.order_id
          ,sum(a2.item_count)         as item_count
          ,sum(a2.base_amount)/100    as base_amount
      from dwd.dwd_trade_short_video_payorder_view    as a2    -- 海剧koc充值订单
     where a2.dt >= '${bf_30_dt}'
       and a2.dt <= '${dt}'
       and a2.create_time < date_sub(now(), interval 1 hour)
       and a2.product_id = 6833
       and a2.test_flag = 0
       and a2.status = 0    -- 正常订单
     group by 1, 2, 3, 4, 5, 6
)
-- 用户作品维度信息关联上koc订单广告收益事实
, attr_user_book_payord_adamt as (
    select a1.dt
          ,a1.product_id
          ,a1.ad_id
          ,a1.resource_id
          ,a1.mt
          ,a1.core
          ,a1.chl
          ,a1.current_language
          ,a1.koc_text
          ,sum(case when a2.create_time < a1.end_time then a2.item_count else 0 end)                             as item_count
          ,sum(case when a2.create_time < a1.end_time and a1.is_new_user = 1 then a2.item_count else 0 end)      as new_koc_amt
          ,sum(case when a2.create_time < a1.end_time and a1.is_new_user = 0 then a2.item_count else 0 end)      as active_koc_amt
          ,sum(case when a2.create_time < a1.end_time then a2.base_amount else 0 end)                            as base_amount
          ,sum(case when a2.create_time < a1.end_time and a1.is_new_user = 1 then a2.base_amount else 0 end)     as new_koc_amt_after
          ,sum(case when a2.create_time < a1.end_time and a1.is_new_user = 0 then a2.base_amount else 0 end)     as active_koc_amt_after
          ,sum(case when a2.create_time < a1.end_time_14d then a2.item_count else 0 end)                         as item_count_14d
          ,sum(case when a2.create_time < a1.end_time_14d then a2.base_amount else 0 end)                        as base_amount_14d
          ,count(case when a2.create_time < a1.end_time then a2.order_id else null end)                          as order_id
          ,0                                                                                                     as ad_amt
          ,0                                                                                                     as ad_amt_14d
          ,sum(case when a2.create_time < a1.end_time and a1.is_anom_user = 1 then a2.item_count else 0 end)     as anom_amt
          ,sum(case when a2.create_time < a1.end_time and a1.is_anom_user = 1 then a2.base_amount else 0 end)    as ded_chl_anom_amt
      from dt_attr_user_book                                    as a1
      left join srsv_koc_payord                                 as a2
        on a1.dt = a2.dt
       and a1.product_id = a2.product_id
       and a1.user_id = a2.user_id
       and a2.create_time >= a1.begin_time
       and a2.create_time <= a1.end_time_14d
     where a1.begin_time >= '${bf_30_dt}'
     group by 1, 2, 3, 4, 5, 6, 7, 8, 9
     union all
    select a3.dt
          ,a3.product_id
          ,a3.ad_id
          ,a3.resource_id
          ,a3.mt
          ,a3.core
          ,a3.chl
          ,a3.current_language
          ,a3.koc_text
          ,0                                                                                   as item_count
          ,0                                                                                   as new_koc_amt
          ,0                                                                                   as active_koc_amt
          ,0                                                                                   as base_amount
          ,0                                                                                   as new_koc_amt_after
          ,0                                                                                   as active_koc_amt_after
          ,0                                                                                   as item_count_14d
          ,0                                                                                   as base_amount_14d
          ,0                                                                                   as order_id
          ,sum(case when a4.create_tm < a3.end_time then a4.ad_position_amt else 0 end)        as ad_amt
          ,sum(case when a4.create_tm < a3.end_time_14d then a4.ad_position_amt else 0 end)    as ad_amt_14d
          ,0                                                                                   as anom_amt
          ,0                                                                                   as ded_chl_anom_amt
      from dt_attr_user_book                                    as a3
      left join dwd.dwd_advertisement_user_position_amt_p_di    as a4
        on a4.dt >= '${bf_30_dt}'
       and a4.dt <= '${dt}'
       and a4.dt >= '2025-08-01'
       and a3.dt = a4.dt
       and a3.product_id = a4.product_id
       and a3.user_id = a4.user_id
       and a4.create_tm >= a3.begin_time
       and a4.create_tm < a3.end_time_14d
     where a3.begin_time >= '${bf_30_dt}'
     group by 1, 2, 3, 4, 5, 6, 7, 8, 9
)
select a1.dt                                  as dt                      -- 统计日期
      ,a1.product_id                          as product_id              -- 产品id
      ,a1.ad_id                               as adid                    -- koc的广告ID
      ,max(a3.p_cd_val)                       as project_tp              -- 产品类型
      ,max(a1.resource_id)                    as book_id                 -- 书籍id
      ,max(a1.mt)                             as mt                      -- 终端
      ,max(a1.core)                           as core                    -- Core
      ,'koc'                                  as source_chl              -- 媒体
      ,max(a1.chl)                            as chl                     -- 渠道
      ,max(a1.current_language)               as current_language        -- 投放语言
      ,max(a1.koc_text)                       as koc_code                -- 口令
      ,coalesce(max(a2.dev_unt), 0)           as dev_unt                 -- 激活用户数
      ,coalesce(max(a2.new_dev_unt), 0)       as new_dev_unt             -- 激活新用户数
      ,coalesce(max(a2.active_dev_unt), 0)    as active_dev_unt          -- 激活活跃用户数
      ,count(a1.order_id)                     as order_num               -- 订单数
      ,sum(a1.item_count)                     as koc_amt                 -- 充值金额
      ,sum(a1.new_koc_amt)                    as new_koc_amt             -- 激活新用户充值金额
      ,sum(a1.active_koc_amt)                 as active_koc_amt          -- 激活活跃用户充值金额
      ,sum(a1.base_amount)                    as koc_amt_after           -- 扣除渠道费之后的充值金额
      ,sum(a1.new_koc_amt_after)              as new_koc_amt_after       -- 激活新用户扣除渠道费之后的充值金额
      ,sum(a1.active_koc_amt_after)           as active_koc_amt_after    -- 激活活跃用户扣除渠道费之后的充值金额
      ,sum(a1.item_count_14d)                 as koc_amt_14d             -- 充值金额
      ,sum(a1.base_amount_14d)                as koc_amt_after_14d       -- 扣除渠道费之后的充值金额
      ,sum(a1.ad_amt)                         as ad_amt                  -- 广告收入
      ,now()                                  as etl_tm                  -- 清洗时间
      ,sum(a1.anom_amt)                       as anom_amt                -- 异常充值金额
      ,sum(a1.ded_chl_anom_amt)               as ded_chl_anom_amt        -- 扣除通道费异常充值金额
  from attr_user_book_payord_adamt            as a1
  left join active_user                       as a2
    on a1.dt = a2.dt
   and a1.product_id = a2.product_id
   and a1.ad_id = a2.ad_id
  left join dim.dim_pub_code_mapping_dict     as a3
    on a1.product_id = a3.cd_val
   and a3.app_plat = 'pub'
   and a3.cd_col = 'product_id'
 where a1.dt >= '${bf_3_dt}'
   and (    (    a1.dt >= '2024-12-11' 
              and a1.dt < '2024-12-14'
             )
          or a1.dt >= '2025-01-02'
        )
   and a1.core in (1, 15)
 group by 1, 2, 3
;