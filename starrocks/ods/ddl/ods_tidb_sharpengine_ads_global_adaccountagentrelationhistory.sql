----------------------------------------------------------------
-- 目标表：ods_tidb_sharpengine_ads_global_adaccountagentrelationhistory
-- 来源实例：new_tidb_source
-- 来源表：sharpengine_ads_global.AdAccountAgentRelationHistory
-- 来源负责人：102094
-- 开发人：xjc
-- 开发日期：2026-06-16
----------------------------------------------------------------

create table if not exists ods.ods_tidb_sharpengine_ads_global_adaccountagentrelationhistory (
     id            bigint       not null                           comment "主键id"
    ,accountsource int          not null                           comment "账号来源"
    ,account       varchar(384) not null                           comment "广告账号id"
    ,agentid       bigint       not null                           comment "代理商id"
    ,begindate     date         not null                           comment "生效开始日期，包含当天"
    ,begindatekey  varchar(384) not null                           comment "生效开始日期yyyy-mm-dd"
    ,enddate       date         not null                           comment "生效结束日期，包含当天"
    ,enddatekey    varchar(384) not null                           comment "生效结束日期yyyy-mm-dd"
    ,createtime    datetime     not null                           comment "创建时间"
    ,updatetime    datetime     not null                           comment "更新时间"
    ,sr_createtime datetime     default current_timestamp          comment "sr入库时间"
    ,sr_updatetime datetime     default current_timestamp          comment "sr更新时间"
)
primary key(id)
comment "广告账号代理商归属历史表 author:(102094)"
distributed by hash(id)
properties (
    "replication_num" = "3",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "lz4"
)
;
