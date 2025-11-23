----------------------------------------------------------------
-- 目标表： ods.ods_tidb_hallow_log_log_advertlog
-- 来源实例： old_tidb_source
-- 来源表： hallow_log.log_advertlog
-- 来源负责：
-- 采集工具： SeaTunnel
-- 开发人： qhr
-- 开发日期： 2025-11-23
----------------------------------------------------------------

drop table if exists ods.ods_tidb_hallow_log_log_advertlog;
create table ods.ods_tidb_hallow_log_log_advertlog (
     Id                bigint         not null                  comment '广告日志Id'
    ,CreateTime        datetime       not null                  comment '创建时间'
    ,ECPMInfo          json                                     comment 'eCPM全部信息'
    ,ECPMValueMicros   decimal(30,20)                           comment '预测的eCPM值'
    ,ECPMValueType     tinyint                                  comment 'eCPM值类型 0：预测 1：真实'
    ,UserId            bigint         not null                  comment '用户ID'
    ,MT                int                                      comment '平台类型'
    ,Core              int                                      comment 'Core'
    ,UniqueCdReaderId  varchar(765)                             comment '设备号'
    ,Appver            varchar(765)                             comment '版本'
    ,sr_createtime     datetime       default current_timestamp comment "starrocks入库时间"
    ,sr_updatetime     datetime       default current_timestamp comment "starrocks数据更新时间"
)
primary key(Id, CreateTime)
comment "广告信息日志"
partition by date_trunc("month", CreateTime)
distributed by hash(CreateTime)
properties (
    "replication_num" = "3",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "LZ4"
)
;
