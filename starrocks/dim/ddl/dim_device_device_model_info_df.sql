
DROP TABLE IF EXISTS dim.dim_device_device_model_info_df;
CREATE TABLE dim.dim_device_device_model_info_df (
     dt            date         not null comment '日期'
    ,core          int          not null comment 'core'
    ,dev_mdl       varchar(100) not null comment '设备型号'
    ,product_id    bigint       not null comment 'product_id'
    ,biz_type_cd   int          not null comment '业务类型编码'
    ,biz_type_name varchar(10)           comment '业务类型名称'
    ,etl_tm        datetime     not null comment 'etl时间'
)
primary key (dt, core, dev_mdl, product_id)
comment "设备域-神农机型信息表-每日全量"
partition by date_trunc('day', dt)
distributed by hash(dt, core, dev_mdl, product_id)
properties (
    "replication_num" = "2",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "LZ4"
)
;