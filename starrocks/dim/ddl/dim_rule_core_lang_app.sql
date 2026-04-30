create table if not exists dim.dim_rule_core_lang_app (
     biz_type_code tinyint     not null comment "业务类型编码"
    ,core          tinyint     not null comment "core"
    ,lang_code     tinyint     not null comment "语言编码"
    ,biz_type_name varchar(50)          comment "业务类型名称"
    ,lang_name     varchar(50)          comment "语言名称"
    ,app_name      varchar(50)          comment "应用名称"
)
primary key (biz_type_code, core, lang_code)
comment "规则-包体应用名称"
distributed by hash (biz_type_code, core, lang_code)
properties (
    "replication_num" = "3",
    "in_memory" = "false",
    "enable_persistent_index" = "false",
    "replicated_storage" = "true",
    "compression" = "LZ4"
)
;