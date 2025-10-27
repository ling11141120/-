DROP TABLE IF EXISTS dwd.dwd_video_short_video_epis_history;
CREATE TABLE dwd.dwd_video_short_video_epis_history (
     dt           DATE         NOT NULL                  COMMENT "日期，根据CreateTime转换而来"
    ,id           BIGINT(20)   NOT NULL                  COMMENT "历史记录主键id"
    ,account_id   BIGINT(20)   NOT NULL                  COMMENT "用户id"
    ,series_id    BIGINT(20)   NOT NULL                  COMMENT "剧id"
    ,epis_id      BIGINT(20)   NOT NULL                  COMMENT "集id"
    ,watch_stamp  INT(11)      NOT NULL                  COMMENT "观看时间戳"
    ,create_time  DATETIME     NOT NULL                  COMMENT "创建时间"
    ,epis_num     INT(11)                                COMMENT "集数"
    ,region_id    SMALLINT(6)                            COMMENT "归属区域 id，1：香港，2：北美；"
    ,watch_over   TINYINT(4)                             COMMENT "是否观看完成"
    ,etl_time     DATETIME     DEFAULT CURRENT_TIMESTAMP COMMENT "sr数据创建时间"
)
PRIMARY KEY(dt, id)
COMMENT "短剧域海外短剧有效观看记录表"
PARTITION BY RANGE(dt)
(PARTITION p202510 VALUES LESS THAN ("2025-11-01"))
DISTRIBUTED BY HASH(id) BUCKETS 3
PROPERTIES (
    "replication_num" = "2",
    "dynamic_partition.enable" = "true",
    "dynamic_partition.time_unit" = "month",
    "dynamic_partition.time_zone" = "Asia/Shanghai",
    "dynamic_partition.start" = "-2147483648",
    "dynamic_partition.end" = "3",
    "dynamic_partition.prefix" = "p",
    "dynamic_partition.buckets" = "15",
    "dynamic_partition.history_partition_num" = "0",
    "dynamic_partition.start_day_of_month" = "1",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "LZ4"
)
;