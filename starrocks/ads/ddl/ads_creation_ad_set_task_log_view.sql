create view `ads_creation_ad_set_task_log_view`
            (`id` comment "Id", `task_id` comment "任务Id", `ad_set_name` comment "广告组名称",
             `ad_set_id` comment "广告组Id", `ad_id` comment "广告Id", `response_content` comment "响应内容",
             `status` comment "状态 0 待执行 1 成功 2 失败", `create_time` comment "创建时间",
             `update_time` comment "更新时间", `ad_name` comment "广告名称", `check_status` comment "广告发布状态",
             `ad_status` comment "状态", `arrange_time` comment "日期", `book_id` comment "书籍Id", `mt` comment "终端",
             `ads_optimizer` comment "优化师", `account_id` comment "账号", `project_code` comment "项目", `etl_tm`)
as
select `ods`.`ods_tidb_sharpengine_ads_global_AdsCreationAdSetTaskLog`.`Id`
     , `ods`.`ods_tidb_sharpengine_ads_global_AdsCreationAdSetTaskLog`.`TaskId`          as `task_id`
     , `ods`.`ods_tidb_sharpengine_ads_global_AdsCreationAdSetTaskLog`.`AdSetName`       as `ad_set_name`
     , `ods`.`ods_tidb_sharpengine_ads_global_AdsCreationAdSetTaskLog`.`AdSetId`         as `ad_set_id`
     , `ods`.`ods_tidb_sharpengine_ads_global_AdsCreationAdSetTaskLog`.`AdId`            as `ad_id`
     , `ods`.`ods_tidb_sharpengine_ads_global_AdsCreationAdSetTaskLog`.`ResponseContent` as `response_content`
     , `ods`.`ods_tidb_sharpengine_ads_global_AdsCreationAdSetTaskLog`.`Status`
     , `ods`.`ods_tidb_sharpengine_ads_global_AdsCreationAdSetTaskLog`.`CreateTime`      as `create_time`
     , `ods`.`ods_tidb_sharpengine_ads_global_AdsCreationAdSetTaskLog`.`UpdateTime`      as `update_time`
     , `ods`.`ods_tidb_sharpengine_ads_global_AdsCreationAdSetTaskLog`.`AdName`          as `ad_name`
     , `ods`.`ods_tidb_sharpengine_ads_global_AdsCreationAdSetTaskLog`.`CheckStatus`     as `check_status`
     , `ods`.`ods_tidb_sharpengine_ads_global_AdsCreationAdSetTaskLog`.`AdStatus`        as `ad_status`
     , `ods`.`ods_tidb_sharpengine_ads_global_AdsCreationAdSetTaskLog`.`ArrangeTime`     as `arrange_time`
     , `ods`.`ods_tidb_sharpengine_ads_global_AdsCreationAdSetTaskLog`.`BookId`          as `book_id`
     , `ods`.`ods_tidb_sharpengine_ads_global_AdsCreationAdSetTaskLog`.`Mt`
     , `ods`.`ods_tidb_sharpengine_ads_global_AdsCreationAdSetTaskLog`.`AdsOptimizer`    as `ads_optimizer`
     , `ods`.`ods_tidb_sharpengine_ads_global_AdsCreationAdSetTaskLog`.`AccountId`       as `account_id`
     , `ods`.`ods_tidb_sharpengine_ads_global_AdsCreationAdSetTaskLog`.`ProjectCode`     as `project_code`
     , now()                                                                             as `etl_tm`
  from `ods`.`ods_tidb_sharpengine_ads_global_AdsCreationAdSetTaskLog`;