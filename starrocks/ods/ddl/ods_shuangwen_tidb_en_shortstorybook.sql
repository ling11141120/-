----------------------------------------------------------------
-- 目标表： ods.ods_shuangwen_tidb_en_shortstorybook
-- 来源实例： old_tidb_source
-- 来源表： shuangwen_tidb_en.shortstorybook
-- 采集工具： 极光-定时批量
-- 负责人： qhr
-- 开发日期： 2023-08-05
----------------------------------------------------------------

DROP TABLE IF EXISTS ods.ods_shuangwen_tidb_en_shortstorybook;
CREATE TABLE ods.ods_shuangwen_tidb_en_shortstorybook (
     Id                  bigint(20)    not null                           comment 'Id'
    ,SwBookId            bigint(20)                                       comment '英语爽文书籍id'
    ,CreateTime          datetime      not null                           comment '创建时间'
    ,LangId              int(11)       not null default "0"               comment '语言 0中文 322'
    ,TextType            int(11)       not null default "0"               comment '文本类型  0、超短篇  1、中长短篇'
    ,Version             varchar(150)                                     comment '版本号'
    ,sr_createtime       datetime               default current_timestamp comment 'starrocks数据注入时间'
    ,sr_updatetime       datetime               default current_timestamp comment 'starrocks数据更新时间'
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