----------------------------------------------------------------
-- 目标表： ods.ods_tidb_short_video_admin_epis
-- 来源实例： old_tidb_source
-- 来源表： short_video_admin.epis
-- 来源负责：
-- 采集工具： SeaTunnel
-- 开发人：xjc
-- 开发日期：2026-02-03
----------------------------------------------------------------

drop table if exists ods.ods_tidb_short_video_admin_epis;
create table ods.ods_tidb_short_video_admin_epis (
    dt                    date             not null                    comment "日期"
   ,episid                bigint           not null                    comment "单集id"
   ,seriesid              bigint           not null                    comment "剧集id"
   ,createtime            datetime                                     comment "创建时间"
   ,updatetime            datetime                                     comment "修改时间"
   ,createuser            varchar(300)                                 comment "上传人"
   ,coverurl              varchar(1536)                                comment "视频封面"
   ,mediaurl              varchar(1536)    not null                    comment "媒体播放地址"
   ,fileid                varchar(300)                                 comment "媒体文件的唯一标识"
   ,episnum               int              not null                    comment "分集序号"
   ,isfree                tinyint                                      comment "是否免费  1免费 0收费"
   ,duration              int                                          comment "视频长度"
   ,isdelete              tinyint                                      comment "是否删除"
   ,episdescription       string                                       comment "分集简介"
   ,filesize              bigint                                       comment "文件大小"
   ,price                 int                                          comment "分集价格（分）"
   ,publishstatus         int                                          comment "上架状态(1上架 2下架)"
   ,title                 varchar(1500)                                comment "标题"
   ,titlekey              varchar(1500)                                comment "标题key"
   ,episdescriptionkey    string                                       comment "分集简介转换key"
   ,streamurl             varchar(1536)                                comment "串流地址"
   ,transstatus           tinyint                                      comment "转码状态"
   ,subtitles             varchar(1536)                                comment "字幕文件地址"
   ,subtitlestxt          varchar(1536)                                comment "翻译文件地址"
   ,subtitlestxtlong      bigint                                       comment "翻译文件内容长度"
   ,vid                   varchar(300)                                 comment "火山云视频ID"
   ,srtnew                tinyint                                      comment "字幕文件 新标签"
   ,sr_createtime         datetime        default current_timestamp    comment "starrocks入库时间"
   ,sr_updatetime         datetime        default current_timestamp    comment "starrocks数据更新时间"
)
primary key(dt, episid)
comment "短剧分集表"
partition by date_trunc("month", dt)
distributed by hash(dt, episid)
properties (
    "replication_num" = "3"
   ,"in_memory" = "false"
   ,"enable_persistent_index" = "true"
   ,"replicated_storage" = "true"
   ,"compression" = "LZ4"
)
;