drop table if exists dws.dws_user_wide_active_period_west5_ed
;
create table dws.dws_user_wide_active_period_west5_ed
(
    dt                 date           not null comment "日期",
    product_id         bigint(20)     not null comment "产品id",
    user_id            bigint(20)     not null comment "用户id",
    period_type        varchar(20)    not null comment "统计周期类型,ctt/rmt,rmt(拉活用户)",
    user_type          varchar(65533) null comment "用户类型",
    corever            bigint(20)     null comment "core",
    mt                 bigint(20)     null comment "mt",
    ver                bigint(20)     null comment "客户端版本号",
    current_language   bigint(20)     null comment "当前语言",
    current_language2  bigint(20)     null comment "注册语言",
    source_chl         varchar(1000)  null comment "最新渠道",
    reg_country        varchar(65533) null comment "注册国家",
    country_level      varchar(65533) null comment "国家等级",
    appver             varchar(65533) null comment "app版本",
    reg_time           datetime       null comment "注册时间",
    reg_days           bigint(20)     null comment "活跃留存天数",
    sex                bigint(20)     null comment "性别",
    is_pay             int(11)        null comment "历史是否付费 1：是 0：否",
    is_pay_current     int(11)        null comment "当天是否付费 1：是 0：否",
    user_ad_source     int(11)        null comment "广告投流用户：0：正常用户，1：vip投流用户",
    user_ad_set_source int(11)        null comment "设置来源：0：未知，1：华总通知设置，2:1029接口客户端上报设置，华总通知设置后，1029接口上报不再更新UserAdSource和UserAdVipSourceBookId",
    user_ad_set_time   datetime       null comment "广告投流用户设置时间",
    etl_time           datetime       null comment "数据清洗时间",
    index country_level (country_level) using BITMAP comment 'index_country_level'
) engine = OLAP
    primary key (dt, product_id, user_id, period_type)
COMMENT "阅读线-用户域登录阅读充值消耗事件汇总活跃表_西五区"
    partition by date_trunc("day",dt)
distributed by hash(product_id, user_id, period_type)
properties (
    "replication_num" = "2",
    "enable_persistent_index" = "true",
    "in_memory" = "false",
    "replicated_storage" = "true",
    "compression" = "lz4"
)
;