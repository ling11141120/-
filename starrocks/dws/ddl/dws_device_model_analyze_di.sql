DROP TABLE IF EXISTS dws.dws_device_model_analyze_di;
CREATE TABLE dws.dws_device_model_analyze_di
(
     dt                  DATE             NOT NULL    COMMENT '日期'
    ,biz_type_cd         INT              NOT NULL    COMMENT '业务类型编码'
    ,product_id          BIGINT           NOT NULL    COMMENT 'product_id'
    ,core                INT              NOT NULL    COMMENT 'core'
    ,dev_mdl             VARCHAR(100)     NOT NULL    COMMENT '设备型号'
    ,biz_type_name       VARCHAR(10)                  COMMENT '业务类型名称'
    ,svr_dau             DECIMAL(20,5)                COMMENT '服务端日活'
    ,ad_uv               DECIMAL(20,5)                COMMENT '广告uv'
    ,ad_ttl_amt          DECIMAL(20,5)                COMMENT '广告总收入'
    ,ad_rpc              DECIMAL(20,5)                COMMENT '广告人均单价'
    ,web_ad_amt          DECIMAL(20,5)                COMMENT 'web广告收入'
    ,web_ad_rpc          DECIMAL(20,5)                COMMENT 'web广告人均单价'
    ,med_sdk_ad_amt      DECIMAL(20,5)                COMMENT '聚合sdk广告收入'
    ,med_sdk_ad_rpc      DECIMAL(20,5)                COMMENT '聚合sdk广告人均单价'
    ,clk_uv              DECIMAL(20,5)                COMMENT '点击uv'
    ,push_act_clk_uv     DECIMAL(20,5)                COMMENT '下发活跃点击uv'
    ,tp_rev              DECIMAL(20,5)                COMMENT '充值收入'
    ,push_af_1h_tp_rev   DECIMAL(20,5)                COMMENT '拉活后1小时内充值收入'
    ,etl_tm              DATETIME                     COMMENT 'etl时间'
)
ENGINE=OLAP
PRIMARY KEY (dt, biz_type_cd, product_id, core, dev_mdl)
COMMENT '设备域-机型分析-每日增量'
PARTITION BY DATE_TRUNC('month', dt)
DISTRIBUTED BY HASH(dt, biz_type_cd, product_id, core, dev_mdl)
PROPERTIES (
    "replication_num" = "3",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "LZ4"
)
;