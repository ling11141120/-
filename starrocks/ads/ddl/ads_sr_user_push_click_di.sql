create table if not exists ads.ads_sr_user_push_click_di (
     dt          date            not null comment "日期分区"
    ,user_id     bigint          not null comment "用户Id"
    ,push_id     varchar(65533)  not null comment "pushId"
    ,push_title  varchar(512)             comment "推送标题"
    ,push_type   int                      comment "推送类型"
    ,click_time  datetime                 comment "最近点击时间"
    ,app_version varchar(64)              comment "应用版本"
    ,core        int                      comment "core版本"
    ,mt          int                      comment "终端"
    ,lang_id     int                      comment "语言Id"
    ,etl_time    datetime                 comment "ETL时间"
)
primary key(dt, user_id, push_id)
comment "海阅-用户push点击频控表"
partition by date_trunc("day", dt)
distributed by hash(dt,user_id)
properties (
    "replication_num" = "3",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "LZ4",
    "partition_live_number" = "14"
)
;
