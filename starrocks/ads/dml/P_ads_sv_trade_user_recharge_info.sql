----------------------------------------------------------------
-- 程序功能： 海剧用户充值信息
-- 程序名： P_ads_sv_trade_user_recharge_info
-- 目标表： ads.ads_sv_trade_user_recharge_info
-- 负责人： qhr
-- 开发日期：2026-06-23
----------------------------------------------------------------

-- SQL语句
insert into ads.ads_sv_trade_user_recharge_info
select user_id
     , current_language
     , corever
     , last_login_time
     , expire_time
     , bind_email
     , last_recharge_tm
     , now() as etl_time
  from ads.ads_wide_short_video_user_info_a_view
 where dt = '${bf_1_dt}'
;
