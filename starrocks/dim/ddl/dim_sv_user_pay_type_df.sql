
drop table if exists dim.dim_sv_user_pay_type_df;
create table dim.dim_sv_user_pay_type_df
(
    dt                          date         not null comment "数据日期"
    ,user_id                     bigint       not null comment "用户ID"
    ,first_pay_time              datetime              comment "首次充值时间"
    ,first_subscribe_time        datetime              comment "首次订阅时间(shop_item<>0)"
    ,last_subscribe_expire_time  datetime              comment "最后订阅过期时间"
    ,total_pay_count             int                   comment "总充值次数"
    ,total_subscribe_count       int                   comment "总订阅次数"
    ,user_type                   varchar(20)           comment "当前用户类型(订阅用户/IAP用户)"
    ,etl_time                    datetime              comment "数据清洗时间"
) engine = OLAP
    primary key(dt, user_id)
comment "短剧-用户充值类型维表(每日快照)"
partition by date_trunc("day", dt)
distributed by hash(user_id) buckets 3
properties (
    "replication_num" = "3",
    "enable_persistent_index" = "true",
    "in_memory" = "false",
    "replicated_storage" = "true",
    "compression" = "LZ4"
);
