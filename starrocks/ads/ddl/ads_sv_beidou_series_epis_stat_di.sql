
drop table if exists ads.ads_sv_beidou_series_epis_stat_di;
create table ads.ads_sv_beidou_series_epis_stat_di
(
    dt                      date         not null comment "日期"
    ,core                    int          not null comment "Core"
    ,acquisition_source_cd   int          not null comment "引流来源(1:引流, 0:非引流)"
    ,language_code           int          not null comment "语言编码"
    ,series_id               bigint       not null comment "短剧ID"
    ,epis_id                 bigint       not null comment "单集ID"
    ,epis_num                int                   comment "分集序号"
    ,language_name           varchar(100)          comment "语言名称"
    ,series_code             varchar(100)          comment "短剧代号"
    ,series_name             varchar(255)          comment "短剧名称"
    -- 续看指标 (bitmap)
    ,next_epis_user          bitmap                comment "下一集续看用户数"
    ,epis_complete_user      bitmap                comment "本集完播用户数(进度>=95%)"
    -- 观看进度指标
    ,epis_total_watch_duration   bigint            comment "本集观看进度总时长(秒)"
    ,epis_duration               int               comment "本集总时长(秒)"
    -- 跳出用户 (bitmap)
    ,exit_0_5s_user          bitmap                comment "0~5s跳出用户"
    ,exit_5_10s_user         bitmap                comment "5~10s跳出用户"
    ,exit_10_20s_user        bitmap                comment "10~20s跳出用户"
    ,exit_20_30s_user        bitmap                comment "20~30s跳出用户"
    ,exit_30_40s_user        bitmap                comment "30~40s跳出用户"
    ,exit_40_50s_user        bitmap                comment "40~50s跳出用户"
    ,exit_50_60s_user        bitmap                comment "50~60s跳出用户"
    ,exit_60s_plus_user      bitmap                comment ">=60s跳出用户"
    -- 本集总观看用户 (bitmap)
    ,epis_watch_user         bitmap                comment "本集观看总用户"
    ,etl_time                datetime              comment "数据清洗时间"
) engine = OLAP
    primary key(dt, core, acquisition_source_cd, language_code, series_id, epis_id)
comment "北斗短剧-每集观看数据统计表"
partition by date_trunc("day", dt)
distributed by hash(dt, core, acquisition_source_cd, language_code, series_id, epis_id) buckets 2
properties (
    "replication_num" = "3",
    "enable_persistent_index" = "true",
    "in_memory" = "false",
    "replicated_storage" = "true",
    "compression" = "LZ4"
);
