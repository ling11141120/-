
DROP TABLE IF EXISTS dim.dim_device_device_model_info_df;
CREATE TABLE dim.dim_device_device_model_info_df
(
     dt            DATE         NOT NULL    COMMENT '日期'
    ,core          INT          NOT NULL    COMMENT 'core'
    ,dev_mdl       VARCHAR(100) NOT NULL    COMMENT '设备型号'
    ,product_id    BIGINT       NOT NULL    COMMENT 'product_id'
    ,biz_type_cd   INT          NOT NULL    COMMENT '业务类型编码'
    ,biz_type_name VARCHAR(10)              COMMENT '业务类型名称'
    ,etl_tm        DATETIME     NOT NULL    COMMENT 'etl时间'
)
ENGINE=OLAP
PRIMARY KEY (dt, core, dev_mdl, product_id)
COMMENT "设备域-神农机型信息表-每日全量"
PARTITION BY DATE_TRUNC('day', dt)
DISTRIBUTED BY HASH(dt, core, dev_mdl, product_id)
PROPERTIES (
    "replication_num" = "2",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "LZ4"
)
;