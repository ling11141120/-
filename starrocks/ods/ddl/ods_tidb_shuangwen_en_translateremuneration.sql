----------------------------------------------------------------
-- 目标表：ods.ods_tidb_shuangwen_en_translateremuneration
-- 来源实例：old_starrocks_source
-- 来源表：shuangwen_tidb_en.TranslateRemuneration
-- 来源负责：
-- 采集工具：极光-定时链路
-- 开发人：wx
-- 创建日期：2025-09-24
----------------------------------------------------------------
DROP TABLE IF EXISTS ods.ods_tidb_shuangwen_en_translateremuneration;
CREATE TABLE IF NOT EXISTS ods.ods_tidb_shuangwen_en_translateremuneration (
    Id                  bigint(20)        NOT NULL     COMMENT "自增id"
    ,dt                  date              NOT NULL    COMMENT "日期"
    ,ToLanguage          int(11)           NOT NULL    COMMENT "目标语言"
    ,BookId              bigint(20)        NOT NULL    COMMENT "输出书籍Id"
    ,AuthorId            bigint(20)        NOT NULL    COMMENT "译员Id"
    ,ObjectChapterId     bigint(20)        NOT NULL    COMMENT "翻译章节Id"
    ,AuthorType          int(11)           NOT NULL    COMMENT "译员类型"
    ,RoleType            int(11)           NOT NULL    COMMENT "角色类型1:译员、2:外籍一校、3:二校、4:三校、5:PM、6:初译审核、7:初校审核、8:国内测试稿审核、9:国外测试稿审核、10:三校抽查、11:一校抽查、12:质检抽查"
    ,PenName             varchar(65533)                COMMENT "译名"
    ,RealName            varchar(65533)                COMMENT "真名"
    ,BookName            varchar(65533)                COMMENT "输出书籍名称"
    ,ChapterName         varchar(65533)                COMMENT "章节名"
    ,FontLength          bigint(20)                    COMMENT "字数"
    ,Price               decimal(18, 4)    NOT NULL    COMMENT "单价:美元"
    ,TotalPrice          decimal(18, 4)    NOT NULL    COMMENT "稿酬金额:美元"
    ,CurrencyType        tinyint(4)        NOT NULL    COMMENT "货币类型 1:人民币 2:美元"
    ,PayType             int(11)           NOT NULL    COMMENT "支付方式:0:银行卡、1:Paypal、2:Payoneer、3:Upwork、4:Freelancer、5:Fiverr、6:银行卡（华美）"
    ,RemunerationTime    datetime          NOT NULL    COMMENT "稿酬生成时间"
    ,BillDate            int(11)           NOT NULL    COMMENT "账期"
    ,Status              int(11)           NOT NULL    COMMENT "状态 0:专员未审核、1:专员待定、2:专员审核通过、3:专员审核拒绝、4:经理审核通过、5:经理审核拒绝、6:财务审核通过、7:财务审核拒绝"
    ,PayStatus           tinyint(4)        NOT NULL    COMMENT "打款状态 0:待处理、1:已打款、2:不打款"
    ,PayTime             datetime                      COMMENT "打款时间"
    ,RemarkByFirst       varchar(65533)                COMMENT "专员审核备注"
    ,RemarkBySecond      varchar(65533)                COMMENT "经理审核备注"
    ,RemarkByThird       varchar(65533)                COMMENT "财务审核备注"
    ,RemarkByPay         varchar(65533)                COMMENT "付款备注"
    ,CreateTime          datetime          NOT NULL    COMMENT "创建时间"
    ,UpdateTime          datetime                      COMMENT "更新时间"
    ,RemunerationType    int(11)           NOT NULL    COMMENT "稿酬类型 1实时稿酬、2附加稿酬、3奖金包"
    ,PriceType           tinyint(4)        NOT NULL    COMMENT "单价计算方式 1:份数 、2:千字价"
    ,SourceBookName      varchar(65533)                COMMENT "输入书籍名称"
    ,FromLanguage        int(11)           NOT NULL    COMMENT "来源语言"
    ,SourceBookId        bigint(20)        NOT NULL    COMMENT "输入书籍Id"
    ,PayAccount          varchar(65533)                COMMENT "支付账号"
    ,BankName            varchar(65533)                COMMENT "银行名称"
    ,AccountName         varchar(65533)                COMMENT "银行账号名称"
    ,ReasonType          varchar(65533)                COMMENT "附加稿酬原因类型"
    ,BankSubBranch       varchar(65533)                COMMENT "银行支行"
    ,PaymentType         tinyint(4)                    COMMENT "付款方式:0:未选择,1:平台，2:转账"
    ,BookType            int(11)           NOT NULL    COMMENT "书籍类型"
    ,UndoReason          varchar(65533)                COMMENT "撤销原因"
    ,sr_createtime       datetime          NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间"
    ,sr_updatetime       datetime          NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间"
    INDEX index_ToLanguage (ToLanguage) USING BITMAP COMMENT '目标语言索引'
) ENGINE = OLAP
PRIMARY KEY (Id)
COMMENT "翻译书籍稿酬+附加稿酬+奖金包并表"
DISTRIBUTED BY HASH (Id) BUCKETS 1
PROPERTIES (
    "replication_num" = "3",
    "bloom_filter_columns" = "AuthorId, BookId",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "LZ4"
)
;