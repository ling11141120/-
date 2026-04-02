----------------------------------------------------------------
-- 目标表： ods.ods_tidb_shuangwen_tidb_xx_tagbookinfo
-- 来源实例： old_tidb_source
-- 来源表： shuangwen_fr.tagbookinfo
--         shuangwen_ft.tagbookinfo
--         shuangwen_pt.tagbookinfo
--         shuangwen_sp.tagbookinfo
--         shuangwen_en.tagbookinfo
-- 来源负责：
-- 采集工具： SeaTunnel
-- 开发人：xjc
-- 开发日期： 2026-03-02
----------------------------------------------------------------

drop table if exists ods.ods_tidb_shuangwen_tidb_xx_tagbookinfo;
create table ods.ods_tidb_shuangwen_tidb_xx_tagbookinfo (
    product_id        int              not null                     comment "产品id"
   ,id                bigint           not null                     comment "id"
   ,bookid            bigint           not null                     comment "书籍id"
   ,tagid             bigint           not null                     comment "标签id"
   ,creator           varchar(150)                                  comment "创建人"
   ,creationtime      datetime         not null                     comment "创建时间"
   ,isdelete          int                                           comment "是否删除"
   ,row_update_time   datetime                                      comment "行更新时间"
   ,sr_createtime     datetime         default current_timestamp    comment "starrocks入库时间"
   ,sr_updatetime     datetime         default current_timestamp    comment "starrocks数据更新时间"
)
primary key(product_id, id)
comment "书籍id-标签映射表"
distributed by hash(product_id, id)
properties (
    "replication_num" = "3"
   ,"in_memory" = "false"
   ,"enable_persistent_index" = "true"
   ,"replicated_storage" = "true"
   ,"compression" = "LZ4"
)
;