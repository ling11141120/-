----------------------------------------------------------------
-- 目标表： ods.ods_tidb_koc_codeinfo
-- 来源实例： hk-koc-mysql-slave
-- 来源表： koc_data.koc_codeinfo
-- 来源负责：
-- 采集工具： SeaTunnel
-- 开发人：
-- 开发日期： 2025-09-11
----------------------------------------------------------------

DROP TABLE IF EXISTS ods.ods_tidb_koc_codeinfo;
CREATE TABLE IF NOT EXISTS ods.ods_tidb_koc_codeinfo (
     Id            BIGINT(20)     NOT NULL                  COMMENT "主键ID"
    ,KocCode       VARCHAR(65533)                           COMMENT "口令"
    ,ProjectType   INT(11)                                  COMMENT "授权范围 1=网文|2=短剧"
    ,DataId        BIGINT(20)                               COMMENT "书籍|短剧ID"
    ,InstitutionId BIGINT(20)                               COMMENT "机构ID"
    ,StarId        BIGINT(20)                               COMMENT "达人ID"
    ,CodeSort      BIGINT(20)                               COMMENT "排序"
    ,CreateTime    DATETIME                                 COMMENT "创建时间"
    ,Creator       VARCHAR(65533)                           COMMENT "创建人"
    ,CreatorUid    VARCHAR(65533)                           COMMENT "创建人账号ID"
    ,sr_createtime DATETIME       DEFAULT CURRENT_TIMESTAMP COMMENT "数据创建时间"
    ,sr_updatetime DATETIME                                 COMMENT "数据更新时间"
)
PRIMARY KEY (Id)
COMMENT "KOC口令信息"
DISTRIBUTED BY HASH (Id) BUCKETS 3
PROPERTIES (
    "replication_num" = "3",
    "in_memory" = "false",
    "enable_persistent_index" = "false",
    "replicated_storage" = "true",
    "compression" = "LZ4"
)
;