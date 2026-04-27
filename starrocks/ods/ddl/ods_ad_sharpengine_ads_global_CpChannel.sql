----------------------------------------------------------------
-- 目标表：ods_ad_sharpengine_ads_global_CpChannel
-- 来源实例：idc-tidb-查询
-- 来源表：sharpengine_ads_global.CpChannel
-- 来源负责人：未知
-- 开发人：050239
-- 开发日期：2026-04-21
----------------------------------------------------------------

drop table if exists ods.ods_ad_sharpengine_ads_global_CpChannel;
create table ods.ods_ad_sharpengine_ads_global_CpChannel (
     Id            bigint       not null    comment ""
    ,SyncId        int          default "0" comment ""
    ,ChlId         varchar(150)             comment ""
    ,Name          varchar(150)             comment ""
    ,ProductId     int                      comment ""
    ,CreateTime    datetime                 comment ""
    ,ChannelTypeId int          default "0" comment ""
    ,Status        int          default "0" comment ""
    ,OsType        int                      comment ""
    ,Core          int                      comment ""
    ,sr_createtime datetime                 comment ""
    ,sr_updatetime datetime                 comment ""
)
primary key(id)
distributed by hash(id) buckets 1
properties (
    "replication_num" = "3",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "LZ4"
)
;
