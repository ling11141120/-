----------------------------------------------------------------
-- 目标表： ods.ods_tidb_short_video_series_unlock
-- 来源实例： video-en-mysql-slave
-- 来源表： short_video.series_unlock
-- 来源负责： 
-- 采集工具： SeaTunnel
-- 开发人： qhr
-- 开发日期：2025-11-25
----------------------------------------------------------------
drop table if exists ods.ods_tidb_short_video_series_unlock;
create table ods.ods_tidb_short_video_series_unlock (
     Id             bigint(20)  not null                  comment "剧集解锁表主键id"
    ,AccountId      bigint(20)  not null                  comment "用户id"
    ,SeriesId       bigint(20)                            comment "剧id"
    ,EpisId         bigint(20)                            comment "具体集数id"
    ,CreateTime     datetime    not null                  comment "创建时间"
    ,EpisNum        int(11)                               comment "第几集"
    ,SeriesName     string                                comment "剧名称"
    ,BillId         bigint(20)                            comment "订单流水id"
    ,regionId       smallint(6) default "1"               comment "归属区域 id，1：香港，2：北美；"
    ,ExpireTime     datetime                              comment "过期时间,广告解锁的会有具体的过期时间,付费解锁的全都是9999年"
    ,PurchaseType   int(11)                               comment "购买（解锁）类型：0-普通购买；1-超前点播购买,2:打包售卖,3:跨集解锁，4：批量购买，5：免费解锁"
    ,showtype       int(11)                               comment "解锁详情展示类型：0或null——按集展示，1按剧展示"
    ,StartEpisNum   int(11)                               comment "跨集解锁开始集数，只有跨集解锁才有值"
    ,sr_updatetime  datetime                              comment "ods同步时间"
    ,sr_createtime  datetime    default current_timestamp comment "starrocks数据注入时间"
)
primary key(Id)
comment "短剧-短剧剧集解锁表"
distributed by hash(Id) buckets 70 
properties (
    "replication_num" = "3",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "LZ4"
)
;