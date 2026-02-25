----------------------------------------------------------------
-- 程序功能： 海剧-广告触达到播放转化报表-广告转化明细
-- 程序名： P_ads_sv_ad_conversion_detail
-- 目标表： ads.ads_sv_ad_conversion_detail
-- 负责人： xjc
-- 开发日期：2026-01-05
-- 版本号： v0.0.1
----------------------------------------------------------------

insert into ads.ads_sv_ad_conversion_detail
with adrequest as (
    select dt
          ,ad_show_type
          ,ad_show_type_name
          ,ad_position_id
          ,ad_position_name
          ,ad_id
          ,core
          ,mt
          ,language_id
          ,reg_country
          ,project_id
          ,count(1)    as ad_request_pv
          ,count(case when request_result = 'success' then 1
                      else null
                  end
                )      as ad_request_success_pv
      from dws.dws_ad_srsv_ad_position_request_df
     where dt = '${bf_1_dt}'
       and ad_position_id != '0'
       and event_name = 'ADRequest'
     group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11
)
, adinvocation as (
    select dt
          ,ad_show_type
          ,ad_show_type_name
          ,ad_position_id
          ,ad_position_name
          ,ad_id
          ,core
          ,mt
          ,language_id
          ,reg_country
          ,project_id
          ,count(1)    as ad_invocation_pv
      from dws.dws_ad_srsv_ad_position_request_df
     where dt = '${bf_1_dt}'
       and ad_position_id != '0'
       and event_name = 'ADInvocation'
     group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11
)
, adshow as (
    select dt
          ,ad_show_type
          ,ad_show_type_name
          ,ad_position_id
          ,ad_position_name
          ,ad_id
          ,core
          ,mt
          ,language_id
          ,reg_country
          ,project_id
          ,count(1)                 as ad_show_success_pv
          ,sum(request_duration)    as total_show_duration
      from dws.dws_ad_srsv_ad_position_request_df
     where dt = '${bf_1_dt}'
       and ad_position_id != '0'
       and event_name = 'ADShow'
     group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11
)
, adtrigger as (
    select dt
          ,ad_show_type
          ,ad_show_type_name
          ,ad_position_id
          ,ad_position_name
          ,ad_id
          ,core
          ,mt
          ,language_id
          ,reg_country
          ,project_id
          ,count(1)    as ad_show_fail_pv
      from dws.dws_ad_srsv_ad_position_request_df
     where dt = '${bf_1_dt}'
       and ad_position_id != '0'
       and event_name = 'ADTrigger'
     group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11
)
, union_result as (
    select dt
          ,ad_show_type
          ,ad_show_type_name
          ,ad_position_id
          ,ad_position_name
          ,ad_id
          ,core
          ,mt
          ,language_id
          ,reg_country
          ,project_id
      from adrequest
     union
    select dt
          ,ad_show_type
          ,ad_show_type_name
          ,ad_position_id
          ,ad_position_name
          ,ad_id
          ,core
          ,mt
          ,language_id
          ,reg_country
          ,project_id
      from adinvocation
     union
    select dt
          ,ad_show_type
          ,ad_show_type_name
          ,ad_position_id
          ,ad_position_name
          ,ad_id
          ,core
          ,mt
          ,language_id
          ,reg_country
          ,project_id
      from adshow
     union
    select dt
          ,ad_show_type
          ,ad_show_type_name
          ,ad_position_id
          ,ad_position_name
          ,ad_id
          ,core
          ,mt
          ,language_id
          ,reg_country
          ,project_id
      from adtrigger
)
select a1.dt                            as dt                       -- 日期
      ,md5(concat_ws('_'
          ,ifnull(a1.project_id, '')
          ,ifnull(a1.ad_show_type, '')
          ,ifnull(a1.ad_position_id, '')
          ,ifnull(a1.ad_id, '')
          ,ifnull(a1.core, '')
          ,ifnull(a1.mt, '')
          ,ifnull(a1.language_id, '')
          ,ifnull(a1.reg_country, '')
                    )
          )                             as md5_key                  -- md5_key
      ,a1.ad_show_type
      ,a1.ad_position_id
      ,a1.ad_id
      ,a1.core
      ,a1.mt
      ,a1.language_id
      ,a1.reg_country
      ,a1.ad_show_type_name
      ,a1.ad_position_name
      ,case when a1.mt = 1 then 'iOS'
            when a1.mt = 4 then 'Android'
            else null
        end                             as mt_name                  -- mt操作系统
      ,a6.cd_val_desc                   as language_name            -- 语言
      ,a7.cd_val_desc                   as reg_country_name         -- 国家
      ,sum(a2.ad_request_pv)            as ad_request_pv            -- 广告请求数
      ,sum(a2.ad_request_success_pv)    as ad_request_success_pv    -- 广告请求成功数
      ,sum(a3.ad_invocation_pv)         as ad_invocation_pv         -- 广告调用数
      ,sum(a4.ad_show_success_pv)       as ad_show_success_pv       -- 广告展示成功数
      ,sum(a4.total_show_duration)      as total_show_duration      -- 广告展示时长
      ,sum(a5.ad_show_fail_pv)          as ad_show_fail_pv          -- 广告展示失败数
      ,now()                            as etl_time                 -- 数据处理时间
      ,a1.project_id
  from union_result                          as a1
  left join  adrequest                       as a2
    on a1.dt = a2.dt
   and a1.ad_show_type = a2.ad_show_type
   and a1.ad_position_id = a2.ad_position_id
   and a1.ad_id = a2.ad_id
   and a1.core = a2.core
   and a1.mt = a2.mt
   and a1.language_id = a2.language_id
   and a1.reg_country = a2.reg_country
   and a1.project_id = a2.project_id
  left join adinvocation                     as a3
    on a1.dt = a3.dt
   and a1.ad_show_type = a3.ad_show_type
   and a1.ad_position_id = a3.ad_position_id
   and a1.ad_id = a3.ad_id
   and a1.core = a3.core
   and a1.mt = a3.mt
   and a1.language_id = a3.language_id
   and a1.reg_country = a3.reg_country
   and a1.project_id = a3.project_id
  left join adshow                           as a4
    on a1.dt = a4.dt
   and a1.ad_show_type = a4.ad_show_type
   and a1.ad_position_id = a4.ad_position_id
   and a1.ad_id = a4.ad_id
   and a1.core = a4.core
   and a1.mt = a4.mt
   and a1.language_id = a4.language_id
   and a1.reg_country = a4.reg_country
   and a1.project_id = a4.project_id
  left join adtrigger                        as a5
    on a1.dt = a5.dt
   and a1.ad_show_type = a5.ad_show_type
   and a1.ad_position_id = a5.ad_position_id
   and a1.ad_id = a5.ad_id
   and a1.core = a5.core
   and a1.mt = a5.mt
   and a1.language_id = a5.language_id
   and a1.reg_country = a5.reg_country
   and a1.project_id = a5.project_id
  left join dim.dim_pub_code_mapping_dict    as a6
    on a1.language_id = a6.cd_val
   and a6.app_plat='pub'
   and a6.cd_col='lang_cd'
  left join dim.dim_pub_code_mapping_dict    as a7
    on a1.reg_country = a7.cd_val
   and a7.app_plat='pub'
   and a7.cd_col='lang_cd'
 group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 22
;
