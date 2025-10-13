CREATE OR REPLACE VIEW ads.ads_short_video_admin_series_view (
     SeriesId                  COMMENT "id"
    ,series_code               COMMENT "代号"
    ,Language                  COMMENT "语言"
    ,SeriesName
    ,Description               COMMENT "短剧简介"
    ,CoverUrl                  COMMENT "封面"
    ,CreateTime                COMMENT "创建时间"
    ,Up                        COMMENT "修改时间"
    ,CreateUser                COMMENT "上传人"
    ,PublishStatus             COMMENT "上架状态(1上架 2下架)"
    ,PublishedAt               COMMENT "上架时间"
    ,UnPublishedAt             COMMENT "下架时间"
    ,LastEpis                  COMMENT "更新至第几集"
    ,AllEpis                   COMMENT "总集数"
    ,PayEpisFrom               COMMENT "收费起始集数"
    ,IsDelete                  COMMENT "是否删除"
    ,Producer
    ,Recommend
    ,SourceSeriesId            COMMENT "源语言短剧"
    ,Price                     COMMENT "单集价格（分）"
    ,MinutePrice               COMMENT "分钟价格"
    ,Ending                    COMMENT "完结状态（1连载中 2已完结）"
    ,SeriesNameKey
    ,DescriptionKey            COMMENT "短剧简介转换key"
    ,RecommendKey
    ,IsSubtitles               COMMENT "是否需要字幕 1 需要 0 不需要"
    ,SubtitlesStatus           COMMENT "字幕是否完整 1 完整 0 缺失"
    ,EpisStatus                COMMENT "分集是否完成 1 完整 0 缺失"
    ,VideoStatus               COMMENT "分集视频是否完整 1 完整 0 缺失"
    ,SeriesLevel               COMMENT "等级 1.S 2.A 3.B 4.C"
    ,OperateLevel              COMMENT "运营等级 1.S 2.A 3.B 4.C"
    ,WorkType                  COMMENT "作品类型 1.男频  2.女频 3.双番"
    ,ImageKey                  COMMENT "轮播榜单配图id"
    ,ListRecommendKey          COMMENT "轮播榜单推荐语key"
    ,ListRecommend             COMMENT "轮播榜单推荐语"
    ,AdsBeginTime              COMMENT "测推时间"
    ,Core                      COMMENT "Core ，多个用逗号隔开(1core1，2core2，3core3，4core4)"
    ,IsScheduledPublish        COMMENT "是否定时上架"
    ,ScheduledPublishTime      COMMENT "定时上架时间"
    ,HighLightPlot             COMMENT "高光剧情"
    ,TurningPoint              COMMENT "转折点"
    ,import_time               COMMENT "引入时间"
    ,source_create_time        COMMENT "剧壳创建时间"
    ,plan_status               COMMENT "跑出状态（-1无状态，0待定，1跑出，2未跑出）"
    ,run_out_time              COMMENT "跑出时间"
    ,multilingual_status       COMMENT "当前状态"
    ,sd_type_name              COMMENT "短剧类型名称"
    ,at_type_name              COMMENT "音轨类型名称"
    ,dub_type_name             COMMENT "配音类型名称"
) AS
SELECT
      a.SeriesId
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
     ,c.add_time AS import_time
     ,f.source_create_time
     ,d.PlanStatus AS plan_status
     ,d.BeginDate AS run_out_time
     ,IF(
        a.PublishedAt <= CURRENT_DATE(),
        '已上架',
        e.status
       ) AS multilingual_status
     ,case when g.localType=1 and g.localSubType = 1 then '本土剧-AI短剧'
           when g.localType=1 then '本土剧'
           when g.localType=2 then '译制剧'
           else null
       end as sd_type_name
     ,case when g.audioType = 1 then '原声剧'
           when g.audioType = 2 then '配音剧'
           else null
       end as at_type_name
     ,case when g.dubbedType = 1 then '人工配音'
           when g.dubbedType = 2 then 'AI配音'
           else null
       end as dub_type_name
  FROM ods.ods_tidb_short_video_admin_series AS a
  LEFT JOIN dim.dim_short_video_source_series_view AS b
    ON a.SourceSeriesId = b.series_id
  LEFT JOIN (
            SELECT
                    series_code
                  ,MIN(create_time) AS source_create_time
              FROM
                dim.dim_short_video_source_series_view
             GROUP BY
                series_code
    ) f
    ON b.series_code = f.series_code
  LEFT JOIN ods.ods_tidb_cdcreator_tidb_cn_story_original AS c
    ON b.series_code = c.story_code
  LEFT JOIN (
            SELECT
                  CodeId
                 ,PlanStatus
                 , MIN(BeginDate) AS BeginDate
              FROM
                ods.ods_tidb_ad_sharpengine_ads_global_MarketingPlan
             WHERE PlanStatus = 1
               AND CodeStage >= 2
             GROUP BY
                    CodeId
                   ,PlanStatus
          ) d
    ON a.SeriesId = d.CodeId
  LEFT JOIN (
            SELECT
                  BookCode
                 ,3 AS language_id
                 ,EnStatus AS status
              FROM ods.ods_tidb_shuangwen_tidb_en_shortvideomultilingual
             WHERE IFNULL(EnStatus, '') != ''
             UNION ALL
            SELECT
                  BookCode
                 ,4 AS language_id
                 ,SpStatus AS status
              FROM ods.ods_tidb_shuangwen_tidb_en_shortvideomultilingual
             WHERE IFNULL(SpStatus, '') != ''
             UNION ALL
            SELECT
        BookCode
                 ,5 AS language_id
                 ,PtStatus
              FROM ods.ods_tidb_shuangwen_tidb_en_shortvideomultilingual
             WHERE IFNULL(PtStatus, '') != ''
             UNION ALL
            SELECT
        BookCode
                 ,6 AS language_id
                 ,FrStatus
              FROM ods.ods_tidb_shuangwen_tidb_en_shortvideomultilingual
             WHERE IFNULL(FrStatus, '') != ''
             UNION ALL
            SELECT
        BookCode
                 ,7 AS language_id
                 ,RuStatus
              FROM ods.ods_tidb_shuangwen_tidb_en_shortvideomultilingual
             WHERE IFNULL(RuStatus, '') != ''
             UNION ALL
            SELECT
        BookCode
                 ,11 AS language_id
                 ,IdStatus
              FROM ods.ods_tidb_shuangwen_tidb_en_shortvideomultilingual
             WHERE IFNULL(IdStatus, '') != ''
             UNION ALL
            SELECT
        BookCode
                 ,12 AS language_id
                 ,ThStatus
              FROM ods.ods_tidb_shuangwen_tidb_en_shortvideomultilingual
             WHERE IFNULL(ThStatus, '') != ''
             UNION ALL
            SELECT
        BookCode
                 ,9 AS language_id
                 ,JpStatus
              FROM ods.ods_tidb_shuangwen_tidb_en_shortvideomultilingual
             WHERE IFNULL(JpStatus, '') != ''
             UNION ALL
            SELECT
        BookCode
                 ,14 AS language_id
                 ,KoStatus
              FROM ods.ods_tidb_shuangwen_tidb_en_shortvideomultilingual
             WHERE IFNULL(KoStatus, '') != ''
        ) e
    ON b.series_code = e.BookCode
   AND a.Language = e.language_id
  left join ods.ods_tidb_source_series as g
    on a.SourceSeriesId = g.SeriesId