----------------------------------------------------------------
-- 程序功能： 热剧榜（西五区）
-- 程序名： P_ads_sv_hot_series_rank_di_west5
-- 目标表： ads.ads_sv_hot_series_rank_di_west5
-- 负责人： roger
-- 开发日期：2026-04-02
-- 版本号： v1.1
----------------------------------------------------------------

insert into ads.ads_sv_hot_series_rank_di_west5
with
period_cfg as (
    select '24h' as period_type, 24 as back_hours
    union all
    select '36h', 36
    union all
    select '14d', 336
    union all
    select '30d', 720
),

-- endwatching 源表去重（按用户+剧+集）
epis_watch_view as (
    select p.period_type
         , ew.login_id                                          as user_id
         , coalesce(cast(substring(ew.app_id, 4, 3) as int), 0) as core
         , ew.shortplay_id                                      as series_id
         , ew.episode_id                                        as epis_id
         , ew.watch_episode_sort                                as epis_num
         , max(if(cast(ew.watch_progress as double) > 1, 1,
                  cast(ew.watch_progress as double)))           as watch_progress
    from dwd.dwd_sensors_cd_video_endwatching_view ew
    cross join period_cfg p
    where date_add(ew.event_tm, interval -13 hour) >= hours_add(cast('${dt}' as datetime), -p.back_hours)
      and date_add(ew.event_tm, interval -13 hour) <= cast('${dt}' as datetime)
      and ew.shortplay_id is not null
      and ew.app_id is not null
    group by 1, 2, 3, 4, 5, 6
),

watch_base as (
    select ew.period_type
         , ew.user_id
         , ew.core
         , ew.series_id
         , coalesce(s.language, 0)                                  as language_code
         , ew.epis_id
         , ew.epis_num
         , ew.watch_progress * coalesce(ev.duration, 0)             as watch_duration
    from epis_watch_view ew
    left join dim.dim_short_video_epis_view ev
      on ew.series_id = ev.series_id and ew.epis_id = ev.epis_id
    left join dim.dim_short_video_series_view s
      on ew.series_id = s.series_id
),

user_series_stat as (
    select w.period_type
         , w.user_id
         , w.core
         , w.language_code
         , w.series_id
         , sum(w.watch_duration)                                     as total_watch_duration
         , count(distinct w.epis_id)                                as watch_epis_count
         , max(case when w.epis_num = 1 then w.watch_duration else 0 end) as first_epis_watch_duration
         , max(case when w.epis_num = 1 then e.duration else 0 end) as first_epis_duration
    from watch_base w
    left join dim.dim_short_video_epis_view e
      on w.series_id = e.series_id and w.epis_id = e.epis_id
    group by 1, 2, 3, 4, 5
),

metric_stat as (
    select period_type
         , core
         , language_code
         , series_id
         , sum(watch_epis_count)                                     as total_play_epis_count
         , count(distinct user_id)                                   as play_user_cnt
         , count(distinct user_id)                                   as complete_user_cnt
         , count(distinct case when total_watch_duration >= 10 then user_id end) as complete_10s_user_cnt
         , count(distinct case
                              when first_epis_duration > 0
                               and first_epis_watch_duration >= first_epis_duration * 0.95
                                  then user_id
                         end)                                         as first_epis_complete_user_cnt
    from user_series_stat
    group by 1, 2, 3, 4
),

click_stat as (
    select p.period_type
         , c.core
         , coalesce(s.language, 0)                  as language_code
         , c.shortplay_id                            as series_id
         , count(1)                                  as click_num
    from ads.ads_sensors_cd_video_itemclick_view c
    cross join period_cfg p
    left join dim.dim_short_video_series_view s
      on c.shortplay_id = s.series_id
    where date_add(c.event_tm, interval -13 hour) >= hours_add(cast('${dt}' as datetime), -p.back_hours)
      and date_add(c.event_tm, interval -13 hour) <= cast('${dt}' as datetime)
      and c.shortplay_id is not null
    group by 1, 2, 3, 4
),

exposure_stat as (
    select p.period_type
         , e.core
         , coalesce(s.language, 0)                  as language_code
         , e.shortplay_id                            as series_id
         , count(1)                                  as exposure_num
    from ads.ads_sensors_cd_video_itemexposure_view e
    cross join period_cfg p
    left join dim.dim_short_video_series_view s
      on e.shortplay_id = s.series_id
    where date_add(e.event_tm, interval -13 hour) >= hours_add(cast('${dt}' as datetime), -p.back_hours)
      and date_add(e.event_tm, interval -13 hour) <= cast('${dt}' as datetime)
      and e.shortplay_id is not null
    group by 1, 2, 3, 4
),

