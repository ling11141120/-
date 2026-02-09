drop table if exists dwd.dwd_subscribe_signin_card_log;
create table dwd.dwd_subscribe_signin_card_log (
     dt          date     not null comment "分区日期"
    ,product_id  int      not null comment "product_id"
    ,log_id      bigint   not null comment "记录id"
    ,user_id     bigint            comment "用户id"
    ,expire_time datetime          comment "过期时间"
    ,create_time datetime          comment "创建时间"
    ,mt          int               comment "终端系统"
    ,etl_time    datetime          comment "etl时间"
)
primary key(dt, product_id, log_id)
comment "订阅域-签到卡发放记录"
partition by date_trunc('month', dt)
distributed by hash(dt, product_id, log_id)
properties (
    "replication_num" = "3",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "LZ4"
)
;