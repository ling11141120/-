
drop table if exists dim.dim_sv_beidou_serices_detail_df;
create table dim.dim_sv_beidou_serices_detail_df
(
    core            int    not null comment "Core"
    ,language_code   int    not null comment "语言编码"
    ,series_id       bigint not null comment "短剧ID"
    ,language_name   varchar(100) comment "语言名称"
    ,series_code     varchar(100) comment "短剧代号"
    ,series_name     varchar(255) comment "短剧名称"
    ,all_epis        int comment "短剧集数"
    ,cover_url       varchar(512) comment "短剧封面"
    ,publish_time    datetime comment "发布时间"
    ,series_duration bigint comment "短剧总时长(单位: 秒)"
    ,etl_time        datetime comment "数据清洗时间"
) engine = OLAP
    primary key(core, language_code, series_id)
comment "北斗短剧信息维表"
DISTRIBUTED BY HASH(core, language_code, series_id) BUCKETS 3
properties (
    "replication_num" = "3",
    "enable_persistent_index" = "true",
    "in_memory" = "false",
    "replicated_storage" = "true",
    "compression" = "LZ4"
);
