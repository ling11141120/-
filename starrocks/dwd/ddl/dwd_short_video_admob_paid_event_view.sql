create view `dwd_short_video_admob_paid_event_view`
            (`id` comment "唯一ID", `create_tm` comment "创建时间", `dt` comment "创建日期",
             `account_id` comment "账户id", `precision_tp` comment "精准投放类型", `value_micros` comment "值",
             `currency_code` comment "货币代码", `adunit_id` comment "广告id",
             `mediation_ad_apter_class_name` comment "媒体适配器类名", `update_tm` comment "更新时间",
             `user_id` comment "用户ID", `mt` comment "类型", `app_ver` comment "版本号", `app_id` comment "应用ID",
             `chl` comment "渠道", `lang_id` comment "语言ID", `position` comment "广告位置id")
as
select `ods`.`ods_tidb_short_video_admob_paid_event`.`Id`
     , `ods`.`ods_tidb_short_video_admob_paid_event`.`CreateTime`
     , date(`ods`.`ods_tidb_short_video_admob_paid_event`.`CreateTime`) as `dt`
     , `ods`.`ods_tidb_short_video_admob_paid_event`.`AccountId`
     , `ods`.`ods_tidb_short_video_admob_paid_event`.`PrecisionType`
     , `ods`.`ods_tidb_short_video_admob_paid_event`.`ValueMicros`
     , `ods`.`ods_tidb_short_video_admob_paid_event`.`CurrencyCode`
     , `ods`.`ods_tidb_short_video_admob_paid_event`.`AdUnitId`
     , `ods`.`ods_tidb_short_video_admob_paid_event`.`MediationAdapterClassName`
     , `ods`.`ods_tidb_short_video_admob_paid_event`.`UpdateTime`
     , `ods`.`ods_tidb_short_video_admob_paid_event`.`Userid`
     , `ods`.`ods_tidb_short_video_admob_paid_event`.`Mt`
     , `ods`.`ods_tidb_short_video_admob_paid_event`.`Appver`
     , `ods`.`ods_tidb_short_video_admob_paid_event`.`Appid`
     , `ods`.`ods_tidb_short_video_admob_paid_event`.`Chl`
     , `ods`.`ods_tidb_short_video_admob_paid_event`.`Langid`
     , `ods`.`ods_tidb_short_video_admob_paid_event`.`position`
  from `ods`.`ods_tidb_short_video_admob_paid_event`;