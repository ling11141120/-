----------------------------------------------------------------
-- 目标表： ods.ods_tidb_short_video_admin_center_action_content
-- 来源实例： old_tidb_source
-- 来源表： center_action_content
-- 来源负责： 
-- 采集工具： SeaTunnel
-- 开发人：xjc
-- 开发日期： 2026-04-09
----------------------------------------------------------------

drop table if exists ods.ods_tidb_short_video_admin_center_action_content;
create table ods.ods_tidb_short_video_admin_center_action_content (
    id                int            not null                     comment "主键"
   ,resourceid        varchar(384)                                comment "资源id(翻译keyId)"
   ,isbindkey         tinyint        not null                     comment "是否关联翻译key 1是0否"
   ,name              varchar(300)   not null                     comment "名称"
   ,actiontype        int            not null                     comment "应用场景:1-活动规则；2-模块标题；3-弹窗标题；4-榜单标题；5-频道标题；6-规则文案；7-任务主标题；8-任务副标题；9-任务按钮；10-TAB名称；11-角标文案；12-push标题；13-push内容；14-折扣限时榜单标题；15-广告限免榜单标题"
   ,createtime        datetime       not null                     comment "创建时间"
   ,updatetime        datetime                                    comment "更新时间"
   ,apptype           int                                         comment "应用类型： 1：短剧，2：阅读"
   ,sr_createtime     datetime       default current_timestamp    comment "starrocks数据注入时间"
   ,sr_updatetime     datetime       default current_timestamp    comment "starrocks数据更新时间"
)
primary key(id)
comment "文案库资源场景表"
distributed by hash(id)
properties (
    "replication_num" = "3"
   ,"in_memory" = "false"
   ,"enable_persistent_index" = "true"
   ,"replicated_storage" = "true"
   ,"compression" = "LZ4"
)
;