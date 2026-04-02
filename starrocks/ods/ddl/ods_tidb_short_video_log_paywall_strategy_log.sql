----------------------------------------------------------------
-- 目标表： ods.ods_tidb_short_video_log_paywall_strategy_log
-- 来源实例： video-en-log-mysql-slave
-- 来源表： short_video_log.paywall_strategy_log
-- 来源负责： fjw
-- 开发人： qhr
-- 开发日期： 2026-04-01
----------------------------------------------------------------

drop table if exists ods.ods_tidb_short_video_log_paywall_strategy_log;
create table ods.ods_tidb_short_video_log_paywall_strategy_log (
     dt              date     not null                  comment "日期，根据CreateTime转换而来"
    ,Id              bigint   not null                  comment "唯一ID"
    ,AccountId       int                                comment "用户账户ID"
    ,NodeId          string                             comment "节点ID"
    ,TemplateId      bigint                             comment "模板ID，对应海剧的策略ID"
    ,VersionId       int                                comment "版本ID"
    ,CreateTime      datetime                           comment "创建时间"
    ,sr_createtime   datetime default current_timestamp comment "starrocks数据注入时间"
    ,sr_updatetime   datetime default current_timestamp comment "starrocks数据更新时间"
)
primary key(dt, Id)
comment "短剧-付费墙策略日志表"
partition by date_trunc('month', dt)
distributed by hash(Id)
properties (
    "replication_num" = "3"
    ,"in_memory" = "false"
    ,"enable_persistent_index" = "true"
    ,"replicated_storage" = "true"
    ,"compression" = "LZ4"
    ,"partition_live_number" = "24"
)
;
