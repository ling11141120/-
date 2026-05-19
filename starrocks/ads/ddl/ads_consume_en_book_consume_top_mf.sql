drop table if exists ads.ads_consume_en_book_consume_top_mf;
create table ads.ads_consume_en_book_consume_top_mf (
     dt                  date        not null                     comment "分区日期"
    ,product_id          int         not null                     comment "产品id"
    ,book_id             bigint      not null                     comment "书籍id"
    ,site_id             int         not null                     comment "site_id"
    ,book_name           varchar(900)                             comment "书名"
    ,book_code           varchar(50)                              comment "代号"
    ,tags                varchar(65533)                           comment "标签"
    ,story_type          int                                      comment "类型  0长篇小说 1短篇小说"
    ,channel             int                                      comment "频道 1女频 2男频"
    ,revenue             decimal(20,4)                            comment "阅币收入"
    ,introduction        varchar(65533)                           comment "简介"
    ,category_name       varchar(100)                             comment "分类名称"
    ,source_book_id      bigint                                   comment "源书籍id"
    ,source_book_name    varchar(900)                             comment "源书名"
    ,source_book_code    varchar(50)                              comment "源代号"
    ,`rank`              bigint                                   comment "收入排名"
    ,etl_tm              datetime    default current_timestamp    comment "etl清洗时间"
    ,sexy                int                                      comment "书籍上架、下架判断：字段来源novel_book; Sexy2 >= 4 为下架状态，<4 为上架，其中，Sexy涉黄等级 4软下架 5强制下架 "
)
primary key (dt, product_id, book_id, site_id)
comment "消费域-小说阅币收入标签维度月榜单"
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