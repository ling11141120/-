create or replace view ads.`ads_advertisement_adext_view`
            (`id` comment "主键id", `product_id` comment "产品id", `ad_id` comment "广告id", `book_id` comment "书籍id",
             `ads_type` comment "adstype", `ads_quality` comment "adsquality", `web_site` comment "官网",
             `position` comment "广告位置", `create_time` comment "创建时间", `update_time` comment "更新时间",
             `ad_name` comment "广告名称", `ad_setname` comment "广告组名称", `ad_campname` comment "广告系列名称",
             `book_channel` comment "书籍类型", `book_nature` comment "书籍来源", `book_name` comment "书籍名称",
             `ad_set_id` comment "广告组id", `ad_camp_id` comment "广告系列", `fb_account` comment "fb账号",
             `url` comment "广告url", `page_version` comment "广告页面版本", `at` comment "广告归因窗口",
             `mt` comment "终端", `core` comment "包体", `chl2` comment "渠道值", `current_language2` comment "语言",
             `source_chl` comment "媒体渠道值", `ads_optimizer` comment "优化师",
             `account_tz` comment "账号时区 -13=gmt-5默认时区|-20=gmt-12英西时区|-18=gmt-10葡语时区|-7=gmt+1亚洲时区",
             `ad_optimizer_code` comment "优化师缩写", `tv_id` comment "国内短剧id", `tv_name` comment "国内短剧名称",
             `invite_code` comment "代理编码", `invite_name` comment "代理名称", `middleman_id` comment "机构编码",
             `middleman_name` comment "机构名称", `tf_id` comment "投放id", `tf_url` comment "投放链接",
             `pay_tmpl` comment "充值模板", `tv_code` comment "国剧代号", `video_id` comment "3A和普通广告的视频素材Id",
             `ad_optimizer_uid` comment "优化师工号", `ad_optimizer_group` comment "优化师组别",
             `ad_optimizer_master` comment "优化师师傅工号", `xcx_type` comment "国剧账号小程序类型 1=抖小|2=微小",
             `ad_group_name` comment "广告组别", `template_id` comment "创编模板ID",
             `ads_creation_type` comment "创编方式 0 手动 1 自动", `plan_content_type` comment "方案内容类型",
             `ad_target` comment "广告受众类型", `asset_test_tag` comment "素材算法测试标签",
             `story_type` comment "类型0长篇小说 1短篇小说", `book_series` comment "书籍系列",
             `asc1_test_tag` comment "广告组关闭首日规则测试标签", `asc2_test_tag` comment "广告组关闭次日规则测试标签",
             `ib1_test_tag` comment "自动加量首日规则测试标签", `ib2_test_tag` comment "自动加量次日规则测试标签")
