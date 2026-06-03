create table if not exists ads.ads_sv_user_subscribe_status_di (
     dt                  date         not null comment "日期分区"
    ,user_id             bigint       not null comment "用户Id"
    ,vip_status          int                   comment "VIP状态"
    ,expire_time         datetime              comment "过期时间"
    ,is_expiring_soon    int                   comment "即将到期(3天内) 1是0否"
    ,is_expired          int                   comment "已过期 1是0否"
    ,renewal_failed      int                   comment "续费失败 1是0否"
    ,renewal_failed_time datetime              comment "续费失败时间"
    ,core                int                   comment "core版本"
    ,mt                  int                   comment "终端"
    ,lang_id             int                   comment "语言Id"
    ,reg_country         varchar(255)          comment "注册国家"
    ,etl_time            datetime              comment "ETL时间"
)
primary key(dt, user_id)
comment "海剧-用户订阅状态日表"
partition by date_trunc("day", dt)
distributed by hash(dt,user_id)
properties (
    "replication_num" = "3",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "LZ4"
)
;
