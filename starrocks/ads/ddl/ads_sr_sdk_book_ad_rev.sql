drop table if exists ads.ads_sr_sdk_book_ad_rev;
create table ads.ads_sr_sdk_book_ad_rev (
     dt          date           not null comment "日期"
    ,product_id  bigint         not null comment "产品id"
    ,core        int            not null comment "core"
    ,book_id     bigint         not null comment "书籍id"
    ,ad_revenue  decimal(38, 9)          comment "广告收入"
)
primary key(dt, product_id, core, book_id)
comment "sdk c4 书籍广告收入"
partition by date_trunc("month", dt)
distributed by hash(dt, book_id)
properties (
    "replication_num" = "3",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "lz4"
)
;
