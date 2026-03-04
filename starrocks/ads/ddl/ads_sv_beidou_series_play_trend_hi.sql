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


-- 已有表增加字段时执行(仅运行一次)
alter table ads.ads_sv_beidou_series_play_trend_hi
    add column series_level       int comment "短剧等级(1.S 2.A 3.B 4.C)" after series_name,
    add column work_type          int comment "作品类型(1.男频 2.女频 3.双番)" after series_level,
    add column local_type         int comment "类型 (1.本土剧 2.译制剧 4.动态漫)" after work_type,
    add column local_sub_type     int comment "短剧子类型(0.默认 1.本土剧-AI短剧)" after local_type,
    add column audio_type         int comment "音轨类型(1.原声剧 2.配音剧)" after local_sub_type,
    add column dubbed_type        int comment "配音类型(1.人工配音 2.AI配音)" after audio_type
;
