----------------------------------------------------------------
-- 程序功能： 海外短剧行为统计表
-- 程序名： P_ads_bi_short_video_action_stat
-- 目标表： ads.ads_bi_short_video_action_stat
-- 负责人： lwb
-- 开发日期： 2026-06-15
----------------------------------------------------------------
-- 前置SQL语句
delete from ads.ads_bi_short_video_action_stat where dt >= date_sub('${dt}', interval 10 day) and dt < '${dt}';

-- SQL语句
insert into ads.ads_bi_short_video_action_stat
with b as (
    select dt
         , User_Id
         , Book_Id as series_id
      from (
          select dt
               , Product_Id
               , User_Id
               , Book_Id
               , Install_Date
               , row_number() over (partition by dt, Product_Id, User_Id order by Install_Date desc, Id desc) rn
            from (
                select a.dt
                     , b.id
                     , b.Product_Id
                     , b.User_Id
                     , b.Book_Id
                     , b.install_date
                  from (
                      select datestr as dt
                        from dim.dim_date
                       where datestr >= date_sub('${dt}', interval 10 day)
                         and datestr < '${dt}'
                  ) a
                  left join (
                      select id
                           , Product_Id
                           , User_Id
                           , Book_Id
                           , install_date
                           , dt
                           , Core
                        from dwd.dwd_user_install_info_ed_view
                       where dt >= date_sub('${dt}', interval 40 day)
                         and dt < '${dt}'
                         and Product_Id = 6833
                         and IsDelete != 1
                         and User_Id > 0
                         and Book_Id > 0
                  ) b
                    on datediff(a.dt, b.dt) >= 0
                   and datediff(a.dt, b.dt) <= 30
            ) t1
      ) t2
     where rn = 1
)
, startwatching_tmp as (
    select dt
         , shortplay_id
         , episode_id
         , login_id
         , core
         , event_tm
      from dwd.dwd_sensors_cd_video_startwatching_view
     where dt >= date_sub('${dt}', interval 10 day)
       and dt < '${dt}'
       and product_id = 6833
       and cast(shortplay_id as bigint) > 0
)
, svip as (
    select a.dt
         , a.series_id
         , a.episode_id
         , a.user_id
         , a.core
         , b.user_id as svip_user_id
         , c.is_free
      from (
          select dt
               , shortplay_id as series_id
               , episode_id
               , login_id as user_id
               , core
               , event_tm
            from startwatching_tmp
      ) a
      left join (
          select user_id
               , vip_start_time
               , vip_expire_time
            from ads.ads_bi_short_video_trade_user_subscribe_di
           where product_id = 6833
             and shop_item = 810
      ) b
        on a.user_id = b.user_id
       and a.event_tm >= b.vip_start_time
       and a.event_tm < b.vip_expire_time
      left join dim.dim_short_video_epis_view c
        on a.episode_id = c.epis_id
)
, unlockEpisode_tmp as (
    select dt
         , shortplay_id
         , login_id
         , core
         , episode_id
         , unlock_type
      from dwd.dwd_sensors_cd_video_unlockEpisode_view
     where dt >= date_sub('${dt}', interval 10 day)
       and dt < '${dt}'
       and product_id = 6833
       and project_id = 8
       and cast(shortplay_id as bigint) > 0
)
, base as (
    select a.dt
         , a.series_id
         , a.user_id
         , a.core
         , a.type
         , c.series_name
         , c.language                                      as series_language
         , f.source
         , if(b.user_id is not null and a.series_id = b.series_id, 1, 2) as is_toufang
         , coalesce(sst.subscribe_type_cd, '其他')         as user_subscribe_type
         , c.last_epis
         , 6833                                            as product_id
         , d.series_code
         , e.series_tp
         , c.publish_edat                                  as publish_tm
         , g.mt
      from (
          select dt
               , series_id
               , user_id
               , core
               , type
            from (
                select dt
                     , shortplay_id as series_id
                     , login_id as user_id
                     , core
                     , 1 as type
                  from dwd.dwd_sensors_cd_video_itemclick_view
                 where dt >= date_sub('${dt}', interval 10 day)
                   and dt < '${dt}'
                   and product_id = 6833
                   and project_id = 8
                   and cast(shortplay_id as bigint) > 0
                union all
                select dt
                     , shortplay_id as series_id
                     , login_id as user_id
                     , core
                     , 2 as type
                  from dwd.dwd_sensors_cd_video_itemexposure_view
                 where dt >= date_sub('${dt}', interval 10 day)
                   and dt < '${dt}'
                   and product_id = 6833
                   and project_id = 8
                   and cast(shortplay_id as bigint) > 0
                union all
                -- 解锁总数
                select dt
                     , shortplay_id as series_id
                     , login_id as user_id
                     , core
                     , 3 as type
                  from unlockEpisode_tmp
                union all
                -- 观看总数
                select dt
                     , shortplay_id as series_id
                     , login_id as user_id
                     , core
                     , 4 as type
                  from startwatching_tmp
                union all
                -- SVIP观看
                select dt
                     , series_id
                     , user_id
                     , core
                     , 5 as type
                  from svip
                 where svip_user_id is not null
                union all
                -- 消费解锁
                select dt
                     , shortplay_id as series_id
                     , login_id as user_id
                     , core
                     , 6 as type
                  from unlockEpisode_tmp
                 where unlock_type in (1, 2, 6, 9, 10, 11)
                union all
                -- SVIP解锁
                select dt
                     , shortplay_id as series_id
                     , login_id as user_id
                     , core
                     , 7 as type
                  from unlockEpisode_tmp
                 where unlock_type = 3
                union all
                -- 广告解锁
                select dt
                     , shortplay_id as series_id
                     , login_id as user_id
                     , core
                     , 8 as type
                  from unlockEpisode_tmp
                 where unlock_type = 8
                union all
                -- 解锁总数（剧集粒度）
                select dt
                     , shortplay_id as series_id
                     , concat(login_id, ':', episode_id) as user_id
                     , core
                     , 9 as type
                  from unlockEpisode_tmp
                union all
                -- 消费解锁剧集
                select dt
                     , shortplay_id as series_id
                     , concat(login_id, ':', episode_id) as user_id
                     , core
                     , 10 as type
                  from unlockEpisode_tmp
                 where unlock_type in (1, 2, 6, 9, 10, 11)
                union all
                -- SVIP解锁剧集
                select dt
                     , shortplay_id as series_id
                     , concat(login_id, ':', episode_id) as user_id
                     , core
                     , 11 as type
                  from unlockEpisode_tmp
                 where unlock_type = 3
                union all
                -- 广告解锁剧集
                select dt
                     , shortplay_id as series_id
                     , concat(login_id, ':', episode_id) as user_id
                     , core
                     , 12 as type
                  from unlockEpisode_tmp
                 where unlock_type = 8
            ) tmp1
           group by 1, 2, 3, 4, 5
      ) a
      left join b
        on a.dt = b.dt
       and substring_index(a.user_id, ':', 1) = b.user_id
      left join dim.dim_short_video_series_view c
        on a.series_id = c.series_id
      left join (
          select a.series_id as series_id
               , b.series_code as series_code
            from dim.dim_short_video_series_view a
            left join dim.dim_short_video_source_series_view b
              on a.source_series_id = b.series_id
           where b.series_id is not null
      ) d
        on a.series_id = d.series_id
      left join (
          select a.series_id
               , array_join(array_sort(array_distinct(array_agg(b.name))), '_') as series_tp
            from dim.dim_short_video_series_ref_type_view a
            left join dim.dim_short_video_series_type_view b
              on a.series_type_id = b.id
           group by 1
      ) e
        on a.series_id = e.series_id
      left join (
          select User_Id
               , Source
            from (
                select User_Id
                     , Source
                     , row_number() over (partition by User_Id order by Create_Time desc) as rn
                  from dwd.dwd_user_install_info_ed_view
                 where Product_Id = 6833
                   and IsDelete != 1
            ) f
           where rn = 1
      ) f
        on substring_index(a.user_id, ':', 1) = f.User_Id
      left join dim.dim_short_video_account_device_info g
        on substring_index(a.user_id, ':', 1) = g.user_id
      left join ads.ads_user_sv_subscribe_status_di sst
        on substring_index(a.user_id, ':', 1) = sst.user_id
       and sst.dt = a.dt
)
select dt
     , md5(concat(series_id, is_toufang, user_subscribe_type, if(Source is not null, Source, '-99'), if(mt is not null, mt, -99), if(core is not null, core, -99))) as md5_key
     , series_id
     , is_toufang
     , user_subscribe_type
     , Source
     , mt
     , core
     , product_id
     , series_name
     , series_language
     , last_epis
     , series_code
     , series_tp
     , publish_tm
     , bitmap_union(to_bitmap(if(type = 1, user_id, null)))                   as click_user_bitmap
     , bitmap_union(to_bitmap(if(type = 2, user_id, null)))                   as exposure_user_bitmap
     , bitmap_union(to_bitmap(if(type = 3, user_id, null)))                   as all_unlock_user_bitmap
     , bitmap_union(to_bitmap(if(type = 6, user_id, null)))                   as consume_unlock_user_bitmap
     , bitmap_union(to_bitmap(if(type = 7, user_id, null)))                   as svip_unlock_user_bitmap
     , bitmap_union(to_bitmap(if(type = 8, user_id, null)))                   as ad_unlock_user_bitmap
     , bitmap_union(to_bitmap(if(type = 4, user_id, null)))                   as watch_user_bitmap
     , bitmap_union(to_bitmap(if(type = 5, user_id, null)))                   as svip_watch_user_bitmap
     , count(if(type = 9, user_id, null))                                     as all_unlock_user_epis_cnt
     , count(if(type = 10, user_id, null))                                    as consume_unlock_user_epis_cnt
     , count(if(type = 11, user_id, null))                                    as svip_unlock_user_epis_cnt
     , count(if(type = 12, user_id, null))                                    as ad_unlock_user_epis_cnt
     , now()                                                                  as etl_time
  from base
 group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15
