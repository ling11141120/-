drop table if exists ads.ads_sv_new_series_rank_di_west5;
create table ads.ads_sv_new_series_rank_di_west5 (
    dt                 date         not null comment "统计日期"
    , core             int          not null comment "core"
    , language_code    int          not null comment "语言编码"
    , series_id        bigint       not null comment "短剧ID"
    , period_type      varchar(10)  not null comment "统计周期(24h/36h/14d/30d)"
    , publish_time     datetime              comment "上架时间"
    , language_name    varchar(100)          comment "语言名称"
    , series_code      varchar(100)          comment "短剧代号"
    , series_name      varchar(255)          comment "短剧名称"
    , series_new_index bigint                comment "新剧指数"
    , series_new_score int                   comment "新剧得分"
    , etl_time         datetime              comment "清洗时间"
)
engine = OLAP
primary key(dt, core, language_code, series_id, period_type)
comment "短剧新剧榜_西五区"
partition by date_trunc("day", dt)
distributed by hash(core, language_code, period_type, series_id) buckets 2
properties (
    "replication_num" = "3",
    "partition_live_number" = "31",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "LZ4"
)
;