as
select `ods`.`ods_tidb_sharpengine_ads_global_adext`.`Id`
     , `ods`.`ods_tidb_sharpengine_ads_global_adext`.`ProductId`
     , `ods`.`ods_tidb_sharpengine_ads_global_adext`.`AdId`
     , `ods`.`ods_tidb_sharpengine_ads_global_adext`.`BookId`
     , `ods`.`ods_tidb_sharpengine_ads_global_adext`.`AdsType`
     , `ods`.`ods_tidb_sharpengine_ads_global_adext`.`AdsQuality`
     , `ods`.`ods_tidb_sharpengine_ads_global_adext`.`WebSite`
     , `ods`.`ods_tidb_sharpengine_ads_global_adext`.`Position`
     , `ods`.`ods_tidb_sharpengine_ads_global_adext`.`CreateTime`
     , `ods`.`ods_tidb_sharpengine_ads_global_adext`.`UpdateTime`
     , `ods`.`ods_tidb_sharpengine_ads_global_adext`.`AdName`
     , `ods`.`ods_tidb_sharpengine_ads_global_adext`.`AdSetName`
     , `ods`.`ods_tidb_sharpengine_ads_global_adext`.`AdCampName`
     , `ods`.`ods_tidb_sharpengine_ads_global_adext`.`BookChannel`
     , `ods`.`ods_tidb_sharpengine_ads_global_adext`.`BookNature`
     , `ods`.`ods_tidb_sharpengine_ads_global_adext`.`BookName`
     , `ods`.`ods_tidb_sharpengine_ads_global_adext`.`AdSetId`
     , `ods`.`ods_tidb_sharpengine_ads_global_adext`.`AdCampId`
     , `ods`.`ods_tidb_sharpengine_ads_global_adext`.`FbAccount`
     , `ods`.`ods_tidb_sharpengine_ads_global_adext`.`Url`
     , `ods`.`ods_tidb_sharpengine_ads_global_adext`.`PageVersion`
     , `ods`.`ods_tidb_sharpengine_ads_global_adext`.`At`
     , `ods`.`ods_tidb_sharpengine_ads_global_adext`.`Mt`
     , `ods`.`ods_tidb_sharpengine_ads_global_adext`.`Core`
     , `ods`.`ods_tidb_sharpengine_ads_global_adext`.`Chl2`
     , `ods`.`ods_tidb_sharpengine_ads_global_adext`.`CurrentLanguage2`
     , `ods`.`ods_tidb_sharpengine_ads_global_adext`.`SourceChl`
     , `ods`.`ods_tidb_sharpengine_ads_global_adext`.`AdsOptimizer`
     , `ods`.`ods_tidb_sharpengine_ads_global_adext`.`AccountTz`
     , `ods`.`ods_tidb_sharpengine_ads_global_adext`.`AdOptimizerCode`
     , `ods`.`ods_tidb_sharpengine_ads_global_adext`.`TvId`
     , `ods`.`ods_tidb_sharpengine_ads_global_adext`.`TvName`
     , `ods`.`ods_tidb_sharpengine_ads_global_adext`.`InviteCode`
     , `ods`.`ods_tidb_sharpengine_ads_global_adext`.`InviteName`
     , `ods`.`ods_tidb_sharpengine_ads_global_adext`.`MiddleManId`
     , `ods`.`ods_tidb_sharpengine_ads_global_adext`.`MiddleManName`
     , `ods`.`ods_tidb_sharpengine_ads_global_adext`.`TfId`
     , `ods`.`ods_tidb_sharpengine_ads_global_adext`.`TfUrl`
     , `ods`.`ods_tidb_sharpengine_ads_global_adext`.`PayTmpl`
     , `ods`.`ods_tidb_sharpengine_ads_global_adext`.`TvCode`
     , `ods`.`ods_tidb_sharpengine_ads_global_adext`.`VideoId`
     , `ods`.`ods_tidb_sharpengine_ads_global_adext`.`AdOptimizerUid`
     , `ods`.`ods_tidb_sharpengine_ads_global_adext`.`AdOptimizerGroup`
     , `ods`.`ods_tidb_sharpengine_ads_global_adext`.`AdOptimizerMaster`
     , `ods`.`ods_tidb_sharpengine_ads_global_adext`.`XcxType`
     , `ods`.`ods_tidb_sharpengine_ads_global_adext`.`AdGroupName`
     , `ods`.`ods_tidb_sharpengine_ads_global_adext`.`TemplateId`
     , `ods`.`ods_tidb_sharpengine_ads_global_adext`.`AdsCreationType`
     , `ods`.`ods_tidb_sharpengine_ads_global_adext`.`PlanContentType`
     , `ods`.`ods_tidb_sharpengine_ads_global_adext`.`AdTarget`
     , `ods`.`ods_tidb_sharpengine_ads_global_adext`.`AssetTestTag`
     , `ods`.`ods_tidb_sharpengine_ads_global_adext`.`StoryType`
     , `ods`.`ods_tidb_sharpengine_ads_global_adext`.`BookSeries`
     , `ods`.`ods_tidb_sharpengine_ads_global_adext`.`Asc1TestTag`
     , `ods`.`ods_tidb_sharpengine_ads_global_adext`.`Asc2TestTag`
     , `ods`.`ods_tidb_sharpengine_ads_global_adext`.`Ib1TestTag`
     , `ods`.`ods_tidb_sharpengine_ads_global_adext`.`Ib2TestTag`
  from `ods`.`ods_tidb_sharpengine_ads_global_adext`;