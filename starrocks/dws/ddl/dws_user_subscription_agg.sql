drop table if exists tmp.dws_user_subscription_agg;
create table tmp.dws_user_subscription_agg (
     product_id          int          not null comment "产品ID"
    ,user_id             bigint       not null comment "用户ID"
    ,recharge_type_cd    varchar(128) not null comment "充值类型编码"
    ,item_id             varchar(128) not null comment "申请ID"
    ,shop_num            int                   comment "订阅次数"
    ,subscribe_status    int                   comment "订阅状态"
)
primary key(product_id, user_id, recharge_type_cd, item_id)
comment "用户订阅聚合表"
distributed by hash(product_id, user_id)
properties (
    "replication_num" = "3",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "LZ4"
);