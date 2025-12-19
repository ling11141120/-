create view `ads_creation_template_view`
            (`id` comment "模板Id", `name` comment "模板名称", `project_code` comment "项目类型",
             `current_language` comment "投放语言", `product_id` comment "语言", `mt` comment "终端",
             `core` comment "Core", `source_chl` comment "媒体", `ads_type` comment "AdsType",
             `create_by` comment "创建人", `status` comment "模板状态", `create_by_uid` comment "创建人",
             `create_time` comment "创建时间", `update_time` comment "更新时间", `account_id` comment "账号Id",
             `ads_mode` comment "广告模式0动态广告1普通广告2A+AC", `etl_tm`)
as
select `ods`.`ods_tidb_sharpengine_ads_global_AdsCreationTemplate`.`Id`
     , `ods`.`ods_tidb_sharpengine_ads_global_AdsCreationTemplate`.`Name`
     , `ods`.`ods_tidb_sharpengine_ads_global_AdsCreationTemplate`.`ProjectCode`     as `project_code`
     , `ods`.`ods_tidb_sharpengine_ads_global_AdsCreationTemplate`.`CurrentLanguage` as `current_language`
     , `ods`.`ods_tidb_sharpengine_ads_global_AdsCreationTemplate`.`ProductId`       as `product_id`
     , `ods`.`ods_tidb_sharpengine_ads_global_AdsCreationTemplate`.`Mt`
     , `ods`.`ods_tidb_sharpengine_ads_global_AdsCreationTemplate`.`Core`
     , `ods`.`ods_tidb_sharpengine_ads_global_AdsCreationTemplate`.`SourceChl`       as `source_chl`
     , `ods`.`ods_tidb_sharpengine_ads_global_AdsCreationTemplate`.`AdsType`         as `ads_type`
     , `ods`.`ods_tidb_sharpengine_ads_global_AdsCreationTemplate`.`CreateBy`        as `create_by`
     , `ods`.`ods_tidb_sharpengine_ads_global_AdsCreationTemplate`.`Status`
     , `ods`.`ods_tidb_sharpengine_ads_global_AdsCreationTemplate`.`CreateByUid`     as `create_by_uid`
     , `ods`.`ods_tidb_sharpengine_ads_global_AdsCreationTemplate`.`CreateTime`      as `create_time`
     , `ods`.`ods_tidb_sharpengine_ads_global_AdsCreationTemplate`.`UpdateTime`      as `update_time`
     , `ods`.`ods_tidb_sharpengine_ads_global_AdsCreationTemplate`.`AccountId`       as `account_id`
     , `ods`.`ods_tidb_sharpengine_ads_global_AdsCreationTemplate`.`AdsMode`         as `ads_mode`
     , now()                                                                         as `etl_tm`
  from `ods`.`ods_tidb_sharpengine_ads_global_AdsCreationTemplate`;