create view `ads_creation_ad_set_task_view`
            (`id` comment " Id", `template_id` comment "模板Id", `campaign_task_id` comment "创建系列任务Id",
             `book_id` comment "BookId", `creative_id` comment "CreativeId",
             `pinned_creative_id` comment "PinnedCreativeId", `image_id` comment "ImageId",
             `pinned_image_id` comment "PinnedImageId", `object_content_text` comment "ObjectContent_text",
             `short_text` comment "ShortText", `landing_page` comment "LandingPage", `ad_camp_id` comment "AdCampId",
             `creative_count` comment "CreativeCount", `creative_open_count` comment "CreativeOpenCount",
             `is_pinned_first` comment "IsPinnedFirst", `ad_set_count` comment "AdSetCount",
             `object_content_template_id` comment "object_content_template_id", `task_id` comment "TaskId",
             `object_content_marketing_plan_last_task_id` comment "object_content_MarketingPlanLastTaskId",
             `arrange` comment "Arrange", `ads_creation_ad_set` comment "AdsCreationAdSet",
             `deep_link` comment "DeepLink", `object_content` comment "广告组信息",
             `status` comment "状态0待执行1成功2失败", `create_time` comment "创建时间",
             `update_time` comment "更新时间", `response_content` comment "响应内容", `create_by` comment "创建人",
             `create_by_uid` comment "创建人", `marketing_plan_last_task_id` comment "内容任务最终任务ID",
             `creation_type` comment "创编方式0手动1自动", `plan_id` comment "方案Id",
             `plan_item_id` comment "方案配置项Id", `plan_task_id` comment "任务Id",
             `default_account_id` comment "默认账号", `default_page_id` comment "默认主页",
             `default_insta_id` comment "默认IG账号", `sync` comment "是否同步",
             `ads_mode` comment "广告模式 0 动态广告 1 普通广告 2 A+AC", `default_identity_id` comment "默认头像",
             `copy_from_task_id` comment "从哪个任务复制", `rule_log_guid` comment "规则日志唯一Id",
             `elt_tm` comment "清洗时间")
