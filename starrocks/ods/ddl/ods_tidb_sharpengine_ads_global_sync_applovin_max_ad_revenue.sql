----------------------------------------------------------------
-- 目标表： ods.ods_tidb_sharpengine_ads_global_sync_applovin_max_ad_revenue
-- 来源实例： new_tidb_source
-- 来源表： sharpengine_ads_global.sync_applovin_max_ad_revenue
-- 采集工具： SeaTunnel
-- 负责人： qhr
-- 创建日期： 2025-07-02
----------------------------------------------------------------

DROP TABLE IF EXISTS ods.ods_tidb_sharpengine_ads_global_sync_applovin_max_ad_revenue;
CREATE TABLE ods.ods_tidb_sharpengine_ads_global_sync_applovin_max_ad_revenue (
     id                     BIGINT(20)    NOT NULL                  COMMENT '主键ID'
    ,uuid                   VARCHAR(150)  NOT NULL                  COMMENT 'day+hour+country+ad_format+max_ad_unit_id+network+device_type+has_idfa组合的md5'
    ,day                    VARCHAR(60)                             COMMENT '原始值-UTC日期：yyyy-MM-dd'
    ,hour                   VARCHAR(60)                             COMMENT '原始值-UTC时间：HH:mm'
    ,application            VARCHAR(3000)                           COMMENT '原始值-应用程序名称'
    ,country                VARCHAR(300)                            COMMENT '原始值-国家'
    ,ad_format              VARCHAR(300)                            COMMENT '原始值-广告类型'
    ,max_ad_unit_id         VARCHAR(300)                            COMMENT '原始值-最大广告单元ID'
    ,max_ad_unit            VARCHAR(600)                            COMMENT '原始值-最大广告单元名称'
    ,network                VARCHAR(600)                            COMMENT '原始值-广告网络名称'
    ,device_type            VARCHAR(300)                            COMMENT '原始值-设备类型'
    ,has_idfa               VARCHAR(30)                             COMMENT '原始值-用户是否有可用的广告ID。0如果用户启用了LAT（限制广告流量）或选择不使用GDPR地理信息系统中的数据，则为1'
    ,ecpm_str               VARCHAR(300)                            COMMENT '原始值-以美元计算的预计eCPM。'
    ,ecpm                   DECIMAL(30,5)                           COMMENT '转换值-以美元计算的预计eCPM。'
    ,estimated_revenue_str  VARCHAR(300)                            COMMENT '原始值-估计产生的收入（美元）。'
    ,estimated_revenue      DECIMAL(30,5)                           COMMENT '转换值-估计产生的收入（美元）。'
    ,impressions            VARCHAR(30)                             COMMENT '原始值-显示的印象数'
    ,network_placement      VARCHAR(600)                            COMMENT '原始值-外部广告网络的布局'
    ,package_name           VARCHAR(600)                            COMMENT '原始值-包名'
    ,platform               VARCHAR(60)                             COMMENT '原始值-平台'
    ,store_id               VARCHAR(300)  NOT NULL                  COMMENT '原始值-ios商店id'
    ,data_time              DATETIME      NOT NULL                  COMMENT '原始值-数据时间-北京时间'
    ,create_time            DATETIME      NOT NULL                  COMMENT '添加时间'
    ,sync_update_time       DATETIME                                COMMENT '数据更新时间戳'
    ,sr_createtime          DATETIME      DEFAULT CURRENT_TIMESTAMP COMMENT 'starrocks数据注入时间'
    ,sr_updatetime          DATETIME      DEFAULT CURRENT_TIMESTAMP COMMENT 'starrocks数据更新时间'
    ,INDEX index_store_id (store_id) USING BITMAP                   COMMENT 'index_store_id'
) 
PRIMARY KEY (id)
COMMENT '阅读-max广告收入数据'
DISTRIBUTED BY HASH (id) BUCKETS 3
PROPERTIES (
    "replication_num" = "3",
    "bloom_filter_columns" = "create_time, data_time",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "LZ4"
)
;