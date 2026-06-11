----------------------------------------------------------------
-- 程序功能： 北斗短剧信息维表
-- 程序名： P_dim_sv_beidou_serices_detail_df
-- 目标表： dim.dim_sv_beidou_serices_detail_df
-- 负责人： roger
-- 开发日期：2026-01-26
----------------------------------------------------------------

insert into dim.dim_sv_beidou_serices_detail_df
select unnest          as core
     , language_code
     , series_id
     , language_name
     , series_code
     , series_name
     , all_epis
     , cover_url
     , publish_time
     , placement_time
     , series_duration
     , now()           as etl_time
  from (select if(nullif(a.Core, '') is not null, a.Core, '1,2,3,4,15,16,17') as core
             , a.Language                                                     as language_code
             , d.cd_val_desc                                                  as language_name
             , a.SeriesId                                                     as series_id
             , b.SeriesCode                                                   as series_code
             , a.SeriesName                                                   as series_name
             , a.AllEpis                                                      as all_epis
             , a.CoverUrl                                                     as cover_url
             , a.PublishedAt                                                  as publish_time
             , mp.placement_time                                              as placement_time
             , epis.series_duration                                           as series_duration
          from ods.ods_tidb_short_video_series                   as a
          left join ods.ods_tidb_short_video_admin_source_series as b
            on a.SourceSeriesId = b.SeriesId
          left join dim.dim_pub_code_mapping_dict                as d
            on a.Language = d.cd_val
           and d.app_plat = 'pub'
           and d.cd_col = 'lang_cd'
          left join (select SeriesId
                          , sum(Duration) as series_duration
                       from ods.ods_tidb_short_video_epis
                      where IsDelete = 0
                      group by SeriesId
                    )                                            as epis
            on a.SeriesId = epis.SeriesId
          left join (select CodeId                   as series_id
                          , hours_add(BeginDate, 13) as placement_time
                     from ods.ods_tidb_ad_sharpengine_ads_global_MarketingPlan
                     where ProjectCode = 2
                       and CodeId <> ''
                       and SourceChl = ''
                       and IsDel = 0
                    )                                            as mp
            on a.SeriesId = mp.series_id
          where a.AppType = 1
       ) as t
     , unnest(split(t.core, ','))                                as unnest
 where unnest is not null
   and language_code is not null
   and series_id is not null
;
