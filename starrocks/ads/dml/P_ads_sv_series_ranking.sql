----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_sv_series_ranking
-- workflow_version : 10
-- create_user      : chenmo
-- task_name        : ads_sv_series_ranking
-- task_version     : 7
-- update_time      : 2026-05-21 21:19:34
-- sql_path         : \starrocks\tbl_ads_sv_series_ranking\ads_sv_series_ranking
----------------------------------------------------------------
-- 前置SQL语句
delete from ads.ads_sv_series_ranking where dt = '${dt}';

-- SQL语句
-- 总榜
insert into ads.ads_sv_series_ranking
select '${dt}'                                    as dt
     , 1                                          as days
     , d.series_id
     , d.language                                 as lang_id
     , d.publish_edat
     , d.series_level
     , d.publish_status
     , ifnull(b.consume_value, 0)                 as consume_value
     , ifnull(c.account_id, 0)                    as uv
     , ifnull(e.vip_unlock_episode_count, 0)      as vip_unlock_episode_count
     , now()                                      as etl_time
  from (select series_id
          from dim.dim_short_video_series_view
         where publish_edat < now()
           and publish_status = 1
           and last_epis != 0
       )                                          as a
  full join (select series_id
                  , sum(consume_value)             as consume_value
               from dwd.dwd_sv_consume_user_consume_bill_pdi
              where create_time < now()
                and series_id is not null
              group by series_id
            )                                     as b
    on a.series_id = b.series_id
  full join (select series_id
                  , count(distinct account_id)     as account_id
               from dwd.dwd_video_short_video_epis_history
              where create_time < now()
              group by series_id
            )                                     as c
    on ifnull(a.series_id, b.series_id) = c.series_id
  full join (select shortplay_id                  as series_id
                  , count(1)                      as vip_unlock_episode_count
               from dwd.dwd_sensors_cd_video_unlockEpisode_view
              where unlock_type = 3
                and event_tm < now()
              group by shortplay_id
            )                                     as e
    on coalesce(a.series_id, b.series_id, c.series_id) = e.series_id
  left join (select series_id
                  , publish_edat
                  , series_level
                  , publish_status
                  , language
               from dim.dim_short_video_series_view
            )                                     as d
    on coalesce(a.series_id, b.series_id, c.series_id, e.series_id) = d.series_id
 where d.series_id is not null
;

-- SQL语句
-- 一日榜
insert into ads.ads_sv_series_ranking
select '${dt}'                                    as dt
     , 2                                          as days
     , d.series_id
     , d.language                                 as lang_id
     , d.publish_edat
     , d.series_level
     , d.publish_status
     , ifnull(b.consume_value, 0)                 as consume_value
     , ifnull(c.account_id, 0)                    as uv
     , ifnull(e.vip_unlock_episode_count, 0)      as vip_unlock_episode_count
     , now()                                      as etl_time
  from (select series_id
          from dim.dim_short_video_series_view
         where publish_edat >= date_sub(now(), interval 1 day)
           and publish_edat < now()
           and publish_status = 1
           and last_epis != 0
       )                                          as a
  full join (select series_id
                  , sum(consume_value)             as consume_value
               from dwd.dwd_sv_consume_user_consume_bill_pdi
              where create_time >= date_sub(now(), interval 1 day)
                and create_time < now()
                and series_id is not null
              group by series_id
            )                                     as b
    on a.series_id = b.series_id
  full join (select series_id
                  , count(distinct account_id)     as account_id
               from dwd.dwd_video_short_video_epis_history
              where create_time >= date_sub(now(), interval 1 day)
                and create_time < now()
              group by series_id
            )                                     as c
    on ifnull(a.series_id, b.series_id) = c.series_id
  full join (select shortplay_id                  as series_id
                  , count(1)                      as vip_unlock_episode_count
               from dwd.dwd_sensors_cd_video_unlockEpisode_view
              where unlock_type = 3
                and event_tm >= date_sub(now(), interval 1 day)
                and event_tm < now()
              group by shortplay_id
            )                                     as e
    on coalesce(a.series_id, b.series_id, c.series_id) = e.series_id
  left join (select series_id
                  , publish_edat
                  , series_level
                  , publish_status
                  , language
               from dim.dim_short_video_series_view
            )                                     as d
    on coalesce(a.series_id, b.series_id, c.series_id, e.series_id) = d.series_id
 where d.series_id is not null
