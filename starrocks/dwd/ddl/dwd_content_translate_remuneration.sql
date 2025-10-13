DROP TABLE IF EXISTS dwd.dwd_content_translate_remuneration;
CREATE TABLE dwd.dwd_content_translate_remuneration (
     dt                DATE          NOT NULL           COMMENT "日期,remuneration_time转换而来"
    ,auto_id           BIGINT        NOT NULL           COMMENT "自增id"
    ,to_language       BIGINT        NOT NULL           COMMENT "目标语言id"
    ,book_id           BIGINT        NOT NULL           COMMENT "输出书籍Id"
    ,author_id         BIGINT        NOT NULL           COMMENT "译员Id"
    ,chapter_id        BIGINT        NOT NULL           COMMENT "翻译章节Id"
    ,author_type       SMALLINT      NOT NULL           COMMENT "译员类型"
    ,role_type         SMALLINT      NOT NULL           COMMENT "角色类型1：译员、2：外籍一校、3：二校、4：三校、5：PM、6：初译审核、7：初校审核、8：国内测试稿审核、9：国外测试稿审核、10：三校抽查、11：一校抽查、12：质检抽查"
    ,pen_name          STRING                           COMMENT "译名"
    ,real_name         STRING                           COMMENT "真名"
    ,book_name         STRING                           COMMENT "输出书籍名称"
    ,chapter_name      STRING                           COMMENT "章节名"
    ,font_length       BIGINT                           COMMENT "字数"
    ,price             DECIMAL(18, 4) NOT NULL          COMMENT "单价"
    ,total_price       DECIMAL(18, 4) NOT NULL          COMMENT "稿酬金额"
    ,currency_type     SMALLINT       NOT NULL          COMMENT "货币类型 1：人民币 2：美元"
    ,pay_type          BIGINT         NOT NULL          COMMENT "支付方式：0：银行卡、1：Paypal、2：Payoneer、3：Upwork、4：Freelancer、5：Fiverr、6：银行卡（华美）"
    ,remuneration_time DATETIME       NOT NULL          COMMENT "稿酬生成时间"
    ,bill_date         BIGINT         NOT NULL          COMMENT "账期"
    ,st                SMALLINT       NOT NULL          COMMENT "状态 0:专员未审核、1：专员待定、2：专员审核通过、3：专员审核拒绝、4：经理审核通过、5：经理审核拒绝、6：财务审核通过、7：财务审核拒绝"
    ,pay_st            SMALLINT       NOT NULL          COMMENT "打款状态 0：待处理、1：已打款、2：不打款"
    ,pay_time          DATETIME                         COMMENT "打款时间"
    ,remark_by_first   STRING                           COMMENT "专员审核备注"
    ,remark_by_second  STRING                           COMMENT "经理审核备注"
    ,remark_by_third   STRING                           COMMENT "财务审核备注"
    ,remark_by_pay     STRING                           COMMENT "付款备注"
    ,create_time       DATETIME                         COMMENT "创建时间"
    ,update_time       DATETIME                         COMMENT "更新时间"
    ,remuneration_type SMALLINT       NOT NULL          COMMENT "稿酬类型 1实时稿酬、2附加稿酬、3奖金包"
    ,price_type        SMALLINT       NOT NULL          COMMENT "单价计算方式 1：份数 、2：千字价"
    ,source_book_name  STRING                           COMMENT "输入书籍名称"
    ,from_language     SMALLINT       NOT NULL          COMMENT "来源语言"
    ,source_book_id    BIGINT         NOT NULL          COMMENT "输入书籍Id"
    ,pay_account       STRING                           COMMENT "支付账号"
    ,bank_name         STRING                           COMMENT "银行名称"
    ,account_name      STRING                           COMMENT "银行账号名称"
    ,reason_type       STRING                           COMMENT "附加稿酬原因类型"
    ,bank_sub_branch   STRING                           COMMENT "银行支行"
    ,payment_type      SMALLINT                         COMMENT "付款方式：0:未选择,1:平台，2：转账"
    ,book_type         SMALLINT       NOT NULL          COMMENT "书籍类型"
    ,undo_reason       STRING                           COMMENT "撤销原因"
    ,object_book_type  INT                              COMMENT "图书书籍类型,0-网文 1-短剧"
    ,is_cost_rate      INT                              COMMENT "是否计算成本率,0-否 1-是"
    ,etl_time          DATETIME                         COMMENT "数据清洗时间"
    ,INDEX index_to_language (to_language) USING BITMAP COMMENT '目标语言索引'
)
PRIMARY KEY(dt, auto_id, to_language, book_id, author_id)
COMMENT "内容域翻译书籍稿酬+附加稿酬+奖金包明细表"
PARTITION BY RANGE(dt)
(PARTITION p202510 VALUES LESS THAN ("2025-11-01"))
DISTRIBUTED BY HASH(to_language, book_id, author_id) BUCKETS 1
PROPERTIES (
    "replication_num" = "3",
    "bloom_filter_columns" = "dt, book_id, author_id",
    "dynamic_partition.enable" = "true",
    "dynamic_partition.time_unit" = "Month",
    "dynamic_partition.time_zone" = "Asia/Shanghai",
    "dynamic_partition.start" = "-2147483648",
    "dynamic_partition.end" = "3",
    "dynamic_partition.prefix" = "p",
    "dynamic_partition.buckets" = "1",
    "dynamic_partition.history_partition_num" = "0",
    "dynamic_partition.start_day_of_month" = "1",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "LZ4"
)
;