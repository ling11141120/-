----------------------------------------------------------------
-- 目标表：ods.ods_tidb_cdmoney_report_tidb_cn_youtubechannel_detail
-- 来源实例： old_tidb_source
-- 来源表： cdmoney_report_tidb_cn.youtubechannel_detail
-- 来源负责：蔡扶炜
-- 采集工具：极光-定时链路
-- 开发人：xjc
-- 创建日期：2025-10-22
----------------------------------------------------------------

drop table if exists ods.ods_tidb_cdmoney_report_tidb_cn_youtubechannel_detail;
create table if not exists ods.ods_tidb_cdmoney_report_tidb_cn_youtubechannel_detail (
    Id                  int              not null                     comment "id"
   ,infoid              int              null                         comment "infoid"
   ,channel_id          varchar(1020)    not null                     comment "渠道id"
   ,channename          varchar(1020)    null                         comment "渠道名称 展示用的"
   ,channename_api      varchar(1020)    null                         comment "渠道名称 api上取的"
   ,subscriber_count    bigint           null                         comment "订阅人数"
   ,view_count          bigint           null                         comment "观看次数"
   ,updatetime          datetime         null                         comment "更新时间"
   ,sr_createtime       datetime         default current_timestamp    comment "starrocks入库时间"
   ,sr_updatetime       datetime         default current_timestamp    comment "starrocks数据更新时间"
)
primary key (id)
comment "youtube渠道详情表，author:272516"
distributed by hash(id)
properties (
    "replication_num" = "3",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "lz4"
)
;