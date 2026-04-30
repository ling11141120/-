create table if not exists dim.dim_dic (
     auto_id     bigint       not null comment "自增id"
    ,table_name  string                comment "表名"
    ,dic_column  string                comment "枚举字段"
    ,enum_id     string                comment "枚举数字"
    ,enum_name   string                comment "枚举名称"
    ,remarks     varchar(255)          comment ""
    ,update_time datetime              comment "更新时间"
)
primary key(auto_id)
comment "公共字典表"
distributed by hash(auto_id) buckets 3
properties (
    "replication_num" = "3",
    "bloom_filter_columns" = "dic_column, enum_id",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "LZ4"
)
;
