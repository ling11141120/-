----------------------------------------------------------------
-- 目标表： ods.ods_tidb_koc_db_koc_partneragency_video
-- 来源实例： old_tidb_source
-- 来源表： koc_db.koc_partneragency_video
-- 来源负责： 黄文
-- 采集工具： 极光-定时批量
-- 开发人： qhr
-- 开发日期： 2025-07-30
----------------------------------------------------------------

DROP TABLE IF EXISTS ods.ods_tidb_koc_db_koc_partneragency_video;
CREATE TABLE ods.ods_tidb_koc_db_koc_partneragency_video (
     id                 BIGINT(20)       NOT NULL                  COMMENT "主键ID"
    ,agencyid           BIGINT(20)                                 COMMENT "版权方机构ID"
    ,seriesid           BIGINT(20)                                 COMMENT "短剧ID"
    ,language           INT(11)                                    COMMENT "语言"
    ,seriesname         VARCHAR(600)                               COMMENT "短剧名称"
    ,coverurl           VARCHAR(2000)                              COMMENT "封面"
    ,tagstr             VARCHAR(2000)                              COMMENT "标签"
    ,description        VARCHAR(1048576)                           COMMENT "短剧简介"
    ,diskpath           VARCHAR(3000)                              COMMENT "百度网盘链接"
    ,publishstatus      INT(11)                                    COMMENT "上架状态(1上架 2下架)"
    ,allepis            INT(11)                                    COMMENT "总集数"
    ,payepisfrom        INT(11)                                    COMMENT "收费起始集数"
    ,updatetime         DATETIME                                   COMMENT "修改时间"
    ,synchcreatetime    DATETIME                                   COMMENT "同步创建时间"
    ,synchupdatetime    DATETIME                                   COMMENT "更新时间"
    ,createtime         DATETIME                                   COMMENT "创建时间"
    ,worktype           INT(11)                                    COMMENT "作品类型0未知 1.男频 2.女频 "
    ,sr_createtime      DATETIME         DEFAULT CURRENT_TIMESTAMP COMMENT "sr入库时间"
    ,sr_updatetime      DATETIME         DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间"
)
PRIMARY KEY(id)
COMMENT "版权方短剧信息"
DISTRIBUTED BY HASH(id) BUCKETS 1
PROPERTIES (
    "replication_num" = "3",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "LZ4"
)
;