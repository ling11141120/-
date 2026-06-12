
drop table if exists ads.ads_sv_beidou_series_user_type_di;
create table ads.ads_sv_beidou_series_user_type_di
(
    dt                  date         not null comment "日期"
    ,core                int          not null comment "Core"
    ,acquisition_source_cd int          not null comment "引流来源(1:引流, 0:非引流)"
    ,language_code       int          not null comment "语言编码"
    ,series_id           bigint       not null comment "短剧ID"
    ,user_type           varchar(50)  not null comment "用户分类(订阅用户/IAP用户/免费用户)"
    ,country             varchar(100) not null comment "国家"
    ,language_name       varchar(100)          comment "语言名称"
    ,series_code         varchar(100)          comment "短剧代号"
    ,series_name         varchar(255)          comment "短剧名称"
    ,publish_time        datetime              comment "发布时间"
    ,placement_time      datetime              comment "投放时间(东八区)"
    ,user_count          bitmap                comment "用户数量"
    ,etl_time            datetime              comment "数据清洗时间"
) engine = OLAP
    primary key(dt, core, acquisition_source_cd, language_code, series_id, user_type, country)
comment "北斗短剧-用户分类统计表"
partition by date_trunc("day", dt)
distributed by hash(dt, core, acquisition_source_cd, language_code, series_id) buckets 2
properties (
    "replication_num" = "3",
    "enable_persistent_index" = "true",
    "in_memory" = "false",
    "replicated_storage" = "true",
    "compression" = "LZ4"
);
