----------------------------------------------------------------
-- 程序功能： 短剧：用户域按天登录观看充值消耗汇总活跃表
-- 程序名： P_ads_wide_user_short_video_active_ed
-- 目标表： ads.ads_wide_user_short_video_active_ed
-- 负责人： tyg
-- 开发日期：2026-06-09
----------------------------------------------------------------

-- 前置SQL语句
delete from ads.ads_wide_user_short_video_active_ed where dt >= '${bf_3_dt}';

-- SQL语句
insert into ads.ads_wide_user_short_video_active_ed
select a.dt
     , a.product_id
     , a.user_id
     , b.user_type
     , a.corever
     , a.mt
     , a.current_language
     , a.current_language2
     , a.reg_country
     , a.country_level
     , a.reg_time              as reg_date
     , a.reg_days
     , a.sex
     , a.is_acc_login
     , a.is_has_email
     , b.user_period
     , b.user_value
     , b.source
     , now()                   as etl_tm
     , c.app_live_notify_state
  from dws.dws_user_short_video_wide_active_ed as a
  left join dws.dws_user_short_video_wide_tag_info_ed as b
    on a.dt = b.dt
   and a.product_id = b.product_id
   and a.user_id = b.user_id
   and b.dt >= '${bf_3_dt}'
   and b.dt < '${dt}'
  left join dim.dim_short_video_user_accountinfo as c
    on a.user_id = c.user_id
   and a.product_id = c.product_id
where a.dt >= '${bf_3_dt}'
   and a.dt < '${dt}'
   and a.product_id != 6883
   and cast(a.user_id as int) > 0
;
