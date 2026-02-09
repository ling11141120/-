----------------------------------------------------------------
-- 目标表： ods.ods_tidb_hallow_books
-- 来源实例： old_tidb_source
-- 来源表： hallow.books
-- 来源负责：
-- 采集工具： SeaTunnel
-- 开发人：xjc
-- 开发日期： 2025-12-23
----------------------------------------------------------------

drop table if exists ods.ods_tidb_hallow_books;
create table ods.ods_tidb_hallow_books (
    bookid            int              not null                     comment "书籍id"
   ,bookname          varchar(765)     not null                     comment "书名"
   ,writenlanguage    int              not null                     comment "书写语言"
   ,showlanguages     varchar(765)     not null                     comment "展示语言列表，以逗号分隔"
   ,version           varchar(30)      not null                     comment "书籍版本"
   ,relatedbookids    varchar(765)     not null                     comment "关联书籍id"
   ,introduction      varchar(1536)    not null                     comment "书籍简介"
   ,status            int              not null                     comment "书籍状态"
   ,bookcode          varchar(765)                                  comment "书籍代号，同书不同语言代号相同"
   ,sr_createtime     datetime         default current_timestamp    comment "starrocks入库时间"
   ,sr_updatetime     datetime         default current_timestamp    comment "starrocks数据更新时间"
)
primary key(bookid)
comment "圣经书籍信息表"
distributed by hash(bookid)
properties (
    "replication_num" = "3",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "LZ4"
)
;
