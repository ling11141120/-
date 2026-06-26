create table if not exists dws.dws_advertisement_toufang_ed (
     dt                date           not null                  comment "日期（createtime）"
    ,type              int            not null                  comment "投放渠道类型（1facbook,2其他渠道）3:国内短剧"
    ,product_id        int            not null                  comment "产品id"
    ,corever           int            not null                  comment "corever"
    ,current_language2 int            not null                  comment "投放语言"
    ,mt                int            not null                  comment "终端"
    ,spend             decimal(10, 2)                           comment "投放金额"
    ,etl_time          datetime       default current_timestamp comment "etl清洗时间"
)
primary key(dt, type, product_id, corever, current_language2, mt)
comment "广告域投放1日汇总表"
partition by date_trunc("day", dt)
distributed by hash(dt, product_id) buckets 1
properties (
    "replication_num" = "3",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "LZ4"
)
;