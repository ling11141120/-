----------------------------------------------------------------
-- 目标表： ods.ods_tidb_hallow_sectionmappings
-- 来源实例： old_tidb_source
-- 来源表： hallow.sectionmappings
-- 来源负责：
-- 采集工具： SeaTunnel
-- 开发人：xjc
-- 开发日期： 2025-12-23
----------------------------------------------------------------

drop table if exists ods.ods_tidb_hallow_sectionmappings;
create table ods.ods_tidb_hallow_sectionmappings (
    id               bigint      not null                     comment "主键id"
   ,bookid           int                                      comment "书籍id"
   ,volumeindex      int                                      comment "卷索引"
   ,chapterindex     int                                      comment "章索引"
   ,sectionindex     int                                      comment "节索引"
   ,memeid           bigint                                   comment "梗图套图id"
   ,sectionid        bigint                                   comment "节id"
   ,sr_createtime    datetime    default current_timestamp    comment "starrocks入库时间"
   ,sr_updatetime    datetime    default current_timestamp    comment "starrocks数据更新时间"
)
primary key(id)
comment "书籍卷章节索引映射表"
distributed by hash(id)
properties (
    "replication_num" = "3",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "LZ4"
)
;
