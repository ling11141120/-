CREATE TABLE ods.ods_tidb_ad_sharpengine_ads_global_MarketingPlan (
     Id                    bigint(20)     NOT NULL             COMMENT "主键ID"
    ,ProjectCode           int(11)        NOT NULL             COMMENT "项目类型 1=海阅|2=海剧"
    ,CodeId                varchar(128)   NOT NULL             COMMENT "代号ProjectCode为1=书籍ID|ProjectCode为2=短剧ID"
    ,Code                  varchar(128)                        COMMENT "代号ProjectCode为1=书籍代号|ProjectCode为2=短剧代号"
    ,PutProductId          int(11)        NOT NULL             COMMENT "投放语言"
    ,CurrentLanguage       int(11)        NOT NULL             COMMENT "投放语言"
    ,SourceChl             varchar(128)                        COMMENT "媒体"
    ,PlanRound             int(11)        NOT NULL             COMMENT "计划次数1|2|3"
    ,DateSpan              int(11)        NOT NULL             COMMENT "日期跨度7|14"
    ,BeginDate             datetime       NOT NULL             COMMENT "开始日期"
    ,EndDate               datetime       NOT NULL             COMMENT "结束日期"
    ,PlanRemark            varchar(65533)                      COMMENT "计划说明"
    ,PlanStatus            int(11)        NOT NULL             COMMENT "计划结果状态 0=无结果|1=跑出|2=未跑出"
    ,PlanDocsUrl           varchar(1024)                       COMMENT "星河链接地址"
    ,CreateTime            datetime       NOT NULL             COMMENT "创建时间"
    ,Creator               varchar(128)                        COMMENT "创建人"
    ,CreatorUid            varchar(128)                        COMMENT "创建人账号ID"
    ,UpdateTime            datetime                            COMMENT "更新时间"
    ,Updater               varchar(128)                        COMMENT "更新人"
    ,UpdaterUid            varchar(128)                        COMMENT "更新人账号ID"
    ,IsDel                 int(11)        NOT NULL             COMMENT "是否删除 0=否|1=是"
    ,AssetNum              int(11)                             COMMENT "首批素材数量"
    ,Budget                decimal(20, 2)                      COMMENT "投放预发"
    ,PlanStatusRemark      varchar(65533)                      COMMENT "计划状态变更说明"
    ,TestStatus            int(11)                 DEFAULT "0" COMMENT "测试状态 0=未开始|1=测试中|2=已结束"
    ,Spend                 decimal(14, 4)          DEFAULT "0" COMMENT "花费"
    ,Amount                decimal(14, 4)          DEFAULT "0" COMMENT "收入"
    ,D0Amount              decimal(14, 4)          DEFAULT "0" COMMENT "Day0花费"
    ,Day0FirstPayNum       int(11)                 DEFAULT "0" COMMENT "Day0付费人数"
    ,RegNum                int(11)                 DEFAULT "0" COMMENT "注册人数"
    ,IsInit                int(11)                 DEFAULT "0" COMMENT "是否初始数据 初始数据会跑一次ROI"
    ,BeginLength           int(11)                             COMMENT "开始总字数"
    ,BeginPublishLength    int(11)                             COMMENT "开始发布字数"
    ,BeginIsFull           int(11)                             COMMENT "开始是否完本 0=否|1=是"
    ,EndLength             int(11)                             COMMENT "结束总字数"
    ,EndPublishLength      int(11)                             COMMENT "结束发布字数"
    ,EndIsFull             int(11)                             COMMENT "结束是否完本 0=否|1=是"
    ,CodeStage             int(11)                 DEFAULT "1" COMMENT "代号阶段 海阅最大3阶 海剧最大2阶 国剧就1阶"
    ,D0StdAmount           decimal(14, 4)          DEFAULT "0" COMMENT "Day0标准收入"
    ,D7StdAmount           decimal(14, 4)          DEFAULT "0" COMMENT "Day0标准收入"
    ,CodeLv                varchar(20)                         COMMENT "最高阶段投放等级 A|S|SS"
    ,IsAutoCreation        int            NOT NULL DEFAULT '0' COMMENT "是否开启自动创编 0=否|1=是"
    ,sr_createtime         datetime                            COMMENT "sr入库时间"
    ,sr_updatetime         datetime                            COMMENT "sr更新时间"
)
PRIMARY KEY (Id)
COMMENT "市场测推表 author:102094(何妨)"
DISTRIBUTED BY HASH (Id) BUCKETS 1
PROPERTIES ("replication_num"      = "3",
            "bloom_filter_columns" = "ProjectCode",
            "in_memory"            = "false",
            "enable_persistent_index" = "true",
            "replicated_storage"   = "true",
            "compression"          = "LZ4"
)
;