----------------------------------------------------------------
-- 目标表： ods.ods_tidb_unifypush_log_log_pushlog_sv
-- 来源实例： old_tidb_source
-- 来源表： unifypush_log.log_pushlog_sv
-- 来源负责： 串总
-- 开发人： qhr
-- 创建日期： 2025-09-23
----------------------------------------------------------------

create table if not exists ods.ods_tidb_unifypush_log_log_pushlog_sv (
     dt            date          not null                  comment "日期"
    ,Id            bigint        not null                  comment "自增Id"
    ,CreateTime    datetime      not null                  comment "入库时间"
    ,AppId         int                                     comment "app_id"
    ,BatchId       bigint                                  comment "batch_id"
    ,AccountId     bigint                                  comment "账号Id"
    ,DeviceId      bigint                                  comment "设备Id"
    ,Token         varchar(1000)                           comment "推送的Token"
    ,ScheduleTime  datetime                                comment "预期发送时间"
    ,SendTime      datetime                                comment "实际发送时间"
    ,SendCount     int                                     comment "发送次数"
    ,FinishTime    datetime                                comment "发送完成时间"
    ,IsSuccess     int                                     comment "是否成功"
    ,ErrorMessage  varchar(1000)                           comment "失败消息"
    ,Body          string                                  comment "Push的内容"
    ,CustomData    string                                  comment "额外自定义数据"
    ,PushData      string                                  comment "PushData"
    ,PushRequest   string                                  comment "PushRequest"
    ,sr_createtime datetime      default current_timestamp comment "starrocks数据注入时间"
    ,sr_updatetime datetime      default current_timestamp comment "starrocks数据更新时间"
)
primary key(dt, Id, CreateTime)
comment "海剧-push资源位需要推送的消息表"
partition by range(dt)
(partition p20251015 values less than ("2025-10-16"))
distributed by hash(dt, Id, CreateTime) buckets 5
properties (
    "replication_num" = "3",
    "bloom_filter_columns" = "dt, AccountId, DeviceId, CreateTime, BatchId, Id",
    "dynamic_partition.enable" = "true",
    "dynamic_partition.time_unit" = "day",
    "dynamic_partition.time_zone" = "Asia/Shanghai",
    "dynamic_partition.start" = "-35",
    "dynamic_partition.end" = "3",
    "dynamic_partition.prefix" = "p",
    "dynamic_partition.buckets" = "1",
    "dynamic_partition.history_partition_num" = "0",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "LZ4"
)
;