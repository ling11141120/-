
DROP TABLE IF EXISTS dwd.dwd_device_gp_app_anr_di;
CREATE TABLE dwd.dwd_device_gp_app_anr_di
(
     dt              DATE           NOT NULL    COMMENT "日期"
    ,id              BIGINT(20)     NOT NULL    COMMENT "主键"
    ,anr_type        VARCHAR(50)    NOT NULL    COMMENT "ANR类型"
    ,init_time       DATETIME       NOT NULL    COMMENT "数据写入时间"
    ,start_time      DATETIME                   COMMENT "抓取日期"
    ,product_id      INT(11)                    COMMENT "产品Id"
    ,core            INT(11)                    COMMENT "Core"
    ,lang            VARCHAR(60)                COMMENT "语言"
    ,version_code    BIGINT(20)                 COMMENT "版本号"
    ,device_name     VARCHAR(300)               COMMENT "设备名称"
    ,manufacturer    VARCHAR(100)               COMMENT "厂商"
    ,device_model    VARCHAR(100)               COMMENT "机型"
    ,anr_count       INT(11)                    COMMENT "受影响用户数"
    ,anr_rate        DECIMAL(15, 5)             COMMENT "受影响比例"
    ,anr_global_rate DECIMAL(15, 5)             COMMENT "全局ANR率"
    ,device_guid     VARCHAR(150)               COMMENT "Guid"
    ,update_time     DATETIME                   COMMENT "数据更新时间"
    ,anr_time        DATETIME                   COMMENT "ANR日期"
    ,session_count   INT(11)                    COMMENT "会话数"
    ,active_count    INT(11)                    COMMENT "活动用户数"
    ,etl_tm          DATETIME                   COMMENT "etl时间"
)
ENGINE=OLAP
PRIMARY KEY (dt, id, anr_type)
COMMENT "设备域-GooglePlay上报机型ANR-每日增量"
PARTITION BY DATE_TRUNC('month', dt)
DISTRIBUTED BY HASH(dt, id, anr_type)
PROPERTIES (
    "replication_num" = "2",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "LZ4"
)
;