;

-- SQL语句
-- 三日榜
insert into ads.ads_sv_series_ranking
select '${dt}'                                    as dt
     , 3                                          as days
     , d.series_id
     , d.language                                 as lang_id
     , d.publish_edat
     , d.series_level
     , d.publish_status
     , ifnull(b.consume_value, 0)                 as consume_value
     , ifnull(c.account_id, 0)                    as uv
     , ifnull(e.vip_unlock_episode_count, 0)      as vip_unlock_episode_count
     , now()                                      as etl_time
  from (select series_id
          from dim.dim_short_video_series_view
         where publish_edat >= date_sub(now(), interval 3 day)
           and publish_edat < now()
           and publish_status = 1
           and last_epis != 0
       )                                          as a
  full join (select series_id
                  , sum(consume_value)             as consume_value
               from dwd.dwd_sv_consume_user_consume_bill_pdi
              where create_time >= date_sub(now(), interval 3 day)
                and create_time < now()
                and series_id is not null
              group by series_id
            )                                     as b
    on a.series_id = b.series_id
  full join (select series_id
                  , count(distinct account_id)     as account_id
               from dwd.dwd_video_short_video_epis_history
              where create_time >= date_sub(now(), interval 3 day)
                and create_time < now()
              group by series_id
            )                                     as c
    on ifnull(a.series_id, b.series_id) = c.series_id
  full join (select shortplay_id                  as series_id
                  , count(1)                      as vip_unlock_episode_count
               from dwd.dwd_sensors_cd_video_unlockEpisode_view
              where unlock_type = 3
                and event_tm >= date_sub(now(), interval 3 day)
                and event_tm < now()
              group by shortplay_id
            )                                     as e
    on coalesce(a.series_id, b.series_id, c.series_id) = e.series_id
  left join (select series_id
                  , publish_edat
                  , series_level
                  , publish_status
                  , language
               from dim.dim_short_video_series_view
            )                                     as d
    on coalesce(a.series_id, b.series_id, c.series_id, e.series_id) = d.series_id
 where d.series_id is not null
;

-- SQL语句
-- 七日榜
insert into ads.ads_sv_series_ranking
select '${dt}'                                    as dt
     , 4                                          as days
     , d.series_id
     , d.language                                 as lang_id
     , d.publish_edat
     , d.series_level
     , d.publish_status
     , ifnull(b.consume_value, 0)                 as consume_value
     , ifnull(c.account_id, 0)                    as uv
     , ifnull(e.vip_unlock_episode_count, 0)      as vip_unlock_episode_count
     , now()                                      as etl_time
  from (select series_id
          from dim.dim_short_video_series_view
         where publish_edat >= date_sub(now(), interval 7 day)
           and publish_edat < now()
           and publish_status = 1
           and last_epis != 0
       )                                          as a
  full join (select series_id
                  , sum(consume_value)             as consume_value
               from dwd.dwd_sv_consume_user_consume_bill_pdi
              where create_time >= date_sub(now(), interval 7 day)
                and create_time < now()
                and series_id is not null
              group by series_id
            )                                     as b
    on a.series_id = b.series_id
  full join (select series_id
                  , count(distinct account_id)     as account_id
               from dwd.dwd_video_short_video_epis_history
              where create_time >= date_sub(now(), interval 7 day)
                and create_time < now()
              group by series_id
            )                                     as c
    on ifnull(a.series_id, b.series_id) = c.series_id
  full join (select shortplay_id                  as series_id
                  , count(1)                      as vip_unlock_episode_count
               from dwd.dwd_sensors_cd_video_unlockEpisode_view
              where unlock_type = 3
                and event_tm >= date_sub(now(), interval 7 day)
                and event_tm < now()
              group by shortplay_id
            )                                     as e
    on coalesce(a.series_id, b.series_id, c.series_id) = e.series_id
  left join (select series_id
                  , publish_edat
                  , series_level
                  , publish_status
                  , language
               from dim.dim_short_video_series_view
            )                                     as d
    on coalesce(a.series_id, b.series_id, c.series_id, e.series_id) = d.series_id
 where d.series_id is not null