click_exposure_stat as (
    select coalesce(c.period_type, e.period_type)    as period_type
         , coalesce(c.core, e.core)                  as core
         , coalesce(c.language_code, e.language_code) as language_code
         , coalesce(c.series_id, e.series_id)         as series_id
         , c.click_num
         , e.exposure_num
    from click_stat c
    full outer join exposure_stat e
      on c.period_type = e.period_type
     and c.core = e.core
     and c.language_code = e.language_code
     and c.series_id = e.series_id
),

ad_income as (
    select p.period_type
         , cast(u.corever as int)                      as core
         , coalesce(s.language, 0)                     as language_code
         , a.shortplay_id                              as series_id
         , sum(case
                   when a.ad_platform in ('Max', 'MAX') then a.ad_revenue / 10000
                   when a.ad_platform = 'AdMob' and a.os in ('Android', 'HarmonyOS') and a.ad_revenue_category in (0, 1, 3)
                       then a.ad_revenue / 10000 / 1000000
                   when a.ad_platform = 'AdMob' and a.os in ('Android', 'HarmonyOS') and a.ad_revenue_category = 2
                       then a.ad_revenue / 10000 / 1000 / 1000000
                   when a.ad_platform = 'AdMob' and a.os = 'iOS' and a.ad_revenue_category in (0, 1, 3)
                       then a.ad_revenue / 10000
                   when a.ad_platform = 'AdMob' and a.os = 'iOS' and a.ad_revenue_category = 2
                       then a.ad_revenue / 10000 / 1000
                   else 0
               end)                                    as amount
    from ods_log.ods_sensors_sr_sv_adrevenueaction a
    join dim.dim_short_video_user_accountinfo u
      on a.login_id = u.user_id
     and u.reg_country is not null
    cross join period_cfg p
    left join dim.dim_short_video_series_view s
      on a.shortplay_id = s.series_id
    where date_add(a.event_tm, interval -13 hour) >= hours_add(cast('${dt}' as datetime), -p.back_hours)
      and date_add(a.event_tm, interval -13 hour) <= cast('${dt}' as datetime)
      and a.project_id = 8
      and a.shortplay_id is not null
      and a.shortplay_id != 0
      and u.corever is not null
    group by 1, 2, 3, 4
),

recharge_income as (
    select p.period_type
         , cast(u.corever as int)                      as core
         , coalesce(s.language, 0)                     as language_code
         , coalesce(c.series_id, e.series_id)          as series_id
         , sum(c.consume_value) / 100                  as amount
    from dim.dim_short_video_epis_view e
    join dwd.dwd_sv_consume_user_consume_bill_pdi c
      on e.epis_id = c.epis_id
    join dim.dim_short_video_user_accountinfo u
      on c.account_id = u.user_id
     and u.reg_country is not null
    cross join period_cfg p
    left join dim.dim_short_video_series_view s
      on coalesce(c.series_id, e.series_id) = s.series_id
    where date_add(c.create_time, interval -13 hour) >= hours_add(cast('${dt}' as datetime), -p.back_hours)
      and date_add(c.create_time, interval -13 hour) <= cast('${dt}' as datetime)
      and u.corever is not null
    group by 1, 2, 3, 4
),

income_stat as (
    select period_type
         , core
         , language_code
         , series_id
         , sum(amount) as total_income
    from (
        select period_type, core, language_code, series_id, amount from ad_income
        union all
        select period_type, core, language_code, series_id, amount from recharge_income
    ) t
    group by 1, 2, 3, 4
),

base_keys as (
    select period_type, core, language_code, series_id from metric_stat
    union
    select period_type, core, language_code, series_id from click_exposure_stat
    union
    select period_type, core, language_code, series_id from income_stat
),

base_stat as (
    select k.period_type
         , k.core
         , k.language_code
         , k.series_id
         , i.total_income
         , case
               when m.play_user_cnt is null or m.play_user_cnt = 0 then null
               else cast(m.total_play_epis_count as decimal(20, 6)) / m.play_user_cnt
           end                                        as avg_play_episode_count
         , m.complete_user_cnt
         , m.complete_10s_user_cnt
         , m.first_epis_complete_user_cnt
         , case
               when ce.exposure_num is null or ce.exposure_num = 0 then null
               else cast(ce.click_num as decimal(20, 6)) / ce.exposure_num
           end                                        as cover_click_rate
         , m.play_user_cnt
    from base_keys k
    left join metric_stat m
      on k.period_type = m.period_type
     and k.core = m.core
     and k.language_code = m.language_code
     and k.series_id = m.series_id
    left join click_exposure_stat ce
      on k.period_type = ce.period_type
     and k.core = ce.core
     and k.language_code = ce.language_code
     and k.series_id = ce.series_id
    left join income_stat i
      on k.period_type = i.period_type
     and k.core = i.core
     and k.language_code = i.language_code
     and k.series_id = i.series_id
),

