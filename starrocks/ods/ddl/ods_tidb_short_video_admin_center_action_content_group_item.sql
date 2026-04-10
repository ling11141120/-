----------------------------------------------------------------
-- 目标表： ods.ods_tidb_short_video_admin_center_action_content_group_item
-- 来源实例： old_tidb_source
-- 来源表： center_action_content_group_item
-- 来源负责： 
-- 采集工具： SeaTunnel
-- 开发人：xjc
-- 开发日期： 2026-04-09
----------------------------------------------------------------

drop table if exists ods.ods_tidb_short_video_admin_center_action_content_group_item;
create table ods.ods_tidb_short_video_admin_center_action_content_group_item (
    id                bigint         not null                     comment "id"
   ,create_time       datetime       not null                     comment "创建时间"
   ,update_time       datetime                                    comment "更新时间"
   ,is_delete         tinyint                                     comment "删除状态,1是0否"
   ,title_id          bigint         not null                     comment "标题id"
   ,content_id        bigint         not null                     comment "内容id"
   ,group_id          bigint         not null                     comment "组id"
   ,group_name        varchar(600)   not null                     comment "组名"
   ,sr_createtime     datetime       default current_timestamp    comment "starrocks数据注入时间"
   ,sr_updatetime     datetime       default current_timestamp    comment "starrocks数据更新时间"
)
primary key(id)
comment "文案组"
distributed by hash(id)
properties (
    "replication_num" = "3"
   ,"in_memory" = "false"
   ,"enable_persistent_index" = "true"
   ,"replicated_storage" = "true"
   ,"compression" = "LZ4"
)
;