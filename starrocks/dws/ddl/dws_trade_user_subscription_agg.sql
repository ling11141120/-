drop table if exists dws.dws_trade_user_subscription_agg;
create table dws.dws_trade_user_subscription_agg (
     dt                   date         not null comment "分区日期"
    ,product_id           int          not null comment "产品ID"
    ,user_id              bigint       not null comment "用户ID"
    ,recharge_type_cd     varchar(128) not null comment "充值类型编码"
    ,item_id              varchar(128) not null comment "申请ID"
    ,subscribe_num        int                   comment "订阅次数"
    ,subscribe_status     int                   comment "订阅状态"
    ,first_subscribe_time datetime              comment "首次订阅时间"
    ,etl_time             datetime              comment "ETL时间"
)
primary key(dt, product_id, user_id, recharge_type_cd, item_id)
comment "用户订阅聚合表"
partition by date_trunc('day', dt)
distributed by hash(product_id, user_id)
properties (
    "replication_num" = "3",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "LZ4"
)
;