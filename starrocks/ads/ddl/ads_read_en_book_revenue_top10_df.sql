drop table if exists ads.ads_read_en_book_revenue_top10_df;
create table ads.ads_read_en_book_revenue_top10_df (
     dt                       date        not null                     comment "日期"
    ,book_id                  bigint      not null                     comment "书籍id"
    ,book_name                varchar(900)                             comment "书名"
    ,book_code                varchar(50)                              comment "代号"
    ,site_id                  int                                      comment "site_id"
    ,rank                     int                                      comment "排名"
    ,revenue                  decimal(20,4)                            comment "收入"
    ,source_book_id           bigint                                   comment "来源书籍id"
    ,is_translated_from_zh    int                                      comment "是否中文翻译来的"
    ,tags                     varchar(900)                             comment "标签"
    ,introduction             varchar(65533)                           comment "简介"
    ,etl_tm                   datetime    default current_timestamp    comment "etl清洗时间"
)
primary key (dt, book_id)
comment "英文小说收入TOP10书籍信息"
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
