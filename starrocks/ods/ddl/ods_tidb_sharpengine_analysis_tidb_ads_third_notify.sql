----------------------------------------------------------------
-- 目标表： ods_tidb_sharpengine_analysis_tidb_ads_third_notify
-- 来源实例： old_tidb_source
-- 来源表： sharpengine_analysis_tidb.ads_third_notify
-- 来源负责： 
-- 采集工具： SeaTunnel
-- 开发人： qhr
-- 开发日期： 2025-10-23
----------------------------------------------------------------

DROP TABLE IF EXISTS ods.ods_tidb_sharpengine_analysis_tidb_ads_third_notify;
CREATE TABLE ods.ods_tidb_sharpengine_analysis_tidb_ads_third_notify (
     Id                         BIGINT       NOT NULL    COMMENT 'Id'
    ,CreateTime                 DATETIME     NOT NULL    COMMENT '创建时间'
    ,NotifyType                 VARCHAR(765)             COMMENT '通知类型'
    ,NotifyData                 STRING                   COMMENT '通知数据'
    ,Status                     INT          DEFAULT '0' COMMENT '状态'
    ,EventType                  VARCHAR(765)             COMMENT '事件类型'
    ,PurchaseAttributeStatus    INT          DEFAULT '0' COMMENT '充值归因处理状态值'
    ,SendToAdPlatformStatus     INT          DEFAULT '0' COMMENT '是否已经通知到广告平台'
    ,MediaSource                VARCHAR(765)             COMMENT '媒体类型,比如fb_int,applovin_int'
    ,AppsflyerId                VARCHAR(765)             COMMENT 'AppsflyerId'
    ,EventTime                  DATETIME                 COMMENT '事件时间,可能是InstallTime,也可能是其他'
    ,Core                       INT                      COMMENT 'Core'
    ,AfAttributeStatus          INT          DEFAULT '0' COMMENT 'Af归因的处理状态'
    ,BundleId                   VARCHAR(300)             COMMENT '包Id'
    ,Platform                   VARCHAR(300)             COMMENT '平台'
)
PRIMARY KEY (Id, CreateTime)
COMMENT "广告第三方af通知日志表"
PARTITION BY DATE_TRUNC('day', CreateTime)
DISTRIBUTED BY HASH(Id)
PROPERTIES (
     "replication_num" = "3"
    ,"bloom_filter_columns" = "NotifyType, Status, EventType, AfAttributeStatus, MediaSource"
    ,"in_memory" = "false"
    ,"enable_persistent_index" = "true"
    ,"replicated_storage" = "true"
    ,"compression" = "LZ4"
)
;