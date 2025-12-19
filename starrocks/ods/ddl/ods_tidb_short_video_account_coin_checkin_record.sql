----------------------------------------------------------------
-- 目标表： ods.ods_tidb_short_video_account_coin_checkin_record
-- 来源实例： kafka=>starrocks:fzidc.normal_group_14
-- 来源表： short_video.account_coin_checkin_record
-- 来源负责：
-- 采集工具： SeaTunnel
-- 开发人： roger
-- 开发日期：2025-12-15
----------------------------------------------------------------
drop table if exists ods.ods_tidb_short_video_account_coin_checkin_record;
create table ods.ods_tidb_short_video_account_coin_checkin_record
(
    dt            date           not null                  comment '日期',
    id            bigint(20)     not null                  comment '主键ID',
    account_id    int(11)        not null                  comment '账号ID',
    created_ymd   int(11)        not null                  comment '西五区ymd格式',
    created_time  datetime       default null              comment '创建时间',
    sr_createtime datetime       default current_timestamp comment 'starrocks数据注入时间',
    sr_updatetime datetime       default current_timestamp comment 'starrocks数据更新时间'
)
primary key(dt, Id)
comment "金币网赚打卡记录表"
partition by date_trunc('month', dt)
distributed by hash(Id)
properties (
    "replication_num" = "3",
    "bloom_filter_columns" = "account_id",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "LZ4"
)
;