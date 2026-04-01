----------------------------------------------------------------
-- 目标表： ods.ods_tidb_readernovel_tidb_tag_center_content_group_info
-- 来源实例： old_tidb_source
-- 来源表： readernovel.center_content_group_info
-- 来源负责： 
-- 采集工具： SeaTunnel
-- 开发人： xjc
-- 开发日期： 2026-04-01
----------------------------------------------------------------

drop table if exists ods.ods_tidb_readernovel_tidb_tag_center_content_group_info;
create table ods.ods_tidb_readernovel_tidb_tag_center_content_group_info (
     dt               date        not null                     comment '日期,create_time'
    ,id               int         not null                     comment '主键'
    ,groupid          int         not null                     comment '组Id'
    ,titleid          int         not null                     comment '标题Id'
    ,contentid        int         not null                     comment '内容Id'
    ,sort             int         not null                     comment '序号'
    ,createtime       datetime    not null                     comment '创建时间'
    ,sr_createtime    datetime    default current_timestamp    comment 'starrocks数据注入时间'
    ,sr_updatetime    datetime    default current_timestamp    comment 'starrocks数据更新时间'
)
primary key(dt,id)
comment "文案组明细 author:195666"
partition by date_trunc('year', dt)
distributed by hash(id)
properties (
    "replication_num" = "3"
   ,"in_memory" = "false"
   ,"enable_persistent_index" = "true"
   ,"replicated_storage" = "true"
   ,"compression" = "lz4"
)
;
