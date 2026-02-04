drop table if exists ads.ads_sv_beidou_series_source_stat_di;
create table ads.ads_sv_beidou_series_source_stat_di
(
     dt                    date     not null comment "日期"
    ,core                  int      not null comment "Core"
    ,language_code         int      not null comment "语言编码"
    ,series_id             bigint   not null comment "短剧ID"
    ,source                varchar(255)      comment "来源"
    ,language_name         varchar(100)      comment "语言名称"
    ,series_code           varchar(100)      comment "短剧代号"
    ,series_name           varchar(255)      comment "短剧名称"
    ,startwatching_num     bigint            comment "观看量"
    ,exposure_num          bigint            comment "曝光量"
    ,etl_time              datetime          comment "数据清洗时间"
) engine = OLAP
    primary key(dt, core, language_code, series_id, source)
comment "北斗短剧来源统计表"
partition by date_trunc("day", dt)
DISTRIBUTED BY HASH(dt, core, language_code, series_id) buckets 2
properties (
    "replication_num" = "3",
    "enable_persistent_index" = "true",
    "in_memory" = "false",
    "replicated_storage" = "true",
    "compression" = "LZ4"
);