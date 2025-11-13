CREATE OR REPLACE VIEW dwd.dwd_advertisement_adext_view
(
 id                  COMMENT "主键id",
 product_id          COMMENT "产品id",
 ad_id               COMMENT "广告id",
 book_id             COMMENT "书籍id",
 ads_type            COMMENT "adstype",
 ads_quality         COMMENT "adsquality",
 web_site            COMMENT "官网",
 position            COMMENT "广告位置",
 create_time         COMMENT "创建时间",
 update_time         COMMENT "更新时间",
 ad_name             COMMENT "广告名称",
 ad_setname          COMMENT "广告组名称",
 ad_campname         COMMENT "广告系列名称",
 book_channel        COMMENT "书籍类型",
 book_nature         COMMENT "书籍来源",
 book_name           COMMENT "书籍名称",
 ad_set_id           COMMENT "广告组id",
 ad_camp_id          COMMENT "广告系列",
 fb_account          COMMENT "fb账号",
 url                 COMMENT "广告url",
 page_version        COMMENT "广告页面版本",
 at                  COMMENT "广告归因窗口",
 mt                  COMMENT "终端",
 core                COMMENT "包体",
 chl2                COMMENT "渠道值",
 current_language2   COMMENT "语言",
 source_chl          COMMENT "媒体渠道值",
 ads_optimizer       COMMENT "优化师",
 account_tz          COMMENT "账号时区 -13=gmt-5默认时区|-20=gmt-12英西时区|-18=gmt-10葡语时区|-7=gmt+1亚洲时区",
 ad_optimizer_code   COMMENT "优化师缩写",
 tv_id               COMMENT "国内短剧id",
 tv_name             COMMENT "国内短剧名称",
 invite_code         COMMENT "代理编码",
 invite_name         COMMENT "代理名称",
 middleman_id        COMMENT "机构编码",
 middleman_name      COMMENT "机构名称",
 tf_id               COMMENT "投放id",
 tf_url              COMMENT "投放链接",
 pay_tmpl            COMMENT "充值模板",
 tv_code             COMMENT "国剧代号",
 video_id            COMMENT "3A和普通广告的视频素材Id",
 ad_optimizer_uid    COMMENT "优化师工号",
 ad_optimizer_group  COMMENT "优化师组别",
 ad_optimizer_master COMMENT "优化师师傅工号",
 xcx_type            COMMENT "国剧账号小程序类型 1=抖小|2=微小",
 ad_group_name       COMMENT "广告组别",
 page_id             COMMENT "页面ID",
 pic_id              COMMENT "默认图片ID",
 non_pic_id          COMMENT "非标图片ID",
 doc_id              COMMENT "文案ID",
 btn_id              COMMENT "按钮ID",
 xcx_app_id          COMMENT "国剧微信小程序AppId",
 xcx_bxms            COMMENT "国剧变现模式iaa|iap",
 search_word         COMMENT "用户搜索词",
 page_temp_type      COMMENT "落地页模板类型",
 agent_id            COMMENT "代理商ID",
 cd_code             COMMENT "短剧分销唯一编码",
 inst_id             COMMENT "机构ID",
 dc_acct             COMMENT "分销投放账号"
)
AS
SELECT Id                as id
     , ProductId         as product_id
     , AdId              as ad_id
     , BookId            as book_id
     , AdsType           as ads_type
     , AdsQuality        as ads_quality
     , WebSite           as web_site
     , Position          as position
     , CreateTime        as create_time
     , UpdateTime        as update_time
     , AdName            as ad_name
     , AdSetName         as ad_setname
     , AdCampName        as ad_campname
     , BookChannel       as book_channel
     , BookNature        as book_nature
     , BookName          as book_name
     , AdSetId           as ad_set_id
     , AdCampId          as ad_camp_id
     , FbAccount         as fb_account
     , Url               as url
     , PageVersion       as page_version
     , At                as at
     , Mt                as mt
     , Core              as core
     , Chl2              as chl2
     , CurrentLanguage2  as current_language2
     , SourceChl         as source_chl
     , AdsOptimizer      as ads_optimizer
     , AccountTz         as account_tz
     , AdOptimizerCode   as ad_optimizer_code
     , TvId              as tv_id
     , TvName            as tv_name
     , InviteCode        as invite_code
     , InviteName        as invite_name
     , MiddleManId       as middleman_id
     , MiddleManName     as middleman_name
     , TfId              as tf_id
     , TfUrl             as tf_url
     , PayTmpl           as pay_tmpl
     , TvCode            as tv_code
     , VideoId           as video_id
     , AdOptimizerUid    as ad_optimizer_uid
     , AdOptimizerGroup  as ad_optimizer_group
     , AdOptimizerMaster as ad_optimizer_master
     , XcxType           as xcx_type
     , AdGroupName       as ad_group_name
     , PageId            as page_id
     , PicId             as pic_id
     , NonPicId          as non_pic_id
     , DocId             as doc_id
     , BtnId             as btn_id
     , XcxAppId          as xcx_app_id
     , XcxBxms           as xcx_bxms
     , SearchWord        as search_word
     , PageTempType      as page_temp_type
     , AgentId           as agent_id
     , CdCode            as cd_code
     , InstId            as inst_id
     , DcAcct            as dc_acct
FROM ods.ods_tidb_sharpengine_ads_global_adext
;