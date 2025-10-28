DROP TABLE IF EXISTS ads.ads_sv_user_element_exposure_info;
CREATE TABLE ads.ads_sv_user_element_exposure_info (
     dt                   DATE         NOT NULL COMMENT "分区日期"
    ,product_id           INT(11)      NOT NULL COMMENT "产品id"
    ,id                   VARCHAR(255) NOT NULL COMMENT "ID"
    ,zffs_rank            INT(11)      NOT NULL COMMENT "曝光顺序，zzfs_list里面的位次"
    ,user_id              BIGINT(20)            COMMENT "用户id"
    ,zffs                 VARCHAR(255)          COMMENT "支付方式"
    ,sfzf_strategy_id     VARCHAR(255)          COMMENT "三方策略id"
    ,event_tm             DATETIME              COMMENT "事件时间"
    ,current_language2    INT(11)               COMMENT "初始语言"
    ,core                 INT(11)               COMMENT "corever"
    ,user_type            VARCHAR(255)          COMMENT "用户类型"
    ,mt                   INT(11)               COMMENT "最新平台号,1为ios 4为安卓"
    ,reg_country          VARCHAR(255)          COMMENT "注册国家"
    ,etl_time             DATETIME              COMMENT "etl时间"
) 
PRIMARY KEY(dt, product_id, id, zffs_rank)
COMMENT "海剧-用户控件曝光事件信息"
PARTITION BY RANGE(dt)
(PARTITION p20251026 VALUES LESS THAN ("2025-10-27"))
DISTRIBUTED BY HASH(dt, product_id, id, zffs_rank) BUCKETS 10
PROPERTIES (
    "replication_num" = "2",
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