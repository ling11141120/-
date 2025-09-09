----------------------------------------------------------------
-- 目标表： ods.ods_tidb_koc_db_koc_partneragency_cfg
-- 来源实例： old_tidb_source
-- 来源表： koc_db.koc_partneragency_cfg
-- 来源负责： 黄文
-- 采集工具： 极光-定时批量
-- 开发人： qhr
-- 开发日期： 2025-07-30
----------------------------------------------------------------

DROP TABLE IF EXISTS ods.ods_tidb_koc_db_koc_partneragency_cfg;
CREATE TABLE ods.ods_tidb_koc_db_koc_partneragency_cfg (
     id                 BIGINT(20)       NOT NULL                  COMMENT "主键ID"
    ,agencyid           BIGINT(20)                                 COMMENT "版权方机构ID"
    ,agencyname         VARCHAR(600)                               COMMENT "版权方机构名称"
    ,agencylogo         VARCHAR(600)                               COMMENT "版权方机构名称"
    ,platformraito      DECIMAL(10, 4)                             COMMENT "平台分成比例"
    ,agencyraito        DECIMAL(10, 4)                             COMMENT "机构分成比例"
    ,starraito          DECIMAL(10, 4)                             COMMENT "达人分成比例"
    ,status             INT(11)                                    COMMENT "状态 0=禁用|1=启用"
    ,createtime         DATETIME                                   COMMENT "创建时间"
    ,creator            VARCHAR(600)                               COMMENT "创建人名称"
    ,creatoruid         VARCHAR(600)                               COMMENT "创建人账号ID"
    ,updatetime         DATETIME                                   COMMENT "更新时间"
    ,updater            VARCHAR(600)                               COMMENT "创建人名称"
    ,updateruid         VARCHAR(600)                               COMMENT "更新人账号ID"
    ,appid              INT(11)                                    COMMENT "AppId"
    ,productid          INT(11)                                    COMMENT "ProductId"
    ,rulekey            VARCHAR(600)                               COMMENT "规则说明"
    ,needreport         INT(11)                                    COMMENT "是否报备"
    ,institutionraito   DECIMAL(14, 4)                             COMMENT "分销比例"
    ,projecttype        INT(11)                                    COMMENT "1=网文|2=短剧"
    ,sort               INT(11)                                    COMMENT "排序"
    ,sr_createtime      DATETIME         DEFAULT CURRENT_TIMESTAMP COMMENT "sr入库时间"
    ,sr_updatetime      DATETIME         DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间"
) 
PRIMARY KEY(id)
COMMENT "版权方机构信息"
DISTRIBUTED BY HASH(Id) BUCKETS 1
PROPERTIES (
    "replication_num" = "3",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "LZ4"
)
;