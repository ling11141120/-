----------------------------------------------------------------
-- 目标表： ods.ods_tidb_short_video_account_extend
-- 来源实例： old_tidb_source
-- 来源表： short_video.account_extend
-- 来源负责：
-- 开发人： qhr
-- 开发日期：2026-04-07
----------------------------------------------------------------

drop table if exists ods.ods_tidb_short_video_account_extend;
create table ods.ods_tidb_short_video_account_extend(
     AccountId          bigint   not null comment "用户id"
    ,FontSize           double            comment "字体大小"
    ,CreatePasswordTime datetime          comment "初次设置密码时的时间"
    ,ThirdLoginTime     datetime          comment "初次三方登录的时间"
    ,UpdateTime         datetime          comment "修改时间"
    ,CreateTime         datetime          comment "创建时间"
    ,sr_createtime      datetime          comment "starrocks数据注入时间"
    ,sr_updatetime      datetime          comment "starrocks数据更新时间"
)
primary key(AccountId)
comment "账号扩展信息表"
distributed by hash(AccountId)
properties (
    "replication_num" = "3",
    "bloom_filter_columns" = "ThirdLoginTime, CreatePasswordTime",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "LZ4"
)
;