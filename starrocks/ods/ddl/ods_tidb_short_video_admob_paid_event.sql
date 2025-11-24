----------------------------------------------------------------
-- 目标表： ods_tidb_short_video_admob_paid_event
-- 来源实例： old_tidb_source
-- 来源表： short_video_log.admob_paid_event_*(每月一个表)
-- 来源负责： 
-- 采集工具： SeaTunnel
-- 开发人： qhr
-- 开发日期： 2025-11-23
----------------------------------------------------------------

drop table if exists ods.ods_tidb_short_video_admob_paid_event;
create table ods.ods_tidb_short_video_admob_paid_event (
     Id                        bigint(20)    not null                                   comment "唯一ID"
    ,CreateTime                datetime      not null default "1970-01-01 00:00:00.000" comment "创建时间"
    ,AccountId                 bigint(20)                                               comment "账户id"
    ,PrecisionType             int(11)                                                  comment "精准投放类型"
    ,ValueMicros               double                                                   comment "值"
    ,CurrencyCode              varchar(300)                                             comment "货币代码"
    ,AdUnitId                  varchar(300)                                             comment "广告id"
    ,MediationAdapterClassName varchar(300)                                             comment "媒体适配器类名"
    ,UpdateTime                datetime      default "1970-01-01 00:00:00.000"          comment "更新时间"
    ,Userid                    bigint(20)    default "0"                                comment "用户ID"
    ,Mt                        varchar(150)  default ""                                 comment "类型"
    ,Appver                    varchar(150)  default ""                                 comment "版本号"
    ,Appid                     varchar(50)   default "683001001"                        comment "应用ID"
    ,Chl                       varchar(655)  default ""                                 comment "渠道"
    ,Langid                    varchar(150)  default ""                                 comment "语言ID"
    ,position                  int(11)                                                  comment "广告位置"
    ,adchannel                 varchar(500)                                             comment "广告商，218 max广告版本开始上报，旧版本为空"
    ,adsPlatform               varchar(500)                                             comment "广告商，218 max广告版本开始上报，旧版本为空"
    ,RevenuePrecision          varchar(500)                                             comment "精准投放类型(String)"
    ,core                      int(11)                                                  comment ""
    ,mainstrategyid            varchar(300)                                             comment "主策略id"
    ,eventstrategyid           varchar(300)                                             comment "广告策略id"
    ,sr_createtime             datetime      default current_timestamp                  comment ""
    ,sr_updatetime             datetime                                                 comment ""
)
primary key(Id, CreateTime)
distributed by hash(Id, CreateTime) buckets 150
properties (
    "replication_num" = "3",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "LZ4"
)
;