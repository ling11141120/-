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

drop table if exists ods.ods_tidb_readernovel_tidb_kocattributionrecord_di;
create table ods.ods_tidb_readernovel_tidb_kocattributionrecord_di (
     Id              bigint         not null                  comment "自增id"
    ,product_id      int            not null                  comment "产品id"
    ,Pid             bigint         not null                  comment "用户id"
    ,Mt              int                                      comment "mt"
    ,Core            int                                      comment "core"
    ,Chl             string                                   comment "渠道"
    ,CurrentLanguage int                                      comment "语言"
    ,BeginTime       datetime                                 comment "开始时间"
    ,EndTime         datetime                                 comment "结束时间"
    ,ResourceId      bigint                                   comment "书籍id"
    ,KocText         string                                   comment "口令"
    ,AdId            string                                   comment "adid"
    ,CreateTime      datetime                                 comment "创建时间"
    ,UpdateTime      datetime                                 comment "更新时间"
    ,sr_createtime   datetime       default current_timestamp comment "starrocks数据注入时间"
    ,sr_updatetime   datetime       default current_timestamp comment "starrocks数据更新时间"
)
primary key (Id, product_id)
comment "海阅海剧-用户koc归因记录"
distributed by hash (Id, product_id) buckets 6
properties (
    "replication_num" = "3",
    "bloom_filter_columns" = "Pid",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "storage_medium" = "SSD",
    "compression" = "ZSTD"
)
;