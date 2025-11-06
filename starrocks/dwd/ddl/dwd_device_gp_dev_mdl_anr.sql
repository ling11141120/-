DROP TABLE IF EXISTS dwd.dwd_device_gp_dev_mdl_anr;
CREATE TABLE dwd.dwd_device_gp_dev_mdl_anr (
     evt_id         BIGINT(20)  NOT NULL    COMMENT '事件id'
    ,anr_type       VARCHAR(10) NOT NULL    COMMENT 'ANR类型'
    ,anr_dt         DATE        NOT NULL    COMMENT 'ANR日期'
    ,product_id     INT                     COMMENT 'product_id'
    ,core           INT                     COMMENT 'core'
    ,lang_abbr      VARCHAR(20)             COMMENT '语言缩写'
    ,lang_name      VARCHAR(20)             COMMENT '语言名称'
    ,ver_no         BIGINT                  COMMENT '版本号'
    ,src_dev_mdl    VARCHAR(300)            COMMENT '源设备型号'
    ,mfr            VARCHAR(100)            COMMENT '厂商'
    ,dev_mdl        VARCHAR(100)            COMMENT '设备型号'
    ,anr_num        INT                     COMMENT 'ANR个数'
    ,anr_rt         DECIMAL(15,5)           COMMENT 'ANR率'
    ,glb_anr_rt     DECIMAL(15,5)           COMMENT '全局ANR率'
    ,sess_num       INT                     COMMENT '会话数'
    ,dev_guid       VARCHAR(150)            COMMENT '设备GUID'
    ,etl_time       DATETIME                COMMENT 'etl时间'
)
DUPLICATE KEY (evt_id, anr_type, anr_dt)
COMMENT '设备域-Google Play设备型号ANR'
PARTITION BY DATE_TRUNC('month', anr_dt)
DISTRIBUTED BY HASH (evt_id, anr_type)
PROPERTIES(
    "replication_num" = "3",
    "in_memory" = "false",
    "storage_format" = "DEFAULT",
    "enable_persistent_index" = "true",
    "compression" = "LZ4"
)
;