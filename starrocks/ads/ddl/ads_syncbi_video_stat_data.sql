drop table if exists ads.syncbi_video_stat_data;
create table ads.syncbi_video_stat_data (
     productid       int             not null    comment "产品id"
    ,AutoId          int             not null    comment "自增id"
    ,BookId          bigint          not null    comment "书籍id"
    ,StatField       varchar(150)    not null    comment "统计字段"
    ,RankClass       varchar(150)    not null    comment "排名类型"
    ,Code            int             not null    comment "统计维度编码"
    ,Value           bigint          not null    comment "统计值"
    ,realnum         bigint                      comment "真实统计值"
    ,etl_tm          datetime        default current_timestamp comment "清洗时间"
)
primary key (productid, AutoId)
comment "海阅书籍阅读统计同步表"
distributed by hash(productid, AutoId) buckets 3
properties (
    "replication_num" = "3",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "LZ4"
)
;
