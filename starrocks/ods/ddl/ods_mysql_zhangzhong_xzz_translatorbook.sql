----------------------------------------------------------------
-- 目标表： ods.ods_mysql_zhangzhong_xzz_translatorbook
-- 来源实例： 10.10.10.71-阅读查询
-- 来源表： zhangzhong_xzz.TranslatorBook
-- 来源负责：蔡扶炜
-- 采集工具： 极光-定时批量
-- 开发人：xjc
-- 开发日期： 2026-02-26
----------------------------------------------------------------

drop table if exists ods.ods_mysql_zhangzhong_xzz_translatorbook;
create table ods.ods_mysql_zhangzhong_xzz_translatorbook (
     id                int             not null                     comment "主键id"
    ,bookid            bigint          not null                     comment "书籍id"
    ,swbookid          bigint          not null                     comment "翻译书籍id"
    ,tobookname        varchar(765)                                 comment "翻译书名"
    ,tolanguage        int             not null                     comment "目标语言"
    ,isfist            int             not null                     comment "是否直译"
    ,dblang            varchar(765)    not null                     comment "语言：en"
    ,isdelete          int             not null                     comment "是否删除"
    ,objectbookid      int                                          comment "配置id"
    ,isunpackbook      int             not null                     comment "是否拆章书籍 0否 1是"
    ,bookcreatetime    datetime                                     comment "书籍的创建时间"
    ,sr_createtime     datetime        default current_timestamp    comment "starrocks入库时间"
    ,sr_updatetime     datetime        default current_timestamp    comment "starrocks数据更新时间"
)
primary key (id)
comment "新掌中翻译书籍表"
distributed by hash(id)
properties (
    "replication_num" = "3"
   ,"in_memory" = "false"
   ,"enable_persistent_index" = "false"
   ,"replicated_storage" = "true"
   ,"compression" = "lz4"
)
;