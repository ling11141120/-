----------------------------------------------------------------
-- 目标表： ods.ods_tidb_short_video_admin_ai_series_content_task
-- 来源实例： old_tidb_source
-- 来源表： short_video_admin.ai_series_content_task
-- 来源负责： 
-- 采集工具： SeaTunnel
-- 开发人： xjc
-- 开发日期： 2026-03-31
----------------------------------------------------------------

drop table if exists ods.ods_tidb_short_video_admin_ai_series_content_task;
create table ods.ods_tidb_short_video_admin_ai_series_content_task (
     dt               date        not null                     comment '日期,create_time'
    ,id               bigint      not null                     comment 'ID'
    ,series_code      varchar(600)                             comment '代号'
    ,status           tinyint                                  comment '文案生成状态：0-待生成，1-已生成'
    ,audit_status     tinyint                                  comment '审核状态：0-待审，1-已审'
    ,generate_time    datetime                                 comment '文案生成时间'
    ,remark           varchar(65533)                           comment '备注'
    ,creator          varchar(150)                             comment '创建人'
    ,creator_name     varchar(300)                             comment '创建人姓名'
    ,create_time      datetime                                 comment '创建时间'
    ,updater          varchar(150)                             comment '更新人'
    ,updater_name     varchar(300)                             comment '更新人姓名'
    ,update_time      datetime                                 comment '更新时间'
    ,sr_createtime    datetime    default current_timestamp    comment 'starrocks数据注入时间'
    ,sr_updatetime    datetime    default current_timestamp    comment 'starrocks数据更新时间'
)
primary key(dt,id)
comment "PUSH文案生成任务"
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