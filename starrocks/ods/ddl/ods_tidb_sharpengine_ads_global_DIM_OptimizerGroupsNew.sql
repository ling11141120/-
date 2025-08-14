----------------------------------------------------------------
-- 目标表： ods.ods_tidb_sharpengine_ads_global_DIM_OptimizerGroupsNew
-- 来源表： sharpengine_ads_global.DIM_OptimizerGroupsNew
-- 同步方式： 实时同步
-- 负责人： qhr
-- 创建日期： 2023-08-13
----------------------------------------------------------------

CREATE TABLE IF NOT EXISTS ods.ods_tidb_sharpengine_ads_global_DIM_OptimizerGroupsNew (
     Id               INT             NOT NULL                           COMMENT '主键ID'
    ,Code             VARCHAR(300)    NOT NULL                           COMMENT '优化师组Code'
    ,Enable           INT             NOT NULL DEFAULT '1'               COMMENT '是否启用'
    ,ParentId         INT             NOT NULL                           COMMENT '父ID'
    ,ProjectCode      INT                                                COMMENT '项目 1阅读 2短剧'
    ,GroupType        INT                                                COMMENT '组类型'
    ,IsGroupLeader    INT                                                COMMENT '1 组长 0 组员'
    ,SourceChl        STRING                                             COMMENT '媒体'
    ,CodeValue        VARCHAR(300)                                       COMMENT '优化师组Code值'
    ,SubGroupType     INT                                                COMMENT '子组类型 1编制 2师徒'
    ,AssetGroup       VARCHAR(300)                                       COMMENT '素材组别'
    ,sr_createtime    DATETIME                 DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间"
    ,sr_updatetime    DATETIME                 DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间"
)
PRIMARY KEY(Id)
COMMENT "优化师组配置"
DISTRIBUTED BY HASH(Id)
PROPERTIES ("replication_num" = "3",
            "in_memory" = "false",
            "enable_persistent_index" = "true",
            "replicated_storage" = "true",
            "compression" = "LZ4"
)
;