;

-- SQL语句
-- 十五日榜
insert into ads.ads_sv_series_ranking
select '${dt}'                                    as dt
     , 5                                          as days
     , d.series_id
     , d.language                                 as lang_id
     , d.publish_edat
     , d.series_level
     , d.publish_status
     , ifnull(b.consume_value, 0)                 as consume_value
     , ifnull(c.account_id, 0)                    as uv
     , ifnull(e.vip_unlock_episode_count, 0)      as vip_unlock_episode_count
     , now()                                      as etl_time
  from (select series_id
          from dim.dim_short_video_series_view
         where publish_edat >= date_sub(now(), interval 15 day)
           and publish_edat < now()
           and publish_status = 1
           and last_epis != 0
       )                                          as a
  full join (select series_id
                  , sum(consume_value)             as consume_value
               from dwd.dwd_sv_consume_user_consume_bill_pdi
              where create_time >= date_sub(now(), interval 15 day)
                and create_time < now()
                and series_id is not null
              group by series_id
            )                                     as b
    on a.series_id = b.series_id
  full join (select series_id
                  , count(distinct account_id)     as account_id
               from dwd.dwd_video_short_video_epis_history
              where create_time >= date_sub(now(), interval 15 day)
                and create_time < now()
              group by series_id
            )                                     as c
    on ifnull(a.series_id, b.series_id) = c.series_id
  full join (select shortplay_id                  as series_id
                  , count(1)                      as vip_unlock_episode_count
               from dwd.dwd_sensors_cd_video_unlockEpisode_view
              where unlock_type = 3
                and event_tm >= date_sub(now(), interval 15 day)
                and event_tm < now()
              group by shortplay_id
            )                                     as e
    on coalesce(a.series_id, b.series_id, c.series_id) = e.series_id
  left join (select series_id
                  , publish_edat
                  , series_level
                  , publish_status
                  , language
               from dim.dim_short_video_series_view
            )                                     as d
    on coalesce(a.series_id, b.series_id, c.series_id, e.series_id) = d.series_id
 where d.series_id is not null
;

-- SQL语句
-- 三十日榜
insert into ads.ads_sv_series_ranking
select '${dt}'                                    as dt
     , 6                                          as days
     , d.series_id
     , d.language                                 as lang_id
     , d.publish_edat
     , d.series_level
     , d.publish_status
     , ifnull(b.consume_value, 0)                 as consume_value
     , ifnull(c.account_id, 0)                    as uv
     , ifnull(e.vip_unlock_episode_count, 0)      as vip_unlock_episode_count
     , now()                                      as etl_time
  from (select series_id
          from dim.dim_short_video_series_view
         where publish_edat >= date_sub(now(), interval 30 day)
           and publish_edat < now()
           and publish_status = 1
           and last_epis != 0
       )                                          as a
  full join (select series_id
                  , sum(consume_value)             as consume_value
               from dwd.dwd_sv_consume_user_consume_bill_pdi
              where create_time >= date_sub(now(), interval 30 day)
                and create_time < now()
                and series_id is not null
              group by series_id
            )                                     as b
    on a.series_id = b.series_id
  full join (select series_id
                  , count(distinct account_id)     as account_id
               from dwd.dwd_video_short_video_epis_history
              where create_time >= date_sub(now(), interval 30 day)
                and create_time < now()
              group by series_id
            )                                     as c
    on ifnull(a.series_id, b.series_id) = c.series_id
  full join (select shortplay_id                  as series_id
                  , count(1)                      as vip_unlock_episode_count
               from dwd.dwd_sensors_cd_video_unlockEpisode_view
              where unlock_type = 3
                and event_tm >= date_sub(now(), interval 30 day)
                and event_tm < now()
              group by shortplay_id
            )                                     as e
    on coalesce(a.series_id, b.series_id, c.series_id) = e.series_id
  left join (select series_id
                  , publish_edat
                  , series_level
                  , publish_status
                  , language
               from dim.dim_short_video_series_view
            )                                     as d
    on coalesce(a.series_id, b.series_id, c.series_id, e.series_id) = d.series_id
 where d.series_id is not null
