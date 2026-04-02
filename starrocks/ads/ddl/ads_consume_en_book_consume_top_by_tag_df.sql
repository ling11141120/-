drop table if exists ads.ads_consume_en_book_consume_top_by_tag_df;
create table ads.ads_consume_en_book_consume_top_by_tag_df (
     dt                  date        not null                     comment "分区日期"
    ,book_id             bigint      not null                     comment "书籍id"
    ,book_name           varchar(900)                             comment "书名"
    ,book_code           varchar(50)                              comment "代号"
    ,tags                varchar(65533)                           comment "标签"
    ,story_type          int                                      comment "类型  0长篇小说 1短篇小说"
    ,show_date           date           not null                  comment "展示时间,dt+1"
    ,site_id             int                                      comment "site_id"
    ,channel             int                                      comment "频道 1女频 2男频"
    ,revenue             decimal(20,4)                            comment "阅币收入"
    ,introduction        varchar(65533)                           comment "简介"
    ,etl_tm              datetime    default current_timestamp    comment "etl清洗时间"
    ,category_name       varchar(100)                             comment "分类名称"
    ,source_book_id      bigint                                   comment "源书籍id"
    ,source_book_name    varchar(900)                             comment "源书名"
    ,source_book_code    varchar(50)                              comment "源代号"
)
primary key (dt, book_id)
comment "消费域-英语产品线3366小说阅币收入标签维度榜单"
partition by date_trunc("month", dt)
distributed by hash(dt, book_id)
properties (
    "replication_num" = "3"
   ,"in_memory" = "false"
   ,"enable_persistent_index" = "true"
   ,"replicated_storage" = "true"
   ,"compression" = "lz4"
)
;