----------------------------------------------------------------
-- 程序功能： 海阅-用户push点击频控表
-- 程序名： P_ads_sr_user_push_click_di
-- 目标表： ads.ads_sr_user_push_click_di
-- 负责人： tyg
-- 开发日期：2026-06-18
----------------------------------------------------------------

delete from ads.ads_sr_user_push_click_di where dt = '${dt}';

insert into ads.ads_sr_user_push_click_di
select '${dt}'      as dt
     , user_id
     , push_id
     , push_title
     , push_type
     , event_tm     as click_time
     , app_version
     , app_core_ver as core
     , os           as mt
     , app_lang_id  as lang_id
     , now()        as etl_time
  from (select cast(identity_user_id as bigint) as user_id
             , push_id
             , push_title
             , push_type
             , event_tm
             , app_version
             , app_core_ver
             , os
             , app_lang_id
             , row_number() over ( partition by identity_user_id, push_id order by event_tm desc ) as rn
          from dwd.dwd_sensors_read_pushclick_view
         where identity_user_id is not null
           and identity_user_id regexp '^[0-9]+$'
           and push_id is not null
           and push_id regexp '^[0-9]+$'
       ) as pushclick_tmp
 where rn = 1
;
