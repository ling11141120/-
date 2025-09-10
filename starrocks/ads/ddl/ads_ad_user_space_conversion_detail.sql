DROP TABLE IF EXISTS ads.ads_ad_user_space_conversion_detail;
CREATE TABLE ads.ads_ad_user_space_conversion_detail (
     dt                  DATE           NOT NULL                  COMMENT "时间"
    ,user_id             BIGINT(20)     NOT NULL                  COMMENT "登录id"
    ,ad_position_id      VARCHAR(60)    NOT NULL                  COMMENT "广告位id"
    ,ad_strategy_id      VARCHAR(60)    NOT NULL                  COMMENT "策略id"
    ,main_strategy_id    VARCHAR(60)    NOT NULL                  COMMENT "主策略id"
    ,ad_type             VARCHAR(60)    NOT NULL                  COMMENT "广告类型"
    ,period_type         VARCHAR(60)    NOT NULL                  COMMENT "周期类型"
    ,user_type           VARCHAR(60)                              COMMENT "用户类型"
    ,put_language        VARCHAR(60)                              COMMENT "投放语言"
    ,country_leve        VARCHAR(60)                              COMMENT "国家等级"
    ,mt                  VARCHAR(60)                              COMMENT "终端"
    ,corever             VARCHAR(60)                              COMMENT "core"
    ,impression_pv       INT(11)                                  COMMENT "曝光pv"
    ,click_pv            INT(11)                                  COMMENT "点击pv"
    ,watch_completion_pv INT(11)                                  COMMENT "观看完成pv"
    ,ad_revenue_amount   DECIMAL(12, 6)                           COMMENT "广告收益"
    ,etl_time            DATETIME       DEFAULT CURRENT_TIMESTAMP COMMENT "清洗时间"
)
PRIMARY KEY (dt, user_id, ad_position_id, ad_strategy_id, main_strategy_id, ad_type, period_type)
COMMENT "用户广告位转化明细"
PARTITION BY RANGE (dt)
DISTRIBUTED BY HASH (user_id) BUCKETS 3
PROPERTIES (
    "replication_num" = "3",
    "dynamic_partition.enable" = "true",
    "dynamic_partition.time_unit" = "DAY",
    "dynamic_partition.time_zone" = "Asia/Shanghai",
    "dynamic_partition.start" = "-2147483648",
    "dynamic_partition.end" = "3",
    "dynamic_partition.prefix" = "p",
    "dynamic_partition.buckets" = "3",
    "dynamic_partition.history_partition_num" = "0",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "LZ4"
)
;