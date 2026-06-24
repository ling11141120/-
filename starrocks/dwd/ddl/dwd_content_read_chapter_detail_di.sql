create table if not exists dwd.dwd_content_read_chapter_detail_di (
     dt          date         not null                  comment "阅读事件分区日期"
    ,product_id  int          not null                  comment "产品id"
    ,autoid      bigint       not null                  comment "原始日志自增id"
    ,book_id     bigint                                 comment "书籍id，空值兜底为-99"
    ,chapter_id  bigint                                 comment "章节id，空值兜底为-99"
    ,user_id     bigint                                 comment "用户id"
    ,prod_id     varchar(512)                           comment "原始x值，空值兜底为-99"
    ,create_time datetime                               comment "阅读时间"
    ,appid       int                                    comment "应用程序id，空值兜底为-99"
    ,read_times  bigint       default "0"               comment "阅读时长，单位秒"
    ,etl_time    datetime     default current_timestamp comment "etl写入时间"
)
duplicate key(dt, product_id, autoid)
comment "内容域-用户章节阅读明细事实表"
partition by date_trunc("day", dt)
distributed by hash(product_id, user_id) buckets 10
properties (
    "replication_num" = "3",
    "partition_live_number" = "46",
    "in_memory" = "false",
    "replicated_storage" = "false",
    "compression" = "LZ4"
)
;
