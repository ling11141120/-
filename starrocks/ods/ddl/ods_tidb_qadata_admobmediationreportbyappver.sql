----------------------------------------------------------------
-- 目标表： ods.ods_tidb_qadata_admobmediationreportbyappver
-- 来源实例： old_tidb_source
-- 来源表： qadata.AdMobMediationReportByAppver
-- 来源负责： 陈思杰
-- 采集工具： SeaTunnel
-- 开发人： qhr
-- 开发日期： 2025-07-02
----------------------------------------------------------------

DROP TABLE IF EXISTS ods.ods_tidb_qadata_admobmediationreportbyappver;
CREATE TABLE ods.ods_tidb_qadata_admobmediationreportbyappver (
     dt               DATE             NOT NULL                  COMMENT "日期,date字段"
    ,Id               BIGINT(20)       NOT NULL                  COMMENT ""
    ,DATE             VARCHAR(10)                                COMMENT "日期"
    ,AD_UNIT          VARCHAR(128)                               COMMENT "广告单元"
    ,PLATFORM         VARCHAR(10)                                COMMENT "APP 终端"
    ,AD_SOURCE        VARCHAR(50)                                COMMENT "广告来源"
    ,APP_VERSION_NAME VARCHAR(50)                                COMMENT "APP版本号"
    ,APP              VARCHAR(128)                               COMMENT "APP"
    ,AD_REQUESTS      INT(11)                                    COMMENT "请求的数量。该值是一个整数。"
    ,CLICKS           INT(11)                                    COMMENT "用户点击广告的次数。该值是一个整数。"
    ,ESTIMATED_EARNINGS BIGINT(20)                               COMMENT "AdMob 发布商的估算收入 例如,6.50 美元将表示为 6500000"
    ,IMPRESSIONS      INT(11)                                    COMMENT "向用户展示的广告总数。该值是一个整数。"
    ,MATCHED_REQUESTS INT(11)                                    COMMENT "响应请求而返回广告的次数。该值是一个整数。"
    ,MATCH_RATE       DOUBLE                                     COMMENT "匹配的广告请求与总广告请求的比率。该值是双精度（近似）十进制值。"
    ,OBSERVED_ECPM    BIGINT(20)                                 COMMENT "第三方广告网络的估计平均 eCPM 例如，$2.30 将表示为 2300000"
    ,Account          VARCHAR(255)                               COMMENT "广告账户"
    ,CreatedTime      DATETIME                                   COMMENT "创建时间"
    ,UpdatedTime      DATETIME                                   COMMENT "更新时间"
    ,sr_createtime    DATETIME         DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间"
    ,sr_updatetime    DATETIME                                   COMMENT "sr数据更新时间"
) ENGINE = OLAP
PRIMARY KEY (dt, Id)
COMMENT "Admob广告收入表"
DISTRIBUTED BY HASH (dt, Id) BUCKETS 1
PROPERTIES (
    "replication_num" = "3",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "LZ4"
)
;