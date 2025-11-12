----------------------------------------------------------------
-- 目标表： ods.ods_tidb_short_video_log_ext_epis_history_part2
-- 来源实例： video-en-log-mysql-slave
-- 来源表： short_video_log.epis_history_*
-- 来源负责： 
-- 采集工具： SeaTunnel
-- 开发人： qhr
-- 开发日期： 2025-11-12
----------------------------------------------------------------

DROP TABLE IF EXISTS ods.ods_tidb_short_video_log_ext_epis_history_part2;
CREATE TABLE ods.ods_tidb_short_video_log_ext_epis_history_part2 (
     dt              DATE     NOT NULL                  COMMENT "日期，根据CreateTime转换而来"
    ,Id              BIGINT   NOT NULL                  COMMENT "历史记录主键id"
    ,AccountId       BIGINT   NOT NULL                  COMMENT "用户id"
    ,SeriesId        BIGINT   NOT NULL                  COMMENT "剧id"
    ,EpisId          BIGINT   NOT NULL                  COMMENT "集id"
    ,WatchStamp      INT      NOT NULL                  COMMENT "观看时间戳"
    ,CreateTime      DATETIME NOT NULL                  COMMENT "创建时间"
    ,EpisNum         INT                                COMMENT "集数"
    ,regionId        SMALLINT                           COMMENT "归属区域 id，1：香港，2：北美；"
    ,WatchOver       TINYINT                            COMMENT "是否观看完成"
    ,sr_createtime   DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间"
    ,sr_updatetime   DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间"
) 
PRIMARY KEY(dt, Id)
COMMENT "短剧-用户有效观看短剧记录表2"
PARTITION BY RANGE(dt)
(PARTITION p202511 VALUES LESS THAN ("2025-12-01"))
DISTRIBUTED BY HASH(Id) BUCKETS 20
PROPERTIES (
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