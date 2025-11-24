drop table if exists dwd.dwd_advertisement_user_position_amt_p_di;
create table dwd.dwd_advertisement_user_position_amt_p_di (
     dt                date           not null                  comment "事件时间"
    ,create_tm         datetime       not null                  comment "事件时间"
    ,product_id        int(11)        not null                  comment "产品id"
    ,user_id           bigint(20)     not null                  comment "用户id"
    ,corever           int(11)                                  comment "core,包体，对应不同的app,枚举值：1,2,3,4"
    ,mt                int(11)                                  comment "平台"
    ,appver            varchar(255)                             comment "版本号"
    ,ad_unit           varchar(255)                             comment "广告单元id"
    ,position_id       int(11)                                  comment "广告位置id"
    ,ads_name          varchar(255)                             comment "广告来源-广告平台 (adomob,topon,max)"
    ,ads_source        varchar(655)                             comment "admob广告源,可通过这个反推是哪家具体的广告"
    ,ad_show_type      int(11)                                  comment "广告类型"
    ,main_strategy_id  string                                   comment "主策略id"
    ,event_strategy_id string                                   comment "策略id"
    ,programme_id      varchar(1000)                            comment "频道方案ID"
    ,ad_position_amt   decimal(38, 9)                           comment "广告收益"
    ,etl_tm            datetime       default current_timestamp comment "清洗时间"
    ,index index_productid (product_id) using bitmap comment 'index_productid'
)
duplicate key(dt, create_tm, product_id)
comment "阅读及海外短剧--广告预估收益明细宽表,数据起始时间23年1月"
partition by range(dt)
distributed by hash(dt, create_tm, product_id, user_id) BUCKETS 20
properties (
    "replication_num" = "2",
    "bloom_filter_columns" = "user_id, create_tm",
    "dynamic_partition.enable" = "true",
    "dynamic_partition.time_unit" = "MONTH",
    "dynamic_partition.time_zone" = "Asia/Shanghai",
    "dynamic_partition.start" = "-120",
    "dynamic_partition.end" = "3",
    "dynamic_partition.prefix" = "p",
    "dynamic_partition.history_partition_num" = "0",
    "dynamic_partition.start_day_of_month" = "1",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "storage_medium" = "SSD",
    "compression" = "ZSTD"
)
;