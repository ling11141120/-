drop table if exists dws.dws_user_wide_active_ed;
create table dws.dws_user_wide_active_ed (
     dt                date     not null              comment "日期"
    ,product_id        bigint   not null              comment "产品id"
    ,user_id           bigint   not null              comment "用户id"
    ,corever           bigint                         comment "core"
    ,mt                bigint                         comment "mt"
    ,ver               bigint                         comment "客户端版本号"
    ,current_language  bigint                         comment "当前语言"
    ,current_language2 bigint                         comment "注册语言"
    ,reg_country       string                         comment "注册国家"
    ,country_level     string                         comment "国家等级"
    ,appver            string                         comment "app版本"
    ,reg_time          datetime                       comment "注册时间"
    ,reg_days          bigint                         comment "活跃留存天数"
    ,sex               bigint                         comment "性别"
    ,is_pay            int                            comment "历史是否付费 1：是 0：否"
    ,is_pay_current    int                            comment "当天是否付费 1：是 0：否"
    ,etl_time          datetime                       comment "数据清洗时间"
    ,index country_level (country_level) using bitmap comment 'index_country_level'
)
primary key(dt, product_id, user_id)
comment "阅读线-用户域登录阅读充值消耗事件汇总活跃表"
partition by range(dt)
(partition p202601 values less than ("2026-02-01"))
distributed by hash(product_id, user_id) buckets 1
properties (
    "replication_num" = "3",
    "bloom_filter_columns" = "reg_time, reg_days",
    "dynamic_partition.enable" = "true",
    "dynamic_partition.time_unit" = "month",
    "dynamic_partition.time_zone" = "Asia/Shanghai",
    "dynamic_partition.start" = "-2147483648",
    "dynamic_partition.end" = "3",
    "dynamic_partition.prefix" = "p",
    "dynamic_partition.buckets" = "1",
    "dynamic_partition.history_partition_num" = "0",
    "dynamic_partition.start_day_of_month" = "1",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "storage_medium" = "SSD",
    "compression" = "LZ4"
)
;