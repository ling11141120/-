----------------------------------------------------------------
-- 目标表： ods.ods_tidb_hallow_sections
-- 来源实例： old_tidb_source
-- 来源表： hallow.sections
-- 来源负责：
-- 采集工具： SeaTunnel
-- 开发人：xjc
-- 开发日期： 2025-12-22
----------------------------------------------------------------

drop table if exists ods.ods_tidb_hallow_sections;
create table ods.ods_tidb_hallow_sections (
    sectionid         bigint            not null                     comment "节id"
   ,bookid            int               not null                     comment "书籍id"
   ,volumeindex       int               not null                     comment "卷索引"
   ,volumename        varchar(765)      not null                     comment "卷名称"
   ,chapterindex      int               not null                     comment "章节索引"
   ,paragraphindex    int               not null                     comment "段落索引"
   ,paragraphtitle    varchar(1536)                                  comment "段落标题"
   ,sectionindex      int               not null                     comment "节索引"
   ,content           varchar(18432)    not null                     comment "内容"
   ,tags              varchar(1536)                                  comment "标签列表"
   ,remark            varchar(3072)                                  comment "注释"
   ,sectioncode       varchar(765)                                   comment "节代号"
   ,sr_createtime     datetime          default current_timestamp    comment "starrocks入库时间"
   ,sr_updatetime     datetime          default current_timestamp    comment "starrocks数据更新时间"
)
primary key(sectionid)
comment "书籍经文表"
distributed by hash(sectionid)
properties (
    "replication_num" = "3"
   ,"in_memory" = "false"
   ,"enable_persistent_index" = "true"
   ,"replicated_storage" = "true"
   ,"compression" = "LZ4"
)
;