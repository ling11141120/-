drop table if exists ads.ads_sv_beidou_series_daily_stat_di;
create table ads.ads_sv_beidou_series_daily_stat_di
(
    dt                          date         not null comment "日期"
    ,core                        int          not null comment "Core"
    ,language_code               int          not null comment "语言编码"
    ,series_id                   bigint       not null comment "短剧ID"
    ,language_name               varchar(100)          comment "语言名称"
    ,series_code                 varchar(100)          comment "短剧代号"
    ,series_name                 varchar(255)          comment "短剧名称"
    ,all_epis                    int                   comment "短剧集数"
    ,cover_url                   varchar(512)          comment "短剧封面"
    ,publish_time                datetime              comment "发布时间"
    ,series_duration             bigint                comment "短剧总时长(秒)"
    ,first_pay_epis_num          int                   comment "第几集开始收费"
    -- 点击曝光指标
    ,click_num                   bigint                comment "短剧点击量"
    ,exposure_num                bigint                comment "短剧曝光量"
    -- 首集完播指标 (bitmap)
    ,first_epis_complete_user    bitmap                comment "首集完播观众数(进度>=95%)"
    ,first_epis_total_user       bitmap                comment "首集总观众数"
    -- 流失率指标 (bitmap)
    ,loss_10s_user               bitmap                comment "<=10s流失用户数"
    -- 完播率指标 (bitmap)
    ,complete_10min_user         bitmap                comment "观看>=10分钟用户数"
    ,complete_30min_user         bitmap                comment "观看>=30分钟用户数"
    ,complete_60min_user         bitmap                comment "观看>=60分钟用户数"
    ,complete_series_user        bitmap                comment "整剧完播用户数(最后一集进度>=95%)"
    -- 播放指标
    ,total_play_epis_count       bigint                comment "总的播放集数"
    ,total_play_duration         bigint                comment "总播放时长(秒)"
    ,play_user                   bitmap                comment "播放总用户数"
    ,play_count                  bigint                comment "播放量"
    ,etl_time                    datetime              comment "数据清洗时间"
) engine = OLAP
    primary key(dt, core, language_code, series_id)
comment "北斗短剧-每日短剧信息统计表"
partition by date_trunc("day", dt)
distributed by hash(core, language_code, series_id) buckets 2
properties (
    "replication_num" = "3",
    "enable_persistent_index" = "true",
    "in_memory" = "false",
    "replicated_storage" = "true",
    "compression" = "LZ4"
);

-- 已有表增加字段时执行(仅运行一次)
-- ALTER TABLE ads.ads_sv_beidou_series_daily_stat_di
-- ADD COLUMN first_pay_epis_num int comment "第几集开始收费"
-- AFTER series_duration;