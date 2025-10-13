create or replace view ads.ads_short_video_admin_series_view (
     SeriesId                  comment "id"
    ,series_code               comment "代号"
    ,Language                  comment "语言"
    ,SeriesName
    ,Description               comment "短剧简介"
    ,CoverUrl                  comment "封面"
    ,CreateTime                comment "创建时间"
    ,Up                        comment "修改时间"
    ,CreateUser                comment "上传人"
    ,PublishStatus             comment "上架状态(1上架 2下架)"
    ,PublishedAt               comment "上架时间"
    ,UnPublishedAt             comment "下架时间"
    ,LastEpis                  comment "更新至第几集"
    ,AllEpis                   comment "总集数"
    ,PayEpisFrom               comment "收费起始集数"
    ,IsDelete                  comment "是否删除"
    ,Producer
    ,Recommend
    ,SourceSeriesId            comment "源语言短剧"
    ,Price                     comment "单集价格（分）"
    ,MinutePrice               comment "分钟价格"
    ,Ending                    comment "完结状态（1连载中 2已完结）"
    ,SeriesNameKey
    ,DescriptionKey            comment "短剧简介转换key"
    ,RecommendKey
    ,IsSubtitles               comment "是否需要字幕 1 需要 0 不需要"
    ,SubtitlesStatus           comment "字幕是否完整 1 完整 0 缺失"
    ,EpisStatus                comment "分集是否完成 1 完整 0 缺失"
    ,VideoStatus               comment "分集视频是否完整 1 完整 0 缺失"
    ,SeriesLevel               comment "等级 1.S 2.A 3.B 4.C"
    ,OperateLevel              comment "运营等级 1.S 2.A 3.B 4.C"
    ,WorkType                  comment "作品类型 1.男频  2.女频 3.双番"
    ,ImageKey                  comment "轮播榜单配图id"
    ,ListRecommendKey          comment "轮播榜单推荐语key"
    ,ListRecommend             comment "轮播榜单推荐语"
    ,AdsBeginTime              comment "测推时间"
    ,Core                      comment "Core ，多个用逗号隔开(1core1，2core2，3core3，4core4)"
    ,IsScheduledPublish        comment "是否定时上架"
    ,ScheduledPublishTime      comment "定时上架时间"
    ,HighLightPlot             comment "高光剧情"
    ,TurningPoint              comment "转折点"
    ,import_time               comment "引入时间"
    ,source_create_time        comment "剧壳创建时间"
    ,plan_status               comment "跑出状态（-1无状态，0待定，1跑出，2未跑出）"
    ,run_out_time              comment "跑出时间"
    ,multilingual_status       comment "当前状态"
    ,sd_type_name              comment "短剧类型名称"
    ,at_type_name              comment "音轨类型名称"
    ,dub_type_name             comment "配音类型名称"
)
as
select a.SeriesId
      ,b.series_code
      ,a.Language
      ,a.SeriesName
      ,a.Description
      ,a.CoverUrl
      ,a.CreateTime
      ,a.UpdateTime
      ,a.CreateUser
      ,a.PublishStatus
      ,a.PublishedAt
      ,a.UnPublishedAt
      ,a.LastEpis
      ,a.AllEpis
      ,a.PayEpisFrom
      ,a.IsDelete
      ,a.Producer
      ,a.Recommend
      ,a.SourceSeriesId
      ,a.Price
      ,a.MinutePrice
      ,a.Ending
      ,a.SeriesNameKey
      ,a.DescriptionKey
      ,a.RecommendKey
      ,a.IsSubtitles
      ,a.SubtitlesStatus
      ,a.EpisStatus
      ,a.VideoStatus
      ,a.SeriesLevel
      ,a.OperateLevel
      ,a.WorkType
      ,a.ImageKey
      ,a.ListRecommendKey
      ,a.ListRecommend
      ,a.AdsBeginTime
      ,a.Core
      ,a.IsScheduledPublish
      ,a.ScheduledPublishTime
      ,a.HighLightPlot
      ,a.TurningPoint
      ,c.add_time                as import_time
      ,f.source_create_time
      ,d.PlanStatus              as plan_status
      ,d.BeginDate               as run_out_time
      ,if(
          a.PublishedAt <= CURRENT_DATE()
         ,'已上架'
         ,e.status
        )                        as multilingual_status
      ,case when g.localType=1 and g.localSubType = 1 then '本土剧-AI短剧'
            when g.localType=1 then '本土剧'
            when g.localType=2 then '译制剧'
            else null
        end                      as sd_type_name
      ,case when g.audioType = 1 then '原声剧'
            when g.audioType = 2 then '配音剧'
            else null
        end as at_type_name
      ,case when g.dubbedType = 1 then '人工配音'
            when g.dubbedType = 2 then 'AI配音'
            else null
        end                      as dub_type_name
  from ods.ods_tidb_short_video_admin_series                 as a
  left join dim.dim_short_video_source_series_view           as b
    on a.sourceseriesid = b.series_id
  left join (select series_code
                   ,min(create_time)    as source_create_time
               from dim.dim_short_video_source_series_view
              group by series_code
            )                                                as f
    on b.series_code = f.series_code
  left join ods.ods_tidb_cdcreator_tidb_cn_story_original    as c
    on b.series_code = c.story_code
  left join (select codeid
                   ,planstatus
                   ,min(begindate)      as begindate
              from ods.ods_tidb_ad_sharpengine_ads_global_marketingplan
             where planstatus = 1
               and codestage >= 2
             group by codeid,planstatus
             )                                               as d
    on a.seriesid = d.codeid
  left join (
            select bookcode
                  ,3                    as language_id
                  ,enstatus             as status
              from ods.ods_tidb_shuangwen_tidb_en_shortvideomultilingual
             where ifnull(enstatus, '') != ''
             union all
            select bookcode
                 ,4                     as language_id
                 ,spstatus              as status
              from ods.ods_tidb_shuangwen_tidb_en_shortvideomultilingual
             where ifnull(spstatus, '') != ''
             union all
            select bookcode
                  ,5                    as language_id
                  ,ptstatus
              from ods.ods_tidb_shuangwen_tidb_en_shortvideomultilingual
             where ifnull(ptstatus, '') != ''
             union all
            select bookcode
                  ,6                    as language_id
                  ,frstatus
              from ods.ods_tidb_shuangwen_tidb_en_shortvideomultilingual
             where ifnull(frstatus, '') != ''
             union all
            select bookcode
                  ,7                    as language_id
                  ,rustatus
              from ods.ods_tidb_shuangwen_tidb_en_shortvideomultilingual
             where ifnull(rustatus, '') != ''
             union all
            select bookcode
                  ,11                   as language_id
                  ,idstatus
              from ods.ods_tidb_shuangwen_tidb_en_shortvideomultilingual
             where ifnull(idstatus, '') != ''
             union all
            select bookcode
                  ,12                   as language_id
                  ,thstatus
              from ods.ods_tidb_shuangwen_tidb_en_shortvideomultilingual
             where ifnull(thstatus, '') != ''
             union all
            select bookcode
                  ,9                    as language_id
                  ,jpstatus
              from ods.ods_tidb_shuangwen_tidb_en_shortvideomultilingual
             where ifnull(jpstatus, '') != ''
             union all
            select bookcode
                  ,14                   as language_id
                  ,kostatus
              from ods.ods_tidb_shuangwen_tidb_en_shortvideomultilingual
             where ifnull(kostatus, '') != ''
            )                                                as e
    on b.series_code = e.bookcode
   and a.language = e.language_id
  left join ods.ods_tidb_source_series                       as g
    on a.sourceseriesid = g.seriesid
;