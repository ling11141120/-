----------------------------------------------------------------
-- 目标表：ods.ods_edit_book_RemunerationDetail
-- 来源实例：old_tidb_source
-- 来源表：shuangwen_tidb_en.RemunerationDetail
--        fanyidb_tidb.RemunerationDetail
--        shuangwen_tidb_sp.RemunerationDetail
-- 来源负责：
-- 采集工具：极光-定时链路
-- 开发人：wx
-- 创建日期：2025-09-24
----------------------------------------------------------------
DROP TABLE IF EXISTS ods.ods_edit_book_RemunerationDetail;
CREATE TABLE IF NOT EXISTS ods.ods_edit_book_RemunerationDetail (
     dt               date          NOT NULL                     COMMENT "createtime 分区"
    ,Productid        int(11)       NOT NULL                     COMMENT "产品id"
    ,Id               bigint(20)    NOT NULL                     COMMENT "自增id"
    ,AuthorId         bigint(20)                                 COMMENT "作者id"
    ,RoleType         int(11)                                    COMMENT "角色类型1:译员、2:外籍一校、3:二校、4:三校、5:PM、6:初译审核、7:初校审核、8:国内测试稿审核
                                                                         、9:国外测试稿审核、10:三校抽查、11:一校抽查、12:质检抽查"
    ,UnitPrice        decimal(18, 2)                             COMMENT "单价"
    ,ChapterId        int(11)                                    COMMENT "章节id"
    ,bookId           bigint(20)                                 COMMENT "书籍ID"
    ,CreateTime       datetime                                   COMMENT "创建时间"
    ,ToLanguage       int(11)                                    COMMENT "目标书籍语言"
    ,FontLength       int(11)                                    COMMENT "字数"
    ,CurrencyType     int(11)                                    COMMENT "货币类型 1:人民币 2:美元"
    ,UndoReason       varchar(65533)                             COMMENT "撤销原因"
    ,sr_createtime    datetime      DEFAULT CURRENT_TIMESTAMP    COMMENT "starrocks数据注入时间"
    ,sr_updatetime    datetime      DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间"
  INDEX index_Productid (Productid) USING BITMAP               COMMENT '产品id索引'
) 
PRIMARY KEY(dt, Productid, Id)
COMMENT "稿酬明细"
-- 增加分桶数量，提高并发处理能力
DISTRIBUTED BY HASH(dt, Productid, Id) BUCKETS 8
PROPERTIES (
    "replication_num" = "3",
    "bloom_filter_columns" = "CreateTime, bookId",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "LZ4",
    -- 添加统计信息自动收集配置，提升查询性能
    "auto_increment" = "true",
    "statistics_autogather" = "true"
)
;