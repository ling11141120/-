----------------------------------------------------------------
-- 目标表： ods.ods_edit_book_LanguageBookTotal
-- 来源实例： old_starrocks_source
-- 来源表： shuangwen_tidb_en.LanguageBookTotal
-- 来源负责： 
-- 采集工具： 极光-定时链路
-- 开发人： wx
-- 创建日期： 2025-09-25
----------------------------------------------------------------
DROP TABLE IF EXISTS ods.ods_edit_book_LanguageBookTotal;
CREATE TABLE ods.ods_edit_book_LanguageBookTotal (
     Productid              INT(11)       NOT NULL           COMMENT "产品id"
    ,Id                     BIGINT(20)   NOT NULL           COMMENT "自增id"
    ,ToBookName             VARCHAR(65533)                  COMMENT "目标语言书籍名称"
    ,FromBookName           VARCHAR(100)                    COMMENT "来源语言书籍名称"
    ,ToBookId               BIGINT(20)                      COMMENT "目标语言书籍Id"
    ,FromBookId             BIGINT(20)                      COMMENT "来源语言书籍Id"
    ,ToLanguage             INT(11)                         COMMENT "目标语言"
    ,FromLanguage           INT(11)                         COMMENT "来源语言"
    ,EditPublishNumber      INT(11)                         COMMENT "最新发布章节"
    ,EditProofreadNumber    INT(11)                         COMMENT "最新发布校对章节"
    ,AppPublishCount        INT(11)                         COMMENT "app发布章节数"
    ,ProofreadCount         INT(11)                         COMMENT "校对章节数"
    ,ForeigningCount        INT(11)                         COMMENT "待一校数量"
    ,ProofreadingCount      INT(11)                         COMMENT "待二校数量"
    ,PublishingCount        INT(11)                         COMMENT "待发布数量"
    ,ProofreadNumber        INT(11)                         COMMENT "精修数量"
    ,ForeignResidue         INT(11)                         COMMENT "一校余量"
    ,UpdateTime             DATETIME                        COMMENT " 修改时间"
    ,StatisticsDate         DATETIME                        COMMENT " 统计时间"
    ,StrConent              VARCHAR(1000)                   COMMENT "状态提示"
    ,CNBookName             VARCHAR(100)                    COMMENT "中文书名"
    ,RollbackSequenceNum    INT(11)                         COMMENT "驳回章节序号"
    ,ForeignedDayCount      INT(11)                         COMMENT "一校章节数"
    ,CheckDayCount          INT(11)                         COMMENT "质检章节数"
    ,BookStatus             INT(11)                         COMMENT "书籍状态 0未上架、1停更、2完本、3机翻、4质检、5精修"
    ,MinProofreadNumber     INT(11)                         COMMENT "精修几章后未发布(二校)"
    ,ForeignNumber          INT(11)                         COMMENT "精修最大数量(一校)"
    ,InterpreterNumber      INT(11)                         COMMENT "精修最大数量(质检)"
    ,MinForeignNumber       INT(11)                         COMMENT "精修几章后未发布(一校)"
    ,MinInterpreterNumber   INT(11)                         COMMENT "精修几章后未发布(质检)"
    ,ChapterStatus          TINYINT(4)                      COMMENT "最新发布章节类型：1机翻、2质检、3精修"
    ,ChapterPlusNumByDay    VARCHAR(50)                     COMMENT "每日常规章节"
    ,ChapterPlusNumByWeek   VARCHAR(50)                     COMMENT "周期加更数量 含日期和数量"
    ,CollectionByForeign    VARCHAR(50)                     COMMENT "外校领稿上限"
    ,StopUpdateNum          VARCHAR(50)                     COMMENT "停更天数（没有开启停更则空白）"
    ,PublishLength          INT(11)                         COMMENT "发布字数"
    ,BookCode               VARCHAR(250)                    COMMENT "书籍代号"
    ,Remark                 VARCHAR(500)      DEFAULT ""    COMMENT "卡章提示"
    ,ObjectBookType         INT(11)                         COMMENT "图书书籍类型,0-网文 1-短剧"
    ,IsCostRate             INT(11)                         COMMENT "是否计算成本率,0-否 1-是"
    ,sr_createtime          DATETIME     NULL DEFAULT       CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间"
    ,sr_updatetime          DATETIME     NULL DEFAULT       CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间"
    ,INDEX index_ProductId (`Productid`) USING BITMAP COMMENT 'index_ProductId'
)
PRIMARY KEY (Productid, Id)
COMMENT "语言信息统计"
DISTRIBUTED BY HASH (Productid, Id) BUCKETS 20
PROPERTIES (
    "replication_num" = "3",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "LZ4"
)
;