----------------------------------------------------------------
-- 目标表： ods.ods_tidb_short_video_log_ext_epis_history_part2
-- 来源实例： video-en-log-mysql-slave
-- 来源表： short_video_log.epis_history_*(每月一个表)
-- 来源负责： 
-- 采集工具： SeaTunnel
-- 开发人： qhr
-- 开发日期： 2025-11-12
----------------------------------------------------------------

drop table if exists ods.ods_tidb_short_video_log_ext_epis_history_part2;
create table ods.ods_tidb_short_video_log_ext_epis_history_part2 (
     dt              date     not null                  comment "日期，根据CreateTime转换而来"
    ,Id              bigint   not null                  comment "历史记录主键id"
    ,AccountId       bigint   not null                  comment "用户id"
    ,SeriesId        bigint   not null                  comment "剧id"
    ,EpisId          bigint   not null                  comment "集id"
    ,WatchStamp      int      not null                  comment "观看时间戳"
    ,CreateTime      datetime not null                  comment "创建时间"
    ,EpisNum         int                                comment "集数"
    ,regionId        smallint                           comment "归属区域 id，1：香港，2：北美；"
    ,WatchOver       tinyint                            comment "是否观看完成"
    ,sr_createtime   datetime default current_timestamp comment "starrocks数据注入时间"
    ,sr_updatetime   datetime default current_timestamp comment "starrocks数据更新时间"
) 
primary key(dt, Id)
comment "短剧-用户有效观看短剧记录表2"
partition by range(dt)
(partition p202511 values less than ("2025-12-01"))
distributed by hash(Id) buckets 20
properties (
    "replication_num" = "3"
    ,"dynamic_partition.enable" = "true"
    ,"dynamic_partition.time_unit" = "MONTH"
    ,"dynamic_partition.time_zone" = "Asia/Shanghai"
    ,"dynamic_partition.start" = "-2147483648"
    ,"dynamic_partition.end" = "3"
    ,"dynamic_partition.prefix" = "p"
    ,"dynamic_partition.buckets" = "20"
    ,"dynamic_partition.history_partition_num" = "0"
    ,"dynamic_partition.start_day_of_month" = "1"
    ,"in_memory" = "false"
    ,"enable_persistent_index" = "true"
    ,"replicated_storage" = "true"
    ,"compression" = "LZ4"
)
;