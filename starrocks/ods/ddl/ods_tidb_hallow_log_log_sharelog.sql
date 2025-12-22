----------------------------------------------------------------
-- 目标表： ods.ods_tidb_hallow_log_log_sharelog
-- 来源实例： old_tidb_source
-- 来源表： hallow_log.log_sharelog
-- 来源负责：
-- 采集工具： SeaTunnel
-- 开发人： qhr
-- 开发日期： 2025-12-02
----------------------------------------------------------------

drop table if exists ods.ods_tidb_hallow_log_log_sharelog;
create table ods.ods_tidb_hallow_log_log_sharelog (
     dt            date          not null comment "分区日期"
    ,Id            bigint        not null comment '主键Id'
    ,BookId        int           not null comment '书籍ID'
    ,UserId        bigint        not null comment '用户ID'
    ,SectionPos    varchar(765)  not null comment '券章节Key'
    ,Scripture     string        not null comment '经文内容'
    ,CreateTime    datetime      not null comment '创建时间'
    ,ShareTarget   varchar(765)           comment '分享平台'
    ,sr_createtime datetime               comment "starrocks入库时间"
    ,sr_updatetime datetime               comment "starrocks数据更新时间"
)
duplicate key(dt, Id)
comment "分享日志表"
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