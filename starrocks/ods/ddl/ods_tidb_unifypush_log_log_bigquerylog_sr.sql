----------------------------------------------------------------
-- 目标表： ods.ods_tidb_unifypush_log_log_bigquerylog_sr
-- 来源实例： old_tidb_source
-- 来源表：
--         unifypush_log.log_bigquerylog_ft
--         unifypush_log.log_bigquerylog_en
--         unifypush_log.log_bigquerylog_sp
--         unifypush_log.log_bigquerylog_pt
--         unifypush_log.log_bigquerylog_fr
--         unifypush_log.log_bigquerylog_ru
--         unifypush_log.log_bigquerylog_jp
--         unifypush_log.log_bigquerylog_id
--         unifypush_log.log_bigquerylog_th
-- 来源负责： 串总
-- 采集工具： SeaTunnel
-- 开发人： qhr
-- 开发日期： 2026-01-06
----------------------------------------------------------------

drop table if exists ods.ods_tidb_unifypush_log_log_bigquerylog_sr;
create table ods.ods_tidb_unifypush_log_log_bigquerylog_sr (
     dt            date         not null                  comment '分区字段'
    ,Id            bigint       not null                  comment '自增Id'
    ,product_id    int          not null                  comment 'product_id'
    ,ProdId        int                                    comment '产品Id'
    ,EventTime     datetime                               comment '事件时间'
    ,MessageId     varchar(765)                           comment '消息id'
    ,InstanceId    varchar(765)                           comment '实例id'
    ,MessageType   varchar(765)                           comment '消息类型'
    ,EventType     varchar(765)                           comment '事件类型'
    ,CreateTime    datetime                               comment '创建时间'
    ,sr_createtime datetime     default current_timestamp comment "starrocks数据注入时间"
    ,sr_updatetime datetime     default current_timestamp comment "starrocks数据更新时间"
    ,index index_productid (ProdId) using bitmap          comment 'index_productid'
)
primary key(dt, Id, product_id)
comment "push推送-送达相关日志表"
partition by date_trunc('day', dt)
distributed by hash(dt, Id, product_id)
properties (
    "replication_num" = "3",
    "bloom_filter_columns" = "CreateTime",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "LZ4"
)
;