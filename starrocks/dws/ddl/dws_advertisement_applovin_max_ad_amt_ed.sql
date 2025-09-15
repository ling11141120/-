DROP TABLE IF EXISTS dws.dws_advertisement_applovin_max_ad_amt_ed;
CREATE TABLE dws.dws_advertisement_applovin_max_ad_amt_ed (
     dt                    DATE                       COMMENT 'date_time 北京时间用来统计收入的日期'
    ,product_id            INT                        COMMENT '产品id'
    ,mt                    INT                        COMMENT '平台'
    ,corever               INT                        COMMENT '包体'
    ,ad_format             VARCHAR(300)               COMMENT '广告类型'
    ,max_ad_unit_id        VARCHAR(300)               COMMENT '最大广告单元ID'
    ,net_work              VARCHAR(300)               COMMENT '广告网络名称(广告来源)'
    ,ad_position           INT                        COMMENT '广告位置id'
    ,ecpm                  DECIMAL(30,5)              COMMENT '以美元计算的预计eCPM保留5位小数。'
    ,estimated_revenue_amt DECIMAL(30,5)              COMMENT '估计产生的收入（美元）保留5位小数。'
    ,impressions_cnt       VARCHAR(30)                COMMENT '原始值-显示的印象数'
    ,etl_tm                DATETIME                   COMMENT '清洗时间'
    ,INDEX index_product_id (product_id) USING BITMAP COMMENT 'index_product_id'
) 
DUPLICATE KEY (dt)
COMMENT '阅读-max广告收入数据'
DISTRIBUTED BY HASH (dt) BUCKETS 3
PROPERTIES (
    "replication_num" = "3",
    "bloom_filter_columns" = "dt",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "LZ4"
)
;