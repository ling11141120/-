drop table if exists ads.ads_consume_book_consume_top30_df;
create table ads.ads_consume_book_consume_top30_df (
     dt                 date        not null                     comment "统计日期"
    ,product_id         int         not null                     comment "产品id"
    ,book_id            bigint      not null                     comment "书籍id"
    ,language_id        int         not null                     comment "语言id"
    ,story_type_id      int         not null                     comment "书籍类型id"
    ,language_name      varchar(50)                              comment "语言名称"
    ,story_type_name    varchar(50)                              comment "书籍类型名称"
    ,consume_14d        bigint                                   comment "近14日阅币+礼券+赠送币+VIP消费消耗"
    ,desc_rank          int                                      comment "倒序排名"
    ,etl_time           datetime    default current_timestamp    comment "etl清洗时间"
)
primary key(dt, product_id, book_id, language_id, story_type_id)
comment "消费域-近14天长篇/短篇书籍合计消费金额（礼券/VIP/SVIP/阅币等）TOP30"
partition by date_trunc('year',dt)
distributed by hash(dt, product_id, book_id, language_id, story_type_id)
properties (
     "replication_num" = "3"
    ,"enable_persistent_index" = "true"
    ,"replicated_storage" = "true"
    ,"compression" = "LZ4"
)
;