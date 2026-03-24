insert into ads.ads_sv_new_series_external_campaigns
select a.project_id
     , a.product_id
     , a.series_id
     , a.language_id
     , a.story_code_series                                                                                           as series_title
     , a.story_code
     , a.series_name
     , a.publish_status
     , a.publish_date
     , a.series_level
     , coalesce(a.begin_date, b.begin_date)                                                                          as begin_date
     , coalesce(a.is_plan_created, b.is_plan_created)                                                                as is_plan_created
     , coalesce(b.is_toufang, a.is_toufang)                                                                          as is_toufang
     , a.advanced_languages
     , if(coalesce(a.is_plan_created, b.is_plan_created) = 0 and coalesce(b.is_toufang, a.is_toufang) = 1, null,
          -1)                                                                                                        as rn
     , now()                                                                                                         as etl_time
  from (select 2                            as project_id
             , 6833                         as product_id
             , a.series_id
             , a.language                   as language_id
             , a.story_code_series
             , a.story_code
             , a.series_name
             , a.publish_status
             , a.publish_date
             , a.series_level
             , b.begin_date
             , ifnull(b.is_plan_created, 0) as is_plan_created
             , if((a.language = 3 and a.series_level <= 2) or (a.language != 3 and c.advanced_languages is not null), 1,
                  ifnull(b.is_toufang, 0))  as is_toufang
             , c.advanced_languages
          from (select a.series_id
                     , a.language
                     , regexp_extract(b.series_code, '^[A-Za-z]+', 0)                                   as story_code_series
                     , split(b.series_code, '-')[1]                                                     as story_code
                     , a.series_name
                     , if(a.publish_status = 1, a.publish_status,
                          if(c.IsScheduledPublish = 1, 4, -99))                                         as publish_status
                     , ifnull(a.publish_edat, c.ScheduledPublishTime)                                   as publish_date
                     , a.publish_edat
                     , a.series_level
                  from (select series_code
                             , series_id
                             , language
                             , series_name
                             , publish_status
                             , publish_edat
                             , series_level
                             , source_series_id
                          from dim.dim_short_video_series_view
                         where is_delete = 0 and language not in (1)
                        )                                                 a
                  left join dim.dim_short_video_source_series_view        b
                  on a.source_series_id = b.series_id
                  left join (
                      -- 获取有定时上架的剧的时间
                      select SeriesId
                           , IsScheduledPublish
                           , ScheduledPublishTime
                        from ods.ods_tidb_short_video_admin_series
                       where PublishStatus != 1 and IsScheduledPublish = 1 and scheduledPublishTime >= '${bf_1_dt}'
                      )                                                   c
                  on a.series_id = c.SeriesId
                  left join (
                      -- 翻译完成的剧
                      select a.series_code
                           , c.langid
                        from dim.dim_short_video_series_view                             a
                        left join ads.ads_tidb_short_video_admin_subtitle_trans_job_view b
                        on a.series_id = b.SeriesId
                        left join dim.DIM_ProductType                                    c
                        on b.TranslangId = c.book_langid
                       where b.Status = 3 and c.langid is not null
                       group by 1, 2
                      )                                                   d
                  on a.series_code = d.series_code and a.language = d.langid
                  left join ads.ads_tidb_short_video_admin_series_qa_view e
                  on a.series_id = e.SeriesId
                  left join ads.ads_short_video_admin_series_view         f
                  on a.series_id = f.SeriesId
                 where !(a.publish_status != 1 and c.ScheduledPublishTime is null)
                   and ifnull(a.publish_edat, c.ScheduledPublishTime) is not null
                   and a.series_name not like '%dj-%' and (
                     ((d.series_code is not null or a.language = 2) and e.Status = 3) or
                     f.IsSubtitles = 0) -- QC完成或该剧不需要字幕
                )      a
          left join (select code_id
                          , begin_date
                          , 1 as is_plan_created
                          , 1 as is_toufang
                       from ads.ads_srsv_ads_marketing_plan_view
                      where is_del = 0 and project_code = 2 and source_chl = 'fb' and code_stage = 1 and plan_round = 1
                     ) b
          on a.series_id = b.code_id
          left join (
              -- 已进阶
              select c.series_code
                   , concat('[', group_concat(json_object('language_id', b.language, 'spend', ifnull(c.spend, 0))),
                            ']') as advanced_languages
                from (select code_id
                        from ads.ads_srsv_ads_marketing_plan_view
                       where is_del = 0 and project_code = 2 and code_stage > 1
                       group by code_id
                      )                                          a
                left join dim.dim_short_video_series_view        b
                on a.code_id = b.series_id
                left join dim.dim_short_video_source_series_view c
                on b.source_series_id = c.series_id
                left join (select b.book_id
                                , sum(a.ConvertSpend) as spend
                             from (select ProductId
                                        , AdId
                                        , ConvertSpend
                                     from dim.dim_FbAdDailyInsight_view
                                    where ProductId = 6833 and date_start >= date_sub('${bf_1_dt}', interval 5 day)
                                    union all
                                   select ProductId
                                        , AdId
                                        , ConvertSpend
                                     from dim.dim_LtvDailyInsight_view
                                    where ProductId = 6833 and date_start >= date_sub('${bf_1_dt}', interval 5 day)
                                   )                                        a
                             left join ads.ads_advertisement_adbase_view as b
                             on a.AdId = b.ad_id and a.ProductId = b.product_id
                            where b.book_id is not null
                            group by a.ProductId, b.book_id
                           )                                     c
                on a.code_id = c.book_id
               group by c.series_code
              )        c
          on a.story_code = c.series_code
        )                                                 a
  left join ads.ads_sv_new_series_external_campaigns_user b
  on a.project_id = b.project_id and a.product_id = b.product_id and a.series_id = b.series_id
