drop table if exists ads.ads_bi_user_read_book_info;
create table ads.ads_bi_user_read_book_info (
     dt              date          not null              comment "createtime 分区"
    ,product_id      int(11)       not null              comment "产品id"
    ,user_id         bigint(20)    not null              comment "用户id"
    ,book_id         bigint(20)    not null              comment "书籍id"
    ,site_id         int(11)                             comment "书籍语言id"
    ,corever         int(11)                             comment "corever"
    ,is_channel_book int(11)                             comment "是否引流书籍"
    ,mt              int(11)                             comment "用户终端"
    ,etl_time        datetime                            comment "etl时间"
    ,index index_product_id (product_id) using bitmap    comment '产品id索引'
 )
primary key (dt, product_id, user_id, book_id)
comment "运营业务bi报表需求-阅读域用户粒度书籍阅读信息表"
partition by date_trunc('month',dt)
distributed by hash (dt, product_id, user_id, book_id) buckets 1
properties (
    "replication_num" = "3",
    "bloom_filter_columns" = "user_id, book_id",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "LZ4"
)
;