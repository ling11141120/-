DROP TABLE IF EXISTS ads.ads_bi_ss_book_anal_rpt;
CREATE TABLE IF NOT EXISTS ads.ads_bi_ss_book_anal_rpt (
     dt              DATE          NOT NULL COMMENT '日期'
    ,book_id         BIGINT        NOT NULL COMMENT '书籍id'
    ,lang_cd         INT                    COMMENT '语言编码'
    ,lang_name       VARCHAR(50)            COMMENT '语言名称'
    ,book_cd         VARCHAR(1000)          COMMENT '书籍代号'
    ,book_zh_name    VARCHAR(300)           COMMENT '书籍中文名称'
    ,book_stat       INT                    COMMENT '书籍状态'
    ,pub_dt          DATETIME               COMMENT '上架日期'
    ,bgn_trl_dt      DATETIME               COMMENT '开始翻译日期'
    ,cmp_trl_dt      DATETIME               COMMENT '完成翻译日期'
    ,trl_days        INT                    COMMENT '翻译天数'
    ,trl_prg         VARCHAR(50)            COMMENT '翻译进度'
    ,trl_emp         BIGINT                 COMMENT '译员id'
    ,trl_emp_name    STRING                 COMMENT '译员名称'
    ,mc_trl_wc       DECIMAL(10,0)          COMMENT '机翻字数'
    ,qa_wc           DECIMAL(10,0)          COMMENT '质检字数'
    ,pub_wc          DECIMAL(10,0)          COMMENT '发布字数'
    ,ttl_chap_num    DECIMAL(4,0)           COMMENT '总章节数'
    ,pub_chap        DECIMAL(4,0)           COMMENT '发布章节'
    ,mat_is_cmp      INT                    COMMENT '物料是否齐全'
    ,ast_cmp_dt      DATETIME               COMMENT '素材完成日期'
    ,rev_sc_dt       DATETIME               COMMENT '审核抽查日期'
    ,zhtw_sig_ctr_dt DATETIME               COMMENT '繁体签约日期'
    ,ph2_test_bgn_dt DATETIME               COMMENT '第二阶段测试开始日期'
    ,ph1_test_bgn_dt DATETIME               COMMENT '第一阶段测试开始日期'
    ,trl_cost_mon    DECIMAL(10,4)          COMMENT '本月翻译成本'
    ,amt_mon         DECIMAL(10,4)          COMMENT '本月收入'
    ,amt_30d         DECIMAL(10,4)          COMMENT '近30天收入'
    ,amt_7d          DECIMAL(10,4)          COMMENT '近7天收入'
)
PRIMARY KEY (dt, book_id)
COMMENT 'bi-短篇书籍分析报表'
PARTITION BY DATE_TRUNC('month', dt)
DISTRIBUTED BY HASH(dt, product_id)
PROPERTIES (
    "replication_num" = "3",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "LZ4"
)
;