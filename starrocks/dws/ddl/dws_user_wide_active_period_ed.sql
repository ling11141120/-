DROP TABLE IF EXISTS dws.dws_user_wide_active_period_ed;
CREATE TABLE dws.dws_user_wide_active_period_ed (
     dt                 date           not null comment "日期"
    ,product_id         bigint(20)     not null comment "产品id"
    ,user_id            bigint(20)     not null comment "用户id"
    ,period_type        varchar(20)    not null comment "统计周期类型,ctt/rmt,rmt(拉活用户)"
    ,user_type          varchar(65533)          comment "用户类型"
    ,corever            bigint(20)              comment "core"
    ,mt                 bigint(20)              comment "mt"
    ,ver                bigint(20)              comment "客户端版本号"
    ,current_language   bigint(20)              comment "当前语言"
    ,current_language2  bigint(20)              comment "注册语言"
    ,source_chl         varchar(1000)           comment "最新渠道"
    ,reg_country        varchar(65533)          comment "注册国家"
    ,country_level      varchar(65533)          comment "国家等级"
    ,appver             varchar(65533)          comment "app版本"
    ,reg_time           datetime                comment "注册时间"
    ,reg_days           bigint(20)              comment "活跃留存天数"
    ,sex                bigint(20)              comment "性别"
    ,is_pay             int(11)                 comment "历史是否付费 1：是 0：否"
    ,is_pay_current     int(11)                 comment "当天是否付费 1：是 0：否"
    ,user_ad_source     int(11)                 comment "广告投流用户：0：正常用户，1：vip投流用户"
    ,user_ad_set_source int(11)                 comment "设置来源：0：未知，1：华总通知设置，2:1029接口客户端上报设置，华总通知设置后，1029接口上报不再更新UserAdSource和UserAdVipSourceBookId"
    ,user_ad_set_time   datetime                comment "广告投流用户设置时间"
    ,etl_time           datetime                comment "数据清洗时间"
    ,index country_level (country_level) using bitmap comment 'index_country_level'
)
primary key(dt, product_id, user_id, period_type)
comment "阅读线-用户域登录阅读充值消耗事件汇总活跃表"
partition by range(dt)
distributed by hash (product_id, user_id, period_type) buckets 1
properties (
    "replication_num" = "2",
    "dynamic_partition.enable" = "true",
    "dynamic_partition.time_unit" = "day",
    "dynamic_partition.time_zone" = "Asia/Shanghai",
    "dynamic_partition.start" = "-2147483648",
    "dynamic_partition.end" = "3",
    "dynamic_partition.prefix" = "p",
    "dynamic_partition.buckets" = "1",
    "dynamic_partition.history_partition_num" = "0",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "LZ4"
)
;