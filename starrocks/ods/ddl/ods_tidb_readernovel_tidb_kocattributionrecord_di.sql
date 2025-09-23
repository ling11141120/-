----------------------------------------------------------------
-- 目标表： ods.ods_tidb_readernovel_tidb_kocattributionrecord_di
-- 来源实例： hk-koc-mysql-slave
-- 来源表： 
--        海阅
--        readernovel_tidb_fr.kocattributionrecord
--        readernovel_tidb_pt.kocattributionrecord
--        readernovel_tidb_ft.kocattributionrecord
--        readernovel_tidb_en.kocattributionrecord
--        readernovel_tidb_ru.kocattributionrecord
--        readernovel_tidb_sp.kocattributionrecord
--        readernovel_tidb_jp.kocattributionrecord
--        readernovel_tidb_id.kocattributionrecord
--        readernovel_tidb_th.kocattributionrecord
--        readernovel_tidb_and2.kocattributionrecord
--        readernovel_tidb_cd2.kocattributionrecord
--        海剧
--        short_video_log.kocattributionrecord
-- 来源负责： 黄文
-- 采集工具： SeaTunnel
-- 开发人： qhr
-- 开发日期： 2025-09-11
----------------------------------------------------------------

DROP TABLE IF EXISTS ods.ods_tidb_readernovel_tidb_kocattributionrecord_di;
CREATE TABLE ods.ods_tidb_readernovel_tidb_kocattributionrecord_di (
     Id              BIGINT(20)     NOT NULL                  COMMENT "自增id"
    ,product_id      INT(11)        NOT NULL                  COMMENT "产品id"
    ,Pid             BIGINT(20)     NOT NULL                  COMMENT "用户id"
    ,Mt              INT(11)                                  COMMENT "mt"
    ,Core            INT(11)                                  COMMENT "core"
    ,Chl             VARCHAR(65533)                           COMMENT "渠道"
    ,CurrentLanguage INT(11)                                  COMMENT "语言"
    ,BeginTime       DATETIME                                 COMMENT "开始时间"
    ,EndTime         DATETIME                                 COMMENT "结束时间"
    ,ResourceId      BIGINT(20)                               COMMENT "书籍id"
    ,KocText         VARCHAR(65533)                           COMMENT "口令"
    ,AdId            VARCHAR(65533)                           COMMENT "adid"
    ,CreateTime      DATETIME                                 COMMENT "创建时间"
    ,UpdateTime      DATETIME                                 COMMENT "更新时间"
    ,sr_createtime   DATETIME       DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间"
    ,sr_updatetime   DATETIME       DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间"
)
PRIMARY KEY (Id, product_id)
COMMENT "海阅海剧-用户koc归因记录"
DISTRIBUTED BY HASH (Id, product_id) BUCKETS 6
PROPERTIES (
    "replication_num" = "3",
    "bloom_filter_columns" = "Pid",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "storage_medium" = "SSD",
    "compression" = "ZSTD"
)
;