drop table if exists ads.ads_syncbi_video_book_user_readchapter;
create table ads.ads_syncbi_video_book_user_readchapter (
     dt             date          not null                  comment "createtime 分区"
    ,Productid      int           not null                  comment "产品id"
    ,Id             bigint        not null                  comment "自增id"
    ,BookId         bigint                                  comment "书籍id"
    ,ChapterId      bigint                                  comment "章节id"
    ,UserId         bigint                                  comment "用户id，海阅用户id映射后的海剧用户id"
    ,ProdId         varchar(512)                            comment "x值"
    ,CreateTime     datetime                                comment "阅读时间"
    ,AppId          int                                     comment "应用程序id"
    ,Time           bigint        default "0"               comment "阅读时长(s)"
    ,etl_tm         datetime      default current_timestamp comment "清洗时间"
    ,index index_productid (Productid) using bitmap         comment "产品id索引"
)
primary key(dt, Productid, Id)
comment "海阅PWA用户章节阅读时长同步表"
distributed by hash(Productid, Id) buckets 3
properties (
    "replication_num" = "3",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "LZ4"
)
;
