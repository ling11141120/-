drop table if exists dws.dws_srsv_wide_user_type_info_di;
create table dws.dws_srsv_wide_user_type_info_di (
     dt                    date               not null comment "统计时间分区,用户活跃时间"
    ,product_id            int(11)            not null comment "产品id"
    ,user_id               bigint(20)         not null comment "用户id"
    ,user_period           int(11)            not null comment "用户类型 1：新用户 2：活跃用户 3：rmt(拉活用户)"
    ,corever               int(11)                     comment "corever"
    ,mt                    int(11)                     comment "终端"
    ,reg_country           varchar(512)                comment "国家"
    ,country_level         int(11)                     comment "国家等级"
    ,current_language2     int(11)                     comment "注册语言"
    ,source                int(11)                     comment "3是付费 2是官网  1 是自然和其他 条件：source in ('fbs2s','facebook','tt','appleadservice','fixadinfo','sem','adwords') then 3 when source in ('officialsite','(not set)') then 2 else 1"
    ,is_pay                int(11)                     comment "1:付费,0:非付费（历史是否付费，充值）"
    ,chl2                  varchar(512)                comment "初始渠道值"
    ,chl                   varchar(512)                comment "最新渠道值"
    ,group_id_list         varchar(655330)             comment "在包用户集合"
    ,position_name_list    varchar(65533)              comment "触发资源位集合"
    ,etl_tm                datetime           not null comment "数据清洗时间"
    ,index index_current_language2 (current_language2) using bitmap comment '注册语言索引'
)
primary key(dt, product_id, user_id, user_period)
comment "海阅sr、海剧sv不同用户类型活跃表"
partition by range(dt)
(partition p202510 values less than ("2025-11-01"))
distributed by hash(dt, product_id, user_id) buckets 10 
properties (
    "replication_num" = "3",
    "dynamic_partition.enable" = "true",
    "dynamic_partition.time_unit" = "Month",
    "dynamic_partition.time_zone" = "Asia/Shanghai",
    "dynamic_partition.start" = "-360",
    "dynamic_partition.end" = "3",
    "dynamic_partition.prefix" = "p",
    "dynamic_partition.buckets" = "70",
    "dynamic_partition.history_partition_num" = "0",
    "dynamic_partition.start_day_of_month" = "1",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "storage_medium" = "SSD",
    "compression" = "ZSTD"
)
;