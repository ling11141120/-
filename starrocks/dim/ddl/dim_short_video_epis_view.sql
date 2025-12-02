create view dim.dim_short_video_epis_view(
     epis_id                       comment "单集id"
    ,series_id                     comment "剧集id"
    ,create_tm                     comment "创建时间"
    ,update_tm                     comment "修改时间"
    ,create_user                   comment "上传人"
    ,cover_url                     comment "视频封面"
    ,media_url                     comment "媒体播放地址"
    ,file_id                       comment "媒体文件的唯一标识"
    ,epis_num                      comment "分集序号"
    ,is_free                       comment "是否免费 1免费 0收费"
    ,duration                      comment "视频长度"
    ,is_delete                     comment "是否删除"
    ,epis_description              comment "分集简介"
    ,file_size                     comment "文件大小"
    ,price                         comment "分集价格（分）"
    ,publish_status                comment "上架状态(1上架 2下架)"
    ,title                         comment "标题"
    ,title_key                     comment "标题key"
    ,epis_description_key          comment "分集简介转换key"
    ,stream_url                    comment "转码后url"
    ,trans_status                  comment "转码状态 1完成 0 未完成"
    ,sub_titles                    comment "字幕文件地址"
    ,preceding_current_duration    comment "到当前剧集的视频长度"
    ,preceding_current_price       comment "到当前剧集的价格（分）"
    ,series_price                  comment "短剧每集价格(分)"
    ,sr_createtime                 comment "sr数据创建时间"
    ,sr_updatetime                 comment "sr数据更新时间"
)
comment "短剧分集表"
as
select a.EpisId
      ,a.SeriesId
      ,a.CreateTime
      ,a.UpdateTime
      ,a.CreateUser
      ,a.CoverUrl
      ,a.MediaUrl
      ,a.FileId
      ,a.EpisNum
      ,a.IsFree
      ,a.Duration
      ,a.IsDelete
      ,a.EpisDescription
      ,a.FileSize
      ,a.Price
      ,a.PublishStatus
      ,a.Title
      ,a.TitleKey
      ,a.EpisDescriptionKey
      ,a.StreamUrl
      ,a.TransStatus
      ,a.Subtitles
      ,a.preceding_current_duration
      ,if(a.preceding_current_price > 0, a.preceding_current_price, 0) as preceding_current_price
      ,a.series_price
      ,a.sr_createtime
      ,a.sr_updatetime
  from (select a.EpisId
              ,a.SeriesId
              ,a.CreateTime
              ,a.UpdateTime
              ,a.CreateUser
              ,a.CoverUrl
              ,a.MediaUrl
              ,a.FileId
              ,a.EpisNum
              ,a.IsFree
              ,a.Duration
              ,a.IsDelete
              ,a.EpisDescription
              ,a.FileSize
              ,a.Price
              ,a.PublishStatus
              ,a.Title
              ,a.TitleKey
              ,a.EpisDescriptionKey
              ,a.StreamUrl
              ,a.TransStatus
              ,a.Subtitles
              ,sum(if(a.EpisNum >= b.PayEpisFrom, a.Duration, 0)) over (partition by a.SeriesId
                                                                            order by a.EpisNum asc
                                                                             rows between unbounded preceding and current row
                                                                       )    as preceding_current_duration
              ,((a.EpisNum - b.PayEpisFrom) + 1) * b.Price                  as preceding_current_price
             , if(a.EpisNum >= b.PayEpisFrom, b.Price,0)                    as series_price
             , a.sr_createtime
             , a.sr_updatetime
          from ods.ods_tidb_short_video_epis           as a
          left join ods.ods_tidb_short_video_series    as b
            on a.SeriesId = b.SeriesId
         where a.IsDelete = 0
         union
        select EpisId
              ,SeriesId
              ,CreateTime
              ,UpdateTime
              ,CreateUser
              ,CoverUrl
              ,MediaUrl
              ,FileId
              ,EpisNum
              ,IsFree
              ,Duration
              ,IsDelete
              ,EpisDescription
              ,FileSize
              ,Price
              ,PublishStatus
              ,Title
              ,TitleKey
              ,EpisDescriptionKey
              ,StreamUrl
              ,TransStatus
              ,Subtitles
              ,0 as preceding_current_duration
              ,0 as preceding_current_price
              ,0 as series_price
              ,sr_createtime
              ,sr_updatetime
          from ods.ods_tidb_short_video_epis
         where ods.ods_tidb_short_video_epis.IsDelete != 0
       )                                               as a
;