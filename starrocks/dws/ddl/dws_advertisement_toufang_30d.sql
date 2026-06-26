create table if not exists dws.dws_advertisement_toufang_30d (
     month             int            not null                  comment "月份（createtime）"
    ,type              int            not null                  comment "投放渠道类型（1facbook,2其他渠道）"
    ,product_id        int            not null                  comment "产品id"
    ,corever           int            not null                  comment "corever"
    ,current_language2 int            not null                  comment "投放语言"
    ,mt                int            not null                  comment "终端"
    ,daysnum           int                                      comment "当月天数"
    ,spend             decimal(10, 2)                           comment "投放金额"
    ,etl_time          datetime       default current_timestamp comment "etl清洗时间"
)
primary key(month, type, product_id, corever, current_language2, mt)
comment "广告域投放30日汇总表"
distributed by hash(month, product_id) buckets 20
properties (
    "replication_num" = "3",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "LZ4"
)
;
