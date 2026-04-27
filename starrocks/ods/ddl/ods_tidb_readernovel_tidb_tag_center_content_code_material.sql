----------------------------------------------------------------
-- 目标表： ods.ods_tidb_readernovel_tidb_tag_center_content_code_material
-- 来源实例： old_tidb_source
-- 来源表： readernovel.center_content_code_material
-- 来源负责： 
-- 采集工具： SeaTunnel
-- 开发人： lwb
-- 开发日期： 2026-04-15
----------------------------------------------------------------

drop table if exists ods.ods_tidb_readernovel_tidb_tag_center_content_code_material;
create table ods.ods_tidb_readernovel_tidb_tag_center_content_code_material (
     dt               date         not null                     comment '日期，create_time'
    ,id               bigint       not null                     comment '主键'
    ,applytype        int          not null                     comment '应用类型 1push'
    ,bookno           varchar(150) not null                     comment '代号'
    ,sort             int          not null                     comment '序号'
    ,status           int          not null                     comment '是否应用'
    ,createtime       datetime     not null                     comment '创建时间'
    ,updatetime       datetime     not null                     comment '更新时间'
    ,sr_createtime    datetime     default current_timestamp    comment 'starrocks数据注入时间'
    ,sr_updatetime    datetime     default current_timestamp    comment 'starrocks数据更新时间'
)
primary key(dt,id)
comment "内容代号素材"
partition by date_trunc('month', dt)
DISTRIBUTED BY HASH(id) BUCKETS 3
PROPERTIES (
    "replication_num" = "3"
   ,"in_memory" = "false"
   ,"enable_persistent_index" = "true"
   ,"compression" = "lz4"
   ,"partition_live_number" = "24"
)
;