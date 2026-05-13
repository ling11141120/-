create table if not exists dim.dim_rule_productid_lang_mapping (
     site_id              bigint       comment "站点ID"
    ,recharge_product_id  bigint       comment "充值产品ID"
    ,lang_id              bigint       comment "语言ID"
    ,app_name             varchar(100) comment "产品应用名称"
    ,lang_name            varchar(50)  comment "语言中文名"
    ,lang_code            varchar(20)  comment "语言代码"
    ,publish_name         varchar(200) comment "发布名称"
    ,shuangwen_product_id bigint       comment "shuangwen产品ID"
    ,server_product_id    bigint       comment "服务器产品ID"
    ,beidou_biz_type      bigint       comment "北斗业务类型"
    ,beidou_biz_type_name varchar(100) comment "北斗业务类型名称"
    ,pub_biz_type         bigint       comment "通用业务类型"
    ,pub_biz_type_name    varchar(100) comment "通用业务类型名称"
)
duplicate key (site_id, recharge_product_id, lang_id)
comment "规则-productid语言映射"
distributed by hash (site_id, recharge_product_id)
properties (
    "replication_num" = "3",
    "in_memory" = "false",
    "enable_persistent_index" = "false",
    "replicated_storage" = "true",
    "compression" = "LZ4"
)
;
