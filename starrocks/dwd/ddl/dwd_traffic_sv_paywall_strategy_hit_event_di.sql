drop table if exists dwd.dwd_traffic_sv_paywall_strategy_hit_event_di;
create table dwd.dwd_traffic_sv_paywall_strategy_hit_event_di (
     dt               date         not null comment "日期分区"
    ,strategy_node_id varchar(200) not null comment "策略节点ID"
    ,event_id         bigint       not null comment "事件id"
    ,user_id          bigint                comment "用户id"
    ,node_id          varchar(200)          comment "节点id"
    ,event_time       datetime              comment "事件时间"
    ,version_id       int                   comment "版本id"
    ,etl_ime          datetime              comment "清洗时间"
    ,template_id      bigint                comment "模板id"
)
primary key(dt, strategy_node_id, event_id)
comment "流量域-海剧付费墙策略命中事件表"
partition by date_trunc('day', dt)
distributed by hash(dt, strategy_node_id, event_id)
properties (
    "replication_num" = "3",
    "bloom_filter_columns" = "dt",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "LZ4",
    "partition_live_number" = "733"
)
;