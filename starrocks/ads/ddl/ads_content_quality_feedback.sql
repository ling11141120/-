DROP TABLE IF EXISTS ads.ads_content_quality_feedback;
CREATE TABLE ads.ads_content_quality_feedback (
     md5_key        STRING        NOT NULL COMMENT "唯一主键"
    ,dt             DATE          NOT NULL COMMENT "统计日期（完成时间）"
    ,site_id        BIGINT(20)    NOT NULL COMMENT "语言ID"
    ,author_id      BIGINT(20)             COMMENT "译员ID"
    ,role_type      BIGINT(20)    NOT NULL COMMENT "角色类型1：译员、2：外籍一校、3：二校、4：三校、5：PM、6：初译审核、7：初校审核、8：国内测试稿审核、9：国外测试稿审核、10：三校抽查、11：一校抽查、12：质检抽查 18:词典创建"
    ,check_model    BIGINT(20)    NOT NULL COMMENT "抽查模块  1:被二校&一校审核反馈的质检  2:被二校要求重校的一校章节  3:修改率异常高一校 4:被二校打低分的一校 5:修改率异常低二校 6:全职质检/二校质量分保障"
    ,pen_name       STRING                 COMMENT "译名"
    ,check_person   STRING                 COMMENT "抽查人"
    ,checked_person STRING                 COMMENT "被抽查人"
    ,book_id        BIGINT(20)             COMMENT "书籍ID"
    ,book_name      VARCHAR(2000)          COMMENT "书名"
    ,chapter_id     BIGINT(20)             COMMENT "章节ID"
    ,chapter_name   VARCHAR(2000)          COMMENT "章节名"
    ,etl_time       DATETIME      NOT NULL COMMENT ""
)
PRIMARY KEY(md5_key)
DISTRIBUTED BY HASH(md5_key) BUCKETS 14
PROPERTIES (
    "replication_num" = "3",
    "in_memory" = "false",
    "enable_persistent_index" = "false",
    "replicated_storage" = "true",
    "compression" = "LZ4"
)
;