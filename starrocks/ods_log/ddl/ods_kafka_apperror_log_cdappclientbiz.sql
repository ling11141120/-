----------------------------------------------------------------
-- 目标表：ods_log.ods_kafka_apperror_log_cdappclientbiz
-- 来源实例：埋点分组13
-- 来源表：data.data_decode.event=CdAppClientBiz
-- 来源负责人：xcl
-- 开发人：050239
-- 开发日期：2026-05-19
----------------------------------------------------------------

create table if not exists ods_log.ods_kafka_apperror_log_cdappclientbiz (
     dt              date     not null comment "日期"
    ,track_id        string            comment "track_id"
    ,rid             string            comment "rid"
    ,project         string            comment "project"
    ,event_tm        datetime          comment "时间"
    ,type            string            comment "type"
    ,distinct_id     string            comment "distinct_id"
    ,event           string            comment "事件"
    ,login_id        string            comment "login_id"
    ,bizType         string            comment "错误类型"
    ,bizAdsType      string            comment "错误广告类型"
    ,bizMsg          string            comment "内容"
    ,bizErrorMsg     string            comment "报错内容"
    ,bizErrorCode    string            comment "报错code"
    ,bizUrl          string            comment "bizUrl"
    ,bizErrorMessage string            comment "bizErrorMessage "
    ,is_first_day    string            comment "是否首次"
    ,os              string            comment "os系统"
    ,lib             string            comment "系统"
    ,lib_version     string            comment "系统版本"
    ,model           string            comment "设备型号"
    ,brand           string            comment "设备品牌"
    ,app_version     string            comment "app版本"
    ,app_id          string            comment "appid"
    ,app_name        string            comment "app名称"
    ,appCoreVer      string            comment "core"
    ,appLangId       string            comment "app语言"
    ,appProductX     string            comment "appProductX"
    ,app_channel     string            comment "app_channel"
    ,appChannel      string            comment "渠道"
    ,deviceLang      string            comment "设备语言"
    ,appId           string            comment "appId"
    ,app_core_ver    string            comment "core"
    ,app_product_id  string            comment "app_product_id"
    ,referrer_title  string            comment "页面"
    ,device_id       string            comment "设备id"
    ,bizBookId       string            comment "书籍id"
    ,bizbookID2      string            comment "书籍id,来自bizbookID"
    ,bizChapterId    string            comment "章节id"
    ,etl_tm          datetime          comment "清洗时间"
)
duplicate key(dt)
comment "event=CdAppClientBiz 客户端上报"
partition by range(dt)
(partition p20260519 values less than ("2026-05-20"))
distributed by hash(dt) buckets 3
properties (
    "replication_num" = "2",
    "dynamic_partition.enable" = "true",
    "dynamic_partition.time_unit" = "DAY",
    "dynamic_partition.time_zone" = "Asia/Shanghai",
    "dynamic_partition.start" = "-30",
    "dynamic_partition.end" = "3",
    "dynamic_partition.prefix" = "p",
    "dynamic_partition.buckets" = "3",
    "dynamic_partition.history_partition_num" = "0",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "ZSTD"
)
;
