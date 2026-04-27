----------------------------------------------------------------
-- 目标表： ods.ods_tidb_short_video_push_trace_notify_record
-- 来源实例： tidb_short_video
-- 来源表： push_trace_notify_record
-- 来源负责： 
-- 采集工具： SeaTunnel
-- 开发人：xjc
-- 开发日期： 2026-04-08
----------------------------------------------------------------

drop table if exists ods.ods_tidb_short_video_push_trace_notify_record;
create table ods.ods_tidb_short_video_push_trace_notify_record (
    dt                date           not null                     comment "日期,create_time"
   ,id                bigint         not null                     comment "主键"
   ,crowd_group_id    varchar(1536)                               comment "人群组/人群包 id 原始 groupId"
   ,account_id        bigint                                      comment "用户 accountId"
   ,hour_bucket       varchar(48)    not null                     comment "执行时间段 yyyyMMddHH,与 trace 时区配置一致，如 2026040221"
   ,position_id       bigint         not null                     comment "资源位 positionId"
   ,app_notify        tinyint        not null                     comment "app 通知开关快照 0关 1开"
   ,create_time       datetime       not null                     comment "落库时间"
   ,sr_createtime     datetime       default current_timestamp    comment "starrocks数据注入时间"
   ,sr_updatetime     datetime       default current_timestamp    comment "starrocks数据更新时间"
)
primary key(dt, id)
comment "push trace appNotify 异步落库明细"
distributed by hash(id)
properties (
    "replication_num" = "3"
   ,"in_memory" = "false"
   ,"enable_persistent_index" = "true"
   ,"replicated_storage" = "true"
   ,"compression" = "LZ4"
)
;