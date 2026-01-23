drop table if exists dws.dws_user_short_video_wide_active_period_ed;
create table dws.dws_user_short_video_wide_active_period_ed (
     dt                     date           not null comment "日期"
    ,period_type            varchar(20)    not null comment "统计周期类型,ctt/rmt,rmt(拉活用户)"
    ,product_id             bigint(20)     not null comment "产品id"
    ,user_id                varchar(65533) not null comment "用户id"
    ,user_type              varchar(100)            comment "用户类型"
    ,corever                bigint(20)              comment "core"
    ,mt                     bigint(20)              comment "mt"
    ,current_language       bigint(20)              comment "当前语言"
    ,current_language2      bigint(20)              comment "注册语言"
    ,source_chl             varchar(1000)           comment "最新渠道"
    ,reg_country            varchar(65533)          comment "注册国家"
    ,country_level          varchar(65533)          comment "国家等级"
    ,reg_time               datetime                comment "注册时间"
    ,reg_days               bigint(20)              comment "活跃留存天数"
    ,sex                    bigint(20)              comment "性别"
    ,is_acc_login           smallint(6)             comment "是否登录用户（使用任一种三方账号登录、或设置密码的用户）"
    ,is_has_email           smallint(6)             comment "是否拥有邮箱信息（使用任一种三方账号登录、或设置密码的用户）"
    ,popularize_series_code varchar(100)            comment "推广剧编号"
    ,etl_time               datetime                comment "数据清洗时间"
)
primary key(dt, period_type, product_id, user_id)
comment "用户域登录观看充值消耗汇总活跃表"
partition by range(dt)
distributed by hash(product_id, user_id)
properties ("replication_num" = "3",
            "bloom_filter_columns" = "mt, reg_time, current_language2, current_language, reg_country, corever, period_type",
            "in_memory" = "false",
            "enable_persistent_index" = "true",
            "replicated_storage" = "true",
            "compression" = "LZ4"
)
;