----------------------------------------------------------------
-- 目标表： ods.ods_tidb_sharpengine_ads_global_admobapp
-- 来源实例： new_tidb_source
-- 来源表： sharpengine_ads_global.AdMobApp
-- 采集工具： SeaTunnel
-- 开发人： qhr
-- 开发日期： 2025-07-02
----------------------------------------------------------------

DROP TABLE IF EXISTS ods.ods_tidb_sharpengine_ads_global_admobapp;
CREATE TABLE ods.ods_tidb_sharpengine_ads_global_admobapp (
     Id              INT(11)          NOT NULL                  COMMENT "自增id"
    ,Name            VARCHAR(65533)                             COMMENT "名字"
    ,AppId           VARCHAR(65533)                             COMMENT "appid"
    ,DisplayName     VARCHAR(65533)                             COMMENT "名称"
    ,Account         VARCHAR(65533)                             COMMENT "广告账户"
    ,Platform        VARCHAR(65533)                             COMMENT "平台"
    ,CreatedTime     DATETIME                                   COMMENT "创建时间"
    ,UpdatedTime     DATETIME                                   COMMENT "更新时间"
    ,Mt              INT(11)                                    COMMENT "设备"
    ,Core            INT(11)                                    COMMENT "core"
    ,ProductId       INT(11)                                    COMMENT "产品id"
    ,AppName         VARCHAR(65533)                             COMMENT "关联App信息"
    ,AppStoreId      VARCHAR(65533)                             COMMENT "关联App包名"
    ,sr_createtime   DATETIME         DEFAULT CURRENT_TIMESTAMP COMMENT "sr数据创建时间"
    ,sr_updatetime   DATETIME                                   COMMENT "sr数据更新时间"
)
PRIMARY KEY (Id)
COMMENT "appid对应表"
DISTRIBUTED BY HASH (Id) BUCKETS 1
PROPERTIES (
    "replication_num" = "3",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "LZ4"
)
;