series_info as (
    select s.series_id
         , s.publish_edat          as publish_time
         , s.series_code
         , s.series_name
         , coalesce(s.language, 0) as language_code
         , d.cd_val_desc           as language_name
    from dim.dim_short_video_series_view s
    left join dim.dim_pub_code_mapping_dict d
      on d.app_plat = 'pub'
     and d.cd_col = 'lang_cd'
     and d.cd_val = s.language
),

metric_with_info as (
    select b.period_type
         , b.core
         , b.language_code
         , b.series_id
         , i.publish_time
         , i.language_name
         , i.series_code
         , i.series_name
         , b.total_income
         , b.avg_play_episode_count
         , b.complete_user_cnt
         , b.complete_10s_user_cnt
         , b.first_epis_complete_user_cnt
         , b.cover_click_rate
         , b.play_user_cnt
    from base_stat b
    left join series_info i
      on b.series_id = i.series_id
    where b.series_id is not null
),

pct_ranked as (
    select *
         , percent_rank() over(partition by period_type, core, language_code order by total_income) as total_income_pct
         , case when play_user_cnt >= 100 and avg_play_episode_count is not null
                then percent_rank() over(partition by period_type, core, language_code order by avg_play_episode_count)
                else null end as avg_play_episode_pct
         , percent_rank() over(partition by period_type, core, language_code order by complete_user_cnt) as complete_user_pct
         , percent_rank() over(partition by period_type, core, language_code order by complete_10s_user_cnt) as complete_10s_user_pct
         , percent_rank() over(partition by period_type, core, language_code order by first_epis_complete_user_cnt) as first_epis_complete_pct
         , case when play_user_cnt >= 100 and cover_click_rate is not null
                then percent_rank() over(partition by period_type, core, language_code order by cover_click_rate)
                else null end as cover_click_rate_pct
    from metric_with_info
),

scored as (
    select period_type
         , core
         , language_code
         , series_id
         , publish_time
         , language_name
         , series_code
         , series_name
         , (
               case
                   when total_income is null then 10
                   when total_income_pct >= 0.95 then 200
                   when total_income_pct >= 0.80 then 100
                   when total_income_pct >= 0.60 then 60
                   when total_income_pct >= 0.40 then 40
                   else 20
               end
             + case
                   when avg_play_episode_pct is null then 10
                   when avg_play_episode_pct >= 0.95 then 100
                   when avg_play_episode_pct >= 0.80 then 80
                   when avg_play_episode_pct >= 0.60 then 60
                   when avg_play_episode_pct >= 0.40 then 40
                   else 20
               end
             + case
                   when complete_user_cnt is null then 10
                   when complete_user_pct >= 0.95 then 100
                   when complete_user_pct >= 0.80 then 80
                   when complete_user_pct >= 0.60 then 60
                   when complete_user_pct >= 0.40 then 40
                   else 20
               end
             + case
                   when complete_10s_user_cnt is null then 10
                   when complete_10s_user_pct >= 0.95 then 100
                   when complete_10s_user_pct >= 0.80 then 80
                   when complete_10s_user_pct >= 0.60 then 60
                   when complete_10s_user_pct >= 0.40 then 40
                   else 20
               end
             + case
                   when first_epis_complete_user_cnt is null then 10
                   when first_epis_complete_pct >= 0.95 then 100
                   when first_epis_complete_pct >= 0.80 then 80
                   when first_epis_complete_pct >= 0.60 then 60
                   when first_epis_complete_pct >= 0.40 then 40
                   else 20
               end
             + case
                   when cover_click_rate_pct is null then 10
                   when cover_click_rate_pct >= 0.95 then 100
                   when cover_click_rate_pct >= 0.80 then 80
                   when cover_click_rate_pct >= 0.60 then 60
                   when cover_click_rate_pct >= 0.40 then 40
                   else 20
               end
           ) as series_heat_score
    from pct_ranked
)

select cast('${dt}' as date) as dt
     , core
     , language_code
     , series_id
     , period_type
     , publish_time
     , language_name
     , series_code
     , series_name
     , series_heat_score
     , now() as etl_time
from scored
;