;

-- SQL语句
-- 六十日榜
insert into ads.ads_sv_series_ranking
select '${dt}'                                    as dt
     , 7                                          as days
     , d.series_id
     , d.language                                 as lang_id
     , d.publish_edat
     , d.series_level
     , d.publish_status
     , ifnull(b.consume_value, 0)                 as consume_value
     , ifnull(c.account_id, 0)                    as uv
     , ifnull(e.vip_unlock_episode_count, 0)      as vip_unlock_episode_count
     , now()                                      as etl_time
  from (select series_id
          from dim.dim_short_video_series_view
         where publish_edat >= date_sub(now(), interval 60 day)
           and publish_edat < now()
           and publish_status = 1
           and last_epis != 0
       )                                          as a
  full join (select series_id
                  , sum(consume_value)             as consume_value
               from dwd.dwd_sv_consume_user_consume_bill_pdi
              where create_time >= date_sub(now(), interval 60 day)
                and create_time < now()
                and series_id is not null
              group by series_id
            )                                     as b
    on a.series_id = b.series_id
  full join (select series_id
                  , count(distinct account_id)     as account_id
               from dwd.dwd_video_short_video_epis_history
              where create_time >= date_sub(now(), interval 60 day)
                and create_time < now()
              group by series_id
            )                                     as c
    on ifnull(a.series_id, b.series_id) = c.series_id
  full join (select shortplay_id                  as series_id
                  , count(1)                      as vip_unlock_episode_count
               from dwd.dwd_sensors_cd_video_unlockEpisode_view
              where unlock_type = 3
                and event_tm >= date_sub(now(), interval 60 day)
                and event_tm < now()
              group by shortplay_id
            )                                     as e
    on coalesce(a.series_id, b.series_id, c.series_id) = e.series_id
  left join (select series_id
                  , publish_edat
                  , series_level
                  , publish_status
                  , language
               from dim.dim_short_video_series_view
            )                                     as d
    on coalesce(a.series_id, b.series_id, c.series_id, e.series_id) = d.series_id
 where d.series_id is not null
;

-- SQL语句
-- 九十日榜
insert into ads.ads_sv_series_ranking
select '${dt}'                                    as dt
     , 8                                          as days
     , d.series_id
     , d.language                                 as lang_id
     , d.publish_edat
     , d.series_level
     , d.publish_status
     , ifnull(b.consume_value, 0)                 as consume_value
     , ifnull(c.account_id, 0)                    as uv
     , ifnull(e.vip_unlock_episode_count, 0)      as vip_unlock_episode_count
     , now()                                      as etl_time
  from (select series_id
          from dim.dim_short_video_series_view
         where publish_edat >= date_sub(now(), interval 90 day)
           and publish_edat < now()
           and publish_status = 1
           and last_epis != 0
       )                                          as a
  full join (select series_id
                  , sum(consume_value)             as consume_value
               from dwd.dwd_sv_consume_user_consume_bill_pdi
              where create_time >= date_sub(now(), interval 90 day)
                and create_time < now()
                and series_id is not null
              group by series_id
            )                                     as b
    on a.series_id = b.series_id
  full join (select series_id
                  , count(distinct account_id)     as account_id
               from dwd.dwd_video_short_video_epis_history
              where create_time >= date_sub(now(), interval 90 day)
                and create_time < now()
              group by series_id
            )                                     as c
    on ifnull(a.series_id, b.series_id) = c.series_id
  full join (select shortplay_id                  as series_id
                  , count(1)                      as vip_unlock_episode_count
               from dwd.dwd_sensors_cd_video_unlockEpisode_view
              where unlock_type = 3
                and event_tm >= date_sub(now(), interval 90 day)
                and event_tm < now()
              group by shortplay_id
            )                                     as e
    on coalesce(a.series_id, b.series_id, c.series_id) = e.series_id
  left join (select series_id
                  , publish_edat
                  , series_level
                  , publish_status
                  , language
               from dim.dim_short_video_series_view
            )                                     as d
    on coalesce(a.series_id, b.series_id, c.series_id, e.series_id) = d.series_id
 where d.series_id is not null
