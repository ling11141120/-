----------------------------------------------------------------
-- 目标表：ods.ods_tidb_cdmoney_report_tidb_cn_youtube_info
-- 来源实例： old_tidb_source
-- 来源表： cdmoney_report_tidb_cn.youtube_info
-- 来源负责：蔡扶炜
-- 采集工具：SeaTunnel
-- 开发人：xjc
-- 创建日期：2026-04-01
----------------------------------------------------------------
drop table if exists ods.ods_tidb_cdmoney_report_tidb_cn_youtube_info;
create table ods.ods_tidb_cdmoney_report_tidb_cn_youtube_info (
    id               int         not null                    comment "Id"
   ,email            varchar(765)                            comment "邮箱账号"
   ,channename       varchar(765)                            comment "渠道名称"
   ,authorization    varchar(6000)                           comment "authorization"
   ,refreshtoken     varchar(765)                            comment "refreshtoken"
   ,addtime          datetime                                comment "添加时间"
   ,cilentid         varchar(765)                            comment "cilentid"
   ,status           int                                     comment "1启用"
   ,sr_createtime    datetime    default current_timestamp   comment "starrocks入库时间"
   ,sr_updatetime    datetime    default current_timestamp   comment "starrocks数据更新时间"
)
primary key (id)
comment "youtube配置信息，author:272516"
distributed by hash(id)
properties (
    "replication_num" = "3",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "lz4"
)
;