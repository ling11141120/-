drop table if exists ads.ads_sr_beidou_books_retention_stat_di;
create table ads.ads_sr_beidou_books_retention_stat_di
(
    dt                 date         not null comment "分区日期"
    ,core              int          not null comment "Core"
    ,book_id           bigint       not null comment "书籍ID"
    ,retention_day     tinyint      not null comment "留存天数"
    ,book_code         varchar(50)           comment "书籍代号"
    ,book_name         varchar(255)          comment "书籍名称"
    ,language_cd       int                   comment "渠道语言编码"
    ,language_name     varchar(50)           comment "渠道语言名称"
    ,content_type_cd   tinyint               comment "内容类型编码"
    ,content_type_name varchar(50)           comment "内容类型名称"
    ,series_name       varchar(50)           comment "书籍代号系列"
    ,build_time        datetime              comment "书籍上架时间"
    ,first_read_uv     bitmap                comment "首次阅读UV"
    ,retention_read_uv bitmap                comment "留存阅读UV"
    ,etl_time          datetime              comment "数据清洗时间"
)
engine = OLAP
primary key(dt, core, book_id, retention_day)
comment "海阅阅读-1到7天留存统计表"
partition by date_trunc("day", dt)
distributed by hash(dt, core, book_id, retention_day) buckets 2
properties (
    "replication_num" = "3",
    "enable_persistent_index" = "true",
    "in_memory" = "false",
    "replicated_storage" = "true",
    "compression" = "LZ4"
)
;
