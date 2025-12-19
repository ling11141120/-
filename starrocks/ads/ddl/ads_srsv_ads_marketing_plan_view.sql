create view `ads_srsv_ads_marketing_plan_view`
            (`id` comment "主键ID", `project_code` comment "项目类型 1=海阅|2=海剧",
             `code_id` comment "代号ProjectCode为1=书籍ID|ProjectCode为2=短剧ID",
             `code` comment "代号ProjectCode为1=书籍代号|ProjectCode为2=短剧代号", `put_product_id` comment "投放语言",
             `current_language` comment "投放语言", `source_chl` comment "媒体", `plan_round` comment "计划次数1|2|3",
             `date_span` comment "日期跨度7|14", `begin_date` comment "开始日期", `end_date` comment "结束日期",
             `plan_remark` comment "计划说明", `plan_status` comment "计划结果状态 0=无结果|1=跑出|2=未跑出",
             `plan_docs_url` comment "星河链接地址", `create_time` comment "创建时间", `creator` comment "创建人",
             `creator_uid` comment "创建人账号ID", `update_time` comment "更新时间", `updater` comment "更新人",
             `updater_uid` comment "更新人账号ID", `is_del` comment "是否删除 0=否|1=是",
             `asset_num` comment "首批素材数量", `budget` comment "投放预发",
             `plan_status_remark` comment "计划状态变更说明",
             `test_status` comment "测试状态 0=未开始|1=测试中|2=已结束", `spend` comment "花费",
             `amount` comment "收入", `d0_amount` comment "Day0花费", `day0_first_pay_num` comment "Day0付费人数",
             `reg_num` comment "注册人数", `is_init` comment "是否初始数据 初始数据会跑一次ROI",
             `begin_length` comment "开始总字数", `begin_publish_length` comment "开始发布字数",
             `begin_is_full` comment "开始是否完本 0=否|1=是", `end_length` comment "结束总字数",
             `end_publish_length` comment "结束发布字数", `end_is_full` comment "结束是否完本 0=否|1=是",
             `code_stage` comment "代号阶段 海阅最大3阶 海剧最大2阶 国剧就1阶", `d0_std_amount` comment "Day0标准收入",
             `d7_std_amount` comment "Day0标准收入", `code_lv` comment "最高阶段投放等级 A|S|SS",
             `sr_createtime` comment "sr入库时间", `sr_updatetime` comment "sr更新时间")
            comment "市场测推表"
as
select `ods`.`ods_tidb_ad_sharpengine_ads_global_MarketingPlan`.`Id`
     , `ods`.`ods_tidb_ad_sharpengine_ads_global_MarketingPlan`.`ProjectCode`
     , `ods`.`ods_tidb_ad_sharpengine_ads_global_MarketingPlan`.`CodeId`
     , `ods`.`ods_tidb_ad_sharpengine_ads_global_MarketingPlan`.`Code`
     , `ods`.`ods_tidb_ad_sharpengine_ads_global_MarketingPlan`.`PutProductId`
     , `ods`.`ods_tidb_ad_sharpengine_ads_global_MarketingPlan`.`CurrentLanguage`
     , `ods`.`ods_tidb_ad_sharpengine_ads_global_MarketingPlan`.`SourceChl`
     , `ods`.`ods_tidb_ad_sharpengine_ads_global_MarketingPlan`.`PlanRound`
     , `ods`.`ods_tidb_ad_sharpengine_ads_global_MarketingPlan`.`DateSpan`
     , `ods`.`ods_tidb_ad_sharpengine_ads_global_MarketingPlan`.`BeginDate`
     , `ods`.`ods_tidb_ad_sharpengine_ads_global_MarketingPlan`.`EndDate`
     , `ods`.`ods_tidb_ad_sharpengine_ads_global_MarketingPlan`.`PlanRemark`
     , `ods`.`ods_tidb_ad_sharpengine_ads_global_MarketingPlan`.`PlanStatus`
     , `ods`.`ods_tidb_ad_sharpengine_ads_global_MarketingPlan`.`PlanDocsUrl`
     , `ods`.`ods_tidb_ad_sharpengine_ads_global_MarketingPlan`.`CreateTime`
     , `ods`.`ods_tidb_ad_sharpengine_ads_global_MarketingPlan`.`Creator`
     , `ods`.`ods_tidb_ad_sharpengine_ads_global_MarketingPlan`.`CreatorUid`
     , `ods`.`ods_tidb_ad_sharpengine_ads_global_MarketingPlan`.`UpdateTime`
     , `ods`.`ods_tidb_ad_sharpengine_ads_global_MarketingPlan`.`Updater`
     , `ods`.`ods_tidb_ad_sharpengine_ads_global_MarketingPlan`.`UpdaterUid`
     , `ods`.`ods_tidb_ad_sharpengine_ads_global_MarketingPlan`.`IsDel`
     , `ods`.`ods_tidb_ad_sharpengine_ads_global_MarketingPlan`.`AssetNum`
     , `ods`.`ods_tidb_ad_sharpengine_ads_global_MarketingPlan`.`Budget`
     , `ods`.`ods_tidb_ad_sharpengine_ads_global_MarketingPlan`.`PlanStatusRemark`
     , `ods`.`ods_tidb_ad_sharpengine_ads_global_MarketingPlan`.`TestStatus`
     , `ods`.`ods_tidb_ad_sharpengine_ads_global_MarketingPlan`.`Spend`
     , `ods`.`ods_tidb_ad_sharpengine_ads_global_MarketingPlan`.`Amount`
     , `ods`.`ods_tidb_ad_sharpengine_ads_global_MarketingPlan`.`D0Amount`
     , `ods`.`ods_tidb_ad_sharpengine_ads_global_MarketingPlan`.`Day0FirstPayNum`
     , `ods`.`ods_tidb_ad_sharpengine_ads_global_MarketingPlan`.`RegNum`
     , `ods`.`ods_tidb_ad_sharpengine_ads_global_MarketingPlan`.`IsInit`
     , `ods`.`ods_tidb_ad_sharpengine_ads_global_MarketingPlan`.`BeginLength`
     , `ods`.`ods_tidb_ad_sharpengine_ads_global_MarketingPlan`.`BeginPublishLength`
     , `ods`.`ods_tidb_ad_sharpengine_ads_global_MarketingPlan`.`BeginIsFull`
     , `ods`.`ods_tidb_ad_sharpengine_ads_global_MarketingPlan`.`EndLength`
     , `ods`.`ods_tidb_ad_sharpengine_ads_global_MarketingPlan`.`EndPublishLength`
     , `ods`.`ods_tidb_ad_sharpengine_ads_global_MarketingPlan`.`EndIsFull`
     , `ods`.`ods_tidb_ad_sharpengine_ads_global_MarketingPlan`.`CodeStage`
     , `ods`.`ods_tidb_ad_sharpengine_ads_global_MarketingPlan`.`D0StdAmount`
     , `ods`.`ods_tidb_ad_sharpengine_ads_global_MarketingPlan`.`D7StdAmount`
     , `ods`.`ods_tidb_ad_sharpengine_ads_global_MarketingPlan`.`CodeLv`
     , `ods`.`ods_tidb_ad_sharpengine_ads_global_MarketingPlan`.`sr_createtime`
     , `ods`.`ods_tidb_ad_sharpengine_ads_global_MarketingPlan`.`sr_updatetime`
  from `ods`.`ods_tidb_ad_sharpengine_ads_global_MarketingPlan`;