;

-- 计算英语剧的 rn
insert into ads.ads_sv_new_series_external_campaigns
select project_id
     , product_id
     , series_id
     , language_id
     , series_title
     , series_code
     , series_name
     , publish_status
     , publish_date
     , series_level
     , begin_date
     , is_plan_created
     , is_toufang
     , advanced_languages
     , row_number() over (order by series_level, publish_date) as rn
     , now()                                                   as etl_time
  from ads.ads_sv_new_series_external_campaigns
 where language_id = 3 and rn is null;

-- 计算非英语剧的 rn
insert into ads.ads_sv_new_series_external_campaigns
  with series as (select project_id
                       , product_id
                       , series_id
                       , language_id
                       , series_title
                       , series_code
                       , series_name
                       , publish_status
                       , publish_date
                       , series_level
                       , begin_date
                       , is_plan_created
                       , is_toufang
                       , advanced_languages
                    from ads.ads_sv_new_series_external_campaigns
                   where language_id in (4, 5, 9, 14, 6, 11, 12, 2, 7, 10, 16, 8) and rn is null
                  )
select a.project_id
     , a.product_id
     , a.series_id
     , a.language_id
     , a.series_title
     , a.series_code
     , a.series_name
     , a.publish_status
     , a.publish_date
     , a.series_level
     , a.begin_date
     , a.is_plan_created
     , a.is_toufang
     , a.advanced_languages
     , row_number() over (partition by language_id order by ifnull(b.spend, 0) desc, c.catena_weight, a.publish_date) as rn
     , now()                                                                                                          as etl_time
  from series a
  left join (
      -- 计算进阶剧的消耗情况
      select series_id
           , sum(ifnull(get_json_string(concat('{', languages), '$.spend'), 0)) as spend
        from series
        cross join unnest(cast(advanced_languages as array<varchar>)) as b(languages)
       where languages like '\"spend%'
       group by series_id
      )       b
  on a.series_id = b.series_id
  left join (
      -- 系列优先级
      select a.series_id
           , ifnull(b.parameter_weight, 99) as catena_weight
        from series  a
        left join (select parameter_name
                        , parameter_weight
                     from ads.ads_sv_new_series_external_campaigns_parameter
                    where id = 1
                   ) b
        on a.series_title = b.parameter_name
      )       c
  on a.series_id = c.series_id;