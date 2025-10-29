DROP TABLE IF EXISTS ads.ads_shennong_dev_mdl_anr_dau_ad_imp_eval;
CREATE TABLE ads.ads_shennong_dev_mdl_anr_dau_ad_imp_eval (
     dt                  DATE             NOT NULL    COMMENT '日期'
    ,dem_type            INT              NOT NULL    COMMENT '降权类型编码'
    ,biz_type_cd         INT              NOT NULL    COMMENT '业务类型编码'
    ,product_id          BIGINT           NOT NULL    COMMENT 'product_id'
    ,core                INT              NOT NULL    COMMENT 'core'
    ,dev_mdl             VARCHAR(100)     NOT NULL    COMMENT '设备型号'
    ,dem_type_name       VARCHAR(20)                  COMMENT '降权类型名称'
    ,biz_type_name       VARCHAR(10)                  COMMENT '业务类型名称'
    ,prd_name            VARCHAR(50)                  COMMENT '产品名称'
    ,mfr                 VARCHAR(100)                 COMMENT '厂商'
    ,anr_ocr_dt          DATE                         COMMENT 'ANR发生日期'
    ,anr_fch_dt          DATE                         COMMENT 'ANR抓取日期'
    ,dev_guid            VARCHAR(50)                  COMMENT '设备GUID'
    ,imp_num             DECIMAL(20,0)                COMMENT '影响数'
    ,sess_num            DECIMAL(20,0)                COMMENT '会话数'
    ,imp_pct             DECIMAL(20,5)                COMMENT '受影响占比'
    ,hist_anr_usr_rat    DECIMAL(20,5)                COMMENT '历史ANR用户比例'
    ,svr_dau             DECIMAL(20,5)                COMMENT '服务端日活'
    ,ad_uv               DECIMAL(20,5)                COMMENT '广告uv'
    ,ad_ttl_amt          DECIMAL(20,5)                COMMENT '广告总收入'
    ,ad_rpc              DECIMAL(20,5)                COMMENT '广告人均单价'
    ,web_ad_amt          DECIMAL(20,5)                COMMENT 'web广告收入'
    ,web_ad_rpc          DECIMAL(20,5)                COMMENT 'web广告人均单价'
    ,med_sdk_ad_amt      DECIMAL(20,5)                COMMENT '聚合SDK广告收入'
    ,med_sdk_ad_rpc      DECIMAL(20,5)                COMMENT '聚合SDK广告人均单价'
    ,clk_uv              DECIMAL(20,5)                COMMENT '点击uv'
    ,push_act_clk_uv     DECIMAL(20,5)                COMMENT '下发活跃点击uv'
    ,tp_rev              DECIMAL(20,5)                COMMENT '充值收入'
    ,etl_tm              DATETIME                     COMMENT 'etl时间'
)
PRIMARY KEY (dt, dem_type, biz_type_cd, product_id, core ,dev_mdl)
COMMENT '神农-机型ANR日活广告影响评估'
PARTITION BY DATE_TRUNC('month',dt)
DISTRIBUTED BY HASH (dt, dem_type, biz_type_cd, product_id, core, dev_mdl)
PROPERTIES(
    "replication_num" = "3",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "LZ4"
)
;