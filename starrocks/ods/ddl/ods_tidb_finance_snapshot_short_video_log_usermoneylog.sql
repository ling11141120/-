----------------------------------------------------------------
-- 目标表：  ods_tidb_finance_snapshot_short_video_log_usermoneylog
-- 来源实例：old_tidb_source
-- 来源表：  finance_snapshot.short_video_log_usermoneylog
-- 采集工具： SeaTunnel
-- 开发人：xjc
-- 开发日期： 2026-05-21
----------------------------------------------------------------

drop table if exists ods.ods_tidb_finance_snapshot_short_video_log_usermoneylog;
create table ods.ods_tidb_finance_snapshot_short_video_log_usermoneylog (
     Id            bigint                     not null comment "id"
    ,UserId        bigint                              comment "用户id"
    ,Amount        int                                 comment "总数"
    ,RemainAmount  int                                 comment "剩余数量"
    ,BookId        bigint                              comment "剧id"
    ,ChapterIds    string                              comment "集ID"
    ,ChapterName   varchar(3000)                       comment "集名称"
    ,CreateTime    datetime                            comment "创建时间"
    ,PayType       int                                 comment "类型"
    ,MT            int                                 comment "机型"
    ,Seq           bigint                              comment "Seq"
    ,VipType       int                                 comment "VipType"
    ,OriginCoin    int                                 comment "OriginCoin"
    ,VipDisPrice   int                                 comment "VipDisPrice"
    ,AppId         int                                 comment "应用id"
    ,PositionId    varchar(200)                        comment "PositionId"
    ,AppGameId     bigint                              comment "AppGameId"
    ,SendId        varchar(1000)                       comment "sendid"
    ,ChapterNos    string                              comment "章节序号列表"
    ,snapshot_time datetime                            comment "快照时间"
    ,sr_createtime datetime default current_timestamp  comment "starrocks数据注入时间"
    ,sr_updatetime datetime default current_timestamp  comment "starrocks数据更新时间"
)
primary key(Id)
comment "财务专用-用户消费记录日志"
distributed by hash(Id)
properties (
    "replication_num" = "3",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "LZ4"
)
;
