----------------------------------------------------------------
-- 目标表： ods.ods_tidb_short_video_admin_center_push_position_conditions
-- 来源实例： old_tidb_source
-- 来源表： short_video.admin_center_push_position_conditions
-- 来源负责： 
-- 采集工具： SeaTunnel
-- 开发人： xjc
-- 开发日期： 2026-04-01
----------------------------------------------------------------

drop table if exists ods.ods_tidb_short_video_admin_center_push_position_conditions;
create table ods.ods_tidb_short_video_admin_center_push_position_conditions (
     id                  bigint      not null                     comment '主键id'
    ,push_position_id    bigint      not null                     comment 'push资源位Id'
    ,core                varchar(60)                              comment 'core，逗号隔开'
    ,mt                  varchar(150)                             comment '平台，逗号隔开'
    ,max_ver             int                                      comment '最大版本号'
    ,min_ver             int                                      comment '最小版本号'
    ,create_time         datetime    not null                     comment '创建时间'
    ,lang_ids            varchar(300)                             comment '界面语言,逗号隔开'
    ,is_remove           tinyint                                  comment '是否删除 1 是，0否'
    ,app_type            tinyint                                  comment '应用类型： 1：短剧，2：阅读'
    ,sr_createtime       datetime    default current_timestamp    comment 'starrocks数据注入时间'
    ,sr_updatetime       datetime    default current_timestamp    comment 'starrocks数据更新时间'
)
primary key(id)
comment "push资源位过滤条件表"
distributed by hash(id)
properties (
    "replication_num" = "3"
   ,"in_memory" = "false"
   ,"enable_persistent_index" = "true"
   ,"replicated_storage" = "true"
   ,"compression" = "lz4"
)
;