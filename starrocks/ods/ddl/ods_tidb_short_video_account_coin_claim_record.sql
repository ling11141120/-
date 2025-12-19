----------------------------------------------------------------
-- 目标表： ods.ods_tidb_short_video_account_coin_claim_record
-- 来源实例： kafka=>starrocks:fzidc.normal_group_14
-- 来源表： short_video.account_coin_claim_record
-- 来源负责：
-- 采集工具： SeaTunnel
-- 开发人： roger
-- 开发日期：2025-12-15
----------------------------------------------------------------
drop table if exists ods.ods_tidb_short_video_account_coin_claim_record;
create table ods.ods_tidb_short_video_account_coin_claim_record
(
    dt            date           not null                  comment '日期',
    id            bigint(20)     not null                  comment 'id',
    account_id    bigint(20)     not null                  comment '用户id',
    series_id     bigint(20)     default null              comment '剧id',
    epis_id       bigint(20)     default null              comment '集id',
    type          int(11)        not null                  comment '0集金币领取|1 剧金币领取|2首次弹窗金币领取|3 新人福利弹窗',
    created_time  datetime       default null              comment '创建时间',
    coin          decimal(10, 4) not null                  comment '金币值',
    is_invalid    tinyint(4)     not null default '0'      comment '0-有效；1-失效',
    sr_createtime datetime       default current_timestamp comment 'starrocks数据注入时间',
    sr_updatetime datetime       default current_timestamp comment 'starrocks数据更新时间'
)
primary key(dt, Id)
comment "金币网赚-金币领取记录表"
partition by date_trunc('day', dt)
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