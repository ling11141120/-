----------------------------------------------------------------
-- 目标表： ods.ods_tidb_short_video_epis
-- 来源实例： video-en-mysql-slave
-- 来源表： short_video.epis
-- 来源负责：
-- 采集工具： SeaTunnel
-- 开发人： qhr
-- 开发日期： 2025-12-01
----------------------------------------------------------------

drop table if exists ods.ods_tidb_short_video_epis;
create table ods.ods_tidb_short_video_epis (
     EpisId                bigint(20) not null                  comment "单集id"
    ,SeriesId              bigint(20) not null                  comment "剧集id"
    ,CreateTime            datetime                             comment "创建时间"
    ,UpdateTime            datetime                             comment "修改时间"
    ,CreateUser            string                               comment "上传人"
    ,CoverUrl              string                               comment "视频封面"
    ,MediaUrl              string     not null                  comment "媒体播放地址"
    ,FileId                string                               comment "媒体文件的唯一标识"
    ,EpisNum               int(11)    not null                  comment "分集序号"
    ,IsFree                tinyint(4)                           comment "是否免费 1免费 0收费"
    ,Duration              int(11)                              comment "视频长度"
    ,IsDelete              tinyint(4)                           comment "是否删除"
    ,EpisDescription       string                               comment "分集简介"
    ,FileSize              bigint(20)                           comment "文件大小"
    ,Price                 int(11)                              comment "分集价格（分）"
    ,PublishStatus         int(11)                              comment "上架状态(1上架 2下架)"
    ,Title                 string                               comment "标题"
    ,TitleKey              string                               comment "标题key"
    ,EpisDescriptionKey    string                               comment "分集简介转换key"
    ,StreamUrl             string                               comment "转码后url"
    ,TransStatus           tinyint(4)                           comment "转码状态 1完成 0 未完成"
    ,Subtitles             string                               comment "字幕文件地址"
    ,sr_createtime         datetime   default current_timestamp comment "sr数据创建时间"
    ,sr_updatetime         datetime   default current_timestamp comment "sr数据更新时间"
)
primary key(EpisId)
comment "短剧分集表"
distributed by hash(EpisId) buckets 1
properties (
    "replication_num" = "3",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "LZ4"
)
;