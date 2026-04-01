----------------------------------------------------------------
-- 目标表： ods.ods_tidb_readernovel_tidb_tag_center_content_group
-- 来源实例： old_tidb_source
-- 来源表： readernovel.center_content_group
-- 来源负责： 
-- 采集工具： SeaTunnel
-- 开发人： xjc
-- 开发日期： 2026-04-01
----------------------------------------------------------------

drop table if exists ods.ods_tidb_readernovel_tidb_tag_center_content_group;
create table ods.ods_tidb_readernovel_tidb_tag_center_content_group (
     id               int             not null                     comment '主键'
    ,name             varchar(765)    not null                     comment '名称'
    ,createtime       datetime        not null                     comment '创建时间'
    ,updatetime       datetime        not null                     comment '更新时间'
    ,sr_createtime    datetime        default current_timestamp    comment 'starrocks数据注入时间'
    ,sr_updatetime    datetime        default current_timestamp    comment 'starrocks数据更新时间'
)
primary key(id)
comment "文案组 author:195666"
distributed by hash(id)
properties (
    "replication_num" = "3"
   ,"in_memory" = "false"
   ,"enable_persistent_index" = "true"
   ,"replicated_storage" = "true"
   ,"compression" = "lz4"
)
;