create or replace view ads.ads_advertisement_adext_view (
     id                     comment "主键id"
    ,product_id             comment "产品id"
    ,ad_id                  comment "广告id"
    ,book_id                comment "书籍id"
    ,ads_type               comment "adstype"
    ,ads_quality            comment "adsquality"
    ,web_site               comment "官网"
    ,position               comment "广告位置"
    ,create_time            comment "创建时间"
    ,update_time            comment "更新时间"
    ,ad_name                comment "广告名称"
    ,ad_setname             comment "广告组名称"
    ,ad_campname            comment "广告系列名称"
    ,book_channel           comment "书籍类型"
    ,book_nature            comment "书籍来源"
    ,book_name              comment "书籍名称"
    ,ad_set_id              comment "广告组id"
    ,ad_camp_id             comment "广告系列"
    ,fb_account             comment "fb账号"
    ,url                    comment "广告url"
    ,page_version           comment "广告页面版本"
    ,at                     comment "广告归因窗口"
    ,mt                     comment "终端"
    ,core                   comment "包体"
    ,chl2                   comment "渠道值"
    ,current_language2      comment "语言"
    ,source_chl             comment "媒体渠道值"
    ,ads_optimizer          comment "优化师"
    ,account_tz             comment "账号时区 -13=gmt-5默认时区|-20=gmt-12英西时区|-18=gmt-10葡语时区|-7=gmt+1亚洲时区"
    ,ad_optimizer_code      comment "优化师缩写"
    ,tv_id                  comment "国内短剧id"
    ,tv_name                comment "国内短剧名称"
    ,invite_code            comment "代理编码"
    ,invite_name            comment "代理名称"
    ,middleman_id           comment "机构编码"
    ,middleman_name         comment "机构名称"
    ,tf_id                  comment "投放id"
    ,tf_url                 comment "投放链接"
    ,pay_tmpl               comment "充值模板"
    ,tv_code                comment "国剧代号"
    ,video_id               comment "3A和普通广告的视频素材Id"
    ,ad_optimizer_uid       comment "优化师工号"
    ,ad_optimizer_group     comment "优化师组别"
    ,ad_optimizer_master    comment "优化师师傅工号"
    ,xcx_type               comment "国剧账号小程序类型 1=抖小|2=微小"
    ,ad_group_name          comment "广告组别"
    ,template_id            comment "创编模板ID"
    ,ads_creation_type      comment "创编方式 0 手动 1 自动"
    ,plan_content_type      comment "方案内容类型"
    ,ad_target              comment "广告受众类型"
    ,asset_test_tag         comment "素材算法测试标签"
    ,story_type             comment "类型0长篇小说 1短篇小说"
    ,book_series            comment "书籍系列"
    ,asc1_test_tag          comment "广告组关闭首日规则测试标签"
    ,asc2_test_tag          comment "广告组关闭次日规则测试标签"
    ,ib1_test_tag           comment "自动加量首日规则测试标签"
    ,ib2_test_tag           comment "自动加量次日规则测试标签"
    ,inst_id                comment "机构id"
)
as
select Id                   as id
     , ProductId            as product_id
     , AdId                 as ad_id
     , BookId               as book_id
     , AdsType              as ads_type
     , AdsQuality           as ads_quality
     , WebSite              as web_site
     , Position             as position
     , CreateTime           as create_time
     , UpdateTime           as update_time
     , AdName               as ad_name
     , AdSetName            as ad_setname
     , AdCampName           as ad_campname
     , BookChannel          as book_channel
     , BookNature           as book_nature
     , BookName             as book_name
     , AdSetId              as ad_set_id
     , AdCampId             as ad_camp_id
     , FbAccount            as fb_account
     , Url                  as url
     , PageVersion          as page_version
     , At                   as at
     , Mt                   as mt
     , Core                 as core
     , Chl2                 as chl2
     , CurrentLanguage2     as current_language2
     , SourceChl            as source_chl
     , AdsOptimizer         as ads_optimizer
     , AccountTz            as account_tz
     , AdOptimizerCode      as ad_optimizer_code
     , TvId                 as tv_id
     , TvName               as tv_name
     , InviteCode           as invite_code
     , InviteName           as invite_name
     , MiddleManId          as middleman_id
     , MiddleManName        as middleman_name
     , TfId                 as tf_id
     , TfUrl                as tf_url
     , PayTmpl              as pay_tmpl
     , TvCode               as tv_code
     , VideoId              as video_id
     , AdOptimizerUid       as ad_optimizer_uid
     , AdOptimizerGroup     as ad_optimizer_group
     , AdOptimizerMaster    as ad_optimizer_master
     , XcxType              as xcx_type
     , AdGroupName          as ad_group_name
     , TemplateId           as template_id
     , AdsCreationType      as ads_creation_type
     , PlanContentType      as plan_content_type
     , AdTarget             as ad_target
     , AssetTestTag         as asset_test_tag
     , StoryType            as story_type
     , BookSeries           as book_series
     , Asc1TestTag          as asc1_test_tag
     , Asc2TestTag          as asc2_test_tag
     , Ib1TestTag           as ib1_test_tag
     , Ib2TestTag           as ib2_test_tag
     , InstId               as inst_id
  from ods.ods_tidb_sharpengine_ads_global_adext
;