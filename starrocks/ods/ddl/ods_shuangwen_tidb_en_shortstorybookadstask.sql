----------------------------------------------------------------
-- 目标表： ods.ods_shuangwen_tidb_en_shortstorybookadstask
-- 来源实例： 
-- 来源表： shuangwen_tidb_en.shortstorybookadstask
-- 采集工具： 
-- 负责人： qhr
-- 开发日期： 
----------------------------------------------------------------

DROP TABLE IF EXISTS ods.ods_shuangwen_tidb_en_shortstorybookadstask;
CREATE TABLE ods.ods_shuangwen_tidb_en_shortstorybookadstask (
     Id                  BIGINT(20)  NOT NULL             COMMENT 'Id'
    ,BookId              BIGINT(20)  NOT NULL             COMMENT '短篇书籍id'
    ,SwBookId            BIGINT(20)  NOT NULL             COMMENT '英语爽文书籍id'
    ,LangId              INT(11)     NOT NULL DEFAULT '0' COMMENT '语言 322英语'
    ,IsCheckPutdown      INT(11)     NOT NULL DEFAULT '1' COMMENT '是否监控上下架 0否 1是'
    ,PutdownTime         DATETIME                         COMMENT '上架时间'
    ,AdsStatus           INT(11)     NOT NULL DEFAULT '0' COMMENT 'ads计划下单状态 0待处理 1完成 2标识外测'
    ,AdsTaskId           VARCHAR(50)                      COMMENT 'ads计划任务id'
    ,StarAdsTime         DATETIME    NOT NULL             COMMENT 'ads开始推送时间'
    ,EndAdsTime          DATETIME                         COMMENT 'ads结束推送时间'
    ,CreateTime          DATETIME    NOT NULL             COMMENT '创建时间'
) 
PRIMARY KEY (Id)
COMMENT '短篇ads同步任务'
DISTRIBUTED BY HASH(Id)
PROPERTIES (
    "replication_num" = "3",
    "in_memory" = "false",
    "storage_format" = "DEFAULT",
    "enable_persistent_index" = "true",
    "compression" = "LZ4"
)
;