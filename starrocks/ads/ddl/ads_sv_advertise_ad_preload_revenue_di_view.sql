create view `ads_sv_advertise_ad_preload_revenue_di_view`
            (`id` comment "唯一ID", `create_time` comment "创建时间", `account_id` comment "账户id",
             `precision_type` comment "精准投放类型", `value_micros` comment "值", `currency_code` comment "货币代码",
             `ad_unit_id` comment "广告id", `mediation_adapter_class_name` comment "媒体适配器类名",
             `update_time` comment "更新时间", `userid` comment "用户ID", `mt` comment "类型",
             `appver` comment "版本号", `appid` comment "应用ID", `chl` comment "渠道", `langid` comment "语言ID",
             `position` comment "广告位置", `ads_platform` comment "广告商，218 max广告版本开始上报，旧版本为空",
             `core` comment "core", `revenue_precision` comment "精准投放类型(String)",
             `ad_type` comment "广告类型：3激励 5插屏", `sr_createtime` comment "sr入库时间",
             `sr_updatetime` comment "sr更新时间")
as
select `ods`.`ods_tidb_sv_short_video_log_ad_preload_revenue_di`.`Id`
     , `ods`.`ods_tidb_sv_short_video_log_ad_preload_revenue_di`.`CreateTime`
     , `ods`.`ods_tidb_sv_short_video_log_ad_preload_revenue_di`.`AccountId`
     , `ods`.`ods_tidb_sv_short_video_log_ad_preload_revenue_di`.`PrecisionType`
     , `ods`.`ods_tidb_sv_short_video_log_ad_preload_revenue_di`.`ValueMicros`
     , `ods`.`ods_tidb_sv_short_video_log_ad_preload_revenue_di`.`CurrencyCode`
     , `ods`.`ods_tidb_sv_short_video_log_ad_preload_revenue_di`.`AdUnitId`
     , `ods`.`ods_tidb_sv_short_video_log_ad_preload_revenue_di`.`MediationAdapterClassName`
     , `ods`.`ods_tidb_sv_short_video_log_ad_preload_revenue_di`.`UpdateTime`
     , `ods`.`ods_tidb_sv_short_video_log_ad_preload_revenue_di`.`Userid`
     , `ods`.`ods_tidb_sv_short_video_log_ad_preload_revenue_di`.`Mt`
     , `ods`.`ods_tidb_sv_short_video_log_ad_preload_revenue_di`.`Appver`
     , `ods`.`ods_tidb_sv_short_video_log_ad_preload_revenue_di`.`Appid`
     , `ods`.`ods_tidb_sv_short_video_log_ad_preload_revenue_di`.`Chl`
     , `ods`.`ods_tidb_sv_short_video_log_ad_preload_revenue_di`.`Langid`
     , `ods`.`ods_tidb_sv_short_video_log_ad_preload_revenue_di`.`position`
     , `ods`.`ods_tidb_sv_short_video_log_ad_preload_revenue_di`.`adsPlatform`
     , `ods`.`ods_tidb_sv_short_video_log_ad_preload_revenue_di`.`core`
     , `ods`.`ods_tidb_sv_short_video_log_ad_preload_revenue_di`.`RevenuePrecision`
     , ifnull(`ods`.`ods_tidb_sv_short_video_log_ad_preload_revenue_di`.`adType`, 3) as `ad_type`
     , `ods`.`ods_tidb_sv_short_video_log_ad_preload_revenue_di`.`sr_createtime`
     , `ods`.`ods_tidb_sv_short_video_log_ad_preload_revenue_di`.`sr_updatetime`
  from `ods`.`ods_tidb_sv_short_video_log_ad_preload_revenue_di`;