----------------------------------------------------------------
-- 目标表： ods.ods_book_novel_book_m
-- 来源实例： old_starrocks_source
-- 来源表： shuangwen_tidb_en.BookCapacityMonitoring
-- 来源负责： 
-- 采集工具： 极光-定时批量
-- 开发人： wx
-- 开发日期： 2023-09-25
----------------------------------------------------------------
DROP TABLE IF EXISTS ods.ods_tidb_shuangwen_en_bookcapacitymonitoring;
CREATE TABLE ods.ods_tidb_shuangwen_en_bookcapacitymonitoring (
     dt                         DATE            NOT NULL    COMMENT "日期,根据StatisticsTime转换而来"
    ,ToBookId                   BIGINT(20)      NOT NULL    COMMENT "目标书籍ID"
    ,ToLanguage                 INT(11)         NOT NULL    COMMENT "目标书籍语言"
    ,Id                         BIGINT(20)      NOT NULL    COMMENT "自增id"
    ,ToBookName                 VARCHAR(250)                COMMENT "目标语言书籍名称"
    ,CNBookName                 VARCHAR(250)                COMMENT "中文书籍名称"
    ,IsPutdown                  INT(11)         NOT NULL    COMMENT "是否下架"
    ,StatisticsTime             DATETIME        NOT NULL    COMMENT "统计时间"
    ,UpdateTime                 DATETIME                    COMMENT "更新时间"
    ,StartTime                  DATETIME                    COMMENT "配置开始时间"
    ,EndTime                    DATETIME                    COMMENT "配置结束时间"
    ,PlanCount                  DECIMAL(19, 2)  NOT NULL    COMMENT "计划完成量"
    ,RealityCount               DECIMAL(19, 2)  NOT NULL    COMMENT "实际完成量"
    ,PublishNumber              INT(11)         NOT NULL    COMMENT "发布章节数"
    ,ProofreadNumber            INT(11)         NOT NULL    COMMENT "二校章节数"
    ,ProofreadLength            INT(11)         NOT NULL    COMMENT "二校字数"
    ,PublishLength              INT(11)         NOT NULL    COMMENT "发布字数"
    ,AddNum                     VARCHAR(250)                COMMENT "加更配置"
    ,WeekRate                   DECIMAL(19, 2)  NOT NULL    COMMENT "七天费率"
    ,MonthRate                  DECIMAL(19, 2)  NOT NULL    COMMENT "三十天费率"
    ,TotalRate                  DECIMAL(19, 2)  NOT NULL    COMMENT "合计费率"
    ,BookCode                   VARCHAR(250)                COMMENT "书籍代号"
    ,InterpreterStartTime       DATETIME                    COMMENT "质检开始时间"
    ,InterpreterEndTime         DATETIME                    COMMENT "质检结束时间"
    ,InterpreterPlanCount       DECIMAL(19, 2)  NOT NULL    COMMENT "质检计划完成量"
    ,InterpreterRealityCount    DECIMAL(19, 2)  NOT NULL    COMMENT "质检实际完成量"
    ,ForeignStartTime           DATETIME                    COMMENT "一校开始时间"
    ,ForeignEndTime             DATETIME                    COMMENT "一校结束时间"
    ,ForeignPlanCount           DECIMAL(19, 2)  NOT NULL    COMMENT "一校计划完成量"
    ,ForeignRealityCount        DECIMAL(19, 2)  NOT NULL    COMMENT "一校实际完成量"
    ,StopTime                   DATETIME                    COMMENT "停更时间"
    ,NoForeignLength            INT(11)         NOT NULL    COMMENT "待一校字数"
    ,NoProofreadLength          INT(11)         NOT NULL    COMMENT "待二校字数"
    ,BookStatus                 INT(11)         NOT NULL    COMMENT "书籍状态"
    ,BookCreateTime             DATETIME                    COMMENT "书籍创建时间"
    ,amount_7                   DECIMAL(19, 2)  NOT NULL    COMMENT "7天收入"
    ,amount_30                  DECIMAL(19, 2)  NOT NULL    COMMENT "30天收入"
    ,ForeignName                VARCHAR(250)                COMMENT "一校"
    ,ProofreadName              VARCHAR(250)                COMMENT "二校"
    ,InterpreterName            VARCHAR(250)                COMMENT "译员"
    ,StartNum                   INT(11)         NOT NULL    COMMENT "常规日更"
    ,StartPlusNum               INT(11)         NOT NULL    COMMENT "周期加更"
    ,RowVersion                 BIGINT(20)                  COMMENT "行更新时间"
    ,sr_createtime              DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间"
    ,sr_updatetime              DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间"
    ,INDEX index_ToLanguage (ToLanguage) USING BITMAP COMMENT '语言id索引'
)
PRIMARY KEY (dt, ToBookId, ToLanguage, Id)
COMMENT "产能监控表"
DISTRIBUTED BY HASH (dt, ToBookId, ToLanguage) BUCKETS 1
PROPERTIES (
    "replication_num" = "3",
    "bloom_filter_columns" = "ToBookId",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "LZ4"
)
;