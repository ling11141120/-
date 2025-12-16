drop table if exists dim.dim_ad_mobking_appid;
create table dim.dim_ad_mobking_appid (
     app_id           int(11)       not null                  comment "站点ID"
    ,app_info         varchar(1000)                           comment "站点ID"
    ,macro_definition varchar(1000)                           comment "宏定义"
    ,system_type      int(11)                                 comment "项目类型，1-海剧，2-海阅"
    ,etl_time         datetime      default current_timestamp comment "starrocks数据更新时间"
)
primary key(app_id)
comment "mobking广告维表"
distributed by hash(app_id) buckets 1
properties (
    "replication_num" = "3",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "LZ4"
)
;