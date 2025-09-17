drop table if exists ads.ads_bi_user_book_consume_info;
create table ads.ads_bi_user_book_consume_info (
     dt                    date         not null    comment "事件分区"
    ,product_id            int(11)                  comment "产品id"
    ,book_id               bigint(20)               comment "书籍id"
    ,book_name             varchar(512)             comment "书名"
    ,book_nature           int(11)                  comment "书籍来源"
    ,new_cname             varchar(512)             comment "书籍分类"
    ,build_time            datetime                 comment "上架时间"
    ,normal_chapter_num_f  int(11)                  comment "发布章节数"
    ,user_id               bigint(20)               comment "用户id"
    ,corever               int(11)                  comment "corever"
    ,types                 int(11)                  comment "1：阅币，2:礼券 3：赠送币 4：vip"
    ,amount                int(11)                  comment "消耗数量"
    ,con_chapter_nums      int(11)                  comment "消费章节数"
    ,is_read               int(11)                  comment "1：有阅读 0 ：非阅读"
    ,is_channel_book       int(11)                  comment "1：引流书籍 0：非引流书籍"
    ,mt                    int(11)                  comment "用户终端"
    ,etl_time              datetime     not null    comment "数据清洗时间"
)
duplicate key (dt, product_id)
comment "bi:用户消耗书籍数据"
partition by date_trunc('month',dt)
distributed by hash(dt, product_id) buckets 1
properties (
    "replication_num" = "3",
    "bloom_filter_columns" = "book_id",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "LZ4"
)
;