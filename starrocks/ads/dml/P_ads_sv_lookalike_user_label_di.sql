----------------------------------------------------------------
-- 程序功能：用户分群lookalike标签表
-- 程序名： P_ads_sv_lookalike_user_label_di
-- 目标表： ads.ads_sv_lookalike_user_label_di
-- 负责人： qhr
-- 开发日期：2026-01-08
----------------------------------------------------------------

insert into ads.ads_sv_lookalike_user_label_di
with base as (
    select a.product_id
         , a.user_id
         , uidx.login_days_td
         , uidx.new_login_tm
         , uidx.last_recharge_tm
         , uidx.first_recharge_amt
         , uidx.total_recharge_amt
         , round(uidx.recharge_avg, 2)    as recharge_avg
         , uidx.consume_money_amt_td
         , bitmap_count(uidx.consume_tv_td)    as total_consumption
         , coin_cnt
      from (select acc.product_id
                 , acc.user_id
                 , ifnull(coin.coin_cnt, 0) as coin_cnt
              from dim.dim_short_video_user_accountinfo acc
              left join (select 6833       as product_id
                              , account_id as user_id
                              , max(value) as coin_cnt
                           from dim.dim_sv_accountinfo_user_coin_view
                          group by 1, 2
                         ) as                           coin
                on acc.product_id = coin.product_id
               and acc.user_id = coin.user_id
             where create_time < '${dt}'
            )                                                          as a
      left join dws.dws_user_sv_idx_his_15d_view                       as uidx
        on a.user_id = uidx.user_id
       and uidx.dt = '${bf_1_dt}'
      left join dim.dim_short_video_user_accountinfo                   as coin
        on a.product_id = coin.product_id
       and a.user_id = coin.user_id
)
select base.product_id
     , base.user_id
     , base.login_days_td
     , base.new_login_tm            as login_re
     , base.last_recharge_tm        as charge_re
     , base.first_recharge_amt      as first_recharge
     , base.total_recharge_amt      as total_recharge
     , base.recharge_avg
     , base.consume_money_amt_td    as coin_consumeption
     , base.coin_cnt
     , base.total_consumption
     , now()                        as elt_time
  from base
  join dws.dws_user_short_video_wide_active_ed    as b
    on base.product_id = b.product_id
   and base.user_id = b.user_id
   and b.product_id = 6833
   and b.dt = '${bf_1_dt}'
;