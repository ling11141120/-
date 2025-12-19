create view `dim_advertisement_third_ad_account_view`
            (`id` comment "主键id", `account` comment "投放账户id", `secret` comment " api secret",
             `page_id` comment "页面", `app_id`, `app_url` comment " appurl", `create_tm` comment "创建时间",
             `product_id` comment "产品id", `product_name` comment "产品 账号名", `mt` comment "设备",
             `token` comment "tiktok api token", `ins_id` comment "tiktok insid", `status` comment "0-禁用 1-启用",
             `autofill_ad` comment "自动填充 0 否 1 是", `update_status` comment "更新状态", `chl` comment "渠道",
             `core` comment "core", `fbadrule_id` comment "自动关闭规则id", `adauto_active`,
             `status_change_tm` comment "状态更新时间", `fb_account_type` comment "1表示再营销 0正常新增投放",
             `row_version` comment "同步数据用的", `spend_cap` comment "额度金额",
             `amount_spent` comment "已经花费的金额", `put_product_id` comment "投放语言id",
             `current_language2` comment "投放语言", `accountad_type` comment "账号广告类型",
             `exchange_rate` comment "汇率", `account_change_toremarketing_tm` comment "设置为再营销账户的时间",
             `last_insight_info` comment "最后一次抓取dailyinsight的信息", `source_chl` comment "渠道值",
             `ad_platform_id` comment "广告渠道 0-苹果 1-抖音 2-快手",
             `account_tz` comment "账号时区 -13=gmt-5默认时区|-20=gmt-12英西时区|-18=gmt-10葡语时区|-7=gmt+1亚洲时区")
as
select `ods`.`ods_tidb_sharpengine_ads_global_ThirdAdAccount`.`Id`
     , `ods`.`ods_tidb_sharpengine_ads_global_ThirdAdAccount`.`Account`
     , `ods`.`ods_tidb_sharpengine_ads_global_ThirdAdAccount`.`Secret`
     , `ods`.`ods_tidb_sharpengine_ads_global_ThirdAdAccount`.`PageId`
     , `ods`.`ods_tidb_sharpengine_ads_global_ThirdAdAccount`.`AppId`
     , `ods`.`ods_tidb_sharpengine_ads_global_ThirdAdAccount`.`AppUrl`
     , `ods`.`ods_tidb_sharpengine_ads_global_ThirdAdAccount`.`CreateTime`
     , `ods`.`ods_tidb_sharpengine_ads_global_ThirdAdAccount`.`ProductId`
     , `ods`.`ods_tidb_sharpengine_ads_global_ThirdAdAccount`.`ProductName`
     , `ods`.`ods_tidb_sharpengine_ads_global_ThirdAdAccount`.`Mt`
     , `ods`.`ods_tidb_sharpengine_ads_global_ThirdAdAccount`.`Token`
     , `ods`.`ods_tidb_sharpengine_ads_global_ThirdAdAccount`.`InsId`
     , `ods`.`ods_tidb_sharpengine_ads_global_ThirdAdAccount`.`Status`
     , `ods`.`ods_tidb_sharpengine_ads_global_ThirdAdAccount`.`AutoFillAd`
     , `ods`.`ods_tidb_sharpengine_ads_global_ThirdAdAccount`.`UpdateStatus`
     , `ods`.`ods_tidb_sharpengine_ads_global_ThirdAdAccount`.`Chl`
     , `ods`.`ods_tidb_sharpengine_ads_global_ThirdAdAccount`.`Core`
     , `ods`.`ods_tidb_sharpengine_ads_global_ThirdAdAccount`.`FbAdRuleId`
     , `ods`.`ods_tidb_sharpengine_ads_global_ThirdAdAccount`.`AdAutoActive`
     , `ods`.`ods_tidb_sharpengine_ads_global_ThirdAdAccount`.`StatusChangeTime`
     , `ods`.`ods_tidb_sharpengine_ads_global_ThirdAdAccount`.`FbAccountType`
     , `ods`.`ods_tidb_sharpengine_ads_global_ThirdAdAccount`.`RowVersion`
     , `ods`.`ods_tidb_sharpengine_ads_global_ThirdAdAccount`.`SpendCap`
     , `ods`.`ods_tidb_sharpengine_ads_global_ThirdAdAccount`.`AmountSpent`
     , `ods`.`ods_tidb_sharpengine_ads_global_ThirdAdAccount`.`PutProductId`
     , `ods`.`ods_tidb_sharpengine_ads_global_ThirdAdAccount`.`CurrentLanguage2`
     , `ods`.`ods_tidb_sharpengine_ads_global_ThirdAdAccount`.`AccountAdType`
     , `ods`.`ods_tidb_sharpengine_ads_global_ThirdAdAccount`.`ExchangeRate`
     , `ods`.`ods_tidb_sharpengine_ads_global_ThirdAdAccount`.`AccountChangeToRemarketingTime`
     , `ods`.`ods_tidb_sharpengine_ads_global_ThirdAdAccount`.`LastInsightInfo`
     , `ods`.`ods_tidb_sharpengine_ads_global_ThirdAdAccount`.`SourceChl`
     , `ods`.`ods_tidb_sharpengine_ads_global_ThirdAdAccount`.`AdPlatformId`
     , `ods`.`ods_tidb_sharpengine_ads_global_ThirdAdAccount`.`AccountTz`
  from `ods`.`ods_tidb_sharpengine_ads_global_ThirdAdAccount`;