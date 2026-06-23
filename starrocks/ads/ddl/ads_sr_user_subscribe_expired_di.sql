create table if not exists ads.ads_sr_user_subscribe_expired_di (
     dt             date     not null comment "日期分区"
    ,user_id        bigint   not null comment "用户Id"
    ,product_id     int      not null comment "产品id"
    ,subscribe_type int               comment "订阅类型：1=VIP,2=SVIP"
    ,expire_time    datetime          comment "过期时间"
    ,vip_type       int               comment "会员类型"
    ,etl_time       datetime          comment "ETL时间"
)
primary key(dt, user_id, product_id, subscribe_type)
comment "海阅-过期用户日表"
partition by date_trunc("day", dt)
distributed by hash(dt,user_id)
properties (
    "replication_num" = "3",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "LZ4"
)
;
