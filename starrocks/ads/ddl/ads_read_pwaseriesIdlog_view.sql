CREATE VIEW ads.`ads_readerlog_en_pwa_series_id_view` (
    `dt`,
    `Id` COMMENT "日志Id",
    `UserId` COMMENT "用户Id",
    `SeriesId` COMMENT "剧Id",
    `CreateTime` COMMENT "创建时间",
    `AppId` COMMENT "appid",
    `UniqueCdReaderId` COMMENT "设备Id",
    `VideoUserId` COMMENT "海剧的用户id",
    `Mt` COMMENT "mt"
) AS SELECT
     `ods`.`ods_tidb_readerlog_en_log_pwaseriesIdlog`.`dt`,
     `ods`.`ods_tidb_readerlog_en_log_pwaseriesIdlog`.`id`,
     `ods`.`ods_tidb_readerlog_en_log_pwaseriesIdlog`.`user_id`,
     `ods`.`ods_tidb_readerlog_en_log_pwaseriesIdlog`.`series_id`,
     `ods`.`ods_tidb_readerlog_en_log_pwaseriesIdlog`.`create_time`,
     `ods`.`ods_tidb_readerlog_en_log_pwaseriesIdlog`.`app_id`,
     `ods`.`ods_tidb_readerlog_en_log_pwaseriesIdlog`.`unique_cd_reader_id`,
     `ods`.`ods_tidb_readerlog_en_log_pwaseriesIdlog`.`video_user_id`,
     `ods`.`ods_tidb_readerlog_en_log_pwaseriesIdlog`.`mt`
FROM `ods`.`ods_tidb_readerlog_en_log_pwaseriesIdlog`;