----------------------------------------------------------------
-- 程序功能： 海剧-广告触达到播放转化报表-广告转化汇总
-- 程序名： P_ads_sv_ad_conversion_summary
-- 目标表： ads.ads_sv_ad_conversion_summary
-- 负责人： xjc
-- 开发日期：2026-01-05
-- 版本号： v0.0.1
----------------------------------------------------------------

insert into ads.ads_sv_ad_conversion_summary
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
          ,0           as ad_invocation_pv
          ,0           as ad_show_success_pv
          ,0           as total_show_duration
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
          ,0           as ad_request_pv
          ,0           as ad_request_success_pv
          ,count(1)    as ad_invocation_pv
          ,0           as ad_show_success_pv
          ,0           as total_show_duration
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
          ,0                        as ad_request_pv
          ,0                        as ad_request_success_pv
          ,0                        as ad_invocation_pv
          ,count(1)                 as ad_show_success_pv
          ,sum(request_duration)    as total_show_duration
      from dws.dws_ad_srsv_ad_position_request_df
     where dt = '${bf_1_dt}'
       and ad_position_id != '0'
       and event_name = 'ADShow'
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
          ,ad_request_pv
          ,ad_request_success_pv
          ,ad_invocation_pv
          ,ad_show_success_pv
          ,total_show_duration
      from adrequest
     union all
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
          ,ad_request_pv
          ,ad_request_success_pv
          ,ad_invocation_pv
          ,ad_show_success_pv
          ,total_show_duration
      from adinvocation
     union all
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
          ,ad_request_pv
          ,ad_request_success_pv
          ,ad_invocation_pv
          ,ad_show_success_pv
          ,total_show_duration
      from adshow
)
select
    dt                            as dt                       -- 日期
   ,md5(concat_ws('_'
        ,ifnull(a1.project_id, '')
        ,ifnull(ad_show_type, '')
        ,ifnull(ad_position_id, '')
        ,ifnull(ad_id, '')
        ,ifnull(core, '')
        ,ifnull(mt, '')
        ,ifnull(language_id, '')
        ,ifnull(reg_country, '')
                 )
       )                          as md5_key                  -- md5key
   ,ad_show_type                  as ad_show_type             -- 广告位类型
   ,ad_position_id                as ad_position_id           -- 广告位id
   ,ad_id                         as ad_id                    -- 广告id
   ,core                          as core                     -- 核心
   ,mt                            as mt                       -- 媒体类型
   ,language_id                   as language_id              -- 语言id
   ,reg_country                   as reg_country              -- 注册国家
   ,ad_show_type_name             as ad_show_type_name        -- 广告位类型名称
   ,ad_position_name              as ad_position_name         -- 广告位名称
   ,case when mt = 1 then 'iOS'
         when mt = 4 then 'Android'
         else null
     end                          as mt                       -- 媒体类型
   ,a2.cd_val_desc                as language_name            -- 语言
   ,a3.cd_val_desc                as reg_country_name         -- 国家
   ,sum(ad_request_pv)            as ad_request_pv            -- 广告请求数
   ,sum(ad_request_success_pv)    as ad_request_success_pv    -- 广告请求成功数
   ,sum(ad_invocation_pv)         as ad_invocation_pv         -- 广告调用数
   ,sum(ad_show_success_pv)       as ad_show_success_pv       -- 广告展示成功数
   ,sum(total_show_duration)      as total_show_duration      -- 总展示时长
   ,now()                         as etl_time                 -- etl时间
   ,a1.project_id                 as project_id               -- 项目id,5:海阅8:海剧
  from union_result                          as a1
  left join dim.dim_pub_code_mapping_dict    as a2
    on a1.language_id = a2.cd_val
   and a2.app_plat='pub'
   and a2.cd_col='lang_cd'
  left join dim.dim_pub_code_mapping_dict    as a3
    on a1.reg_country = a3.cd_val
   and a3.app_plat='pub'
   and a3.cd_col='lang_cd'
 group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 21
;
