----------------------------------------------------------------
-- 目标表：ods.ods_tidb_readernovel_tidb_tag_center_climb_new_book_pool
-- 来源实例： old_tidb_source
-- 来源表：  ReaderNovel_tidb_tag.center_climb_new_book_pool
-- 来源负责： 
-- 开发人： qhr
-- 创建日期：2026-03-23
----------------------------------------------------------------

drop table if exists ods.ods_tidb_readernovel_tidb_tag_center_climb_new_book_pool;
create table ods.ods_tidb_readernovel_tidb_tag_center_climb_new_book_pool (
     Id            int      not null comment "主键"
    ,LangId        int               comment "语言"
    ,BookId        bigint            comment "书籍Id"
    ,StartPoint    int               comment "爬榜起点（1新书榜，2榜一，3榜二）"
    ,StartTime     datetime          comment "起始时间"
    ,EndTime       datetime          comment "结束时间"
    ,CreateTime    datetime          comment "创建时间"
    ,UpdateTime    datetime          comment "更新时间"
    ,sr_createtime datetime          comment "starrocks数据注入时间"
    ,sr_updatetime datetime          comment "starrocks数据更新时间"
)
primary key (Id)
comment "海阅-新书自动爬榜-书籍配置表"
distributed by hash (Id) buckets 3
properties (
    "replication_num" = "3",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "LZ4"
)
;