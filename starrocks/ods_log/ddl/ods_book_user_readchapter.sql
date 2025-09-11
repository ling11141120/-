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

DROP TABLE IF EXISTS ods_log.ods_book_user_readchapter;
CREATE TABLE ods_log.ods_book_user_readchapter (
     dt             DATE          NOT NULL                  COMMENT "createtime 分区"
    ,Productid      INT(11)       NOT NULL                  COMMENT "产品id"
    ,Id             BIGINT(20)    NOT NULL                  COMMENT "自增id"
    ,BookId         BIGINT(20)                              COMMENT "书籍id"
    ,ChapterId      BIGINT(20)                              COMMENT "章节id"
    ,UserId         BIGINT(20)                              COMMENT "用户id"
    ,ProdId         VARCHAR(512)                            COMMENT "x值"
    ,CreateTime     DATETIME                                COMMENT "阅读时间"
    ,AppId          INT(11)                                 COMMENT "应用程序id"
    ,Time           BIGINT(20)    DEFAULT "0"               COMMENT "阅读时长(s)"
    ,sr_createtime  DATETIME      DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间"
    ,sr_updatetime  DATETIME      DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间"
    ,INDEX index_productid (productid) USING BITMAP         COMMENT '产品id索引'
)
PRIMARY KEY(dt, Productid, Id)
COMMENT "用户章节阅读表"
PARTITION BY RANGE(dt)
DISTRIBUTED BY HASH(Productid, Id) BUCKETS 3
PROPERTIES (
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


select sum(a) from ( 
 select count(1) a from readerlog_fr.log_chapterreaderlog where CreateTime >=DATE_SUB(current_date(), INTERVAL 1 day) and CreateTime < current_date() union all
 select count(1)   from readerlog_pt.log_chapterreaderlog where CreateTime >=DATE_SUB(current_date(), INTERVAL 1 day) and CreateTime < current_date() union all
 select count(1)   from readerlog_ft.log_chapterreaderlog where CreateTime >=DATE_SUB(current_date(), INTERVAL 1 day) and CreateTime < current_date() union all
 select count(1)   from readerlog_en.log_chapterreaderlog where CreateTime >=DATE_SUB(current_date(), INTERVAL 1 day) and CreateTime < current_date() union all
 select count(1)   from readerlog_ru.log_chapterreaderlog where CreateTime >=DATE_SUB(current_date(), INTERVAL 1 day) and CreateTime < current_date() union all
 select count(1)   from readerlog_sp.log_chapterreaderlog where CreateTime >=DATE_SUB(current_date(), INTERVAL 1 day) and CreateTime < current_date() union all
 select count(1)   from readerlog_jp.log_chapterreaderlog where CreateTime >=DATE_SUB(current_date(), INTERVAL 1 day) and CreateTime < current_date() union all
 select count(1)   from readerlog_id.log_chapterreaderlog where CreateTime >=DATE_SUB(current_date(), INTERVAL 1 day) and CreateTime < current_date() union all
 select count(1)   from readerlog_th.log_chapterreaderlog where CreateTime >=DATE_SUB(current_date(), INTERVAL 1 day) and CreateTime < current_date() union all
 select count(1)   from readerlog_and2_sync.log_chapterreaderlog where CreateTime >=DATE_SUB(current_date(), INTERVAL 1 day) and CreateTime < current_date() union all
 select count(1)   from readerlog_cd2_sync.log_chapterreaderlog where CreateTime >=DATE_SUB(current_date(), INTERVAL 1 day) and CreateTime < current_date() union all
 select count(1)   from readerlog_and.log_chapterreaderlog where CreateTime >=DATE_SUB(current_date(), INTERVAL 1 day) and CreateTime < current_date() union all
 select count(1)   from readerlog_cd.log_chapterreaderlog where CreateTime >=DATE_SUB(current_date(), INTERVAL 1 day) and CreateTime < current_date() )a
