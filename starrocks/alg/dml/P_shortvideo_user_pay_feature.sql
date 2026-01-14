----------------------------------------------------------------
-- 程序功能：海剧用户充值信息
-- 程序名： P_ads_sv_trade_user_recharge_info
-- 目标表： ads.ads_sv_trade_user_recharge_info
-- 负责人： qhr
-- 开发日期：2026-01-08
----------------------------------------------------------------

insert into alg.shortvideo_user_pay_feature
select concat('sv', x1.user_id)    as user_id
     , 'payfeature'                as cache_key
     , concat( total_recharge_amt, ',', first_recharge_amt
              ,',', recharge_max, ',', recharge_avg
              ,',', month_recharge_max, ',', last_recharge_amt
              ,',', charge_mode, ',', total_refund_amt
              ,',', total_refund_cnt, ',', coalesce(watch_video_num, 0)
              ,',', coalesce(unlock_cnt, 0), ',', coalesce(epis_cnt, 0)
              , ',', coalesce(like_cnt, 0), ',', coalesce(consume_amt, 0)
             )                     as features
  from (select user_id
             , cast(total_recharge_amt as int)    as total_recharge_amt
             , cast(first_recharge_amt as int)    as first_recharge_amt
             , cast(recharge_max as int)          as recharge_max
             , cast(recharge_avg as int)          as recharge_avg
             , cast(month_recharge_max as int)    as month_recharge_max
             , cast(last_recharge_amt as int)     as last_recharge_amt
             , cast(charge_mode as int)           as charge_mode
             , cast(total_refund_amt as int)      as total_refund_amt
             , cast(total_refund_cnt as int)      as total_refund_cnt
          from dws.dws_trade_short_video_subscribe_payorder_a_view
         where dt = '${bf_1_dt}'
           and total_recharge_amt > 0
           and user_id > 0
       )        as x1
  left join(select user_id
                 , count(series_id)     as watch_video_num
                 , sum(unlock_cnt)      as unlock_cnt
                 , sum(epis_cnt)        as epis_cnt
                 , sum(complete_cnt)    as complete_cnt
                 , sum(like_cnt)        as like_cnt
                 , sum(consume_amt)     as consume_amt
              from alg.alg_short_video_user_series_info_collect
             where dt = '${bf_1_dt}'
             group by user_id
           )    as x2
    on x1.user_id = x2.user_id