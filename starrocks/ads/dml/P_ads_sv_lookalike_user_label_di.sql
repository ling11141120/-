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
         , login.login_days_td
         , login.new_login_tm
         , recharge.last_recharge_tm
         , recharge.first_recharge_amt
         , recharge.total_recharge_amt
         , recharge.recharge_avg
         , csm.consume_money_amt_td
         , csm.total_consumption
         , coin_cnt
      from (select acc.product_id
                 , acc.user_id
                 , ifnull(coin.coin_cnt, 0)    as coin_cnt
              from dim.dim_short_video_user_accountinfo acc
              left join (select 6833           as product_id
                              , account_id     as user_id
                              , max(value)     as coin_cnt
                           from dim.dim_sv_accountinfo_user_coin_view
                          group by 1, 2
                        )                                as coin
                on acc.product_id = coin.product_id
               and acc.user_id = coin.user_id
             where create_time < '${dt}'
           )                                             as a
      left join dws.dws_user_short_video_login_a_view    as login
        on a.product_id = login.product_id
       and a.user_id = login.user_id
       and login.dt = '${bf_1_dt}'
      left join (select dt
                      , 6833                                                as product_id
                      , user_id
                      , last_recharge_tm
                      , first_recharge_amt
                      , total_recharge_amt
                      , round(recharge_avg, 2) as recharge_avg
                   from dws.dws_trade_short_video_subscribe_payorder_a_view
                  where dt >= '${bf_1_dt}'
                    and dt < '${dt}'
                )                             as recharge
        on a.product_id = recharge.product_id
       and a.user_id = recharge.user_id
      left join (select dt
                      , 6833                        as product_id
                      , user_id
                      , consume_money_amt_td
                      , bitmap_count(consume_tv_td) as total_consumption
                   from dws.dws_consume_short_video_consume_a_view
                  where dt >= '${bf_1_dt}'
                    and dt < '${dt}'
                )                             as csm
        on a.product_id = csm.product_id
       and a.user_id = csm.user_id
      left join dim.dim_short_video_user_accountinfo coin
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
  join(select dt
            , product_id
            , user_id
         from dws.dws_user_short_video_wide_active_ed
        where dt = '${bf_1_dt}'
          and product_id = 6833
      ) b
    on base.product_id = b.product_id
   and base.user_id = b.user_id
;