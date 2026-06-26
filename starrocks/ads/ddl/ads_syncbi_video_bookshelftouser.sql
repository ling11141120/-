drop table if exists ads.ads_syncbi_video_bookshelftouser;
create table ads.ads_syncbi_video_bookshelftouser (
     Productid            int          not null    comment "产品id"
    ,ID                   bigint       not null    comment "自增id"
    ,UserId               bigint       not null    comment "用户id，海阅用户id映射后的海剧用户id"
    ,BookId               bigint       not null    comment "书籍id"
    ,ChapterId            bigint       not null    comment "章节id"
    ,CreateTime           datetime                 comment "创建时间"
    ,CollectTime          datetime                 comment "加入书架时间"
    ,UpdateTime           datetime                 comment "更新时间"
    ,ChapterNum           int          not null default "0" comment "章节数"
    ,BookType             int          not null default "0" comment "书籍类型"
    ,LastPushChapterNum   int                       comment "上次推送的书籍量"
    ,BookName             varchar(255)              comment "添加时书的名称"
    ,ReadType             int          not null     comment "书架书籍阅读类型"
    ,ChapterIndex         bigint                    comment "章节索引"
    ,ReadLargestChapter   int                       comment "已阅读最高章节索引"
    ,LastReadTime         datetime                  comment "最后一次阅读时间"
    ,LastReadChapterName  varchar(500)              comment "最后一次阅读章节名称"
    ,etl_tm               datetime     default current_timestamp comment "清洗时间"
    ,index index_bookid (BookId) using bitmap       comment "书籍id索引"
)
primary key(Productid, ID, UserId)
comment "海阅PWA用户书架同步表"
distributed by hash(Productid, ID, UserId) buckets 3
properties (
    "replication_num" = "3",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "LZ4"
)
;
