create or replace view ads.ads_short_video_admin_series_epis_view (
     dt                    comment "日期"
    ,episid                comment "单集id"
    ,seriesid              comment "剧集id"
    ,createtime            comment "创建时间"
    ,updatetime            comment "修改时间"
    ,createuser            comment "上传人"
    ,coverurl              comment "视频封面"
    ,mediaurl              comment "媒体播放地址"
    ,fileid                comment "媒体文件的唯一标识"
    ,episnum               comment "分集序号"
    ,isfree                comment "是否免费  1免费 0收费"
    ,duration              comment "视频长度"
    ,isdelete              comment "是否删除"
    ,episdescription       comment "分集简介"
    ,filesize              comment "文件大小"
    ,price                 comment "分集价格（分）"
    ,publishstatus         comment "上架状态(1上架 2下架)"
    ,title                 comment "标题"
    ,titlekey              comment "标题key"
    ,episdescriptionkey    comment "分集简介转换key"
    ,streamurl             comment "串流地址"
    ,transstatus           comment "转码状态"
    ,subtitles             comment "字幕文件地址"
    ,subtitlestxt          comment "翻译文件地址"
    ,subtitlestxtlong      comment "翻译文件内容长度"
    ,vid                   comment "火山云视频ID"
    ,srtnew                comment "字幕文件 新标签"
    ,sr_createtime         comment "starrocks入库时间"
    ,sr_updatetime         comment "starrocks数据更新时间"
)
comment "短剧分集信息视图"
as
select a1.dt                    as dt                    -- 日期
      ,a1.episid                as episid                -- 单集id
      ,a1.seriesid              as seriesid              -- 剧集id
      ,a1.createtime            as createtime            -- 创建时间
      ,a1.updatetime            as updatetime            -- 修改时间
      ,a1.createuser            as createuser            -- 上传人
      ,a1.coverurl              as coverurl              -- 视频封面
      ,a1.mediaurl              as mediaurl              -- 媒体播放地址
      ,a1.fileid                as fileid                -- 媒体文件的唯一标识
      ,a1.episnum               as episnum               -- 分集序号
      ,a1.isfree                as isfree                -- 是否免费  1免费 0收费
      ,a1.duration              as duration              -- 视频长度
      ,a1.isdelete              as isdelete              -- 是否删除
      ,a1.episdescription       as episdescription       -- 分集简介
      ,a1.filesize              as filesize              -- 文件大小
      ,a1.price                 as price                 -- 分集价格（分）
      ,a1.publishstatus         as publishstatus         -- 上架状态(1上架 2下架)
      ,a1.title                 as title                 -- 标题
      ,a1.titlekey              as titlekey              -- 标题key
      ,a1.episdescriptionkey    as episdescriptionkey    -- 分集简介转换key
      ,a1.streamurl             as streamurl             -- 串流地址
      ,a1.transstatus           as transstatus           -- 转码状态
      ,a1.subtitles             as subtitles             -- 字幕文件地址
      ,a1.subtitlestxt          as subtitlestxt          -- 翻译文件地址
      ,a1.subtitlestxtlong      as subtitlestxtlong      -- 翻译文件内容长度
      ,a1.vid                   as vid                   -- 火山云视频ID
      ,a1.srtnew                as srtnew                -- 字幕文件 新标签
      ,a1.sr_createtime         as sr_createtime         -- starrocks入库时间
      ,a1.sr_updatetime         as sr_updatetime         -- starrocks数据更新时间
  from ods.ods_tidb_short_video_admin_epis    as a1
;