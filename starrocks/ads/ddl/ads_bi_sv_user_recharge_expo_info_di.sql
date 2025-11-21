create table if not exists tmp.ads_bi_sv_user_recharge_expo_info_di
(
    dt                     date comment "日期",
    user_id                bigint comment "用户id",
    zffs                   varchar(256) comment "支付渠道",
    zffs_rank              int comment "曝光位次",
    strategy_id            bigint comment "策略id",
    app_id                 varchar(512) comment "应用id",
    app_core_ver           int comment "core",
    shop_item              varchar(256) comment "充值类型名称",
    mt                     varchar(256) comment "移动终端",
    user_type              varchar(256) comment "用户类型名称",
    reg_country            varchar(256) comment "注册国家编码",
    current_language2      int comment "投放语言",
    current_language2_name varchar(256) comment "投放语言名称",
    etl_tm                 datetime not null comment "etl时间"
) primary key (dt, user_id, zffs)
comment "BI-海剧用户充值曝光信息"
    partition by date_trunc("day",dt)
distributed by hash(user_id, zffs)
properties (
"replication_num" = "2",
"enable_persistent_index" = "true",
"in_memory" = "false",
"replicated_storage" = "true",
"compression" = "lz4"
)
;