DROP TABLE IF EXISTS dws.dws_advertisement_user_position_amt_ed;
CREATE TABLE dws.dws_advertisement_user_position_amt_ed (
     dt                    DATE                                     COMMENT "事件时间"
    ,product_id            INT(11)        NOT NULL                  COMMENT "产品id"
    ,user_id               BIGINT(20)                               COMMENT "用户id"
    ,core                  INT(11)                                  COMMENT "core"
    ,mt                    INT(11)                                  COMMENT "终端"
    ,current_language2     VARCHAR(255)                             COMMENT "投放语言"
    ,appver                VARCHAR(255)                             COMMENT "版本号"
    ,ad_show_type          INT(11)                                  COMMENT "广告类型"
    ,positions             INT(11)                                  COMMENT "广告位置"
    ,ads_name              VARCHAR(255)                             COMMENT "广告来源-广告平台 (adomob,topon,max)"
    ,ads_source            VARCHAR(655)                             COMMENT "admob广告源,可通过这个反推是哪家具体的广告"
    ,main_strategy_id      VARCHAR(65533)                           COMMENT "主策略id"
    ,event_strategy_id     VARCHAR(65533)                           COMMENT "策略id"
    ,programme_id          VARCHAR(1000)                            COMMENT "频道方案ID"
    ,fst_amt               DECIMAL(38, 9)                           COMMENT "首次广告收益"
    ,lst_amt               DECIMAL(38, 9)                           COMMENT "末次广告收益"
    ,cnt                   INT(11)                                  COMMENT "次数"
    ,amt                   DECIMAL(38, 9)                           COMMENT "广告收益"
    ,etl_tm                DATETIME       DEFAULT CURRENT_TIMESTAMP COMMENT "清洗时间"
)
DUPLICATE KEY(dt, product_id)
COMMENT "阅读及海外短剧--分广告类型、位置用户粒度广告展现收益表（海外短剧暂时没有分位置）"
PARTITION BY RANGE(dt)
DISTRIBUTED BY HASH(dt, product_id, user_id) BUCKETS 3 
PROPERTIES ("replication_num" = "3",
            "bloom_filter_columns" = "user_id",
            "dynamic_partition.enable" = "true",
            "dynamic_partition.time_unit" = "month",
            "dynamic_partition.time_zone" = "Asia/Shanghai",
            "dynamic_partition.start" = "-2147483648",
            "dynamic_partition.end" = "3",
            "dynamic_partition.prefix" = "p",
            "dynamic_partition.buckets" = "3",
            "dynamic_partition.history_partition_num" = "0",
            "dynamic_partition.start_day_of_month" = "1",
            "in_memory" = "false",
            "enable_persistent_index" = "true",
            "replicated_storage" = "true",
            "compression" = "LZ4"
)
;