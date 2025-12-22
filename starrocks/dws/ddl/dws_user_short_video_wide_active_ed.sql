drop table if exists dws.dws_user_short_video_wide_active_ed;
create table dws.dws_user_short_video_wide_active_ed (
     dt                     date         not null    comment "日期"
    ,product_id             bigint(20)   not null    comment "产品id"
    ,user_id                string       not null    comment "用户id"
    ,corever                bigint(20)               comment "core"
    ,mt                     bigint(20)               comment "mt"
    ,current_language       bigint(20)               comment "当前语言"
    ,current_language2      bigint(20)               comment "注册语言"
    ,reg_country            string                   comment "注册国家"
    ,country_level          string                   comment "国家等级"
    ,reg_time               datetime                 comment "注册时间"
    ,reg_days               bigint(20)               comment "活跃留存天数"
    ,sex                    bigint(20)               comment "性别"
    ,is_acc_login           smallint(6)              comment "是否登录用户（使用任一种三方账号登录、或设置密码的用户）"
    ,is_has_email           smallint(6)              comment "是否拥有邮箱信息（使用任一种三方账号登录、或设置密码的用户）"
    ,popularize_series_code varchar(100)             comment "推广剧编号"
    ,etl_time               datetime                 comment "数据清洗时间"
    ,index index_product_id(product_id) using BITMAP comment 'index_product_id'
    ,index country_level(country_level) using BITMAP comment 'index_country_level'
)
primary key(dt, product_id, user_id)
comment "用户域登录观看充值消耗汇总活跃表"
partition by range(dt)
(partition p202512 values less than ("2026-01-01"))
distributed by hash(product_id, user_id) buckets 1
properties (
    "replication_num" = "3",
    "bloom_filter_columns" = "mt, reg_time, current_language2, current_language, reg_country, corever",
    "dynamic_partition.enable" = "true",
    "dynamic_partition.time_unit" = "month",
    "dynamic_partition.time_zone" = "Asia/Shanghai",
    "dynamic_partition.start" = "-2147483648",
    "dynamic_partition.end" = "3",
    "dynamic_partition.prefix" = "p",
    "dynamic_partition.buckets" = "12",
    "dynamic_partition.history_partition_num" = "0",
    "dynamic_partition.start_day_of_month" = "1",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "LZ4"
)
;