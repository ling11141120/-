drop table if exists dws.dws_trade_short_video_user_shop_num_da;
create table dws.dws_trade_short_video_user_shop_num_da (
     dt              date    not null comment "统计日期"
    ,product_id      int     not null comment "产品 id 6833 海外短剧"
    ,user_id         bigint  not null comment "用户 id"
    ,shop_item       int     not null comment "订阅类型"
    ,item_id         string  not null comment "item_id"
    ,shop_num        int              comment "订阅次数"
    ,autoRenew_times int              comment "续订次数"
    ,first_time      datetime         comment "第一次订阅时间"
    ,create_time     datetime         comment "最后一次订阅时间"
    ,etl_time        datetime         comment "处理时间"
)
primary key(dt, product_id, user_id, shop_item, item_id)
comment "海外短剧 - 用户订阅次数统计表"
partition by range(dt)
(partition by p20260305 values less than ("2026-03-06"))
distributed by hash(dt, product_id, user_id, shop_item, item_id) buckets 1
properties (
    "replication_num" = "3",
    "dynamic_partition.enable" = "true",
    "dynamic_partition.time_unit" = "day",
    "dynamic_partition.time_zone" = "Asia/Shanghai",
    "dynamic_partition.start" = "-2147483648",
    "dynamic_partition.end" = "3",
    "dynamic_partition.prefix" = "p",
    "dynamic_partition.buckets" = "1",
    "dynamic_partition.history_partition_num" = "0",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "LZ4"
)
;
