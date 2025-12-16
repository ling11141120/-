----------------------------------------------------------------
-- 目标表： ods.ods_tidb_mobkingaddata
-- 来源实例： old_tidb_source
-- 来源表：readernovel_tidb_ft.surgeaddata
-- 来源负责：
-- 采集工具： 极光-定时批量
-- 开发人： qhr
-- 开发日期： 2025-12-15
----------------------------------------------------------------

drop table if exists ods.ods_tidb_SurgeAdData;
create table ods.ods_tidb_SurgeAdData (
     Id            bigint         not null                  comment ""
    ,Date          date                                     comment "日期"
    ,Sessions      bigint                                   comment "展示次数"
    ,Clicks        bigint                                   comment "点击数"
    ,RevenueNet    decimal(10, 2)                           comment "分成后收益"
    ,Ctr           decimal(10, 2)                           comment "点击率"
    ,Cpm           decimal(10, 2)                           comment "广告千次展现单价"
    ,Cpc           decimal(10, 2)                           comment "广告千次点击单价"
    ,UrlNo         varchar(255)                             comment "链接ID"
    ,UrlName       varchar(255)                             comment "链接命名"
    ,PartnerNo     varchar(255)                             comment "合作方ID"
    ,PartnerName   varchar(255)                             comment "合作方名称"
    ,sr_createtime datetime       default current_timestamp comment "starrocks数据注入时间"
    ,sr_updatetime datetime       default current_timestamp comment "starrocks数据更新时间"
)
primary key(Id)
comment "澎湃广告数据"
distributed by hash(Id) buckets 1
properties (
    "replication_num" = "3",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "LZ4"
)
;