----------------------------------------------------------------
-- 目标表： ods.ods_tidb_qadata_gp_app_push_device_anr
-- 来源实例： old_tidb_source
-- 来源表： qadata.gp_app_push_device_anr
-- 采集工具： 极光-定时批量
-- 开发人： qhr
-- 开发日期： 2025-10-10
----------------------------------------------------------------

DROP TABLE IF EXISTS ods.ods_tidb_qadata_gp_app_push_device_anr;
CREATE TABLE ods.ods_tidb_qadata_gp_app_push_device_anr (
     Id            BIGINT(20)    NOT NULL                  COMMENT '主键'
    ,InitTime      DATETIME      NOT NULL                  COMMENT '数据写入时间'
    ,StartTime     DATETIME                                COMMENT '抓取日期'
    ,ProductId     INT(11)                                 COMMENT '产品Id'
    ,Core          INT(11)                                 COMMENT 'Core'
    ,Lang          VARCHAR(60)                             COMMENT '语言'
    ,VersionCode   BIGINT(20)                              COMMENT '版本号'
    ,DeviceName    VARCHAR(300)                            COMMENT '机型'
    ,AnrCount      INT(11)                                 COMMENT '受影响用户数'
    ,AnrRate       DECIMAL(15,5)                           COMMENT '受影响比例'
    ,AnrGlobalRate DECIMAL(15,5)                           COMMENT '全局ANR率'
    ,DeviceGuid    VARCHAR(150)                            COMMENT 'Guid'
    ,UpdateTime    DATETIME                                COMMENT '数据更新时间'
    ,AnrTime       DATETIME                                COMMENT 'ANR日期'
    ,ActiveCount   INT(11)                                 COMMENT '活动用户数'
    ,sr_createtime DATETIME      DEFAULT CURRENT_TIMESTAMP COMMENT 'starrocks数据注入时间'
    ,sr_updatetime DATETIME      DEFAULT CURRENT_TIMESTAMP COMMENT 'starrocks数据更新时间'
)
DUPLICATE KEY (Id, InitTime)
COMMENT '谷歌PlayPUSH问题机型维度ANR率'
PARTITION BY DATE_TRUNC('month', InitTime)
DISTRIBUTED BY HASH (Id)
PROPERTIES(
    "replication_num" = "3",
    "in_memory" = "false",
    "storage_format" = "DEFAULT",
    "enable_persistent_index" = "true",
    "compression" = "LZ4"
)
;