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
    ,series_level                int                   comment "短剧等级(1.S 2.A 3.B 4.C)"
    ,series_level_name           varchar(100)          comment "短剧等级名称"
    ,series_type_labels          varchar(1000)         comment "分类标签集合(按标签名称升序用逗号拼接)"
    ,work_type                   int                   comment "作品类型(1.男频 2.女频 3.双番)"
    ,work_type_name              varchar(100)          comment "作品类型名称"
    ,local_type                  int                   comment "类型(1.本土剧 2.译制剧 4.动态漫)"
    ,local_type_name             varchar(100)          comment "类型名称"
    ,local_sub_type              int                   comment "短剧子类型(0.没有意义 1.本土剧-AI短剧)"
    ,local_sub_type_name         varchar(100)          comment "短剧子类型名称"
    ,audio_type                  int                   comment "音轨类型(1.原声剧 2.配音剧)"
    ,audio_type_name             varchar(100)          comment "音轨类型名称"
    ,dubbed_type                 int                   comment "配音类型(0.没有意义 1.人工配音 2.AI配音)"
    ,dubbed_type_name            varchar(100)          comment "配音类型名称"
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
    ,exit_5s_user                bitmap                comment "<=5s跳出用户数"
    -- 完播率指标 (bitmap)
    ,complete_10s_user           bitmap                comment "观看>=10秒用户数"
    ,complete_10min_user         bitmap                comment "观看>=10分钟用户数"
    ,complete_30min_user         bitmap                comment "观看>=30分钟用户数"
    ,complete_60min_user         bitmap                comment "观看>=60分钟用户数"
    ,complete_series_user        bitmap                comment "整剧完播用户数(最后一集进度>=95%)"
    -- 播放指标
    ,total_play_epis_count       bigint                comment "总的播放集数"
    ,total_play_duration         bigint                comment "总播放时长(秒)"
    ,play_user                   bitmap                comment "播放总用户数"
    ,play_count                  bigint                comment "播放量"
    ,series_unlock_user          bitmap                comment "本部剧解锁用户数"
    ,total_unlock_epis_cnt       bigint                comment "解锁总集数"
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
alter table ads.ads_sv_beidou_series_daily_stat_di
    add column series_level        int comment "短剧等级(1.S 2.A 3.B 4.C)" after cover_url,
    add column series_level_name   varchar(100) comment "短剧等级名称" after series_level,
    add column series_type_labels  varchar(1000) comment "分类标签集合(按标签名称升序用逗号拼接)" after series_level_name,
    add column work_type           int comment "作品类型(1.男频 2.女频 3.双番)" after series_type_labels,
    add column work_type_name      varchar(100) comment "作品类型名称" after work_type,
    add column local_type          int comment "类型 (1.本土剧 2.译制剧 4.动态漫)" after work_type_name,
    add column local_type_name     varchar(100) comment "类型名称" after local_type,
    add column local_sub_type      int comment "短剧子类型(0.默认 1.本土剧-AI短剧)" after local_type_name,
    add column local_sub_type_name varchar(100) comment "短剧子类型名称" after local_sub_type,
    add column audio_type          int comment "音轨类型(1.原声剧 2.配音剧)" after local_sub_type_name,
    add column audio_type_name     varchar(100) comment "音轨类型名称" after audio_type,
    add column dubbed_type         int comment "配音类型(1.人工配音 2.AI配音)" after audio_type_name,
    add column dubbed_type_name    varchar(100) comment "配音类型名称" after dubbed_type,
    add column exit_5s_user bitmap comment "<=5s跳出用户数" after loss_10s_user,
    add column complete_10s_user bitmap comment "观看>=10秒用户数" after exit_5s_user,
    add column series_unlock_user bitmap comment "本部剧解锁用户数" after play_count,
    add column series_charge_user bitmap comment "本剧直充用户数" after series_unlock_user,
    add column total_unlock_epis_cnt bitmap comment "解锁总集数" after series_charge_user
;
