----------------------------------------------------------------
-- 目标表：ods_log.ods_tidb_readerlog_log_installreferrerlog
-- 来源实例：old_tidb_source
-- 来源表：
--        readerlog_pt.Log_InstallReferrerLog
--        readerlog_ft.Log_InstallReferrerLog
--        readerlog_en.Log_InstallReferrerLog
--        readerlog_ru.Log_InstallReferrerLog
--        readerlog_sp.Log_InstallReferrerLog
--        readerlog_jp.Log_InstallReferrerLog
--        readerlog_id.Log_InstallReferrerLog
--        readerlog_th.Log_InstallReferrerLog
--        readerlog_and2_sync.Log_InstallReferrerLog
--        readerlog_cd2_sync.Log_InstallReferrerLog
-- 来源负责人：串总
-- 开发人：qhr
-- 开发日期：2026-06-22
----------------------------------------------------------------

create table if not exists ods.ods_tidb_readerlog_log_installreferrerlog (
     product_id       int          not null                  comment "产品id"
    ,Id               bigint       not null                  comment "自增id"
    ,CreateTime       datetime                               comment "活动时间"
    ,AppId            int                                    comment "应用程序id"
    ,Appver           varchar(255)                           comment "版本号"
    ,Chl              varchar(755)                           comment "渠道值"
    ,Mt               int                                    comment "平台（终端）"
    ,Core             int                                    comment "corever包体"
    ,RowData          string                                 comment "存放广告信息"
    ,DecryptData      string                                 comment "存放广告信息"
    ,UniqueCdReaderId varchar(255)                           comment "唯一id"
    ,CurrentLanguage  int                                    comment "投放语言"
    ,SendToAds        int          default "0"               comment ""
    ,SdkType          int                                    comment "sdk类型"
    ,UacStatus        int                                    comment "uac状态"
    ,sr_createtime    datetime     default current_timestamp comment "starrocks数据注入时间"
    ,sr_updatetime    datetime     default current_timestamp comment "starrocks数据更新时间"
)
primary key(product_id, id)
comment "阅读-记录在站外针对全量用户进行推书，用户点击链接（UTM链接中带有渠道名和BOOKID）的log数据"
distributed by hash(product_id, id) buckets 6
properties (
    "replication_num" = "3",
    "bloom_filter_columns" = "CreateTime",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "storage_medium" = "SSD",
    "compression" = "ZSTD"
)
;
