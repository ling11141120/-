----------------------------------------------------------------
-- 目标表： ods.ods_tidb_realtimecrowd_sv_user_metrics
-- 来源实例： old_tidb_source
-- 来源表： realtimecrowd_sv.user_metrics
-- 来源负责：                                                                                                                                                                                                                                                                                                                -- 采集工具： SeaTunnel
-- 开发人： tyg
-- 开发日期： 2026-05-07
----------------------------------------------------------------

drop table if exists ods.ods_tidb_realtimecrowd_sv_user_metrics;
create table ods.ods_tidb_realtimecrowd_sv_user_metrics (
     id                   bigint      not null                        comment "用户Id"
    ,metrics              json        not null                        comment "指标数据"
    ,update_time          datetime                                    comment "更新时间"
    ,EtlTime              datetime     default '2026-05-01 00:00:00'  comment "首次全量etl时间"
    ,sr_createtime        datetime    default current_timestamp       comment "starrocks数据注入时间"
    ,sr_updatetime        datetime    default current_timestamp       comment "starrocks数据更新时间"
)
primary key(id)
comment "人群包用户指标表"
distributed by hash(id) buckets 10
properties (
    "replication_num" = "3"
   ,"in_memory" = "false"
   ,"enable_persistent_index" = "true"
   ,"replicated_storage" = "true"
   ,"compression" = "LZ4"
)
;