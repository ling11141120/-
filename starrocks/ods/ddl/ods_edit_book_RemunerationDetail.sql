----------------------------------------------------------------
-- 目标表：  ods_edit_book_RemunerationDetail
-- 来源实例：old_tidb_source
-- 来源表：  shuangwen_tidb_en.RemunerationDetail
--          anyidb_tidb.RemunerationDetail
--          huangwen_tidb_sp.RemunerationDetail
-- 采集工具： 极光—定时批量
-- 开发人： wx
-- 开发日期： 2025-10-17
----------------------------------------------------------------
drop table if exists ods.ods_edit_book_RemunerationDetail;
create table if not exists ods.ods_edit_book_RemunerationDetail (
     dt              date              not null          comment "createtime 分区"
    ,productid       int(11)           not null          comment "产品id"
    ,id              bigint(20)        not null          comment "自增id"
    ,authorid        bigint(20)                          comment "作者id"
    ,roletype        int(11)                             comment "角色类型1:译员、2:外籍一校、3:二校、4:三校、5:PM、6:初译审核、7:初校审核、8:国内测试稿审核、9:国外测试稿审核、10:三校抽查、11:一校抽查、12:质检抽查"
    ,unitprice       decimal(18, 2)                      comment "单价"
    ,chapterid       int(11)                             comment "章节id"
    ,bookid          bigint(20)                          comment "书籍ID"
    ,createtime      datetime                            comment "创建时间"
    ,tolanguage      int(11)                             comment "目标书籍语言"
    ,fontlength      int(11)                             comment "字数"
    ,currencytype    int(11)                             comment "货币类型 1:人民币 2:美元"
    ,undoreason      varchar(65533)                      comment "撤销原因"
    ,sr_createtime datetime default current_timestamp    comment "starrocks数据注入时间"
    ,sr_updatetime datetime default current_timestamp    comment "starrocks数据更新时间"
    ,index index_productid (productid) using bitmap      comment '产品id索引'
)
primary key(dt, productid, id)
comment "稿酬明细"
distributed by hash(dt, productid, id) buckets 1
properties (
    "replication_num" = "3",
    "bloom_filter_columns" = "createtime, bookid",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "lz4"
)
;