----------------------------------------------------------------
-- 目标表： ods.ods_tidb_shuangwen_tidb_xx_tagconfig
-- 来源实例： old_tidb_source
-- 来源表： shuangwen_fr.tagconfig
--         shuangwen_ft.tagconfig
--         shuangwen_pt.tagconfig
--         shuangwen_sp.tagconfig
--         shuangwen_en.tagconfig
-- 来源负责：
-- 采集工具： SeaTunnel
-- 开发人：xjc
-- 开发日期： 2026-03-02
----------------------------------------------------------------

drop table if exists ods.ods_tidb_shuangwen_tidb_xx_tagconfig;
create table ods.ods_tidb_shuangwen_tidb_xx_tagconfig (
    product_id        int              not null                     comment "产品id"
   ,id                bigint           not null                     comment "id"
   ,category          varchar(765)                                  comment "类别"
   ,tag               varchar(765)                                  comment "标签"
   ,siteid            int                                           comment "siteid"
   ,createdby         varchar(765)                                  comment "创建人"
   ,createdtime       datetime                                      comment "创建时间"
   ,updatedby         varchar(765)                                  comment "更新人"
   ,updatedtime       datetime                                      comment "更新时间"
   ,isdelete          int              not null                     comment "是否删除"
   ,sort              int                                           comment "排序"
   ,status            int                                           comment "状态"
   ,categoryremark    varchar(450)                                  comment "类别备注"
   ,tagremark         varchar(450)                                  comment "标签备注"
   ,row_update_time   datetime                                      comment "行更新时间"
   ,sr_createtime     datetime         default current_timestamp    comment "starrocks入库时间"
   ,sr_updatetime     datetime         default current_timestamp    comment "starrocks数据更新时间"
)
primary key(product_id, id)
comment "标签字典表"
distributed by hash(product_id, id)
properties (
    "replication_num" = "3"
   ,"in_memory" = "false"
   ,"enable_persistent_index" = "true"
   ,"replicated_storage" = "true"
   ,"compression" = "LZ4"
)
;