drop table if exists dws.dws_device_model_analyze_di;
create table dws.dws_device_model_analyze_di (
     dt                date          not null comment '日期'
    ,biz_type_cd       int           not null comment '业务类型编码'
    ,product_id        bigint        not null comment 'product_id'
    ,core              int           not null comment 'core'
    ,dev_mdl           varchar(100)  not null comment '设备型号'
    ,biz_type_name     varchar(10)            comment '业务类型名称'
    ,svr_dau           decimal(20,5)          comment '服务端日活'
    ,ad_uv             decimal(20,5)          comment '广告uv'
    ,ad_ttl_amt        decimal(20,5)          comment '广告总收入'
    ,ad_rpc            decimal(20,5)          comment '广告人均单价'
    ,web_ad_amt        decimal(20,5)          comment 'web广告收入'
    ,web_ad_rpc        decimal(20,5)          comment 'web广告人均单价'
    ,med_sdk_ad_amt    decimal(20,5)          comment '聚合sdk广告收入'
    ,med_sdk_ad_rpc    decimal(20,5)          comment '聚合sdk广告人均单价'
    ,clk_uv            decimal(20,5)          comment '点击uv'
    ,push_act_clk_uv   decimal(20,5)          comment '下发活跃点击uv'
    ,tp_rev            decimal(20,5)          comment '充值收入'
    ,push_af_1h_tp_rev decimal(20,5)          comment '拉活后1小时内充值收入'
    ,etl_tm            datetime               comment 'etl时间'
)
primary key (dt, biz_type_cd, product_id, core, dev_mdl)
comment '设备域-机型分析-每日增量'
partition by date_trunc('month', dt)
distributed by hash(dt, biz_type_cd, product_id, core, dev_mdl)
properties (
    "replication_num" = "3",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "LZ4"
)
;