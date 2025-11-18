----------------------------------------------------------------
-- 目标表： ods.ods_tidb_sharpengine_ads_global_marketingplanlasttask
-- 来源实例： new_tidb_source
-- 来源表： sharpengine_ads_global.MarketingPlanLastTask
-- 来源负责： 何妨
-- 采集工具： SeaTunnel
-- 负责人： qhr
-- 创建日期： 2025-11-13
----------------------------------------------------------------

DROP TABLE IF EXISTS ods.ods_tidb_sharpengine_ads_global_marketingplanlasttask;
CREATE TABLE ods.ods_tidb_sharpengine_ads_global_marketingplanlasttask (
     Id               BIGINT       NOT NULL                  COMMENT '主键ID'
    ,MarketingPlanId  BIGINT                                 COMMENT '市场测推计划ID'
    ,TaskId           BIGINT       NOT NULL                  COMMENT '任务ID'
    ,SubTaskId        BIGINT       NOT NULL                  COMMENT '子任务ID'
    ,LastTaskAssetNum INT                                    COMMENT '首批素材数量'
    ,LastTaskBudget   DECIMAL(20,2)                          COMMENT '投放预算'
    ,LastTaskAdSetNum INT                                    COMMENT '广告组数量'
    ,LastTaskRemark   STRING                                 COMMENT '任务说明'
    ,LastTaskUid      VARCHAR(384)                           COMMENT '任务接收人工号'
    ,LastTaskUser     VARCHAR(384)                           COMMENT '任务接收人名称'
    ,LastTaskStatus   INT                                    COMMENT '任务状态 0=未完成|1=已完成'
    ,CreateTime       DATETIME     NOT NULL                  COMMENT '创建时间'
    ,Creator          VARCHAR(384)                           COMMENT '创建人'
    ,CreatorUid       VARCHAR(384)                           COMMENT '创建人账号ID'
    ,UpdateTime       DATETIME                               COMMENT '更新时间'
    ,Updater          VARCHAR(384)                           COMMENT '更新人'
    ,UpdaterUid       VARCHAR(384)                           COMMENT '更新人账号ID'
    ,IsDel            INT          NOT NULL                  COMMENT '是否删除 0=否|1=是'
    ,sr_createtime    DATETIME     DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间"
    ,sr_updatetime    DATETIME     DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间"
)
PRIMARY KEY (Id)
COMMENT "市场测推最后任务表"
DISTRIBUTED BY HASH (Id)
PROPERTIES (
    "replication_num" = "3",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "LZ4"
)
;