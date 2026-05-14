CREATE TABLE `dim_rule_productid_lang_mapping` (
  `site_id` bigint(20) NULL COMMENT "站点ID",
  `recharge_product_id` bigint(20) NULL COMMENT "充值产品ID",
  `lang_id` bigint(20) NULL COMMENT "语言ID",
  `app_name` varchar(100) NULL COMMENT "产品应用名称",
  `lang_name` varchar(50) NULL COMMENT "语言中文名",
  `lang_code` varchar(20) NULL COMMENT "语言代码",
  `publish_name` varchar(200) NULL COMMENT "发布名称",
  `shuangwen_product_id` bigint(20) NULL COMMENT "shuangwen产品ID",
  `server_product_id` bigint(20) NULL COMMENT "服务器产品ID",
  `beidou_biz_type` bigint(20) NULL COMMENT "北斗业务类型",
  `beidou_biz_type_name` varchar(100) NULL COMMENT "北斗业务类型名称",
  `pub_biz_type` bigint(20) NULL COMMENT "通用业务类型",
  `pub_biz_type_name` varchar(100) NULL COMMENT "通用业务类型名称"
) ENGINE=OLAP 
DUPLICATE KEY(`site_id`, `recharge_product_id`, `lang_id`)
COMMENT "规则-productid语言映射"
DISTRIBUTED BY HASH(`site_id`, `recharge_product_id`)
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "false",
"replicated_storage" = "true",
"compression" = "LZ4"
);