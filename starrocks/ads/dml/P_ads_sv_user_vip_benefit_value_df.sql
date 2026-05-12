----------------------------------------------------------------
-- 程序功能：海剧用户会员中心权益价值感知
-- 程序名： P_ads_sv_user_vip_benefit_value_df
-- 目标表： ads.ads_sv_user_vip_benefit_value_df
-- 负责人： xjc
-- 开发日期： 2026-05-09
-- 版本号： v0.0.1
----------------------------------------------------------------

insert into ads.ads_sv_user_vip_benefit_value_df
with vip_base as (
    select a.user_id
          ,a.vip_start_time
          ,a.vip_expire_time
          ,a.cancel_time
          ,case when a.cancel_time is not null and date(a.vip_expire_time) <= date(a.cancel_time)
                then date(a.vip_expire_time)
                when a.cancel_time is not null
                then date(a.cancel_time)
                else date(a.vip_expire_time)
            end as valid_vip_end_date
          ,case when a.cancel_time is not null
                 and a.vip_expire_time <= cast(date_add(a.cancel_time, interval 1 day) as datetime)
                then a.vip_expire_time
                when a.cancel_time is not null
                then cast(date_add(a.cancel_time, interval 1 day) as datetime)
                else a.vip_expire_time
            end as valid_vip_end_time
      from ads.ads_bi_short_video_trade_user_subscribe_di as a
     where a.dt >= date_sub('${dt}', interval 400 day)
       and a.dt <= '${dt}'
       and a.product_id = 6833
       and a.shop_item in (810, 860)        -- vip
       and a.vip_start_time is not null
       and a.vip_expire_time is not null
)
, vip_period as (
    select 1 as stat_type
          ,a.user_id
          ,greatest(a.vip_start_time, cast(date_sub('${dt}', interval 6 day) as datetime)) as period_vip_start_time
          ,case when a.valid_vip_end_time <= '${cur_time}' then a.valid_vip_end_time else '${cur_time}' end as period_vip_end_time
      from vip_base as a
     where 1 = 1
       and date(a.vip_start_time) <= '${dt}'
       and a.valid_vip_end_date >= date_sub('${dt}', interval 6 day)
       and a.vip_start_time < a.valid_vip_end_time
    union all
    select 2 as stat_type
          ,a.user_id
          ,greatest(a.vip_start_time, cast(date_sub('${dt}', interval 89 day) as datetime)) as period_vip_start_time
          ,case when a.valid_vip_end_time <= '${cur_time}' then a.valid_vip_end_time else '${cur_time}' end as period_vip_end_time
      from vip_base as a
     where 1 = 1
       and date(a.vip_start_time) <= '${dt}'
       and a.valid_vip_end_date >= date_sub('${dt}', interval 89 day)
       and a.vip_start_time < a.valid_vip_end_time
)
, vip_period_ordered as (
    select stat_type
          ,user_id
          ,period_vip_start_time
          ,period_vip_end_time
          ,max(period_vip_end_time) over (
               partition by stat_type, user_id
               order by period_vip_start_time, period_vip_end_time
               rows between unbounded preceding and 1 preceding
           ) as prev_max_end_time
      from vip_period
     where period_vip_start_time < period_vip_end_time
)
, vip_period_grouped as (
    select stat_type
          ,user_id
          ,period_vip_start_time
          ,period_vip_end_time
          ,sum(case when prev_max_end_time is null
                      or period_vip_start_time > prev_max_end_time
                    then 1
                    else 0
                end
              ) over (
                  partition by stat_type, user_id
                  order by period_vip_start_time, period_vip_end_time
                  rows between unbounded preceding and current row
              ) as period_group_id
      from vip_period_ordered
)
, vip_period_merged as (
    select stat_type
          ,user_id
          ,min(period_vip_start_time) as period_vip_start_time
          ,max(period_vip_end_time)   as period_vip_end_time
      from vip_period_grouped
     group by 1, 2, period_group_id
)
, vip_ad_free as (
    select stat_type
          ,user_id
          ,cast(sum(ceiling(seconds_diff(period_vip_end_time, period_vip_start_time) / 86400.0)) as bigint) as vip_ad_free_epis_cnt
      from vip_period_merged
     group by 1, 2
)
, vip_unlock as (
    select a.stat_type
          ,a.user_id
          ,count(distinct b.epis_id) as vip_unlock_epis_cnt
      from vip_period as a
      join (
            select login_id   as user_id
                  ,episode_id as epis_id
                  ,event_tm   as create_time
              from ads.ads_sensors_cd_video_unlockEpisode_view
             where dt >= date_sub('${dt}', interval 89 day)
               and dt <= '${dt}'
               and project_id = 8
               and unlock_type in ('3')
               and login_id is not null
               and episode_id is not null
           ) as b
        on a.user_id = b.user_id
       and b.create_time >= a.period_vip_start_time
       and b.create_time < a.period_vip_end_time
     group by 1, 2
)
, sign_card_gain as (
    select 1 as stat_type
          ,a.account_id as user_id
          ,sum(coalesce(a.gain_coin, 0))  as sign_card_gain_coin_cnt
          ,sum(coalesce(a.gain_bonus, 0)) as sign_card_gain_bonus_cnt
      from dwd.dwd_sv_sign_in_card_view as a
     where date(a.create_time_dt) >= date_sub('${dt}', interval 6 day)
       and date(a.create_time_dt) <= '${dt}'
       and a.order_mark = 1
       and a.account_id is not null
     group by 2
    union all
    select 2 as stat_type
          ,a.account_id as user_id
          ,sum(coalesce(a.gain_coin, 0))  as sign_card_gain_coin_cnt
          ,sum(coalesce(a.gain_bonus, 0)) as sign_card_gain_bonus_cnt
      from dwd.dwd_sv_sign_in_card_view as a
    where date(a.create_time_dt) >= date_sub('${dt}', interval 89 day)
      and date(a.create_time_dt) <= '${dt}'
       and a.order_mark = 1
       and a.account_id is not null
     group by 2
)
, union_vip_sign_card as(
select '${dt}'                                                 as dt
      ,a.user_id
      ,a.stat_type
      ,coalesce(b.vip_unlock_epis_cnt, 0)                      as vip_unlock_epis_cnt
      ,coalesce(a.vip_ad_free_epis_cnt, 0)                     as vip_ad_free_epis_cnt
      ,0                                                       as sign_card_gain_coin_cnt
      ,0                                                       as sign_card_gain_bonus_cnt
  from vip_ad_free as a
  left join vip_unlock as b
    on a.stat_type = b.stat_type
   and a.user_id = b.user_id
union all
select '${dt}'                                                 as dt
      ,user_id
      ,stat_type
      ,0                                                       as vip_unlock_epis_cnt
      ,0                                                       as vip_ad_free_epis_cnt
      ,coalesce(sign_card_gain_coin_cnt, 0)                    as sign_card_gain_coin_cnt
      ,coalesce(sign_card_gain_bonus_cnt, 0)                   as sign_card_gain_bonus_cnt
  from sign_card_gain
)
select dt                               as dt
      ,user_id                          as user_id
      ,stat_type                        as stat_type
      ,sum(vip_unlock_epis_cnt)         as vip_unlock_epis_cnt
      ,sum(vip_ad_free_epis_cnt)        as vip_ad_free_epis_cnt
      ,sum(sign_card_gain_coin_cnt)     as sign_card_gain_coin_cnt
      ,sum(sign_card_gain_bonus_cnt)    as sign_card_gain_bonus_cnt
      ,now()                            as etl_time
  from union_vip_sign_card
group by 1, 2, 3
;
