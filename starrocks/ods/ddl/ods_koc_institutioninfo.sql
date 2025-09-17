----------------------------------------------------------------
-- 目标表： ods.ods_koc_institutioninfo
-- 来源实例： hk-koc-mysql-slave
-- 来源表： koc_data.koc_institutioninfo
-- 来源负责：
-- 采集工具： SeaTunnel
-- 开发人：
-- 开发日期： 2025-09-11
----------------------------------------------------------------

DROP TABLE IF EXISTS ods.ods_koc_institutioninfo;
CREATE TABLE ods.ods_koc_institutioninfo (
      Id              BIGINT(20)      NOT NULL                  COMMENT "主键ID"
     ,InstitutionName VARCHAR(65533)                            COMMENT "机构名称"
     ,UserId          VARCHAR(65533)                            COMMENT "登录账号表对应的UserId"
     ,InstitutionStatus INT(11)                                 COMMENT "状态 0=禁用|1=启用"
     ,InstitutionType INT(11)                                   COMMENT "机构类型 0=默认|1=api"
     ,Token           VARCHAR(65533)                            COMMENT "机构授权Token"
     ,IpWhiteList     VARCHAR(65533)                            COMMENT "IP白名单"
     ,InstitutionRemark VARCHAR(65533)                          COMMENT "备注"
     ,CreateTime      DATETIME                                  COMMENT "创建时间"
     ,Creator         VARCHAR(65533)                            COMMENT "创建人"
     ,CreatorUid      VARCHAR(65533)                            COMMENT "创建人账号ID"
     ,UpdateTime      DATETIME                                  COMMENT "更新时间"
     ,Updater         VARCHAR(65533)                            COMMENT "更新人"
     ,UpdaterUid      VARCHAR(65533)                            COMMENT "更新人账号ID"
     ,sr_createtime   DATETIME        DEFAULT CURRENT_TIMESTAMP COMMENT "数据创建时间"
     ,sr_updatetime   DATETIME                                  COMMENT "数据更新时间"
)
PRIMARY KEY (Id)
COMMENT "机构信息"
DISTRIBUTED BY HASH (Id) BUCKETS 1
PROPERTIES (
    "replication_num" = "3",
    "in_memory" = "false",
    "enable_persistent_index" = "false",
    "replicated_storage" = "true",
    "compression" = "LZ4"
)
;