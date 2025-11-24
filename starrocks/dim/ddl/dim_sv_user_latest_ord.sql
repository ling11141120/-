CREATE TABLE IF NOT EXISTS dim.dim_sv_user_latest_ord
(
     dt         date          not null         comment "日期"
    ,user_id    varchar(512)  not null         comment "用户id"
    ,order_id   varchar(512)  not null         comment "订单id"
    ,pay_method varchar(512)                   comment "支付方式"
    ,crt_tm     datetime                       comment "创建时间"
    ,etl_tm     datetime      not null         comment "etl时间"
)
    ENGINE = OLAP
PRIMARY KEY (dt, user_id)
COMMENT "海外短剧-用户最新订单表"
PARTITION BY date_trunc("day",dt)
DISTRIBUTED BY HASH(dt)
PROPERTIES (
    "replication_num" = "2",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "partition_live_number" = "10", -- 只保留最近10个分区
    "compression" = "lz4"
)
;