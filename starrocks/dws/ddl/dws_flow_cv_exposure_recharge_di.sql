create table if not exists dws.dws_flow_cv_exposure_recharge_di (
     dt               date     not null                  comment "事件时间"
    ,ads_optimizer    string                             comment "优化师名称"
    ,cz_template_id   string                             comment "充值模板ID"
    ,cz_template_name string                             comment "充值模板名称"
    ,product_tps      string                             comment "产品类型"
    ,real_recharge    string                             comment "档位金额"
    ,exp_user         string                             comment "曝光用户id"
    ,recharge_user    string                             comment "充值用户id"
    ,shortplay_id     string                             comment "短剧id"
    ,tv_name          string                             comment "短剧名称"
    ,recharge_tps     int                                comment "充值来源 1:自营 2：分销 3：星图，4：小程序推广"
    ,etl_tm           datetime default current_timestamp comment "清洗时间"
)
duplicate key(dt)
comment "国剧-充值档位曝光充值转化数据"
distributed by hash(dt) buckets 1
properties (
    "replication_num" = "3",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "storage_medium" = "SSD",
    "compression" = "ZSTD"
)
;
