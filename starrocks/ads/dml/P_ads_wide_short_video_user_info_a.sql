----------------------------------------------------------------
-- 程序功能： 海剧用户累计指标表
-- 程序名： P_ads_wide_short_video_user_info_a
-- 目标表： ads.ads_wide_short_video_user_info_a
-- 负责人： qhr/cm
-- 开发日期： 2025-12-23
----------------------------------------------------------------

insert into ads.ads_wide_short_video_user_info_a
with a as (
    select '${bf_1_dt}'    as dt
         , product_id
         , user_id
         , sex
         , create_time     as reg_tm
         , mt
         , mt2
         , corever
         , corever2
         , app_ver
         , ver
         , current_language
         , current_language2
         , reg_country
         , case when email is not null then 1
                else 0
            end            as is_bound_email
      from dim.dim_short_video_user_accountinfo     as acc
     where create_time < '${dt}'
)
,login as (
    select dt
         , product_id
         , user_id
         , fst_login_tm
         , lst_login_tm
         , new_login_tm
         , login_days_td
         , login_cnt_td
         , remain_day
      from dws.dws_user_short_video_login_a
     where dt = '${bf_1_dt}'
)
, csm as (
    select dt
         , product_id
         , user_id
         , consume_amt_td
         , fst_consume_tm
         , lst_consume_tm
         , consume_cnt_td
         , consume_tv_td
         , consume_money_amt_td
         , fst_consume_money_tm
         , lst_consume_money_tm
         , consume_money_cnt_td
         , consume_money_tv_td
         , consume_cert_amt_td
         , fst_consume_cert_tm
         , lst_consume_cert_tm
         , consume_cert_cnt_td
         , consume_cert_tv_td
      from dws.dws_consume_short_video_consume_a
     where dt = '${bf_1_dt}'
)
, watch as (
    select dt
         , product_id
         , user_id
         , fst_watch_tm
         , lst_watch_tm
         , watch_series_td
         , watch_tv_td
         , watch_days_td
         , watch_cnt_td
      from dws.dws_video_user_watch_series_td_a
     where dt = '${bf_1_dt}'
)
, watch2 as (
    select dt
         , product_id
         , user_id
         , fst_watch_tm
         , lst_watch_tm
         , watch_days_td
         , watch_cnt_td
         , new_epis_series_td
      from dws.dws_video_user_watch_new_epis_series_td_a
     where dt = '${bf_1_dt}'
)
, recharge as (
    select dt
         , product_id
         , user_id
         , total_subscribe_amt
         , first_subscribe_amt
         , first_subscribe_tp
         , first_subscribe_tm
         , last_subscribe_amt
         , last_subscribe_tp
         , last_subscribe_tm
         , total_subscribe_cnt
         , total_subscribe_refund_cnt
         , is_mul_subscribe
         , has_subscribe
         , first_recharge_amt
         , first_recharge_tm
         , total_recharge_amt
         , total_refund_amt
         , total_recharge_cnt
         , total_refund_cnt
         , recharge_avg
         , recharge_max
         , month_recharge_max
         , last_recharge_amt
         , last_recharge_tm
         , charge_mode
      from dws.dws_trade_short_video_subscribe_payorder_a
     where dt = '${bf_1_dt}'
)
, lk as (
    select dt
         , product_id
         , user_id
         , fst_like_tm
         , lst_like_tm
         , like_series_td
         , like_epis_td
         , like_cnt_td
      from dws.dws_interaction_short_video_user_like_a
     where dt = '${bf_1_dt}'
)
, install as (
    select dt
         , product_id
         , user_id
         , first_bookid
         , last_bookid
         , last_source
         , install_date
      from (select dt
                 , product_id
                 , user_id
                 , first_bookid
                 , last_bookid
                 , last_source
                 , install_date
                 , row_number() over (partition by dt,product_id,user_id order by install_date desc ) as rn
              from dws.dws_user_market_channel_info_detail_td
             where dt = '${bf_1_dt}'
               and product_id = 6833
           ) t1
     where rn = 1
)
select a.dt
     , a.product_id
     , a.user_id
     , a.sex
     , a.reg_tm
     , a.mt
     , a.mt2
     , a.corever
     , a.corever2
     , a.app_ver
     , a.ver
     , a.current_language
     , a.current_language2
     , a.reg_country
     , a.is_bound_email
     , login.fst_login_tm
     , login.lst_login_tm
     , login.new_login_tm
     , login.login_days_td
     , login.login_cnt_td
     , login.remain_day
     , csm.consume_amt_td
     , csm.fst_consume_tm
     , csm.lst_consume_tm
     , csm.consume_cnt_td
     , csm.consume_tv_td
     , csm.consume_money_amt_td
     , csm.fst_consume_money_tm
     , csm.lst_consume_money_tm
     , csm.consume_money_cnt_td
     , csm.consume_money_tv_td
     , csm.consume_cert_amt_td
     , csm.fst_consume_cert_tm
     , csm.lst_consume_cert_tm
     , csm.consume_cert_cnt_td
     , csm.consume_cert_tv_td
     , watch.fst_watch_tm
     , watch.lst_watch_tm
     , watch.watch_series_td
     , watch.watch_tv_td
     , watch.watch_days_td
     , watch.watch_cnt_td
     , watch2.new_epis_series_td
     , recharge.total_subscribe_amt
     , recharge.first_subscribe_amt
     , recharge.first_subscribe_tp
     , recharge.first_subscribe_tm
     , recharge.last_subscribe_amt
     , recharge.last_subscribe_tp
     , recharge.last_subscribe_tm
     , recharge.total_subscribe_cnt
     , recharge.total_subscribe_refund_cnt
     , recharge.is_mul_subscribe
     , recharge.has_subscribe
     , recharge.first_recharge_amt
     , recharge.first_recharge_tm
     , recharge.total_recharge_amt
     , recharge.total_refund_amt
     , recharge.total_recharge_cnt
     , recharge.total_refund_cnt
     , recharge.recharge_avg
     , recharge.recharge_max
     , recharge.month_recharge_max
     , recharge.last_recharge_amt
     , recharge.last_recharge_tm
     , recharge.charge_mode
     , lk.fst_like_tm
     , lk.lst_like_tm
     , lk.like_series_td
     , lk.like_epis_td
     , lk.like_cnt_td
     , install.first_bookid
     , install.last_bookid
     , install.last_source
     , install.install_date
     , now() as etl_time
  from a
  left join login
    on a.dt = login.dt
   and a.product_id = login.product_id
   and a.user_id = login.user_id
  left join csm
    on a.dt = csm.dt
   and a.product_id = csm.product_id
   and a.user_id = csm.user_id
  left join watch
    on a.dt = watch.dt
   and a.product_id = watch.product_id
   and a.user_id = watch.user_id
  left join watch2
    on a.dt = watch2.dt
   and a.product_id = watch2.product_id
   and a.user_id = watch2.user_id
  left join recharge
    on a.dt = recharge.dt
   and a.product_id = recharge.product_id
   and a.user_id = recharge.user_id
  left join lk
    on a.dt = lk.dt
   and a.product_id = lk.product_id
   and a.user_id = lk.user_id
  left join install
    on a.dt = install.dt
   and a.product_id = install.product_id
   and a.user_id = install.user_id
;