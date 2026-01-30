drop table if exists dws.dws_subscribe_user_daily_snapshot;
create table dws.dws_subscribe_user_daily_snapshot (
     product_id    int         not null comment "product_id"
    ,user_id       bigint      not null comment "用户id"
    ,sub_type      smallint    not null comment "订阅类型"
    ,expire_time   datetime             comment "过期时间"
    ,is_valid      tinyint              comment "是否有效"
    ,etl_time      datetime             comment "etl时间"
)
primary key (product_id, user_id, sub_type)
comment "订阅域-用户快照表"
distributed by hash(product_id, user_id, sub_type)
properties (
    "replication_num" = "3",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "LZ4"
)
;