----------------------------------------------------------------
-- 目标表：ods_tidb_sharpengine_ads_global_tiktokminisadext
-- 来源实例：idc-adstidb-查询
-- 来源表：sharpengine_ads_global.TiktokMinisAdExt
-- 来源负责人：何妨
-- 开发人：qhr
-- 开发日期：2026-06-26
----------------------------------------------------------------

create table if not exists ods.ods_tidb_sharpengine_ads_global_tiktokminisadext (
     Id               bigint        not null              comment "主键ID"
    ,ProjectCode      int           default "0"           comment "项目类型1=海阅|2=海剧|6=圣经"
    ,AdId             varchar(500)                        comment "广告ID"
    ,AdName           varchar(2000)                       comment "广告名称"
    ,AdSetId          varchar(500)                        comment "广告组ID"
    ,AdSetName        varchar(2000)                       comment "广告组名称"
    ,AdCampId         varchar(500)                        comment "广告系列ID"
    ,AdCampName       varchar(2000)                       comment "广告系列名称"
    ,FbAccount        varchar(500)  not null              comment "广告账号ID"
    ,FbAccountName    varchar(2000)                       comment "广告账号名称"
    ,MinisId          varchar(500)                        comment "小程序ID"
    ,MinisName        varchar(500)                        comment "小程序名称"
    ,BookId           bigint                              comment "书籍ID|短剧ID"
    ,BookName         varchar(2000)                       comment "书籍名称"
    ,BookChannel      int           default "-1"          comment "书籍类型"
    ,BookNature       int           default "-1"          comment "书籍来源"
    ,StoryType        int           not null default "0"  comment "类型0长篇小说 1短篇小说"
    ,CurrentLanguage2 int                                 comment "投放语言"
    ,Mt               int           default "0"           comment "终端"
    ,Core             int           not null default "16" comment "Core"
    ,AdsType          varchar(500)                        comment "AdsType"
    ,AdsQuality       varchar(500)                        comment "AdsQuality"
    ,AdGroupName      varchar(500)                        comment "广告组别"
    ,AdOptimizerUid   varchar(500)                        comment "优化师工号"
    ,AdOptimizerName  varchar(500)                        comment "优化师名称"
    ,AdOptimizerGroup varchar(500)                        comment "优化师组别"
    ,AdsCreationType  int           default "0"           comment "创编方式 0 手动 1 自动"
    ,AdTarget         varchar(500)                        comment "广告受众类型"
    ,ChargePlan       varchar(2000)                       comment "价值面板"
    ,ChargePlanName   varchar(2000)                       comment "价值面板名称"
    ,LandingPageUrl   varchar(2000)                       comment "落地页地址"
    ,CreateTime       datetime      not null              comment "创建时间"
    ,UpdateTime       datetime      not null              comment "更新时间"
    ,TemplateId       bigint                              comment "创编模板Id"
    ,BudgetType       varchar(100)                        comment "预算类型"
    ,CreationDate     date                                comment "创编日期"
    ,CdCode           varchar(384)                        comment "短剧分销唯一编码"
    ,InstId           bigint        not null default "0"  comment "机构ID"
    ,DcAcct           varchar(384)                        comment "分销投放账号"
    ,BookSeries       varchar(384)                        comment "书籍系列"
    ,AdSetStartTime   varchar(150)                        comment "广告组开启时间"
)
primary key(id)
comment "Tiktok小程序广告扩展信息表"
distributed by hash(id)
properties (
    "bloom_filter_columns" = "AdId",
    "compression" = "LZ4",
    "enable_persistent_index" = "true",
    "fast_schema_evolution" = "true",
    "replicated_storage" = "true",
    "replication_num" = "3"
)
;
