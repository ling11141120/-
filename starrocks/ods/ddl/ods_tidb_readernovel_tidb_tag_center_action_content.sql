----------------------------------------------------------------
-- 目标表： ods.ods_tidb_readernovel_tidb_tag_center_action_content
-- 来源实例： old_tidb_source
-- 来源表： readernovel.center_action_content
-- 来源负责： 
-- 采集工具： SeaTunnel
-- 开发人： xjc
-- 开发日期： 2026-04-01
----------------------------------------------------------------

drop table if exists ods.ods_tidb_readernovel_tidb_tag_center_action_content;
create table ods.ods_tidb_readernovel_tidb_tag_center_action_content (
     id               int         not null                     comment '主键id'
    ,langid           int         not null                     comment '语言id'
    ,name             varchar(6000)                            comment '内容库名称'
    ,content          varchar(30000)                           comment '素材内容'
    ,actiontype       int         not null                     comment '活动类型'
    ,createtime       datetime    not null                     comment '创建时间'
    ,updatetime       datetime                                 comment '更新时间'
    ,tag              varchar(1500)                            comment '标签'
    ,resourcekey      varchar(765)                             comment '资源库Key'
    ,sr_createtime    datetime    default current_timestamp    comment 'starrocks数据注入时间'
    ,sr_updatetime    datetime    default current_timestamp    comment 'starrocks数据更新时间'
)
primary key(id)
comment "内容库"
distributed by hash(id)
properties (
    "replication_num" = "3"
   ,"in_memory" = "false"
   ,"enable_persistent_index" = "true"
   ,"replicated_storage" = "true"
   ,"compression" = "lz4"
)
;
