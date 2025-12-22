drop table if exists dws.dws_advertisement_admob_income_ed;
create table dws.dws_advertisement_admob_income_ed (
     dt               date           not null comment "日期，来自DATE字段"
    ,product_id       int(11)        not null comment "产品"
    ,account          string                  comment "账号"
    ,ads_nmae         string                  comment "广告来源"
    ,ad_unit          string                  comment "广告单元id"
    ,mt               int(11)                 comment "终端"
    ,corever          int(11)                 comment "corever"
    ,time_types       smallint(6)    not null comment "时区类型 1北京 2洛杉矶"
    ,ad_requests      bigint(20)              comment "请求的数量。该值是一个整数。"
    ,matched_requests bigint(20)              comment "响应请求而返回广告的次数。该值是一个整数。"
    ,impressions      bigint(20)              comment "向用户展示的广告总数。该值是一个整数。"
    ,clicks           bigint(20)              comment "用户点击广告的次数。该值是一个整数。"
    ,ad_amount        decimal(18, 4)          comment "AdMob 发布商的估算收入 ESTIMATED_EARNINGS/1000000,单位，美元"
    ,etl_time         datetime       not null comment "数据清洗时间"
    ,appver           varchar(50)             comment ""
)
duplicate key(dt, product_id)
comment "沙盘-广告错误报表数据"
partition by range(dt)
(partition p202512 values less than ("2026-01-01"))
distributed by hash(dt, product_id) buckets 1
properties (
    "replication_num" = "3",
    "bloom_filter_columns" = "ads_nmae",
    "dynamic_partition.enable" = "true",
    "dynamic_partition.time_unit" = "month",
    "dynamic_partition.time_zone" = "Asia/Shanghai",
    "dynamic_partition.start" = "-2147483648",
    "dynamic_partition.end" = "3",
    "dynamic_partition.prefix" = "p",
    "dynamic_partition.buckets" = "1",
    "dynamic_partition.history_partition_num" = "0",
    "dynamic_partition.start_day_of_month" = "1",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "LZ4"
)
;