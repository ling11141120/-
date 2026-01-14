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
  left join(select 6833                        as product_id
                 , user_id
                 , last_recharge_tm
              from dws.dws_trade_short_video_subscribe_payorder_a_view
             where dt = '${bf_1_dt}'
            )                                  as b
    on a.product_id = b.product_id
   and a.user_id = b.user_id
 where create_time < '${dt}'
;