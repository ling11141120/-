CREATE TABLE IF NOT EXISTS dim.dim_sv_user_latest_ord
(
    dt         DATE         NOT NULL         COMMENT "日期"
    ,user_id    VARCHAR(512) NOT NULL         COMMENT "用户id"
    ,order_id   VARCHAR(512) NOT NULL         COMMENT "订单id"
    ,pay_method VARCHAR(512)                  COMMENT "支付方式"
    ,crt_tm     DATETIME                      COMMENT "创建时间"
    ,etl_tm     DATETIME     NOT NULL         COMMENT "etl时间"
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