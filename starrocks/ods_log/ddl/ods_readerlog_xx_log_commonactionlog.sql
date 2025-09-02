DROP TABLE IF EXISTS ods_log.ods_readerlog_xx_log_commonactionlog;
CREATE TABLE ods_log.ods_readerlog_xx_log_commonactionlog (
     dt                 DATE             NOT NULL COMMENT ""
    ,productid          INT(11)          NOT NULL COMMENT ""
    ,Id                 BIGINT(20)       NOT NULL COMMENT ""
    ,UserId             BIGINT(20)                COMMENT ""
    ,Action             VARCHAR(1512)             COMMENT ""
    ,ProdId             VARCHAR(1512)             COMMENT ""
    ,Chl                VARCHAR(1512)             COMMENT ""
    ,IMEI               VARCHAR(1512)             COMMENT ""
    ,mt                 INT(11)                   COMMENT ""
    ,appver             VARCHAR(1512)             COMMENT ""
    ,smallpt            VARCHAR(1512)             COMMENT ""
    ,F0                 BIGINT(20)                COMMENT ""
    ,F1                 BIGINT(20)                COMMENT ""
    ,F2                 BIGINT(20)                COMMENT ""
    ,F3                 BIGINT(20)                COMMENT ""
    ,F4                 BIGINT(20)                COMMENT ""
    ,F5                 BIGINT(20)                COMMENT ""
    ,F6                 BIGINT(20)                COMMENT ""
    ,F7                 BIGINT(20)                COMMENT ""
    ,F8                 BIGINT(20)                COMMENT ""
    ,F9                 BIGINT(20)                COMMENT ""
    ,S0                 VARCHAR(65533)            COMMENT ""
    ,S1                 VARCHAR(65533)            COMMENT ""
    ,S2                 VARCHAR(65533)            COMMENT ""
    ,S3                 VARCHAR(65533)            COMMENT ""
    ,S4                 VARCHAR(65533)            COMMENT ""
    ,S5                 VARCHAR(65533)            COMMENT ""
    ,S6                 VARCHAR(65533)            COMMENT ""
    ,S7                 VARCHAR(65533)            COMMENT ""
    ,S8                 VARCHAR(65533)            COMMENT ""
    ,S9                 VARCHAR(65533)            COMMENT ""
    ,CreateTime         DATETIME                  COMMENT ""
    ,AppId              INT(11)                   COMMENT ""
    ,sr_createtime      DATETIME         DEFAULT CURRENT_TIMESTAMP COMMENT ""
    ,sr_updatetime      DATETIME                  COMMENT ""
)
PRIMARY KEY (dt, productid, Id)
PARTITION BY RANGE (dt)
DISTRIBUTED BY HASH (Id) BUCKETS 1
PROPERTIES (
    "replication_num" = "3",
    "dynamic_partition.enable" = "true",
    "dynamic_partition.time_unit" = "DAY",
    "dynamic_partition.time_zone" = "Asia/Shanghai",
    "dynamic_partition.start" = "-3650",
    "dynamic_partition.end" = "3",
    "dynamic_partition.prefix" = "p",
    "dynamic_partition.buckets" = "10",
    "dynamic_partition.history_partition_num" = "0",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "LZ4"
)
;