union all
select dt
     , md5(concat(series_id, 0, user_subscribe_type, if(Source is not null, Source, '-99'), if(mt is not null, mt, -99), if(core is not null, core, -99))) as md5_key
     , series_id
     , 0                                                                       as is_toufang
     , user_subscribe_type
     , Source
     , mt
     , core
     , product_id
     , series_name
     , series_language
     , last_epis
     , series_code
     , series_tp
     , publish_tm
     , bitmap_union(to_bitmap(if(type = 1, user_id, null)))                   as click_user_bitmap
     , bitmap_union(to_bitmap(if(type = 2, user_id, null)))                   as exposure_user_bitmap
     , bitmap_union(to_bitmap(if(type = 3, user_id, null)))                   as all_unlock_user_bitmap
     , bitmap_union(to_bitmap(if(type = 6, user_id, null)))                   as consume_unlock_user_bitmap
     , bitmap_union(to_bitmap(if(type = 7, user_id, null)))                   as svip_unlock_user_bitmap
     , bitmap_union(to_bitmap(if(type = 8, user_id, null)))                   as ad_unlock_user_bitmap
     , bitmap_union(to_bitmap(if(type = 4, user_id, null)))                   as watch_user_bitmap
     , bitmap_union(to_bitmap(if(type = 5, user_id, null)))                   as svip_watch_user_bitmap
     , count(if(type = 9, user_id, null))                                     as all_unlock_user_epis_cnt
     , count(if(type = 10, user_id, null))                                    as consume_unlock_user_epis_cnt
     , count(if(type = 11, user_id, null))                                    as svip_unlock_user_epis_cnt
     , count(if(type = 12, user_id, null))                                    as ad_unlock_user_epis_cnt
     , now()                                                                  as etl_time
  from base
 group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15
;
