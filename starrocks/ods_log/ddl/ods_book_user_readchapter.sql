----------------------------------------------------------------
-- 目标表： ods_log.ods_book_user_readchapter
-- 来源实例： old_tidb_source
-- 来源表：
--        readerlog_fr.log_chapterreaderlog
--        readerlog_pt.log_chapterreaderlog
--        readerlog_ft.log_chapterreaderlog
--        readerlog_en.log_chapterreaderlog
--        readerlog_ru.log_chapterreaderlog
--        readerlog_sp.log_chapterreaderlog
--        readerlog_jp.log_chapterreaderlog
--        readerlog_id.log_chapterreaderlog
--        readerlog_th.log_chapterreaderlog
--        readerlog_and2_sync.log_chapterreaderlog
--        readerlog_cd2_sync.log_chapterreaderlog
--        readerlog_and.log_chapterreaderlog
--        readerlog_cd.log_chapterreaderlog
-- 来源负责： 
-- 采集工具： SeaTunnel
-- 开发人： qhr
-- 开发日期： 2025-07-02
----------------------------------------------------------------

drop table if exists ods_log.ods_book_user_readchapter;
create table ods_log.ods_book_user_readchapter (
     dt             date          not null                  comment "createtime 分区"
    ,Productid      int(11)       not null                  comment "产品id"
    ,Id             bigint(20)    not null                  comment "自增id"
    ,BookId         bigint(20)                              comment "书籍id"
    ,ChapterId      bigint(20)                              comment "章节id"
    ,UserId         bigint(20)                              comment "用户id"
    ,ProdId         varchar(512)                            comment "x值"
    ,CreateTime     datetime                                comment "阅读时间"
    ,AppId          int(11)                                 comment "应用程序id"
    ,Time           bigint(20)    default "0"               comment "阅读时长(s)"
    ,sr_createtime  datetime      default current_timestamp comment "starrocks数据注入时间"
    ,sr_updatetime  datetime      default current_timestamp comment "starrocks数据更新时间"
    ,INDEX index_productid (Productid) using bitmap         comment '产品id索引'
)
primary key(dt, Productid, Id)
comment "用户章节阅读表"
partition by range(dt)
distributed by hash(Productid, Id) buckets 3
properties (
    "replication_num" = "3",
    "bloom_filter_columns" = "UserId, CreateTime",
    "dynamic_partition.enable" = "true",
    "dynamic_partition.time_unit" = "DAY",
    "dynamic_partition.time_zone" = "Asia/Shanghai",
    "dynamic_partition.start" = "-2147483648",
    "dynamic_partition.end" = "3",
    "dynamic_partition.prefix" = "p",
    "dynamic_partition.buckets" = "7",
    "dynamic_partition.history_partition_num" = "0",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "LZ4"
)
;