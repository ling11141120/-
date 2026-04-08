drop table if exists dim.dim_short_video_series_attr_df;
create table dim.dim_short_video_series_attr_df
(
    series_id              bigint not null comment "短剧ID"
    ,language_code         int             comment "语言编码"
    ,language_name         varchar(100)    comment "语言名称"
    ,series_code           varchar(100)    comment "短剧代号"
    ,series_name           varchar(255)    comment "短剧名称"
    ,all_epis              int             comment "短剧总集数"
    ,cover_url             varchar(512)    comment "短剧封面"
    ,publish_time          datetime        comment "发布时间"
    ,series_duration       bigint          comment "短剧总时长(秒)"
    ,first_pay_epis_num    int             comment "首个收费集序号"
    ,series_level          int             comment "短剧等级编码(1.S 2.A 3.B 4.C)"
    ,series_level_name     varchar(100)    comment "短剧等级名称"
    ,work_type             int             comment "作品类型编码(1.男频 2.女频 3.双番)"
    ,work_type_name        varchar(100)    comment "作品类型名称"
    ,local_type            int             comment "地区类型编码(1.本土剧 2.译制剧 4.动漫)"
    ,local_type_name       varchar(100)    comment "地区类型名称"
    ,local_sub_type        int             comment "短剧子类型编码(1.本土剧-AI短剧)"
    ,local_sub_type_name   varchar(100)    comment "短剧子类型名称"
    ,audio_type            int             comment "音轨类型编码(1.原声剧 2.配音剧)"
    ,audio_type_name       varchar(100)    comment "音轨类型名称"
    ,dubbed_type           int             comment "配音类型编码(1.人工配音 2.AI配音)"
    ,dubbed_type_name      varchar(100)    comment "配音类型名称"
    ,series_type_labels    varchar(1000)   comment "分类标签集合(按标签名升序拼接)"
    ,etl_time              datetime        comment "数据清洗时间"
) engine = OLAP
    primary key(series_id)
comment "短剧属性维表(全量)"
DISTRIBUTED BY HASH(series_id) BUCKETS 3
properties (
    "replication_num" = "3",
    "enable_persistent_index" = "true",
    "in_memory" = "false",
    "replicated_storage" = "true",
    "compression" = "LZ4"
);
