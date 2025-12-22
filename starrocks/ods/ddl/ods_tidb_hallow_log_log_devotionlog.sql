----------------------------------------------------------------
-- 目标表： ods.ods_tidb_hallow_log_log_devotionlog
-- 来源实例： old_tidb_source
-- 来源表： hallow_log.log_devotionlog
-- 来源负责：
-- 采集工具： SeaTunnel
-- 开发人： qhr
-- 开发日期： 2025-12-02
----------------------------------------------------------------

drop table if exists ods.ods_tidb_hallow_log_log_devotionlog;
create table ods.ods_tidb_hallow_log_log_devotionlog (
     dt                  date         not null comment "分区日期"
    ,Id                  bigint       not null comment '日志ID'
    ,Event               varchar(765)          comment '事件'
    ,TaskId              varchar(765)          comment '任务ID'
    ,TaskDate            varchar(765)          comment '任务日期'
    ,TaskPeriod          varchar(765)          comment '任务周期'
    ,TaskCurrentProgress int                   comment '当前任务进度'
    ,TaskType            varchar(765)          comment '任务类型'
    ,CreateTime          datetime     not null comment '创建时间'
    ,UserId              bigint       not null comment '用户ID'
    ,Mt                  int                   comment 'mt'
    ,Core                int                   comment 'Core'
    ,UniqueCdReaderId    varchar(765)          comment '设备号'
    ,Appver              varchar(765)          comment '版本'
    ,TaskMaxProgress     int                   comment '任务最大进度'
    ,sr_createtime       datetime              comment "starrocks入库时间"
    ,sr_updatetime       datetime              comment "starrocks数据更新时间"
)
duplicate key(dt, Id)
comment "灵修日志"
partition by date_trunc("month", dt)
distributed by hash(dt, Id)
properties (
    "replication_num" = "3",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "LZ4"
)
;