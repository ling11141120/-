----------------------------------------------------------------
-- 目标表：ods.ods_tidb_cdmoney_report_tidb_cn_youtubechannel_report
-- 来源实例： old_tidb_source
-- 来源表： cdmoney_report_tidb_cn.youtubechannel_report
-- 来源负责：蔡扶炜
-- 采集工具：极光-定时批量
-- 开发人：xjc
-- 创建日期：2025-10-22
----------------------------------------------------------------
drop table if exists ods.ods_tidb_cdmoney_report_tidb_cn_youtubechannel_report;
create table if not exists ods.ods_tidb_cdmoney_report_tidb_cn_youtubechannel_report (
    id                          int                 not null                    comment "id"
   ,infoid                      int                 null                        comment "infoid"
   ,channel_id                  varchar(1020)       null                        comment "渠道id"
   ,dt                          date                not null                    comment "时间"
   ,dtstr                       varchar(1020)       null                        comment "时间"
   ,estimated_revenue           decimal(18,2)       null                        comment "总收入"
   ,estimated_ad_revenue        decimal(18,2)       null                        comment "广告收入"
   ,estimated_vip_revenue       decimal(18,2)       null                        comment "会员收入（近似值）"
   ,estimated_minuteswatched    bigint              null                        comment "观看时长 （分钟）"
   ,updatetime                  datetime            null                        comment "更新时间"
   ,sr_createtime               datetime            default current_timestamp   comment "starrocks入库时间"
   ,sr_updatetime               datetime            default current_timestamp   comment "starrocks数据更新时间"
)
primary key (id)
comment "YouTubeChannel报表,author:272516"
distributed by hash(id)
properties (
    "replication_num" = "3",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "lz4"
)
;