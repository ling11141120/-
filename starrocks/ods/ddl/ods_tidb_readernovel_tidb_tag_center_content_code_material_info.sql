----------------------------------------------------------------
-- 目标表： ods.ods_tidb_readernovel_tidb_tag_center_content_code_material_info
-- 来源实例： old_tidb_source
-- 来源表： readernovel.center_content_code_material_info
-- 来源负责： 
-- 采集工具： SeaTunnel
-- 开发人： lwb
-- 开发日期： 2026-04-15
----------------------------------------------------------------
drop table if exists ods.ods_tidb_readernovel_tidb_tag_center_content_code_material_info;
CREATE TABLE ods.ods_tidb_readernovel_tidb_tag_center_content_code_material_info (
     dt               date        not null                     comment '日期，create_time'
    ,id               bigint      not null                     comment '主键'
    ,contenttype      int         not null                     comment '内容类型（0标题，1内容）'
    ,content          string                                   comment '内容'
    ,materialid       int         not null                     comment '内容素材Id'
    ,translateid      int         not null                     comment '翻译Id'
    ,langid           int         not null                     comment '语言'
    ,createtime       datetime    not null                     comment '创建时间'
    ,updatetime       datetime    not null                     comment '更新时间'
    ,sr_createtime    datetime    default current_timestamp    comment 'starrocks数据注入时间'
    ,sr_updatetime    datetime    default current_timestamp    comment 'starrocks数据更新时间'
)
PRIMARY KEY(dt, id)
COMMENT "内容代号素材明细"
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