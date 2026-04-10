----------------------------------------------------------------
-- 目标表： ods.ods_tidb_short_video_account_extra
-- 来源实例： kafka=>starrocks:fzidc.normal_group_14
-- 来源表： short_video.account_extra
-- 来源负责：
-- 采集工具： SeaTunnel
-- 开发人： roger/xjc
-- 开发日期：2025-12-15
----------------------------------------------------------------
drop table if exists ods.ods_tidb_short_video_account_extra;
create table ods.ods_tidb_short_video_account_extra (
     dt                date        not null                   comment '日期'
    ,Id                bigint(20)  not null                   comment '主键ID'
    ,AccountId         bigint(20)  not null                   comment '账号ID'
    ,CollectEmail      string                                 comment '收集邮箱'
    ,CreateTime        datetime                               comment '创建时间'
    ,UpdateTime        datetime                               comment '修改时间'
    ,IsGolden          tinyint(4)                             comment '是否金币网赚版本用户,0-否，1-是'
    ,sr_createtime     datetime    default current_timestamp  comment 'starrocks数据注入时间'
    ,sr_updatetime     datetime    default current_timestamp  comment 'starrocks数据更新时间'
    ,IsDl              tinyint(4)  not null                   comment '是否DL用户,0-否，1-是'
    ,dlUpdateTime      datetime                               comment 'DL用户修改时间'
    ,isCoinDl          tinyint(4)  not null                   comment '是否金币DL用户,0-否，1-是'
    ,is_dl0_for_you    tinyint(4)  not null                   comment '是否C4 DL0跳转ForYou用户,0-否，1-是'
    ,currencyCode      varchar(60)                            comment '网赚用户首次货币码'
)
primary key(dt, Id)
comment "用户额外信息表"
partition by date_trunc('month', dt)
distributed by hash(Id)
properties (
    "replication_num" = "3",
    "bloom_filter_columns" = "AccountId, CreateTime",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "LZ4"
)
;