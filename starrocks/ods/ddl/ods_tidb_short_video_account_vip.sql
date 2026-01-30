----------------------------------------------------------------
-- 目标表： ods.ods_tidb_short_video_account_vip
-- 来源实例： old_tidb_source
-- 来源表： short_video.account_vip
-- 来源负责：
-- 采集工具： 极光-定时链路
-- 开发人： qhr
-- 开发日期：2026-01-26
----------------------------------------------------------------

drop table if exists ods.ods_tidb_short_video_account_vip;
create table ods.ods_tidb_short_video_account_vip (
     account_id    bigint   not null                  comment '用户ID'
    ,vip_type      int      not null                  comment 'VIP类型（1-svip，其他类型可扩展）'
    ,is_vip        tinyint                            comment '是否为VIP（0-否，1-是）'
    ,vip_level     int                                comment 'VIP等级，预留字段，默认1级别'
    ,expire_time   bigint                             comment 'VIP过期时间（时间戳，单位：毫秒/秒；0表示未生效）'
    ,create_time   datetime                           comment '创建时间（数据库时间）'
    ,update_time   datetime                           comment '更新时间（数据库时间）'
    ,sr_createtime datetime default current_timestamp comment 'starrocks数据注入时间'
    ,sr_updatetime datetime default current_timestamp comment 'starrocks数据更新时间'
)
primary key(account_id, vip_type)
comment "用户VIP信息表（普通vip不是存储在这边）"
distributed by hash(account_id)
properties (
    "replication_num" = "3",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "LZ4"
)
;