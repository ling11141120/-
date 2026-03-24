----------------------------------------------------------------
-- 目标表：ods.ods_tidb_ad_sharpengine_ads_global_MarketingPlan
-- 来源实例： new_tidb_source
-- 来源表： sharpengine_ads_global.MarketingPlan
-- 来源负责：
-- 采集工具：极光-定时链路
-- 开发人：wx
-- 创建日期：2025-09-24
----------------------------------------------------------------

drop table if exists ods.ods_tidb_ad_sharpengine_ads_global_MarketingPlan;
create table ods.ods_tidb_ad_sharpengine_ads_global_MarketingPlan (
     Id                    bigint         not null                comment "主键ID"
    ,ProjectCode           int            not null                comment "项目类型 1=海阅|2=海剧"
    ,CodeId                varchar(128)   not null                comment "代号ProjectCode为1=书籍ID|ProjectCode为2=短剧ID"
    ,Code                  varchar(128)                           comment "代号ProjectCode为1=书籍代号|ProjectCode为2=短剧代号"
    ,PutProductId          int            not null                comment "投放语言"
    ,CurrentLanguage       int            not null                comment "投放语言"
    ,SourceChl             varchar(128)                           comment "媒体"
    ,PlanRound             int            not null                comment "计划次数1|2|3"
    ,DateSpan              int            not null                comment "日期跨度7|14"
    ,BeginDate             datetime       not null                comment "开始日期"
    ,EndDate               datetime       not null                comment "结束日期"
    ,PlanRemark            string                                 comment "计划说明"
    ,PlanStatus            int            not null                comment "计划结果状态 0=无结果|1=跑出|2=未跑出"
    ,PlanDocsUrl           varchar(1024)                          comment "星河链接地址"
    ,CreateTime            datetime       not null                comment "创建时间"
    ,Creator               varchar(128)                           comment "创建人"
    ,CreatorUid            varchar(128)                           comment "创建人账号ID"
    ,UpdateTime            datetime                               comment "更新时间"
    ,Updater               varchar(128)                           comment "更新人"
    ,UpdaterUid            varchar(128)                           comment "更新人账号ID"
    ,IsDel                 int            not null                comment "是否删除 0=否|1=是"
    ,AssetNum              int                                    comment "首批素材数量"
    ,Budget                decimal(20, 2)                         comment "投放预发"
    ,PlanStatusRemark      string                                 comment "计划状态变更说明"
    ,TestStatus            int                     default "0"    comment "测试状态 0=未开始|1=测试中|2=已结束"
    ,Spend                 decimal(14, 4)          default "0"    comment "花费"
    ,Amount                decimal(14, 4)          default "0"    comment "收入"
    ,D0Amount              decimal(14, 4)          default "0"    comment "Day0花费"
    ,Day0FirstPayNum       int                     default "0"    comment "Day0付费人数"
    ,RegNum                int                     default "0"    comment "注册人数"
    ,IsInit                int                     default "0"    comment "是否初始数据 初始数据会跑一次ROI"
    ,BeginLength           int                                    comment "开始总字数"
    ,BeginPublishLength    int                                    comment "开始发布字数"
    ,BeginIsFull           int                                    comment "开始是否完本 0=否|1=是"
    ,EndLength             int                                    comment "结束总字数"
    ,EndPublishLength      int                                    comment "结束发布字数"
    ,EndIsFull             int                                    comment "结束是否完本 0=否|1=是"
    ,CodeStage             int                     default "1"    comment "代号阶段 海阅最大3阶 海剧最大2阶 国剧就1阶"
    ,D0StdAmount           decimal(14, 4)          default "0"    comment "Day0标准收入"
    ,D7StdAmount           decimal(14, 4)          default "0"    comment "Day0标准收入"
    ,CodeLv                varchar                                comment "最高阶段投放等级 A|S|SS"
    ,IsAutoCreation        int            not null default '0'    comment "是否开启自动创编 0=否|1=是"
    ,sr_createtime         datetime                               comment "sr入库时间"
    ,sr_updatetime         datetime                               comment "sr更新时间"
)
primary key (Id)
comment "市场测推表 author:102094(何妨)"
distributed by hash (Id) buckets 1
properties (
    "replication_num" = "3",
    "bloom_filter_columns" = "ProjectCode",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "LZ4"
)
;