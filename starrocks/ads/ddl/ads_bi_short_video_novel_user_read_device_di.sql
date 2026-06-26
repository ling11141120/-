----------------------------------------------------------------
-- 程序功能：海阅 PWA 用户书架、阅读进度及阅读时长同步至海剧
-- 目标表：ads.ads_bi_short_video_novel_user_read_device_di
-- 数据粒度：日期 + 海阅产品 + 海剧用户 + 设备 + 海阅用户 + 海阅书籍
-- 开发日期：2026-06-18
----------------------------------------------------------------

drop table if exists ads.ads_bi_short_video_novel_user_read_device_di;
create table ads.ads_bi_short_video_novel_user_read_device_di (
     dt                         date          not null comment "日期"
    ,product_id                 int           not null comment "海阅产品id"
    ,video_user_id              bigint        not null comment "海剧用户id"
    ,unique_cd_reader_id        varchar(765)  not null comment "海阅PWA与海剧关联设备id"
    ,read_user_id               bigint        not null comment "海阅用户id"
    ,reader_book_id             bigint        not null comment "海阅书籍id"
    ,pwa_app_id                 int                    comment "海阅PWA app id"
    ,user_device_mapping_time   datetime               comment "用户设备最近关联时间"
    ,bookshelf_collect_time     datetime               comment "加入书架时间"
    ,last_read_chapter_id       bigint                 comment "最新阅读章节id"
    ,last_read_chapter_index    bigint                 comment "最新阅读章节索引"
    ,last_read_chapter_name     varchar(500)           comment "最新阅读章节名称"
    ,last_read_time             datetime               comment "最新阅读时间"
    ,total_read_time            bigint                 comment "海阅用户累计阅读时长，单位秒；同一用户多本书会重复展示"
    ,etl_time                   datetime      not null comment "ETL时间"
)
primary key(
     dt
    ,product_id
    ,video_user_id
    ,unique_cd_reader_id
    ,read_user_id
    ,reader_book_id
)
comment "海阅PWA用户与海剧用户设备关联的书架阅读同步表"
partition by date_trunc('day', dt)
distributed by hash(video_user_id, unique_cd_reader_id) buckets 3
properties (
    "replication_num" = "3"
   ,"in_memory" = "false"
   ,"enable_persistent_index" = "true"
   ,"replicated_storage" = "true"
   ,"compression" = "LZ4"
);
