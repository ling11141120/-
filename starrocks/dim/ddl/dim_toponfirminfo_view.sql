CREATE VIEW `dim_toponfirminfo_view` (`id` COMMENT "主键id", `firm_id` COMMENT "应用程序", `name` COMMENT "平台名称", `sr_createtime` COMMENT "starrocks数据注入时间", `sr_updatetime` COMMENT "starrocks数据更新时间")
COMMENT "阅读app内广告相关：TopOn广告聚合平台第三方平台 信息表" AS SELECT `ods`.`ods_tidb_sharpengine_ads_global_TopOnFirmInfo`.`id`, `ods`.`ods_tidb_sharpengine_ads_global_TopOnFirmInfo`.`firmid` AS `firm_id`, `ods`.`ods_tidb_sharpengine_ads_global_TopOnFirmInfo`.`name`, `ods`.`ods_tidb_sharpengine_ads_global_TopOnFirmInfo`.`sr_createtime`, `ods`.`ods_tidb_sharpengine_ads_global_TopOnFirmInfo`.`sr_updatetime`
FROM `ods`.`ods_tidb_sharpengine_ads_global_TopOnFirmInfo`;
utf8
utf8_general_ci