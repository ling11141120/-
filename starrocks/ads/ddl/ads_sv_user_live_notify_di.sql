create table if not exists ads.ads_sv_user_live_notify_di (
     dt                    date        not null  comment "日期"
    ,product_id            int         not null  comment "产品id"
    ,user_id               bigint      not null  comment "用户id"
    ,corever               varchar(50)           comment "核心版本"
    ,app_live_notify_state tinyint               comment "实况通知权限：-1未配置 0关 1开"
    ,etl_time              datetime              comment "etl时间"
)
primary key (dt, product_id, user_id)
comment "海剧-用户live通知权限日表"
partition by date_trunc("day", dt)
distributed by hash(user_id)
properties (
    "replication_num" = "3",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "partition_live_number" = "90",
    "compression" = "lz4"
)
;
