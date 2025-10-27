----------------------------------------------------------------
-- 程序功能： 海剧用户控件曝光事件信息
-- 程序名： P_ads_sv_user_element_exposure_info
-- 目标表： ads.ads_sv_user_element_exposure_info
-- 负责人： qhr
-- 开发日期：2025-10-27
-- 版本号：v0.0.1
----------------------------------------------------------------

insert into ads.ads_sv_user_element_exposure_info
select a.dt
      ,a.product_id
      ,a.id
      ,a.zffs_rank
      ,a.login_id
      ,a.zffs
      ,a.sfzf_strategy_id
      ,a.event_tm
      ,b.current_language2
      ,a.core
      ,case when c.reg_days = 0 then 'D0'
            when c.reg_days >= 1 and reg_days <= 3 then 'D1-D3'
            when c.reg_days >= 4 then 'D3+'
        end      as user_type
      ,b.mt
      ,b.reg_country
      ,now()    as etl_time
  from (select a.dt
              ,a.product_id
              ,a.id
              ,a.login_id
              ,a.zffs_array[generate_series]    as zffs
              ,a.sfzf_strategy_id
              ,generate_series                  as zffs_rank
              ,a.event_tm
              ,a.core
              ,now()                            as etl_time
          from (select dt
                      ,6833 as product_id
                      ,id
                      ,login_id
                      ,ifnull(sfzf_strategy_id, '')           as sfzf_strategy_id
                      ,split(zffs_list, ',')                  as zffs_array
                      ,array_length(split(zffs_list, ','))    as zffs_length
                      ,event_tm
                      ,case when app_id = 683001001 then 1
                            when app_id = 683002001 then 2
                            when app_id = 683003001 then 3
                            when app_id is null and cast(app_core_ver as int) = 15 then 15
                            else null
                        end                                   as core
                  from ads.ads_sensors_cd_video_ElmentExposure_view
                 where dt = '${bf_1_dt}'
                   and product_id = 6833
                   and element_id = 210006
                   and zffs_list is not null
                   and login_id is not null
               )                                    as a
         cross join generate_series(1, zffs_length)
       )                                            as a
  left join dim.dim_short_video_user_accountinfo    as b
    on a.product_id = b.product_id and a.login_id = b.user_id
  left join (select dt
                   ,product_id
                   ,user_id
                   ,reg_days
               from dws.dws_user_short_video_wide_active_period_ed
              where dt = '${bf_1_dt}'
                and period_type = 'ctt'
            )                                       as c
    on a.dt = c.dt
   and a.product_id = c.product_id
   and a.login_id = c.user_id
;