create table if not exists ads.ads_sv_trade_user_recharge_info (
     user_id          bigint   not null comment "用户id"
    ,current_language int               comment "最新用户使用语言"
    ,corever          int               comment "core"
    ,last_login_time  datetime          comment "最后登录时间"
    ,expire_time      datetime          comment "过期时间"
    ,bind_email       string            comment "登录绑定邮箱(bind是用户自己绑的)"
    ,last_recharge_tm datetime          comment "最近一次充值时间"
    ,etl_time         datetime          comment "etl时间"
)
primary key(user_id)
comment "海剧用户充值信息"
distributed by hash(user_id)
properties (
    "replication_num" = "3",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "LZ4"
)
;