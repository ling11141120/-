CREATE TABLE ads.ads_bi_ad_video_income (
     dt               date           not null comment "年分区字段：日期"
    ,product_id       smallint(6)    not null comment "产品id"
    ,ad_show_type     varchar(255)       null comment "广告类型"
    ,positions        smallint(6)        null comment "广告位置"
    ,ads_name         varchar(65533)     null comment "广告商名称"
    ,mt               smallint(6)        null comment "设备"
    ,core             smallint(6)        null comment "core"
    ,appver           varchar(65533)     null comment ""
    ,ad_requests      bigint(20)         null comment "请求的数量。该值是一个整数。"
    ,matched_requests bigint(20)         null comment "响应请求而返回广告的次数。该值是一个整数。"
    ,impressions      bigint(20)         null comment "向用户展示的广告总数。该值是一个整数"
    ,clicks           bigint(20)         null comment "用户点击广告的次数。该值是一个整数"
    ,ad_amount        decimal(18, 6)     null comment "AdMob 发布商的估算收入 ESTIMATED_EARNINGS/1000000,单位，美元"
    ,tps              int(11)            null comment "1:admob 2:topon 3:max 4:starmobi"
    ,etl_time         datetime       not null comment "数据清洗时间"
)
duplicate key (dt, product_id)
comment "海外短剧广告收入统计表"
distributed by hash (dt, product_id) buckets 1
properties (
  "replication_num" = "3",
  "bloom_filter_columns" = "dt",
  "in_memory" = "false",
  "enable_persistent_index" = "true",
  "replicated_storage" = "true",
  "compression" = "LZ4"
)
;