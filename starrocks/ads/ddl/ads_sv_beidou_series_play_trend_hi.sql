drop table if exists ads.ads_sv_beidou_series_play_trend_hi;
create table ads.ads_sv_beidou_series_play_trend_hi
(
    dt                  date         not null comment "日期"
    ,hour_time           datetime     not null comment "小时时间"
    ,core                int          not null comment "Core"
    ,language_code       int          not null comment "语言编码"
    ,series_id           bigint       not null comment "短剧ID"
    ,language_name       varchar(100)          comment "语言名称"
    ,series_code         varchar(100)          comment "短剧代号"
    ,series_name         varchar(255)          comment "短剧名称"
    ,day_time            date                  comment "天"
    ,month_time          date                  comment "月(yyyy-MM-01)"
    ,play_count          bigint                comment "播放量"
    ,etl_time            datetime              comment "数据清洗时间"
) engine = OLAP
    primary key(dt, hour_time, core, language_code, series_id)
comment "北斗短剧-播放量趋势表(小时粒度)"
partition by date_trunc("day", dt)
distributed by hash(dt, core, language_code, series_id) buckets 3
properties (
    "replication_num" = "3",
    "enable_persistent_index" = "true",
    "in_memory" = "false",
    "replicated_storage" = "true",
    "compression" = "LZ4"
);