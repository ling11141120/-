create table dws.dws_srsv_user_first_preload_info_df (
     product_id         int           not null            comment "product_id"
    ,user_id            bigint        not null            comment "用户id"
    ,ad_type            int           not null            comment "广告类型"
    ,lst_preload_ecpm   decimal(16,8) replace_if_not_null comment "最近首次预加载ecpm"
    ,fst_preload_time   datetime      min                 comment "首次预加载事件上报时间"
    ,etl_time           datetime      replace_if_not_null comment "etl清洗时间"
)
aggregate key(product_id, user_id, ad_type)
comment "海剧海阅首次预加载信息"
distributed by hash(product_id, user_id) buckets 3
properties (
    "replication_num" = "3",
    "in_memory" = "false",
    "replicated_storage" = "true",
    "compression" = "LZ4"
)
;