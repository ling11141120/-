create table if not exists ads.ads_sv_user_push_click_di (
     dt         date     not null comment "日期分区"
    ,user_id    bigint   not null comment "用户Id"
    ,push_id    bigint   not null comment "pushId"
    ,click_time datetime          comment "最近点击时间"
    ,core       int               comment "core版本"
    ,mt         int               comment "终端"
    ,lang_id    int               comment "语言Id"
    ,etl_time   datetime          comment "ETL时间"
)
primary key(dt, user_id, push_id)
comment "海剧-用户push点击频控表"
partition by date_trunc("day", dt)
distributed by hash(dt,user_id)
properties (
    "replication_num" = "3",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "LZ4"
)
;
