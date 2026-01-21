drop table if exists dws.dws_user_short_video_login_a;
create table dws.dws_user_short_video_login_a (
     dt            date       not null comment "日期"
    ,product_id    bigint     not null comment "产品id"
    ,user_id       bigint     not null comment "用户id"
    ,fst_login_tm  datetime            comment "首次登录时间"
    ,lst_login_tm  datetime            comment "上一次登录时间"
    ,new_login_tm  datetime            comment "最新登录时间"
    ,login_days_td bigint              comment "累计登录天数"
    ,login_cnt_td  bigint              comment "累计登录次数"
    ,remain_day    bigint              comment "登录留存天数"
    ,etl_time      datetime            comment "数据清洗时间"
)
primary key(dt, product_id, user_id)
comment "用户域用户登录累计指标表"
partition by range(dt)
(partition p20251223 values less than ("2025-12-24"))
distributed by hash(product_id, user_id) buckets 5
properties (
    "replication_num" = "2",
    "dynamic_partition.enable" = "true",
    "dynamic_partition.time_unit" = "day",
    "dynamic_partition.time_zone" = "Asia/Shanghai",
    "dynamic_partition.start" = "-7",
    "dynamic_partition.end" = "3",
    "dynamic_partition.prefix" = "p",
    "dynamic_partition.buckets" = "14",
    "dynamic_partition.history_partition_num" = "0",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "LZ4"
)
;