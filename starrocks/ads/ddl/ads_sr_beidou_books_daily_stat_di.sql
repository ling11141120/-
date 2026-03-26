drop table if exists ads.ads_sr_beidou_books_daily_stat_di;
create table ads.ads_sr_beidou_books_daily_stat_di
(
    dt                           date         not null comment "分区日期"
    ,core                        int          not null comment "Core"
    ,book_id                     bigint       not null comment "书籍ID"
    ,book_code                   varchar(50)           comment "书籍代号"
    ,book_name                   varchar(255)          comment "书籍名称"
    ,language_cd                 int                   comment "渠道语言编码"
    ,language_name               varchar(50)           comment "渠道语言名称"
    ,content_type_cd             int                   comment "内容类型编码"
    ,content_type_name           varchar(50)           comment "内容类型名称"
    ,series_name                 varchar(50)           comment "书籍代号系列"
    ,build_time                  datetime              comment "书籍上架时间"
    ,cover_url                   varchar(512)          comment "书籍封面"
    ,total_chapter_num           bigint                comment "书籍总章数"
    ,word_count                  bigint                comment "书籍总字数"
    ,free_chapter_num            int                   comment "免费章节数"
    ,book_source                 varchar(50)           comment "书籍来源"
    ,total_read_pv               bigint                comment "阅读总PV"
    ,total_read_uv               bitmap                comment "阅读总UV"
    ,cover_click_pv              bigint                comment "封面点击PV"
    ,cover_exposure_pv           bigint                comment "封面曝光PV"
    ,chapter1_read_uv            bitmap                comment "首章阅读UV"
    ,chapter1_loss_uv            bitmap                comment "首章流失UV"
    ,total_read_duration         bigint                comment "阅读总时长"
    ,total_read_chapter_num      bigint                comment "阅读总章数"
    ,before_paid_chapter_read_uv bitmap                comment "付费前章阅读UV"
    ,paid_chapter_unlock_uv      bitmap                comment "付费章解锁UV"
    ,paid_chapter_read_uv        bitmap                comment "付费书籍阅读UV"
    ,chapter30_retention_uv      bitmap                comment "30章留存UV"
    ,chapter60_retention_uv      bitmap                comment "60章留存UV"
    ,d1_retention_uv             bitmap                comment "次日留存UV"
    ,d1_retention_first_read_uv  bitmap                comment "次日留存首次阅读UV"
    ,etl_time                    datetime              comment "数据清洗时间"
)
engine = OLAP
primary key(dt, core, book_id)
comment "海阅阅读-每日信息统计表"
partition by date_trunc("day", dt)
distributed by hash(dt, core, book_id) buckets 8
properties (
    "replication_num" = "3",
    "enable_persistent_index" = "true",
    "bloom_filter_columns" = "language_cd, content_type_cd, series_name",
    "in_memory" = "false",
    "replicated_storage" = "true",
    "compression" = "LZ4"
)
;
