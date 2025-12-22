----------------------------------------------------------------
-- 目标表： ods.ods_tidb_hallow_log_log_readinglog
-- 来源实例： old_tidb_source
-- 来源表： hallow_log.log_readinglog
-- 来源负责：
-- 采集工具： SeaTunnel
-- 开发人： qhr
-- 开发日期： 2025-12-02
----------------------------------------------------------------

drop table if exists ods.ods_tidb_hallow_log_log_readinglog;
create table ods.ods_tidb_hallow_log_log_readinglog (
     dt            date         not null comment "分区日期"
    ,Id            bigint       not null comment '主键'
    ,UserId        bigint       not null comment '用户Id'
    ,BookId        int          not null comment '书籍Id'
    ,ReadTime      int          not null comment '阅读时长，秒为单位'
    ,SectionPos    varchar(765) not null comment '经文位置'
    ,CreateTime    datetime     not null comment '日志时间'
    ,sr_createtime datetime              comment "starrocks入库时间"
    ,sr_updatetime datetime              comment "starrocks数据更新时间"
)
duplicate key(dt, Id)
comment "广告信息日志"
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