----------------------------------------------------------------
-- 程序功能：海剧用户充值信息
-- 程序名： P_ads_sv_trade_user_recharge_info
-- 目标表： ads.ads_sv_trade_user_recharge_info
-- 负责人： qhr
-- 开发日期：2026-01-08
----------------------------------------------------------------

insert into ads.ads_sv_trade_user_recharge_info
select a.user_id
     , a.current_language
     , a.corever
     , a.last_login_time
     , from_unixtime(ifnull(a.expire_time, 0) / 1000)    as expire_time
     , a.bind_email
     , b.last_recharge_tm
     , now()                                             as etl_time
  from dim.dim_short_video_user_accountinfo    as a
  left join dws.dws_user_sv_idx_his_15d_view   as b
    on a.user_id = b.user_id
   and b.dt = '${bf_1_dt}'
 where a.create_time < '${dt}'
;