as
select `ods`.`ods_tidb_sharpengine_ads_global_AdsCreationAdSetTask`.`Id`
     , `ods`.`ods_tidb_sharpengine_ads_global_AdsCreationAdSetTask`.`TemplateId`                                      as `template_id`
     , `ods`.`ods_tidb_sharpengine_ads_global_AdsCreationAdSetTask`.`CampaignTaskId`                                  as `campaign_task_id`
     , get_json_string(`ods`.`ods_tidb_sharpengine_ads_global_AdsCreationAdSetTask`.`ObjectContent`,
                       '$.BookId')                                                                                    as `book_id`
     , get_json_string(`ods`.`ods_tidb_sharpengine_ads_global_AdsCreationAdSetTask`.`ObjectContent`,
                       '$.CreativeId')                                                                                as `creative_id`
     , get_json_string(`ods`.`ods_tidb_sharpengine_ads_global_AdsCreationAdSetTask`.`ObjectContent`,
                       '$.PinnedCreativeId')                                                                          as `pinned_creative_id`
     , get_json_string(`ods`.`ods_tidb_sharpengine_ads_global_AdsCreationAdSetTask`.`ObjectContent`,
                       '$.ImageId')                                                                                   as `image_id`
     , get_json_string(`ods`.`ods_tidb_sharpengine_ads_global_AdsCreationAdSetTask`.`ObjectContent`,
                       '$.PinnedImageId')                                                                             as `pinned_image_id`
     , get_json_string(`ods`.`ods_tidb_sharpengine_ads_global_AdsCreationAdSetTask`.`ObjectContent`,
                       '$.Text')                                                                                      as `object_content_text`
     , get_json_string(`ods`.`ods_tidb_sharpengine_ads_global_AdsCreationAdSetTask`.`ObjectContent`,
                       '$.ShortText')                                                                                 as `short_text`
     , get_json_string(`ods`.`ods_tidb_sharpengine_ads_global_AdsCreationAdSetTask`.`ObjectContent`,
                       '$.LandingPage')                                                                               as `landing_page`
     , get_json_string(`ods`.`ods_tidb_sharpengine_ads_global_AdsCreationAdSetTask`.`ObjectContent`,
                       '$.AdCampId')                                                                                  as `ad_camp_id`
     , get_json_string(`ods`.`ods_tidb_sharpengine_ads_global_AdsCreationAdSetTask`.`ObjectContent`,
                       '$.CreativeCount')                                                                             as `creative_count`
     , get_json_string(`ods`.`ods_tidb_sharpengine_ads_global_AdsCreationAdSetTask`.`ObjectContent`,
                       '$.CreativeOpenCount')                                                                         as `creative_open_count`
     , get_json_string(`ods`.`ods_tidb_sharpengine_ads_global_AdsCreationAdSetTask`.`ObjectContent`,
                       '$.IsPinnedFirst')                                                                             as `is_pinned_first`
     , get_json_string(`ods`.`ods_tidb_sharpengine_ads_global_AdsCreationAdSetTask`.`ObjectContent`,
                       '$.AdSetCount')                                                                                as `ad_set_count`
     , get_json_string(`ods`.`ods_tidb_sharpengine_ads_global_AdsCreationAdSetTask`.`ObjectContent`,
                       '$.TemplateId')                                                                                as `object_content_template_id`
     , get_json_string(`ods`.`ods_tidb_sharpengine_ads_global_AdsCreationAdSetTask`.`ObjectContent`,
                       '$.TaskId')                                                                                    as `task_id`
     , get_json_string(`ods`.`ods_tidb_sharpengine_ads_global_AdsCreationAdSetTask`.`ObjectContent`,
                       '$.MarketingPlanLastTaskId')                                                                   as `object_content_marketing_plan_last_task_id`
     , get_json_string(`ods`.`ods_tidb_sharpengine_ads_global_AdsCreationAdSetTask`.`ObjectContent`,
                       '$.Arrange')                                                                                   as `arrange`
     , get_json_string(`ods`.`ods_tidb_sharpengine_ads_global_AdsCreationAdSetTask`.`ObjectContent`,
                       '$.AdsCreationAdSet')                                                                          as `ads_creation_ad_set`
     , get_json_string(`ods`.`ods_tidb_sharpengine_ads_global_AdsCreationAdSetTask`.`ObjectContent`,
                       '$.DeepLink')                                                                                  as `deep_link`
     , `ods`.`ods_tidb_sharpengine_ads_global_AdsCreationAdSetTask`.`ObjectContent`                                   as `object_content`
     , `ods`.`ods_tidb_sharpengine_ads_global_AdsCreationAdSetTask`.`Status`
     , `ods`.`ods_tidb_sharpengine_ads_global_AdsCreationAdSetTask`.`CreateTime`                                      as `create_time`
     , `ods`.`ods_tidb_sharpengine_ads_global_AdsCreationAdSetTask`.`UpdateTime`                                      as `update_time`
     , `ods`.`ods_tidb_sharpengine_ads_global_AdsCreationAdSetTask`.`ResponseContent`                                 as `response_content`
     , `ods`.`ods_tidb_sharpengine_ads_global_AdsCreationAdSetTask`.`CreateBy`                                        as `create_by`
     , `ods`.`ods_tidb_sharpengine_ads_global_AdsCreationAdSetTask`.`CreateByUid`                                     as `create_by_uid`
     , `ods`.`ods_tidb_sharpengine_ads_global_AdsCreationAdSetTask`.`MarketingPlanLastTaskId`                         as `marketing_plan_last_task_id`
     , `ods`.`ods_tidb_sharpengine_ads_global_AdsCreationAdSetTask`.`CreationType`                                    as `creation_type`
     , `ods`.`ods_tidb_sharpengine_ads_global_AdsCreationAdSetTask`.`PlanId`                                          as `plan_id`
     , `ods`.`ods_tidb_sharpengine_ads_global_AdsCreationAdSetTask`.`PlanItemId`                                      as `plan_item_id`
     , `ods`.`ods_tidb_sharpengine_ads_global_AdsCreationAdSetTask`.`PlanTaskId`                                      as `plan_task_id`
     , `ods`.`ods_tidb_sharpengine_ads_global_AdsCreationAdSetTask`.`DefaultAccountId`                                as `default_account_id`
     , `ods`.`ods_tidb_sharpengine_ads_global_AdsCreationAdSetTask`.`DefaultPageId`                                   as `default_page_id`
     , `ods`.`ods_tidb_sharpengine_ads_global_AdsCreationAdSetTask`.`DefaultInstaId`                                  as `default_insta_id`
     , `ods`.`ods_tidb_sharpengine_ads_global_AdsCreationAdSetTask`.`Sync`
     , `ods`.`ods_tidb_sharpengine_ads_global_AdsCreationAdSetTask`.`AdsMode`                                         as `ads_mode`
     , `ods`.`ods_tidb_sharpengine_ads_global_AdsCreationAdSetTask`.`DefaultIdentityId`                               as `default_identity_id`
     , `ods`.`ods_tidb_sharpengine_ads_global_AdsCreationAdSetTask`.`CopyFromTaskId`                                  as `copy_from_task_id`
     , `ods`.`ods_tidb_sharpengine_ads_global_AdsCreationAdSetTask`.`RuleLogGuid`                                     as `rule_log_guid`
     , now()                                                                                                          as `etl_tm`
  from `ods`.`ods_tidb_sharpengine_ads_global_AdsCreationAdSetTask`;