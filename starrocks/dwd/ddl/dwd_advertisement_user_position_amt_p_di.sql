DROP TABLE IF EXISTS dwd.dwd_advertisement_user_position_amt_p_di;
CREATE TABLE dwd.dwd_advertisement_user_position_amt_p_di (
     dt                   DATE               NOT NULL                  COMMENT "事件时间"
    ,create_tm            DATETIME           NOT NULL                  COMMENT "事件时间"
    ,product_id           INT(11)            NOT NULL                  COMMENT "产品id"
    ,user_id              BIGINT(20)         NOT NULL                  COMMENT "用户id"
    ,corever              INT(11)                                      COMMENT "core,包体，对应不同的app,枚举值：1,2,3,4"
    ,mt                   INT(11)                                      COMMENT "平台"
    ,appver               VARCHAR(255)                                 COMMENT "版本号"
    ,ad_unit              VARCHAR(255)                                 COMMENT "广告单元id"
    ,position_id          INT(11)                                      COMMENT "广告位置id"
    ,ads_name             VARCHAR(255)                                 COMMENT "广告来源-广告平台 (adomob,topon,max)"
    ,ads_source           VARCHAR(655)                                 COMMENT "admob广告源,可通过这个反推是哪家具体的广告"
    ,ad_show_type         INT(11)                                      COMMENT "广告类型"
    ,main_strategy_id     VARCHAR(65533)                               COMMENT "主策略id"
    ,event_strategy_id    VARCHAR(65533)                               COMMENT "策略id"
    ,programme_id         VARCHAR(1000)                                COMMENT "频道方案ID"
    ,ad_position_amt      DECIMAL(38, 9)                               COMMENT "广告收益"
    ,etl_tm               DATETIME           DEFAULT CURRENT_TIMESTAMP COMMENT "清洗时间"
    ,INDEX index_productid (product_id) USING BITMAP COMMENT 'index_productid'
)
DUPLICATE KEY(dt, create_tm, product_id)
COMMENT "阅读及海外短剧--广告预估收益明细宽表,数据起始时间23年1月"
PARTITION BY RANGE(dt)
DISTRIBUTED BY HASH(dt, create_tm, product_id, user_id) BUCKETS 20
PROPERTIES ("replication_num" = "2",
            "bloom_filter_columns" = "user_id, create_tm",
            "dynamic_partition.enable" = "true",
            "dynamic_partition.time_unit" = "MONTH",
            "dynamic_partition.time_zone" = "Asia/Shanghai",
            "dynamic_partition.start" = "-120",
            "dynamic_partition.end" = "3",
            "dynamic_partition.prefix" = "p",
            "dynamic_partition.history_partition_num" = "0",
            "dynamic_partition.start_day_of_month" = "1",
            "in_memory" = "false",
            "enable_persistent_index" = "true",
            "replicated_storage" = "true",
            "storage_medium" = "SSD",
            "compression" = "ZSTD"
)
;