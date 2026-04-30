create table if not exists ads.ads_bi_read_flow_resource_slot_exposure_di (
     dt                date           not null comment "曝光时间"
    ,corever           int            not null comment "core"
    ,mt                varchar(50)    not null comment "平台"
    ,country_level     int            not null comment "国家等级 1：T1,2:T2"
    ,current_language2 int            not null comment "投放语言(注册语言)"
    ,strategy_id       int            not null comment "策略id"
    ,group_id          int            not null comment "人群包id"
    ,element_id        int            not null comment "控件id（各个资源位）"
    ,group_active_unt  bitmap                  comment "人群包活跃人数"
    ,op_exposure_unt   bitmap                  comment "资源位曝光人数"
    ,op_exposure_cnt   int                     comment "资源位曝光次数"
    ,op_click_unt      bitmap                  comment "资源位点击人数"
    ,op_click_cnt      int                     comment "资源位点击次数"
    ,h5_exposure_unt   bitmap                  comment "H5曝光人数"
    ,h5_click_unt      bitmap                  comment "H5点击人数"
    ,recharge_unt      bitmap                  comment "充值成功人数"
    ,recharge_amt      decimal(16, 6)          comment "充值成功金额($)"
    ,etl_tm            datetime                comment "清洗时间"
)
primary key(dt, corever, mt, country_level, current_language2, strategy_id, group_id, element_id)
comment "阅读-app内各资源位曝光充值转化数据"
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