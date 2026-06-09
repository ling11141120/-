----------------------------------------------------------------
-- 目标表： ods.ods_tidb_short_video_log_usermoneylog
-- 来源实例： old_tidb_source
-- 来源表： short_video_log.getmoneylog
-- 来源负责：
-- 采集工具： SeaTunnel
-- 开发人： xjc
-- 开发日期： 2026-05-14
----------------------------------------------------------------

drop table if exists ods.ods_tidb_short_video_log_usermoneylog;
create table if not exists ods.ods_tidb_short_video_log_usermoneylog (
     Id            bigint                     not null comment ""
    ,UserId        bigint                              comment "用户id"
    ,Amount        int                                 comment "总数"
    ,RemainAmount  int                                 comment "剩余数量"
    ,BookId        bigint                              comment "剧id"
    ,ChapterIds    string                              comment "集ID"
    ,ChapterName   varchar(3000)                       comment "集名称"
    ,CreateTime    datetime                            comment ""
    ,PayType       int                                 comment "类型"
    ,MT            int                                 comment "机型"
    ,Seq           bigint                              comment ""
    ,VipType       int                                 comment ""
    ,OriginCoin    int                                 comment ""
    ,VipDisPrice   int                                 comment ""
    ,AppId         int                                 comment "应用id"
    ,PositionId    varchar(200)                        comment ""
    ,AppGameId     bigint                              comment ""
    ,SendId        varchar(1000)                       comment "sendid"
    ,ChapterNos    string                              comment "章节序号列表"
    ,sr_createtime datetime default current_timestamp  comment "starrocks数据注入时间"
    ,sr_updatetime datetime default current_timestamp  comment "starrocks数据更新时间"
)
primary key(Id)
comment "用户消费记录日志"
distributed by hash(Id) buckets 50
properties (
    "replication_num" = "3",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "LZ4"
)
;
