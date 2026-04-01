----------------------------------------------------------------
-- 目标表： ods.ods_tidb_short_video_admin_ai_series_content
-- 来源实例： old_tidb_source
-- 来源表： short_video_admin.ai_series_content
-- 来源负责： 
-- 采集工具： SeaTunnel
-- 开发人： xjc
-- 开发日期： 2026-03-31
----------------------------------------------------------------

drop table if exists ods.ods_tidb_short_video_admin_ai_series_content;
create table ods.ods_tidb_short_video_admin_ai_series_content (
     dt                   date        not null                     comment '日期,create_time'
    ,id                   bigint      not null                     comment 'ID'
    ,series_code          varchar(600)                             comment '代号'
    ,title                varchar(1500)                            comment '文案标题'
    ,content              varchar(6000)                            comment '文案内容'
    ,generate_time        datetime                                 comment '文案生成时间'
    ,translate_status     tinyint                                  comment '翻译状态：0-待翻译，1-已翻译'
    ,translate_time       datetime                                 comment '翻译时间'
    ,translate_task_id    varchar(600)                             comment '翻译任务ID'
    ,apply_status         tinyint                                  comment '是否应用：0-否，1-是'
    ,deleted              tinyint                                  comment '是否删除：0-否，1-是'
    ,creator              varchar(150)                             comment '创建人'
    ,creator_name         varchar(300)                             comment '创建人姓名'
    ,create_time          datetime                                 comment '创建时间'
    ,updater              varchar(150)                             comment '更新人'
    ,updater_name         varchar(300)                             comment '更新人姓名'
    ,update_time          datetime                                 comment '更新时间'
    ,mode_type            tinyint                                  comment '模型类型:1 v1, 2 v2'
    ,sr_createtime        datetime    default current_timestamp    comment 'starrocks数据注入时间'
    ,sr_updatetime        datetime    default current_timestamp    comment 'starrocks数据更新时间'
)
primary key(dt,id)
comment "PUSH文案池"
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