create table if not exists dws.dws_content_read_book_user_agg_di (
     dt                  date         not null                  comment "阅读日期"
    ,product_id          int          not null                  comment "产品id"
    ,user_id             bigint                                 comment "用户id"
    ,book_id             bigint                                 comment "书籍id"
    ,fst_read_tm         datetime                               comment "首次阅读时间"
    ,fst_chapter_id      bigint                                 comment "首次阅读章节id"
    ,lst_read_tm         datetime                               comment "最近阅读时间"
    ,lst_chapter_id      bigint                                 comment "最近阅读章节id"
    ,read_cnt            bigint       default "0"               comment "阅读次数"
    ,read_seconds        bigint       default "0"               comment "阅读时长(秒)"
    ,etl_time            datetime     default current_timestamp comment "etl写入时间"
)
duplicate key(dt, product_id, user_id, book_id)
comment "内容域-用户书籍日阅读聚合表"
partition by date_trunc("day", dt)
properties (
    "replication_num" = "3",
    "partition_live_number" = "46",
    "in_memory" = "false",
    "replicated_storage" = "false",
    "compression" = "LZ4"
)
;