----------------------------------------------------------------
-- 目标表： ods.ods_tidb_sharpengine_ads_global_NewbookRankOptimizerSchedule
-- 来源实例： new_tidb_source
-- 来源表： sharpengine_ads_global.NewbookRankOptimizerSchedule
-- 来源负责： 
-- 采集工具： SeaTunnel
-- 负责人： qhr
-- 创建日期： 2025-08-13
----------------------------------------------------------------

CREATE TABLE IF NOT EXISTS ods.ods_tidb_sharpengine_ads_global_NewbookRankOptimizerSchedule (
     Id                         BIGINT        NOT NULL                           COMMENT '主键ID'
    ,ProjectCode                INT                                              COMMENT '项目编码'
    ,ConfigId                   BIGINT        NOT NULL                           COMMENT '人效配置ID'
    ,Status                     INT                    DEFAULT '0'               COMMENT '状态，0=待执行|1=已执行'
    ,PlanId                     BIGINT        NOT NULL                           COMMENT '计划ID'
    ,Code                       VARCHAR(300)                                     COMMENT '代号'
    ,IsFirst                    INT                                              COMMENT '是否首测'
    ,SourceChl                  VARCHAR(384)                                     COMMENT '媒体'
    ,CurrentLanguage            VARCHAR(384)                                     COMMENT '语言'
    ,OptimizedGroup             VARCHAR(384)  NOT NULL                           COMMENT '优化师分组'
    ,OptimizerUid               VARCHAR(384)  NOT NULL                           COMMENT '优化师'
    ,OptimizerLeaderUid         VARCHAR(384)  NOT NULL                           COMMENT '优化师组长'
    ,CreateTime                 DATETIME      NOT NULL                           COMMENT '创建时间'
    ,Creator                    VARCHAR(384)                                     COMMENT '创建人'
    ,CreatorUid                 VARCHAR(384)                                     COMMENT '创建人账号ID'
    ,UpdateTime                 DATETIME                                         COMMENT '更新时间'
    ,Updater                    VARCHAR(384)                                     COMMENT '更新人'
    ,UpdaterUid                 VARCHAR(384)                                     COMMENT '更新人账号ID'
    ,MarketingPlanTaskId        BIGINT                                           COMMENT '一级拆单计划ID'
    ,MarketingPlanSubTaskId     BIGINT                                           COMMENT '二级拆单计划ID'
    ,MarketingPlanLastTaskId    BIGINT                                           COMMENT '三级拆单计划ID'
    ,H5Url                      VARCHAR(3072)                                    COMMENT 'H5页面地址'
    ,AdsCreationPlanId          BIGINT                                           COMMENT '创编方案Id'
    ,Error                      TEXT                                             COMMENT '错误'
    ,sr_createtime              DATETIME               DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间"
    ,sr_updatetime              DATETIME               DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间"
)
PRIMARY KEY(Id)
COMMENT "新剧测投优化师拆单计划表"
DISTRIBUTED BY HASH(Id)
PROPERTIES (
    "replication_num" = "3",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "LZ4"
)
;