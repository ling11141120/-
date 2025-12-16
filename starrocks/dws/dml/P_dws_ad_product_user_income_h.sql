----------------------------------------------------------------
-- 程序功能： 广告域-产品用户广告收益-小时统计
-- 程序名： P_dws_ad_product_user_income_h
-- 目标表： dws.dws_ad_product_user_income_h
-- 负责人： qhr
-- 开发日期： 2025-11-23
----------------------------------------------------------------

insert into dws.dws_ad_product_user_income_h
-- 阅读及海剧-分广告类型、位置用户粒度广告展现收益表（海外短剧暂时没有分位置）
with ad_click_count as (
    -- 海阅每日H5点击
    select date_trunc('hour', date_sub(ctcv.event_tm, interval 13 hour))    as dt
         , ctcv.app_product_id                                              as product_id
         , ctcv.login_id                                                    as user_id
         , ctcv.app_core_ver                                                as core
         , ctcv.mt                                                          as mt
         , ctcv.ad_src                                                      as ads_src
         , 2                                                                as system_type
         , count(1)                                                         as ad_click_count
      from dwd.dwd_sensors_production_complete_task_click_view    as ctcv
     where ctcv.event_tm >= date_add('${bf_1_dt}', interval 13 hour)
       and ctcv.event_tm < '${af_1_dt}'
       and ctcv.element_id = '100772'
       and ctcv.type = '121'
       and ctcv.ad_src is not null
     group by 1, 2, 3, 4, 5, 6
     union all
    select date_trunc('hour', date_sub(ecv.event_tm, interval 13 hour))    as dt
         , ecv.app_product_id                                              as product_id
         , ecv.login_id                                                    as user_id
         , ecv.app_core_ver                                                as core
         , ecv.mt                                                          as mt
         , ecv.ad_src                                                      as ads_src
         , 2                                                               as system_type
         , count(1)                                                        as ad_click_count
      from dwd.dwd_sensors_production_element_click_view          as ecv
     where ecv.event_tm >= date_add('${bf_1_dt}', interval 13 hour)
       and ecv.event_tm < '${af_1_dt}'
       and ecv.element_id = '100356'
       and ecv.ad_position_id > 0
       and ecv.app_product_id is not null
       and ecv.ad_src is not null
     group by 1, 2, 3, 4, 5, 6
     union all
    -- 海剧每日H5点击
    select date_trunc('hour', date_sub(adpc.event_tm, interval 13 hour))    as dt
         , adpc.product_id                                                  as product_id
         , adpc.user_id                                                     as user_id
         , adpc.core                                                        as core
         , adpc.mt                                                          as mt
         , adpc.ad_src                                                      as ads_src
         , 1                                                                as system_type
         , count(1)                                                         as ad_click_count
      from dwd.dwd_sensors_production_adpositionclick_view        as adpc
      left join dim.dim_sv_ads_position_view                      as dvap
        on adpc.ad_position_id = dvap.ad_position
     where adpc.event_tm >= date_add('${bf_1_dt}', interval 13 hour)
       and adpc.event_tm < '${af_1_dt}'
       and adpc.ad_type = 6
       and adpc.product_id = 6833
       and adpc.ad_src is not null
     group by 1, 2, 3, 4, 5, 6
     union all
    -- 三方
    select date_trunc('hour', date_sub(ctcv.event_tm, interval 13 hour))    as dt
         , 6833                                                             as product_id
         , ctcv.login_id                                                    as user_id
         , ctcv.corever                                                     as core
         , ctcv.mt                                                          as mt
         , ctcv.ad_src                                                      as ads_src
         , 1                                                                as system_type
         , count(1)                                                         as ad_click_count
      from dwd.dwd_sensors_production_complete_task_click_view    as ctcv
     where ctcv.event_tm >= date_add('${bf_1_dt}', interval 13 hour)
       and ctcv.event_tm < '${af_1_dt}'
       and ctcv.task_type in('9', '浏览第三方页面')
       and ctcv.app_product_id is null
       and length(ctcv.ad_src)>=1
     group by 1, 2, 3, 4, 5, 6
)
-- 统计每日H5总收益
, avg_click_amount as (
    select accsum.dt                                                                as dt
         , accsum.system_type                                                       as system_type
         , accsum.ads_name                                                          as ads_name
         , sum(accsum.ad_click_count)                                               as ad_click_count
         , sum(h5rev.revenue_share)                                                 as ad_amt
         , round(sum(h5rev.revenue_share)/sum(accsum.ad_click_count),4)             as ad_avg_click_amt
      from (select acc.dt                                                           as dt
                 , acc.system_type                                                  as system_type
                 , acc.ads_src                                                      as ads_name
                 , sum(ad_click_count)                                              as ad_click_count
              from ad_click_count                                                   as acc
             group by 1, 2, 3
           )                                                                        as accsum
      left join (select date_trunc('hour', date_sub(adiv.day, interval 13 hour))    as dt
                      , adiv.system_type                                            as system_type
                      , 4                                                           as ads_name
                      , sum(adiv.revenue_share)                                     as revenue_share
                   from dim.dim_sv_ad_advertise_info_view                           as adiv
                  where adiv.day >= date_add('${bf_1_dt}', interval 13 hour)
                    and adiv.day < '${af_1_dt}'
                  group by 1, 2, 3
                  union all
                 select date_trunc('hour', date_sub(mbk.Date, interval 13 hour))    as dt
                      , mbkap.system_type                                           as system_type
                      , 5                                                           as ads_name
                      , sum(mbk.SubNetRevenue)                                      as revenue_share
                   from ods.ods_tidb_mobkingaddata                                  as mbk
                   left join dim.dim_ad_mobking_appid                               as mbkap
                     on mbk.Appid = mbkap.app_id
                  where mbk.Date >= date_add('${bf_1_dt}', interval 13 hour)
                    and mbk.Date < '${af_1_dt}'
                  group by 1, 2, 3
                  union all
                 select date_trunc('hour', date_sub(srg.Date, interval 13 hour))    as dt
                      , case when srg.UrlName = 'moboreels' then 1
                             when srg.UrlName = 'moboreader' then 2
                         end                                                        as system_type
                      , 6                                                           as ads_name
                      , sum(srg.RevenueNet)                                         as revenue_share
                   from ods.ods_tidb_SurgeAdData                                    as srg
                  where srg.Date >= date_add('${bf_1_dt}', interval 13 hour)
                    and srg.Date < '${af_1_dt}'
                    and srg.UrlName in('moboreels','moboreader')
                  group by 1, 2, 3
                  union all
                  select date_trunc('hour', date_sub(ffi.day, interval 13 hour))    as dt
                      , ffi.system_type                                             as system_type
                      , 7                                                           as ads_name
                      , sum(ffi.income)                                             as revenue_share
                   from ods.ods_tidb_short_video_log_firefly_income_report          as ffi
                  where ffi.day >= date_add('${bf_1_dt}', interval 13 hour)
                    and ffi.day < '${af_1_dt}'
                  group by 1, 2, 3
                  union all
                  select date_trunc('hour', date_sub(sjy.dt, interval 13 hour))     as dt
                      , case when sjy.ProjectType = 1 then 2
                             when sjy.ProjectType = 2 then 1
                             else sjy.ProjectType
                         end                                                        as system_type
                      , 8                                                           as ads_name
                      , sum(sjy.revenue)                                            as revenue_share
                    from ods.ods_tidb_readernovel_tidb_xx_synjoyaddata              as sjy
                   where sjy.dt >= date_add('${bf_1_dt}', interval 13 hour)
                     and sjy.dt < '${af_1_dt}'
                   group by 1, 2, 3
                )                                                                   as h5rev
        on accsum.dt = h5rev.dt
       and accsum.system_type = h5rev.system_type
       and accsum.ads_name = h5rev.ads_name
     group by 1, 2, 3
)
, user_info_tmp as (
    select usif.product_id
         , usif.user_id
         , usif.corever
         , usif.mt
      from (select vuser.product_id            as product_id
                 , vuser.user_id               as user_id
                 , vuser.corever               as corever
                 , vuser.mt                    as mt
              from dim.dim_short_video_user_accountinfo    as vuser    -- 海剧用户信息
             union all
            select 6883                        as product_id
                 , cnuser.account              as user_id
                 , cnuser.corever2             as corever
                 , cnuser.mt2                  as mt
              from dim.dim_video_cn_accountinfo_view       as cnuser    -- 国剧用户信息
             union all
            select ruser.product_id            as product_id
                 , ruser.id                    as user_id
                 , ruser.corever               as corever
                 , ruser.mt                    as mt
             from dim.dim_user_account_info_view           as ruser     --  海阅用户信息
           )                                               as usif
)
select maind.dt                                 as dt            -- 日期
     , maind.product_id                         as product_id    -- 产品id
     , coalesce(maind.corever, usif.corever)    as corever       -- core
     , coalesce(maind.mt, usif.mt)              as mt            -- 平台
     , maind.user_id                            as user_id       -- 用户id
     , maind.ads_name                           as ads_name      -- 广告来源
     , sum(maind.amount)                        as amount        -- 广告收益
     , now()                                    as etl_tm        -- 清洗时间
  from (select date_trunc('hour', date_sub(aupap.create_tm,interval 13 hour))    as dt
             , aupap.product_id                                                  as product_id
             , aupap.corever                                                     as corever
             , aupap.mt                                                          as mt
             , aupap.user_id                                                     as user_id
             , aupap.ads_name                                                    as ads_name
             , sum(aupap.ad_position_amt)                                        as amount
          from dwd.dwd_advertisement_user_position_amt_p_di                      as aupap
         where aupap.create_tm >= date_add('${bf_1_dt}', interval 13 hour)
           and aupap.create_tm < '${af_1_dt}'
         group by 1, 2, 3, 4, 5, 6
         union all
        -- 新增position_id=59 的数据
        select acc.dt                                                            as dt
             , acc.product_id                                                    as product_id
             , acc.core                                                          as core
             , case when lower(acc.mt) = 'ios' then 1
                    when lower(acc.mt) = 'android' then 4
                    else acc.mt
                end                                                              as mt
             , acc.user_id                                                       as user_id
             , dic.cd_val_desc                                                   as ads_name
             , sum(acc.ad_click_count) * max(aca.ad_avg_click_amt)               as amount
          from ad_click_count                                  as acc
          left join avg_click_amount                           as aca
            on acc.dt = aca.dt
           and acc.system_type = aca.system_type
           and acc.ads_src = aca.ads_name
          left join dim.dim_pub_code_mapping_dict              as dic
            on acc.ads_src = dic.cd_val
           and dic.app_plat = 'pub'
           and dic.cd_col = 'ad_src'
         where acc.user_id is not null
         group by 1, 2, 3, 4, 5, 6
       )                                                       as maind
  left join user_info_tmp                                      as usif
    on maind.product_id = usif.product_id
   and maind.user_id = usif.user_id
 group by 1, 2, 3, 4, 5, 6
;