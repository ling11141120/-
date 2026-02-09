----------------------------------------------------------------
-- 目标表： ods.ods_tidb_short_video_admin_dl0_config
-- 来源实例： old_tidb_source
-- 来源表： short_video_admin.dl0_config
-- 来源负责：
-- 采集工具： SeaTunnel
-- 开发人：xjc
-- 开发日期：2026-02-03
----------------------------------------------------------------

drop table if exists ods.ods_tidb_short_video_admin_dl0_config;
create table ods.ods_tidb_short_video_admin_dl0_config (
    id                     bigint      not null                     comment "主键"
   ,`key`                  varchar(1500)                            comment "key"
   ,type                   int                                      comment "类型"
   ,remark                 varchar(15000)                           comment "备注"
   ,mt                     varchar(600)                             comment "平台"
   ,lang_ids               varchar(1500)                            comment "语言"
   ,core                   varchar(1500)                            comment "core版本"
   ,country_group_id       string                                   comment "国家组id"
   ,country_group_codes    string                                   comment "国家代号"
   ,channel                varchar(1500)                            comment "渠道"
   ,value                  varchar(15000)                           comment "配置值"
   ,value_type             int                                      comment "值类型 1字符串 2数字（后台输入校验用）"
   ,create_time            datetime                                 comment "创建时间"
   ,update_time            datetime                                 comment "更新时间"
   ,status                 tinyint     not null                     comment "启用状态0关1开"
   ,enable_status          tinyint     not null                     comment "配置生效状态 1已生效 2按时生效"
   ,enable_time            datetime                                 comment "配置修改生效时间"
   ,auto_change            int                                      comment "自动切换 0关1开"
   ,sr_createtime          datetime    default current_timestamp    comment "starrocks入库时间"
   ,sr_updatetime          datetime    default current_timestamp    comment "starrocks数据更新时间"
)
primary key(id)
comment "dl0剧配置"
distributed by hash(id)
properties (
    "replication_num" = "3"
   ,"in_memory" = "false"
   ,"enable_persistent_index" = "true"
   ,"replicated_storage" = "true"
   ,"compression" = "LZ4"
)
;