create or replace view dim.dim_sv_epis_di_view (
     epis_id              comment "单集id"
    ,series_id            comment "剧id"
    ,create_time          comment "创建时间"
    ,update_time          comment "修改时间"
    ,create_user          comment "上传人"
    ,cover_url            comment "视频封面"
    ,media_url            comment "媒体播放地址"
    ,file_id              comment "媒体文件的唯一标识"
    ,epis_num             comment "分集序号"
    ,is_free              comment "是否免费"
    ,duration             comment "视频长度"
    ,is_delete            comment "是否删除"
    ,epis_description     comment "分集简介"
    ,file_size            comment "文件大小"
    ,price                comment "分集价格（分）"
    ,publish_status       comment "上架状态"
    ,title                comment "标题"
    ,title_key            comment "标题key"
    ,epis_description_key comment "分集简介转换key"
    ,stream_url           comment "转码后url"
    ,trans_status         comment "转码状态"
    ,subtitles            comment "字幕文件地址"
    ,series_language      comment "剧语言"
    ,series_name          comment "剧名"
    ,series_last_epis     comment "更新至第几集"
    ,series_all_epis      comment "总集数"
    ,series_ending        comment "完结状态（1连载中 2已完结）"
)
comment "海剧分集信息表"
as
select a.EpisId             as epis_id
     , a.SeriesId           as series_id
     , a.CreateTime         as create_time
     , a.UpdateTime         as update_time
     , a.CreateUser         as create_user
     , a.CoverUrl           as cover_url
     , a.MediaUrl           as media_url
     , a.FileId             as file_id
     , a.EpisNum            as epis_num
     , a.IsFree             as is_free
     , a.duration
     , a.IsDelete           as is_delete
     , a.EpisDescription    as epis_description
     , a.FileSize           as file_size
     , a.price
     , a.PublishStatus      as publish_status
     , a.title
     , a.TitleKey           as title_key
     , a.episdescriptionkey as epis_description_key
     , a.streamurl          as stream_url
     , a.transstatus        as trans_status
     , a.subtitles
     , b.language           as series_language
     , b.SeriesName         as series_name
     , b.LastEpis           as series_last_epis
     , b.AllEpis            as series_all_epis
     , b.Ending             as series_ending
  from ods.ods_tidb_short_video_epis        as a
  left join ods.ods_tidb_short_video_series as b
    on a.SeriesId = b.SeriesId
 where b.AppType = 1
;