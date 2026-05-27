----------------------------------------------------------------
-- 目标表： ods.ods_tidb_unifypush_log_log_pushlog_sr
-- 来源实例： old_tidb_source
-- 来源表：
--        unifypush_log.log_pushlog_ft
--        unifypush_log.log_pushlog_en
--        unifypush_log.log_pushlog_sp
--        unifypush_log.log_pushlog_pt
--        unifypush_log.log_pushlog_fr
--        unifypush_log.log_pushlog_ru
--        unifypush_log.log_pushlog_id
--        unifypush_log.log_pushlog_th
--        unifypush_log.log_pushlog_cd2
-- 来源负责： 串总
-- 开发人： qhr
-- 创建日期： 2026-05-08
----------------------------------------------------------------

create table if not exists ods.ods_tidb_unifypush_log_log_pushlog_sr (
     dt             date          not null                           comment "日期"
    ,Id             bigint        not null                           comment "自增Id"
    ,product_id     int           not null                           comment "product_id"
    ,CreateTime     datetime                                         comment "入库时间"
    ,AppId          int                                              comment "app_id"
    ,BatchId        bigint                                           comment "batch_id"
    ,AccountId      bigint                                           comment "账号Id"
    ,DeviceId       bigint                                           comment "设备Id"
    ,Token          varchar(1000)                                    comment "推送的Token"
    ,ScheduleTime   datetime                                         comment "预期发送时间"
    ,SendTime       datetime                                         comment "实际发送时间"
    ,SendCount      int                                              comment "发送次数"
    ,FinishTime     datetime                                         comment "发送完成时间"
    ,IsSuccess      int                                              comment "是否成功"
    ,ErrorMessage   varchar(1000)                                    comment "失败消息"
    ,Body           string                                           comment "Push的内容"
    ,CustomData     string                                           comment "额外自定义数据"
    ,PushData       string                                           comment "PushData"
    ,PushRequest    string                                           comment "PushRequest"
    ,sr_createtime  datetime               default current_timestamp comment "starrocks数据注入时间"
    ,sr_updatetime  datetime               default current_timestamp comment "starrocks数据更新时间"
)
primary key(dt, Id, product_id)
comment "海阅-push资源位需要推送的消息表"
partition by date_trunc('day', dt)
distributed by hash(dt, Id)
properties (
    "replication_num" = "3",
    "bloom_filter_columns" = "dt, AccountId, DeviceId, CreateTime, BatchId, Id",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "LZ4",
    "partition_live_number" = "35"
)
;