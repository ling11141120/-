----------------------------------------------------------------
-- 目标表： ods.ods_shuangwen_tidb_en_shortstorybookadstask
-- 来源表： shuangwen_tidb_en.shortstorybookadstask
-- 开发人： qhr
-- 创建日期： 2023-08-05
----------------------------------------------------------------

create table if not exists ods.ods_shuangwen_tidb_en_shortstorybookadstask (
     Id                  bigint(20)  NOT NULL             COMMENT 'Id'
    ,BookId              bigint(20)  NOT NULL             COMMENT '短篇书籍id'
    ,SwBookId            bigint(20)  NOT NULL             COMMENT '英语爽文书籍id'
    ,LangId              int(11)     NOT NULL DEFAULT '0' COMMENT '语言 322英语'
    ,IsCheckPutdown      int(11)     NOT NULL DEFAULT '1' COMMENT '是否监控上下架 0否 1是'
    ,PutdownTime         datetime                         COMMENT '上架时间'
    ,AdsStatus           int(11)     NOT NULL DEFAULT '0' COMMENT 'ads计划下单状态 0待处理 1完成 2标识外测'
    ,AdsTaskId           varchar(50)                      COMMENT 'ads计划任务id'
    ,StarAdsTime         datetime    NOT NULL             COMMENT 'ads开始推送时间'
    ,EndAdsTime          datetime                         COMMENT 'ads结束推送时间'
    ,CreateTime          datetime    NOT NULL             COMMENT '创建时间'
) 
PRIMARY KEY (Id)
COMMENT '短篇ads同步任务'
DISTRIBUTED BY HASH(Id)
PROPERTIES ("replication_num" = "3",
            "in_memory" = "false",
            "storage_format" = "DEFAULT",
            "enable_persistent_index" = "true",
            "compression" = "LZ4"
)
;