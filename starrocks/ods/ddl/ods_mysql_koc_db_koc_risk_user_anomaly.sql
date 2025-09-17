----------------------------------------------------------------
-- 目标表： ods.ods_mysql_koc_db_koc_risk_user_anomaly
-- 来源实例： hk-koc-mysql-slave
-- 来源表： koc_db.koc_risk_user_anomaly
-- 来源负责： 黄文
-- 采集工具： SeaTunnel
-- 开发人： qhr
-- 开发日期： 2025-09-15
----------------------------------------------------------------

DROP TABLE IF EXISTS ods.ods_mysql_koc_db_koc_risk_user_anomaly;
CREATE TABLE ods.ods_mysql_koc_db_koc_risk_user_anomaly (
     id                 BIGINT       NOT NULL                           COMMENT '自增主键'
    ,user_id            BIGINT       NOT NULL                           COMMENT '用户ID'
    ,anomaly_type       TINYINT      NOT NULL DEFAULT '1'               COMMENT '异常类型 1=刷券 2=撞库 3=薅羊毛 4=套现 …'
    ,status             TINYINT      NOT NULL DEFAULT '1'               COMMENT '状态 1=生效 2=已解除'
    ,start_time         DATETIME     NOT NULL                           COMMENT '异常开始时间'
    ,end_time           DATETIME                                        COMMENT '异常结束时间; NULL 表示尚未结束'
    ,remark             VARCHAR(765)                                    COMMENT '人工备注'
    ,created_at         DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间'
    ,updated_at         DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '更新时间'
    ,sr_createtime      DATETIME              DEFAULT CURRENT_TIMESTAMP COMMENT "sr入库时间"
    ,sr_updatetime      DATETIME              DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间"
)
PRIMARY KEY(id)
COMMENT "异常用户表"
DISTRIBUTED BY HASH(Id) BUCKETS 1
PROPERTIES (
    "replication_num" = "3",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "LZ4"
)
;