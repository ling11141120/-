----------------------------------------------------------------
-- 程序功能： 海剧-用户live通知权限日表
-- 程序名： P_ads_sv_user_live_notify_di
-- 目标表： ads.ads_sv_user_live_notify_di
-- 负责人： tyg
-- 开发日期：2026-06-08
----------------------------------------------------------------

insert into ads.ads_sv_user_live_notify_di
select '${dt}'                as dt
     , 6833                   as product_id
     , cast(userid as bigint) as user_id
     , corever                as corever
     , applivenotifystate     as app_live_notify_state
     , now()                  as etl_time
  from (select userid
             , corever
             , applivenotifystate
             , row_number() over (partition by userid order by timestamp desc) as rn
          from ods.ods_tidb_short_video_device_info
         where userid is not null
           and userid regexp '^[0-9]+$'
       ) as a
 where rn = 1
;
