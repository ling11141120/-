----------------------------------------------------------------
-- 目标表： ods.ods_tidb_qadata_gp_app_country_active_user
-- 来源实例： old_tidb_source
-- 来源表： qadata.gp_app_country_active_user
-- 采集工具： 极光-定时批量
-- 开发人： qhr
-- 开发日期： 2025-10-10
----------------------------------------------------------------

DROP TABLE IF EXISTS ods.ods_tidb_qadata_gp_app_country_active_user;
CREATE TABLE ods.ods_tidb_qadata_gp_app_country_active_user (
     Id            BIGINT(20)    NOT NULL                COMMENT '主键'
    ,InitTime      DATETIME      NOT NULL                COMMENT '数据写入时间'
    ,StartTime     DATETIME                              COMMENT '抓取日期'
    ,ProductId     INT(11)                               COMMENT '产品Id'
    ,Core          INT(11)                               COMMENT 'Core'
    ,Lang          VARCHAR(20)                           COMMENT '语言'
    ,CountryName   VARCHAR(500)                          COMMENT '国家'
    ,UserCount     INT(11)                               COMMENT 'ANR个数'
    ,UpdateTime    DATETIME                              COMMENT '数据更新时间'
    ,sr_createtime DATETIME    DEFAULT CURRENT_TIMESTAMP COMMENT 'starrocks数据注入时间'
    ,sr_updatetime DATETIME    DEFAULT CURRENT_TIMESTAMP COMMENT 'starrocks数据更新时间'
)
DUPLICATE KEY (Id, InitTime)
COMMENT '谷歌Play国家维度每日用户数'
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