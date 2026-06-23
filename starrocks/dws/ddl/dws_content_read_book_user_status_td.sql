create table if not exists dws.dws_content_read_book_user_status_td (
     product_id      int          not null                  comment "产品id"
    ,user_id         bigint       not null                  comment "用户id"
    ,book_id         bigint       not null                  comment "书籍id"
    ,fst_read_tm     datetime                               comment "历史首次阅读时间"
    ,fst_chapter_id  bigint                                 comment "历史首次阅读章节id"
    ,lst_read_tm     datetime                               comment "历史最近阅读时间"
    ,lst_chapter_id  bigint                                 comment "历史最近阅读章节id"
    ,read_cnt_td     bigint       default "0"               comment "累计阅读次数"
    ,read_seconds_td bigint       default "0"               comment "累计阅读时长(秒)"
    ,idx_dt          date                                   comment "最后成功合入的阅读业务日期"
    ,etl_time        datetime     default current_timestamp comment "etl写入时间"
)
primary key(product_id, user_id, book_id)
comment "内容域-用户书籍长期阅读状态表"
distributed by hash(product_id, user_id)
properties (
    "replication_num" = "3",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "LZ4"
)
;