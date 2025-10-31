----------------------------------------------------------------
-- 目标表： ods.ods_tidb_unifypush_log_log_pushlog_sv
-- 来源实例： 
-- 来源表： 
-- 来源负责： 
-- 采集工具： 
-- 开发人： qhr
-- 创建日期： 2025-09-23
----------------------------------------------------------------

DROP TABLE IF EXISTS ods.ods_tidb_unifypush_log_log_pushlog_sv;
CREATE TABLE ods.ods_tidb_unifypush_log_log_pushlog_sv (
     dt            DATE          NOT NULL                  COMMENT "日期"
    ,Id            BIGINT(20)    NOT NULL                  COMMENT "自增Id"
    ,CreateTime    DATETIME      NOT NULL                  COMMENT "入库时间"
    ,AppId         INT(11)                                 COMMENT "app_id"
    ,BatchId       BIGINT(20)                              COMMENT "batch_id"
    ,AccountId     BIGINT(20)                              COMMENT "账号Id"
    ,DeviceId      BIGINT(20)                              COMMENT "设备Id"
    ,Token         VARCHAR(1000)                           COMMENT "推送的Token"
    ,ScheduleTime  DATETIME                                COMMENT "预期发送时间"
    ,SendTime      DATETIME                                COMMENT "实际发送时间"
    ,SendCount     INT(11)                                 COMMENT "发送次数"
    ,FinishTime    DATETIME                                COMMENT "发送完成时间"
    ,IsSuccess     INT(11)                                 COMMENT "是否成功"
    ,ErrorMessage  VARCHAR(1000)                           COMMENT "失败消息"
    ,Body          STRING                                  COMMENT "Push的内容"
    ,CustomData    STRING                                  COMMENT "额外自定义数据"
    ,PushData      STRING                                  COMMENT "PushData"
    ,PushRequest   STRING                                  COMMENT "PushRequest"
    ,sr_createtime DATETIME      DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间"
    ,sr_updatetime DATETIME      DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间"
)
PRIMARY KEY(`dt`, `Id`, `CreateTime`)
COMMENT "海剧-push资源位需要推送的消息表(来源为串总)"
PARTITION BY RANGE(dt)
(PARTITION p20251015 VALUES LESS THAN ("2025-10-16"))
DISTRIBUTED BY HASH(dt, Id, CreateTime) BUCKETS 5
PROPERTIES (
    "replication_num" = "3",
    "bloom_filter_columns" = "dt, AccountId, DeviceId, CreateTime, BatchId, Id",
    "dynamic_partition.enable" = "true",
    "dynamic_partition.time_unit" = "day",
    "dynamic_partition.time_zone" = "Asia/Shanghai",
    "dynamic_partition.start" = "-95",
    "dynamic_partition.end" = "3",
    "dynamic_partition.prefix" = "p",
    "dynamic_partition.buckets" = "1",
    "dynamic_partition.history_partition_num" = "0",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "LZ4"
);