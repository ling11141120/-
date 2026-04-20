drop table if exists dwd.dwd_traffic_sv_paywall_strategy_hit_event_di;
create table dwd.dwd_traffic_sv_paywall_strategy_hit_event_di (
     dt                date            not null    comment "日期分区"
    ,md5_key           varchar(32)     not null    comment "md5唯一键"
    ,id                bigint          not null    comment "id"
    ,unnest_node_id    varchar(200)    not null    comment "拆分节点id"
    ,map_node_id       varchar(200)    not null    comment "映射节点id"
    ,node_id_path      varchar(200)    not null    comment "节点id路径"
    ,user_id           bigint                      comment "用户id"
    ,corever           int                         comment "版本id"
    ,strategy_type     int                         comment "策略类型"
    ,code              int                         comment "业务状态码"
    ,version_id        bigint                      comment "策略id即版本id"
    ,template_id       bigint                      comment "模板id"
    ,node_path         string                      comment "节点名称路径"
    ,is_default        int                         comment "是否走了兜底逻辑"
    ,message           string                      comment "响应消息"
    ,create_time       datetime                    comment "创建时间"
    ,etl_ime           datetime                    comment "清洗时间"
)
primary key(dt, md5_key)
comment "流量域-海剧付费墙策略命中事件表"
partition by date_trunc("day", dt)
distributed by hash(dt, md5_key)
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