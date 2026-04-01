----------------------------------------------------------------
-- 目标表： ods.ods_mysql_zhangzhong_xzz_tagbookinfo
-- 来源实例： mysql_source
-- 来源表： zhangzhong_xzz.tagbookinfo
-- 来源负责：
-- 采集工具： SeaTunnel
-- 开发人：xjc
-- 开发日期： 2026-03-02
----------------------------------------------------------------

drop table if exists ods.ods_mysql_zhangzhong_xzz_tagbookinfo;
create table ods.ods_mysql_zhangzhong_xzz_tagbookinfo (
    id               bigint      not null                     comment "id"
   ,bookid           bigint                                   comment "书籍id"
   ,tagid            bigint                                   comment "标签id"
   ,creator          varchar(150)                             comment "创建人"
   ,creationtime     datetime                                 comment "创建时间"
   ,isdelete         int                                      comment "是否删除"
   ,rowversion       datetime                                 comment "行版本"
   ,sr_createtime    datetime    default current_timestamp    comment "starrocks入库时间"
   ,sr_updatetime    datetime    default current_timestamp    comment "starrocks数据更新时间"
)
primary key(id)
comment "书籍id-标签映射表"
distributed by hash(id)
properties (
    "replication_num" = "3"
   ,"in_memory" = "false"
   ,"enable_persistent_index" = "true"
   ,"replicated_storage" = "true"
   ,"compression" = "LZ4"
)
;