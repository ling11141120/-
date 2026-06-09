----------------------------------------------------------------
-- 程序功能： 算法-用户推送开关状态校验
-- 程序名： P_ads_alg_user_appnotify_verify
-- 目标表： ads.ads_alg_user_appnotify_verify
-- 负责人： xjc
-- 开发日期： 2026-04-09
-- 版本号： v0.0.0
----------------------------------------------------------------

insert into ads.ads_alg_user_appnotify_verify
with device_info as (
    -- 同一设备只取最新一条
    select UniqueCdReaderId
          ,Appnotify
          ,row_number() over(partition by UniqueCdReaderId order by Timestamp desc)    as rn
    from ods.ods_tidb_short_video_device_info
   where Corever=1
)
, sum_result as (
    -- 统计结果
    select dt
          ,hour_bucket
          ,count(distinct a2.id)                                as user_total
          ,sum(case when a3.appnotify = 1 then 1 else 0 end)    as device_open_count
          ,sum(case when a3.appnotify = 0 then 1 else 0 end)    as device_close_count
          ,sum(case when a1.app_notify = 1 then 1 else 0 end)   as push_open_count
          ,sum(case when a1.app_notify = 0 then 1 else 0 end)   as push_close_count
      from ods.ods_tidb_short_video_push_trace_notify_record    as a1
      join ods.ods_tidb_short_video_accountinfo                 as a2
        on a2.Id = a1.account_id
      join device_info                                          as a3
        on a3.UniqueCdReaderId = a2.UniqueCdReaderId
       and a3.rn = 1
     where a1.dt = '${bf_1_dt}'
       and a1.position_id = 108372949248115343
     group by a1.dt, a1.hour_bucket
)
select dt
      ,hour_bucket
      ,user_total
      ,device_open_count
      ,device_close_count
      ,push_open_count
      ,push_close_count
      ,abs(push_open_count 
           - 
           device_open_count
           )     as diff_open_count
      ,round(if(push_open_count > device_open_count
               ,device_open_count / push_open_count
               ,push_open_count / device_open_count
               )
            , 4
            )    as diff_open_percentage
      ,abs(push_close_count 
           - 
           device_close_count
           )     as diff_close_count
      ,round(if(push_close_count>device_close_count
               ,device_close_count / push_close_count
               ,push_close_count / device_close_count
               )
            , 4
            )    as diff_close_percentage
      ,now()     as etl_time
  from sum_result
;