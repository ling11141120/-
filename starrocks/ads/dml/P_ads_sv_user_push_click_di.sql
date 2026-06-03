----------------------------------------------------------------
-- 程序功能： 
-- 程序名： P_ads_sv_user_push_click_di
-- 目标表： ads.ads_sv_user_push_click_di
-- 负责人： tyg
-- 开发日期：2026-06-03
----------------------------------------------------------------

delete from ads.ads_sv_user_push_click_di where dt = '${dt}';

insert into ads.ads_sv_user_push_click_di
select '${dt}'      as dt
     , user_id
     , push_id
     , event_tm     as click_time
     , app_core_ver as core
     , os           as mt
     , app_lang_id  as lang_id
     , now()        as etl_time
  from (select identity_user_id                                                                    as user_id
             , push_id
             , event_tm
             , app_core_ver
             , os
             , app_lang_id
             , row_number() over ( partition by identity_user_id, push_id order by event_tm desc ) as rn
          from ads.ads_sensors_video_pushclick_view
         where identity_user_id is not null
           and push_id is not null
       ) as pushclick_tmp
 where rn = 1
;
