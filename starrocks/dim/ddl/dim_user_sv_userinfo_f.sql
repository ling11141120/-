drop table if exists dim.dim_user_sv_userinfo_f;
create table dim.dim_user_sv_userinfo_f (
     product_id            int          not null comment "product_id"
    ,user_id               bigint       not null comment "用户id"
    ,sex                   int                   comment "性别编码"
    ,sex_name              varchar(50)           comment "性别名称"
    ,create_time           datetime              comment "创建时间"
    ,user_status           tinyint               comment "用户状态编码"
    ,user_status_name      varchar(50)           comment "用户状态名称"
    ,is_delete             tinyint               comment "是否删除"
    ,create_core           int                   comment "创建时core"
    ,current_login_core    int                   comment "当前登录时core"
    ,init_language         int                   comment "初始语言编码"
    ,init_language_name    varchar(50)           comment "初始语言名称"
    ,current_language      int                   comment "当前语言编码"
    ,current_language_name varchar(50)           comment "当前语言名称"
    ,reg_country           varchar(765)          comment "注册国家"
    ,member_level          int                   comment "会员等级编码"
    ,member_level_name     varchar(100)          comment "会员等级名称"
    ,is_gold_coin_user     tinyint               comment "是否金币网赚用户"
    ,etl_time              datetime              comment "数据入库时间"
)
primary key(product_id, user_id)
comment "用户域-短剧全量用户信息"
distributed by hash(user_id)
properties (
    "replication_num" = "3",
    "bloom_filter_columns" = "create_time, etl_time",
    "in_memory" = "false",
    "enable_persistent_index" = "true",
    "replicated_storage" = "true",
    "compression" = "LZ4"
)
;