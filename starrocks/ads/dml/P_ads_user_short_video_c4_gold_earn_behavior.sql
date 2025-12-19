----------------------------------------------------------------
-- 程序功能： 海剧C4金币网赚版本1.6.5用户行为报表
-- 程序名： P_ads_user_short_video_c4_gold_earn_behavior
-- 目标表： ads.ads_user_short_video_c4_gold_earn_behavior
-- 负责人： xjc
-- 开发日期： 2025-12-12
----------------------------------------------------------------

insert into ads.ads_user_short_video_c4_gold_earn_behavior
with total_amount as (
    select account_id             as user_id
          ,round(sum(value),2)    as total_amount -- 用户拥有现金
      from ads.ads_sv_online_earn_view
     where date(create_time) ='${dt}'
      group by 1
)
, ad_cnt_amt as (
    select user_id
          ,sum(if(ad_show_type=3,1,0))    as interstitial_ad_cnt -- 插屏展现次数
          ,sum(if(ad_show_type=6,1,0))    as rewarded_ad_cnt     -- 激励展现次数
          ,round(sum(amt),2)              as ad_all_amt          -- 总广告价值
      from dws.dws_advertisement_user_position_amt_ed
     where dt='${dt}'
       and core=4
     group by 1
)
, app_use_time as (
    select login_id              as user_id
         ,sum(event_duration)    as app_duration -- app使用时长, 单位秒
     from ods_log.ods_sensors_append
    where dt='${dt}'
      and login_id is not null
    group by 1
)
, watch_episode_count as (
    select AccountId                as user_id
         ,count(distinct EpisId)    as watch_episode_count -- 观看集数
    from ods.ods_tidb_short_video_log_ext_epis_history_part2
    where dt='${dt}'
    group by 1
)
, user_coin_tmp as (
    select AccountId as user_id
    ,IsGolden        as user_type
    ,coin_num
    from ods.ods_tidb_short_video_account_extra ae
    left join (
               select account_id
                     ,sum(coin)  as coin_num -- 金币数
               from ods.ods_tidb_short_video_account_coin_claim_record
               where dt = '${dt}'
               group by 1
              ) coin
      on ae.AccountId = coin.account_id
    where dt >= '2025-12-01'
)
, active_user_cnt as (
    select userid as user_id
          ,1      as is_active
    from ods.ods_tidb_short_video_log_client_info
    where date(CreateTime) = '${dt}'
      and userid is not null
      and corever = 4
    group by 1
)

select '${dt}'                                                                          -- 日期
      ,a1.user_id                                                                       -- 用户id
      ,coalesce(a2.total_amount,0) + coalesce(a7.total_cash_amt,0) as total_cash_amt    -- 用户拥有现金
      ,coalesce(a6.coin_num,0) + coalesce(a7.total_coin_num,0)     as total_coin_num    -- 金币数
      ,a3.interstitial_ad_cnt                                                           -- 插屏广告次数
      ,a3.rewarded_ad_cnt                                                               -- 激励视次数
      ,a3.ad_all_amt                                               as today_ad_value    -- 广告总价值
      ,coalesce(a4.app_duration,0)                                 as app_duration      -- app使用时长
      ,coalesce(a7.total_login_days,0) + coalesce(a8.is_active,0)  as total_login_days  -- 总登录天数
      ,a5.watch_episode_count                                                           -- 观看剧集次数
      ,a6.user_type                                                as coin_user_type    -- 金币用户类型
      ,now() as etl_tm
  from dim.dim_short_video_user_accountinfo                as a1
  left join total_amount                                   as a2
    on a1.user_id=a2.user_id
  left join ad_cnt_amt                                     as a3
    on a1.user_id=a3.user_id
  left join app_use_time                                   as a4
    on a1.user_id=a4.user_id
  left join watch_episode_count                            as a5
    on a1.user_id=a5.user_id
  left join user_coin_tmp                                  as a6
    on a1.user_id=a6.user_id
  left join ads.ads_user_short_video_c4_gold_earn_behavior as a7
    on a1.user_id=a7.user_id
   and a7.dt = '${bf_1_dt}'
  left join active_user_cnt                                as a8
    on a1.user_id=a8.user_id
 where a1.corever=4
   and a1.dt <= '${dt}'
;

