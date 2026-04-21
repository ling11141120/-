----------------------------------------------------------------
-- 目标表： ods.ods_edit_book_LanguageBookTotal
-- 来源实例： hk-cm-mysql-slave
-- 来源表： shuangwen_tidb_en.LanguageBookTotal
-- 来源负责人：
-- 开发人： wx
-- 开发日期： 2025-09-25
----------------------------------------------------------------

drop table if exists ods.ods_edit_book_LanguageBookTotal;
create table ods.ods_edit_book_LanguageBookTotal (
     Productid             int           not null                   comment "产品id"
    ,Id                    bigint        not null                   comment "自增id"
    ,ToBookName            string                                   comment "目标语言书籍名称"
    ,FromBookName          varchar(100)                             comment "来源语言书籍名称"
    ,ToBookId              bigint                                   comment "目标语言书籍Id"
    ,FromBookId            bigint                                   comment "来源语言书籍Id"
    ,ToLanguage            int                                      comment "目标语言"
    ,FromLanguage          int                                      comment "来源语言"
    ,EditPublishNumber     int                                      comment "最新发布章节"
    ,EditProofreadNumber   int                                      comment "最新发布校对章节"
    ,AppPublishCount       int                                      comment "app发布章节数"
    ,ProofreadCount        int                                      comment "校对章节数"
    ,ForeigningCount       int                                      comment "待一校数量"
    ,ProofreadingCount     int                                      comment "待二校数量"
    ,PublishingCount       int                                      comment "待发布数量"
    ,ProofreadNumber       int                                      comment "精修数量"
    ,ForeignResidue        int                                      comment "一校余量"
    ,UpdateTime            datetime                                 comment "修改时间"
    ,StatisticsDate        datetime                                 comment "统计时间"
    ,StrConent             varchar(1000)                            comment "状态提示"
    ,CNBookName            varchar(100)                             comment "中文书名"
    ,RollbackSequenceNum   int                                      comment "驳回章节序号"
    ,ForeignedDayCount     int                                      comment "一校章节数"
    ,CheckDayCount         int                                      comment "质检章节数"
    ,BookStatus            int                                      comment "书籍状态 0未上架、1停更、2完本、3机翻、4质检、5精修"
    ,MinProofreadNumber    int                                      comment "精修几章后未发布(二校)"
    ,ForeignNumber         int                                      comment "精修最大数量(一校)"
    ,InterpreterNumber     int                                      comment "精修最大数量(质检)"
    ,MinForeignNumber      int                                      comment "精修几章后未发布(一校)"
    ,MinInterpreterNumber  int                                      comment "精修几章后未发布(质检)"
    ,ChapterStatus         tinyint                                  comment "最新发布章节类型：1机翻、2质检、3精修"
    ,ChapterPlusNumByDay   varchar(50)                              comment "每日常规章节"
    ,ChapterPlusNumByWeek  varchar(50)                              comment "周期加更数量 含日期和数量"
    ,CollectionByForeign   varchar(50)                              comment "外校领稿上限"
    ,StopUpdateNum         varchar(50)                              comment "停更天数（没有开启停更则空白）"
    ,PublishLength         int                                      comment "发布字数"
    ,BookCode              varchar(250)                             comment "书籍代号"
    ,Remark                varchar(500)  default ""                 comment "卡章提示"
    ,ObjectBookType        int                                      comment "图书书籍类型,0-网文 1-短剧"
    ,IsCostRate            int                                      comment "是否计算成本率,0-否 1-是"
    ,sr_createtime         datetime      default current_timestamp  comment "starrocks数据注入时间"
    ,sr_updatetime         datetime      default current_timestamp  comment "starrocks数据更新时间"
    ,index index_ProductId (Productid) using bitmap comment "index_ProductId"
)
primary key(Productid, Id)
comment "语言信息统计"
distributed by hash(Productid, Id) buckets 20
properties (
    "replication_num" = "3",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "LZ4"
)
;
