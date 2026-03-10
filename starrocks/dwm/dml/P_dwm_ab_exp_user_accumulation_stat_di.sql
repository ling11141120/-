----------------------------------------------------------------
-- 程序功能： 海剧-AB实验-用户明细中间表
-- 程序名： P_dwm_ab_exp_user_accumulation_stat_di
-- 目标表： dwm.dwm_ab_exp_user_accumulation_stat_di
-- 负责人： qhr
-- 开发日期： 2026-03-10
----------------------------------------------------------------

insert into dwm.dwm_ab_exp_user_accumulation_stat_di
--  广告相关指标
with group_user as (
    select *
      from (select exp_id
                 , exp_grp_id
                 , exp_grp_ver_id
                 , user_id                                                           as account
                 , min(hit_time)                                                     as min_time
                 , row_number() over(partition by user_id order by min(hit_time))    as row_1
              from dwm.dwm_ab_exp_strategy_hit_user_di
             group by 1, 2, 3, 4
           ) t1
     where row_1 = 1
)
--获取最新的版本
, group_user_today as (
    select *
      from (select exp_id
                 , exp_grp_id
                 , exp_grp_ver_id
                 , user_id              as account
                 , max(date(hit_time)) as max_day
                 , row_number() over(partition by user_id order by max(hit_time)) row_1
              from dwm.dwm_ab_exp_strategy_hit_user_di
             where dt <= '${dt}'
             group by 1, 2, 3, 4
           ) t1
     where row_1 = 1
)
, user_exp_grp_ver as (
    select exp_id
         , exp_grp_id
         , exp_grp_ver_id
         , strategy_id
         , user_id
         , min(exp_start_time) as exp_start_time
         , max(exp_end_time)   as exp_end_time
         , min(start_time)     as start_time
         , max(end_time)       as end_time
         , min(hit_time)       as hit_time
      from dwm.dwm_ab_exp_strategy_hit_user_di
     group by 1, 2, 3, 4, 5
)
, t123 as (
    select t5.*
         , t6.series_code
      from (select t3.*
                 , t4.source_series_id
              from (select a.*
                         , t2.install_date
                         , t2.book_id   as series_id
                         , row_number() over(partition by account order by install_date desc ) as row_2
                      from (select *
                              from (select exp_id
                                         , exp_grp_id
                                         , exp_grp_ver_id
                                         , user_id       as account
                                         , min(hit_time) as min_time
                                         , row_number() over(partition by user_id order by min(hit_time)) row_1
                                      from user_exp_grp_ver
                                     group by 1, 2, 3, 4
                                    )                             as t1
                             where row_1 = 1
                           )                                      as a
                      left join ads.ads_user_install_info_view    as t2
                        on a.account = t2.user_id
                       and t2.install_date <= a.min_time
                       and t2.install_date >= date_add(a.min_time, -30)
                   )                                             as t3
              left join dim.dim_short_video_series_view           as t4
                on t3.series_id = t4.series_id
             where row_2 = 1
           )                                                      as t5
      left join dim.dim_short_video_source_series_view       as t6
        on t5.source_series_id = t6.series_id
)
, pay_tmp as (
    select dt
         , create_time
         , t0.user_id
         , b.exp_id
         , b.exp_grp_id
         , b.exp_grp_ver_id
         , item_count
         , base_amount
         , shop_item
         , package_id
         , case when SPLIT(get_json_string(custom_data, '$.sendId'), '_')[1] = '201300' then '商店页'
                when SPLIT(get_json_string(custom_data, '$.sendId'), '_')[1] = '200900' then '半屏'
                when SPLIT(get_json_string(custom_data, '$.sendId'), '_')[1] = '203300' then 'H5'
                else '其他'
            end                                            as recharge_source
         , get_json_string(custom_data, '$.activityId')    as activity_id
         , get_json_string(custom_data, '$.strategyId')    as strategy_id
         , case when subpay_type in ('GooglePlay', 'AppStore', 'AppGallery') then '原生支付'
                else '三方支付'
            end                                            as if_thirdpay
      from ads.ads_short_video_payorder_view    as t0
      join user_exp_grp_ver                     as b
        on t0.user_id = b.user_id
       and t0.create_time >= b.start_time
       and t0.create_time < b.end_time
       and t0.create_time >= b.hit_time
       and t0.create_time >= b.exp_start_time
       and t0.create_time < b.exp_end_time
     where test_flag = 0
       and dt >= date_add('${dt}', -1)
       and dt <= date_add('${dt}', 1)
       and date (create_time) = '${dt}'
)
-- 充值数据
, pay_amount_data as (
    select t123.exp_id                                                                                          as exp_id
         , t123.exp_grp_id                                                                                      as exp_grp_id
         , t123.exp_grp_ver_id                                                                                  as exp_grp_ver_id
         , t123.account                                                                                         as user_id
         , sum(case when t2.create_time > t123.min_time then t2.base_amount end)/100                            as recharge_amount
         , sum(case when t2.create_time > t123.min_time then t2.item_count end)                                 as recharge_amount_pre
         , sum(case when t2.create_time > t123.min_time and if_thirdpay = '三方支付' then t2.base_amount end)/100 as third_recharge_amount
         , count(case when t2.create_time > t123.min_time then t2.user_id end)                                  as recharge_times
     from t123
     left join pay_tmp    as t2
       on t123.account = t2.user_id
      and t123.exp_id = t2.exp_id
      and t123.exp_grp_id = t2.exp_grp_id
      and t123.exp_grp_ver_id = t2.exp_grp_ver_id
 group by 1, 2, 3, 4
)
-- 广告数据
, ad_tmp as (
    select t1.dt
          , t1.user_id
          , b.exp_id
          , b.exp_grp_id
          , b.exp_grp_ver_id
          , sv_adp.ad_show_type_name
          , sv_adp.ad_position_name
          , amt
          , cnt
      from dws.dws_advertisement_user_position_amt_ed as t1
      join group_user_today                           as b
        on t1.user_id = b.account
       and t1.dt>=b.max_day
      left join dim.dim_sv_ads_position_view          as sv_adp
        on t1.positions = sv_adp.ad_position    --  广告位ID
     where product_id ='6833'
       and t1.dt = '${dt}'
)
-- 广告解锁
, ad_unlock_tmp as (
    select dt
         , exp_id
         , exp_grp_id
         , exp_grp_ver_id
         , user_id
         , count (user_id)    as ad_unlock_user_num
      from (select cast (t0.create_time as date) dt
                 , t0.user_id
                 , b.exp_id
                 , b.exp_grp_id
                 , b.exp_grp_ver_id
             from ads.ads_short_video_series_unlock_view    as t0
             join user_exp_grp_ver                          as b
               on t0.user_id = b.user_id
              and t0.create_time >= b.start_time
              and t0.create_time < b.end_time
              and t0.create_time>=b.hit_time
              and t0.create_time>=b.exp_start_time
              and t0.create_time < b.exp_end_time
            where not date_format(expire_time, '%Y%m%d%H%i%s') like '9999%'
           )                                                as unlock
     where dt = '${dt}'
     group by 1, 2, 3, 4, 5
)
, adv_data_tmp as (
    select '${dt}'                                                                             as dt
         , a.exp_id                                                                            as exp_id
         , a.exp_grp_id                                                                        as exp_grp_id
         , a.exp_grp_ver_id                                                                    as exp_grp_ver_id
         , a.account                                                                           as user_id
         , sum(case when t4.dt>=a.min_time then t4.amt end)                                    as total_adv_amount
         , sum(case when t4.dt>=a.min_time and t4.ad_show_type_name !='H5' then t4.amt end)    as adv_amount
         , sum(case when t4.dt>=a.min_time and t4.ad_show_type_name ='H5' then t4.amt end)     as third_h5_amount
         , max(ad_unlock_user_num)                                                             as adv_unlock_times
      from group_user            as a
      left join ad_tmp           as t4
        on a.account = t4.user_id
       and a.exp_id = t4.exp_id
       and a.exp_grp_id = t4.exp_grp_id
       and a.exp_grp_ver_id = t4.exp_grp_ver_id
      left join ad_unlock_tmp    as t5
        on a.account = t5.user_id
       and a.exp_id = t5.exp_id
       and a.exp_grp_id = t5.exp_grp_id
       and a.exp_grp_ver_id = t5.exp_grp_ver_id
     group by 1, 2, 3, 4, 5
)
-- 付费解锁
, pay_unlock as (
    select b.ab_id                                                                                       as exp_id
         , b.version_id                                                                                  as exp_grp_id
         , c.exp_grp_ver_id
         , dt
         , event_strategy_id
         , login_id                                                                                      as user_id
         ,  sum(case when unlock_type in ('1', '2', '3', '6', '9', '10', '11') then coin_consume end)
          + sum(case when unlock_type in ('1', '2', '3', '6', '9', '10', '11') then gift_consume end)    as unlock_amount
      from (select dt
                 , login_id
                 , unlock_type
                 , coin_consume
                 , gift_consume
                 , event_tm
                 , split(activity_link, '_')[5]    as event_strategy_id
                 , split(activity_link, '_')[8]    as activity_or_shorplay
              from ads.ads_sensors_cd_video_unlockEpisode_view           as a1
             where dt = '${dt}'
               and unlock_type in ('1', '2', '3', '6', '9', '10', '11')
               and product_id = '6833'
               and activity_link is not null
           )                                as a
      join ods.ods_ab_hj_related            as b
        on a.event_strategy_id = b.strategy_id
      join dwd.dwd_ab_exp_version_detail    as c
        on b.ab_id = c.exp_id
       and b.version_id= c.exp_grp_id
       and a.event_tm >= c.exp_start_time
       and c.exp_end_time>a.event_tm
       and a.event_tm >= c.start_time
       and c.end_time>a.event_tm
     where activity_or_shorplay != 0
       and unlock_type in ('1', '2', '3', '6', '9', '10', '11')
     group by 1, 2, 3, 4, 5, 6
)
, watch_vedio as (
    select b.ab_id                         as exp_id
         , b.version_id                    as exp_grp_id
         , c.exp_grp_ver_id
         , a.dt
         , a.event_strategy_id
         , a.login_id                      as user_id
         , count(distinct a.episode_id)    as watch_epis
      from (select dt
                 , login_id
                 , episode_id
                 , event_tm
                 , split(activity_link, '_')[5]    as event_strategy_id
                 , split(activity_link, '_')[8]    as activity_or_shorplay
              from ads.ads_sensors_cd_video_startwatching_view           as a1
             where dt = '${dt}'
               and product_id = '6833'
               and activity_link is not null
           )                                as a
      join ods.ods_ab_hj_related            as b
        on a.event_strategy_id = b.strategy_id
      join dwd.dwd_ab_exp_version_detail    as c
        on b.ab_id = c.exp_id
       and b.version_id= c.exp_grp_id
       and a.event_tm >= c.exp_start_time
       and c.exp_end_time>a.event_tm
       and a.event_tm >= c.start_time
       and c.end_time>a.event_tm
     where activity_or_shorplay != 0
       and coalesce(a.login_id, '') != ''
     group by 1, 2, 3, 4, 5, 6
)
select dt
     , exp_id
     , exp_grp_id
     , exp_grp_ver_id
     , user_id
     , max(recharge_amount)     as recharge_amount
     , max(total_adv_amount)    as total_adv_amount
     , max(adv_amount)          as adv_amount
     , max(third_h5_amount)     as third_h5_amount
     , max(adv_unlock_times)    as adv_unlock_times
     , max(unlock_amount)       as unlock_amount
     , now()
     , max(watch_episodes)      as watch_episodes
  from (select '${dt}'                          as dt
             , a.exp_id                         as exp_id
             , a.exp_grp_id                     as exp_grp_id
             , a.exp_grp_ver_id                 as exp_grp_ver_id
             , a.user_id
             , ifnull(b.recharge_amount, 0)     as recharge_amount
             , ifnull(a.total_adv_amount, 0)    as total_adv_amount
             , ifnull(a.adv_amount, 0)          as adv_amount
             , ifnull(a.third_h5_amount, 0)     as third_h5_amount
             , ifnull(a.adv_unlock_times, 0)    as adv_unlock_times
             , 0                                as unlock_amount
             , 0                                as watch_episodes
          from adv_data_tmp            as a
          left join pay_amount_data    as b
            on a.exp_id = b.exp_id
           and a.exp_grp_id = b.exp_grp_id
           and a.exp_grp_ver_id = b.exp_grp_ver_id
           and a.user_id = b.user_id
         union all
        select '${dt}'             as dt
             , a.exp_id            as exp_id
             , a.exp_grp_id        as exp_grp_id
             , a.exp_grp_ver_id    as exp_grp_ver_id
             , a.user_id           as user_id
             , 0                   as recharge_amount
             , 0                   as total_adv_amount
             , 0                   as adv_amount
             , 0                   as third_h5_amount
             , 0                   as adv_unlock_times
             , unlock_amount       as unlock_amount
             , 0                   as watch_episodes
          from pay_unlock    as a
         union all
        select '${dt}'             as dt
             , a.exp_id            as exp_id
             , a.exp_grp_id        as exp_grp_id
             , a.exp_grp_ver_id    as exp_grp_ver_id
             , a.user_id           as user_id
             , 0                   as recharge_amount
             , 0                   as total_adv_amount
             , 0                   as adv_amount
             , 0                   as third_h5_amount
             , 0                   as adv_unlock_times
             , 0                   as unlock_amount
             , a.watch_epis        as watch_episodes
          from watch_vedio    as a
       ) a
 group by 1, 2, 3, 4, 5
;