----------------------------------------------------------------
-- 目标表： ods.ods_shuangwen_tidb_en_shortstorybook
-- 来源表： shuangwen_tidb_en.shortstorybook
-- 采集工具： 极光-定时批量
-- 负责人： qhr
-- 开发日期： 2023-08-05
----------------------------------------------------------------

create table if not exists ods.ods_shuangwen_tidb_en_shortstorybook (
     Id                  bigint(20)    NOT NULL                           COMMENT 'Id'
    ,SwBookId            bigint(20)                                       COMMENT '英语爽文书籍id'
    ,CreateTime          datetime      NOT NULL                           COMMENT '创建时间'
    ,LangId              int(11)       NOT NULL DEFAULT "0"               COMMENT '语言 0中文 322'
    ,TextType            int(11)       NOT NULL DEFAULT "0"               COMMENT '文本类型  0、超短篇  1、中长短篇'
    ,Version             varchar(150)                                     COMMENT '版本号'
    ,sr_createtime       datetime               DEFAULT CURRENT_TIMESTAMP COMMENT 'starrocks数据注入时间'
    ,sr_updatetime       datetime               DEFAULT CURRENT_TIMESTAMP COMMENT 'starrocks数据更新时间'
)
PRIMARY KEY (Id)
COMMENT '短篇引入书籍'
DISTRIBUTED BY HASH(Id)
PROPERTIES ("replication_num" = "3",
            "in_memory" = "false",
            "storage_format" = "DEFAULT",
            "enable_persistent_index" = "true",
            "compression" = "LZ4"
)
;