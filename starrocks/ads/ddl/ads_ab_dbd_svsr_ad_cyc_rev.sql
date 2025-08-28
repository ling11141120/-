DROP TABLE IF EXISTS ads.ads_ab_dbd_svsr_ad_cyc_rev;
CREATE TABLE ads.ads_ab_dbd_svsr_ad_cyc_rev (
     dt                 DATE           NOT NULL COMMENT '日期'
    ,core               INT(11)        NOT NULL COMMENT 'core'
    ,project_id         INT(3)         NOT NULL COMMENT '项目id'
    ,period_type        VARCHAR(60)    NOT NULL COMMENT '周期类型'
    ,day0_amount_byad   DECIMAL(20, 6)          COMMENT '当天广告收益'
    ,day1_amount_byad   DECIMAL(20, 6)          COMMENT '累计1天广告收益'
    ,day2_amount_byad   DECIMAL(20, 6)          COMMENT '累计2天广告收益'
    ,day3_amount_byad   DECIMAL(20, 6)          COMMENT '累计3天广告收益'
    ,day7_amount_byad   DECIMAL(20, 6)          COMMENT '累计7天广告收益'
    ,day15_amount_byad  DECIMAL(20, 6)          COMMENT '累计15天广告收益'
    ,day21_amount_byad  DECIMAL(20, 6)          COMMENT '累计21天广告收益'
    ,day30_amount_byad  DECIMAL(20, 6)          COMMENT '累计30天广告收益'
    ,day45_amount_byad  DECIMAL(20, 6)          COMMENT '累计45天广告收益'
    ,day60_amount_byad  DECIMAL(20, 6)          COMMENT '累计60天广告收益'
    ,day90_amount_byad  DECIMAL(20, 6)          COMMENT '累计90天广告收益'
    ,day120_amount_byad DECIMAL(20, 6)          COMMENT '累计120天广告收益'
)
PRIMARY KEY (dt, core, project_id, period_type)
COMMENT 'AB测试-运营看板-海剧海阅广告周期收益表'
PARTITION BY DATE_TRUNC('month', dt)
DISTRIBUTED BY HASH(dt, core, project_id, period_type)
PROPERTIES (
    "replication_num" = "3",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "LZ4"
)
;