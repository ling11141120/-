drop table if exists ads.ads_bi_read_adv_income_report_advdata;
create table ads.ads_bi_read_adv_income_report_advdata (
     dt                     date       not null         comment "日期，来自DATE字段"
    ,product_id             int(11)    not null         comment "产品"
    ,mt                     int(11)                     comment "平台"
    ,corever                int(11)                     comment "包体"
    ,ads_name               varchar(65533)              comment "广告来源"
    ,ad_show_type           varchar(255)                comment "广告类型"
    ,position_id            varchar(255)                comment "广告位置id"
    ,tps                    int(11)                     comment "1:admob 2:topon 3:max 4:starmobi"
    ,ad_amt                 decimal(18, 4)              comment "AdMob 发布商的估算收入 ESTIMATED_EARNINGS/1000000,单位，美元"
    ,ad_request_cnt         bigint(20)                  comment "请求的数量。该值是一个整数。"
    ,matched_request_cnt    bigint(20)                  comment "响应请求而返回广告的次数。该值是一个整数。"
    ,impression_cnt         bigint(20)                  comment "向用户展示的广告总数。该值是一个整数。"
    ,click_cnt              bigint(20)                  comment "用户点击广告的次数。该值是一个整数。"
    ,etl_tm                 datetime   not null         comment "数据清洗时间"
    ,index index_product_id (product_id) using bitmap   comment 'index_product_id'
)
DUPLICATE KEY(dt, product_id)
COMMENT "广告位置收入数据"
PARTITION BY RANGE(dt)
DISTRIBUTED BY HASH(dt, product_id) BUCKETS 1 
PROPERTIES (
    "replication_num" = "3",
    "bloom_filter_columns" = "dt",
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