create table if not exists tmp.ads_bi_user_ord_expo_info_di
(
    dt                     date         not null comment "日期",
    user_id                bigint       not null comment "用户id",
    order_id               varchar(512) not null comment "订单id",
    zffs                   varchar(512) comment "当前支付方式",
    last_zffs              varchar(512) comment "上次支付方式",
    core                   int comment "core",
    mt                     varchar(256) comment "移动终端",
    shop_item              varchar(256) comment "充值类型名称",
    custom_data            json comment "自定义数据",
    subscribe_status       int comment "订阅状态编码",
    reg_country            varchar(256) comment "注册国家编码",
    user_type              varchar(256) comment "用户类型名称",
    current_language2      int comment "投放语言",
    current_language2_name varchar(256) comment "投放语言名称",
    zffs_list              varchar(256) comment "本次支付方式列表",
    next_zffs_list         varchar(256) comment "下次支付方式列表",
    etl_tm                 datetime     not null comment "etl时间"
) engine = olap
    primary key (dt, user_id, order_id)
comment "BI-海剧用户订单曝光信息表"
    partition by date_trunc("day",dt)
distributed by hash(dt, user_id, order_id) buckets 10
properties (
"replication_num" = "2",
"enable_persistent_index" = "true",
"in_memory" = "false",
"replicated_storage" = "true",
"compression" = "lz4"
)
;