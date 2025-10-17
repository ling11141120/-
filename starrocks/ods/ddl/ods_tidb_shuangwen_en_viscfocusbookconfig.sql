----------------------------------------------------------------
-- 目标表： ods.ods_tidb_shuangwen_en_viscfocusbookconfig
-- 来源实例： old_tidb_source
-- 来源表： shuangwen_tidb_en.ViscFocusBookConfig
-- 来源负责： 
-- 采集工具： 极光-定时批量
-- 开发人： qhr
-- 开发日期： 2025-10-17
----------------------------------------------------------------

DROP TABLE IF EXISTS ods.ods_tidb_shuangwen_en_viscfocusbookconfig;
CREATE TABLE ods.ods_tidb_shuangwen_en_viscfocusbookconfig (
     dt                    DATE       NOT NULL                  COMMENT "日期，根据MonthTime映射"
    ,BookId                BIGINT(20) NOT NULL                  COMMENT "爽文书籍id"
    ,SiteId                INT(11)    NOT NULL                  COMMENT "语言id"
    ,ResourceType          INT(11)    NOT NULL                  COMMENT "资源位置,生产位-1：新书上架2：内部推荐3：外部测推"
    ,Id                    INT(11)    NOT NULL                  COMMENT "自增id"
    ,BookName              STRING     NOT NULL                  COMMENT "书籍名称"
    ,BookCode              STRING                               COMMENT "书籍代号"
    ,MonthTime             DATETIME   NOT NULL                  COMMENT "月份"
    ,CreateTime            DATETIME   NOT NULL                  COMMENT "创建时间"
    ,LengthTarget          INT(11)    NOT NULL                  COMMENT "字数目标"
    ,DelStatus             INT(11)    NOT NULL DEFAULT '0'      COMMENT '是否删除'
    ,EstimatedDeliveryDate DATETIME                             COMMENT '预计交付日期'
    ,Priority              INT(11)                              COMMENT '优先级 p0,p1,p2'
    ,sr_createtime         DATETIME   DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间"
    ,sr_updatetime         DATETIME                             COMMENT "starrocks数据更新时间"
    ,INDEX index_SiteId (SiteId)             USING BITMAP       COMMENT '语言id索引'
    ,INDEX index_ResourceType (ResourceType) USING BITMAP       COMMENT '资源位置索引'
) 
PRIMARY KEY(dt, BookId, SiteId, ResourceType)
COMMENT "聚焦书籍配置表"
DISTRIBUTED BY HASH(BookId, SiteId, ResourceType) BUCKETS 1 
PROPERTIES (
    "replication_num" = "3",
    "bloom_filter_columns" = "dt, BookId",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "LZ4"
)
;