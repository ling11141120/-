drop table if exists dim.dim_countrylevel;
create table dim.dim_countrylevel (
     product_id      int      not null                  comment "产品id"
    ,id              int      not null                  comment "自增id"
    ,level           int      not null                  comment "国家等级，1：t1国家，2：t2国家"
    ,short_name      string   not null                  comment "国家缩写"
    ,remark          string                             comment "备注"
    ,is_delete       int      default "0"               comment ""
    ,row_update_time datetime                           comment "更新时间"
    ,sync_language   string                             comment "同步语言"
    ,language        int                                comment ""
    ,etl_tm          datetime default current_timestamp comment ""
)
primary key(product_id, id, level, short_name)
comment "OLAP"
distributed by hash(id) buckets 5
properties (
    "replication_num" = "3",
    "bloom_filter_columns" = "row_update_time",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "LZ4"
)
;