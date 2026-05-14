CREATE VIEW `dim_short_video_series_ref_type_view` (`id` COMMENT "主键", `series_id` COMMENT "剧集id", `series_type_id` COMMENT "剧集类型id", `sr_createtime` COMMENT "starrocks数据注入时间", `sr_updatetime` COMMENT "starrocks数据更新时间")
COMMENT "海外短剧-剧分类维度表" AS SELECT `ods`.`ods_tidb_short_video_series_ref_type`.`id`, `ods`.`ods_tidb_short_video_series_ref_type`.`seriesid` AS `series_id`, `ods`.`ods_tidb_short_video_series_ref_type`.`seriestypeid` AS `series_typeid`, `ods`.`ods_tidb_short_video_series_ref_type`.`sr_createtime`, `ods`.`ods_tidb_short_video_series_ref_type`.`sr_updatetime`
FROM `ods`.`ods_tidb_short_video_series_ref_type`;
utf8
utf8_general_ci