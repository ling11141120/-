drop table if exists ads.ads_content_book_comment_info;
create table ads.ads_content_book_comment_info (
     dt              date        not null                     comment "分区日期"
    ,product_id      int         not null                     comment "产品id"
    ,id              bigint      not null                     comment "评论id"
    ,comment_type    int         not null                     comment "评论类型,1:书籍评论,2:段落评论,3:章节评论"
    ,book_id         bigint                                   comment "书籍id"
    ,book_name       varchar(765)                             comment "书籍名称"
    ,book_code       varchar(50)                              comment "书籍代号"
    ,book_series     varchar(50)                              comment "书籍系列"
    ,site_id         int                                      comment "site_id"
    ,language_id     int                                      comment "书籍语言id"
    ,story_type      int                                      comment "类型0长篇小说 1短篇小说"
    ,content         string                                   comment "评论内容"
    ,chapterid       bigint                                   comment "评论对应的章节id"
    ,paraindex       int                                      comment "段落索引"
    ,classify        int                                      comment "评论属性 1:正常评论 2:垃圾评论,5:待审核评论"
    ,spamsource      int                                      comment "被标记的垃圾源"
    ,sendtime        datetime                                 comment "评论发送时间"
    ,etl_tm          datetime    default current_timestamp    comment "etl清洗时间"
)
primary key(dt, product_id, id, comment_type)
comment "内容域-书籍评论信息"
partition by date_trunc("month", dt)
distributed by hash(dt, product_id, id)
properties (
    "replication_num" = "3",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "LZ4"
)
;