;

-- SQL语句
-- 一百八十日榜
insert into ads.ads_sv_series_ranking
select '${dt}'                                    as dt
     , 9                                          as days
     , d.series_id
     , d.language                                 as lang_id
     , d.publish_edat
     , d.series_level
     , d.publish_status
     , ifnull(b.consume_value, 0)                 as consume_value
     , ifnull(c.account_id, 0)                    as uv
     , ifnull(e.vip_unlock_episode_count, 0)      as vip_unlock_episode_count
     , now()                                      as etl_time
  from (select series_id
          from dim.dim_short_video_series_view
         where publish_edat >= date_sub(now(), interval 180 day)
           and publish_edat < now()
           and publish_status = 1
           and last_epis != 0
       )                                          as a
  full join (select series_id
                  , sum(consume_value)             as consume_value
               from dwd.dwd_sv_consume_user_consume_bill_pdi
              where create_time >= date_sub(now(), interval 180 day)
                and create_time < now()
                and series_id is not null
              group by series_id
            )                                     as b
    on a.series_id = b.series_id
  full join (select series_id
                  , count(distinct account_id)     as account_id
               from dwd.dwd_video_short_video_epis_history
              where create_time >= date_sub(now(), interval 180 day)
                and create_time < now()
              group by series_id
            )                                     as c
    on ifnull(a.series_id, b.series_id) = c.series_id
  full join (select shortplay_id                  as series_id
                  , count(1)                      as vip_unlock_episode_count
               from dwd.dwd_sensors_cd_video_unlockEpisode_view
              where unlock_type = 3
                and event_tm >= date_sub(now(), interval 180 day)
                and event_tm < now()
              group by shortplay_id
            )                                     as e
    on coalesce(a.series_id, b.series_id, c.series_id) = e.series_id
  left join (select series_id
                  , publish_edat
                  , series_level
                  , publish_status
                  , language
               from dim.dim_short_video_series_view
            )                                     as d
    on coalesce(a.series_id, b.series_id, c.series_id, e.series_id) = d.series_id
 where d.series_id is not null
;

-- SQL语句
-- 一年榜
insert into ads.ads_sv_series_ranking
select '${dt}'                                    as dt
     , 10                                         as days
     , d.series_id
     , d.language                                 as lang_id
     , d.publish_edat
     , d.series_level
     , d.publish_status
     , ifnull(b.consume_value, 0)                 as consume_value
     , ifnull(c.account_id, 0)                    as uv
     , ifnull(e.vip_unlock_episode_count, 0)      as vip_unlock_episode_count
     , now()                                      as etl_time
  from (select series_id
          from dim.dim_short_video_series_view
         where publish_edat >= date_sub(now(), interval 365 day)
           and publish_edat < now()
           and publish_status = 1
           and last_epis != 0
       )                                          as a
  full join (select series_id
                  , sum(consume_value)             as consume_value
               from dwd.dwd_sv_consume_user_consume_bill_pdi
              where create_time >= date_sub(now(), interval 365 day)
                and create_time < now()
                and series_id is not null
              group by series_id
            )                                     as b
    on a.series_id = b.series_id
  full join (select series_id
                  , count(distinct account_id)     as account_id
               from dwd.dwd_video_short_video_epis_history
              where create_time >= date_sub(now(), interval 365 day)
                and create_time < now()
              group by series_id
            )                                     as c
    on ifnull(a.series_id, b.series_id) = c.series_id
  full join (select shortplay_id                  as series_id
                  , count(1)                      as vip_unlock_episode_count
               from dwd.dwd_sensors_cd_video_unlockEpisode_view
              where unlock_type = 3
                and event_tm >= date_sub(now(), interval 365 day)
                and event_tm < now()
              group by shortplay_id
            )                                     as e
    on coalesce(a.series_id, b.series_id, c.series_id) = e.series_id
  left join (select series_id
                  , publish_edat
                  , series_level
                  , publish_status
                  , language
               from dim.dim_short_video_series_view
            )                                     as d
    on coalesce(a.series_id, b.series_id, c.series_id, e.series_id) = d.series_id
 where d.series_id is not null
;
