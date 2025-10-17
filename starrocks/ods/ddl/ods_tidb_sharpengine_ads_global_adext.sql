----------------------------------------------------------------
-- 目标表：  ods_tidb_sharpengine_ads_global_adext
-- 来源实例：new_tidb_source
-- 来源表：  sharpengine_ads_global.AdExt
-- 采集工具： SeaTunnel
-- 开发人： wx
-- 开发日期： 2025-10-17
----------------------------------------------------------------
drop table if exists ods.ods_tidb_sharpengine_ads_global_adext;
create table if not exists ods.ods_tidb_sharpengine_ads_global_adext (
     id                   bigint(20)      not                        comment "主键ID"
    ,productid            int(11)         default "0"                comment ""
    ,adid                 varchar(250)                               comment "广告ID"
    ,bookid               bigint(20)                                 comment "书籍ID"
    ,adstype              varchar(128)                               comment "AdsType"
    ,adsquality           varchar(128)                               comment "AdsQuality"
    ,website              varchar(128)                               comment "官网"
    ,position             varchar(128)                               comment "广告位置"
    ,createtime           datetime not                               comment "创建时间"
    ,updatetime           datetime not                               comment "更新时间"
    ,adname               varchar(500)                               comment "广告名称"
    ,adsetname            varchar(500)                               comment "广告组名称"
    ,adcampname           varchar(500)                               comment "广告系列名称"
    ,bookchannel          int(11)         default "-1"               comment "书籍类型"
    ,booknature           int(11)         default "-1"               comment "书籍来源"
    ,bookname             varchar(500)                               comment "书籍名称"
    ,adsetid              varchar(255)                               comment "广告组ID"
    ,adcampid             varchar(255)                               comment "广告系列"
    ,fbaccount            varchar(255)                               comment ""
    ,url                  varchar(500)                               comment "广告URL"
    ,pageversion          varchar(10)                                comment "广告页面版本"
    ,at                   varchar(255)                               comment "广告归因窗口"
    ,mt                   int(11)                                    comment ""
    ,core                 int(11)                                    comment ""
    ,chl2                 varchar(255)                               comment ""
    ,currentlanguage2     int(11)                                    comment ""
    ,sourcechl            varchar(128)                               comment ""
    ,adsoptimizer         varchar(128)                               comment ""
    ,accounttz            int(11)                                    comment "账号时区 -13=GMT-5默认时区|-20=GMT-12英西时区|-18=GMT-10葡语时区|-7=GMT+1亚洲时区"
    ,adoptimizercode      varchar(128)                               comment "优化师缩写"
    ,tvid                 varchar(228)                               comment "国内短剧ID"
    ,tvname               varchar(655)                               comment "国内短剧名称"
    ,invitecode           varchar(328)                               comment "代理编码"
    ,invitename           varchar(655)                               comment "代理名称"
    ,middlemanid          varchar(328)                               comment "机构编码"
    ,middlemanname        varchar(655)                               comment "机构名称"
    ,tfid                 varchar(328)                               comment "投放Id"
    ,tfurl                varchar(1500)                              comment "投放链接"
    ,paytmpl              varchar(328)                               comment "充值模板"
    ,tvcode               varchar(328)                               comment "国剧代号"
    ,videoid              varchar(65533)                             comment "3A和普通广告的视频素材Id"
    ,adoptimizeruid       varchar(256)                               comment "优化师工号"
    ,adoptimizergroup     varchar(65533)                             comment "优化师组别"
    ,adoptimizermaster    varchar(65533)                             comment "优化师师傅工号"
    ,xcxtype              int(11)                                    comment "国剧账号小程序类型 1=抖小|2=微小"
    ,adgroupname          varchar(655)                               comment "广告组别"
    ,pageid               varchar(1024)                              comment "页面ID"
    ,picid                bigint(20)                                 comment "默认图片ID"
    ,nonpicid             bigint(20)                                 comment "非标图片ID"
    ,docid                bigint(20)                                 comment "文案ID"
    ,btnid                bigint(20)                                 comment "按钮ID"
    ,xcxappid             varchar(655)                               comment "国剧微信小程序AppId"
    ,xcxbxms              varchar(655)                               comment "国剧变现模式 iaa|iap"
    ,searchword           varchar(65533)                             comment "用户搜索词"
    ,pagetemptype         int(11)                                    comment "落地页模板类型"
    ,agentid              bigint(20)      default "0"                comment "代理商ID"
    ,cdcode               varchar(655)                               comment "短剧分销唯一编码"
    ,instid               bigint(20)                                 comment "机构ID"
    ,dcacct               varchar(655)                               comment "分销投放账号"
    ,templateid           bigint(20)                                 comment "创编模板ID"
    ,adscreationtype      int(11)                                    comment "创编方式 0 手动 1 自动"
    ,plancontenttype      int(11)                                    comment "方案内容类型"
    ,adtarget             varchar(1000)                              comment "广告受众类型"
    ,assettesttag         varchar(1000)                              comment "素材算法测试标签"
    ,storytype            int(11)                                    comment "类型0长篇小说 1短篇小说"
    ,bookseries           varchar(600)                               comment "书籍系列"
    ,asc1testtag          varchar(600)                               comment "广告组关闭首日规则测试标签"
    ,asc2testtag          varchar(600)                               comment "广告组关闭次日规则测试标签"
    ,ib1testtag           varchar(600)                               comment "自动加量首日规则测试标签"
    ,ib2testtag           varchar(600)                               comment "自动加量次日规则测试标签"
    ,sr_createtime        datetime        default current_timestamp  comment "sr入库时间"
    ,sr_updatetime        datetime        default current_timestamp  comment "sr更新时间"
    ,index idx_productid (productid)      using bitmap               comment '语言ID'
)
primary key(id)
comment "OLAP"
distributed by hash(id) buckets 1
properties (
    "replication_num" = "3",
    "bloom_filter_columns" = "adid",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "lz4"
)
;