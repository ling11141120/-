CREATE TABLE IF NOT EXISTS ads.ads_user_sv_subscribe_status_di (
     dt                 date         NOT NULL COMMENT "日期"
    ,user_id            bigint       NOT NULL COMMENT "用户ID"
    ,subscribe_type_cd  varchar(128) NOT NULL COMMENT "订阅类型编码：810(SVIP)/860(NSVIP)/840(新福利包)/0(普通充值)/其他"
    ,etl_time           datetime     NOT NULL COMMENT "数据清洗时间"
)
PRIMARY KEY(dt, user_id)
COMMENT "用户短剧订阅类型状态日表"
PARTITION BY date_trunc('day', dt)
DISTRIBUTED BY HASH(dt, user_id) BUCKETS 3
PROPERTIES (
    "replication_num" = "3",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "LZ4"
)
;
