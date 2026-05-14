CREATE TABLE `dim_product` (
  `product_id` bigint(20) NOT NULL COMMENT "产品id",
  `Id` bigint(20) NOT NULL COMMENT "",
  `product_name` varchar(500) NULL COMMENT "产品名称",
  `product_type` varchar(500) NULL COMMENT "产品类型",
  `product_status` varchar(500) NULL COMMENT "产品状态",
  `unified_product_name` varchar(500) NULL COMMENT "产品名",
  `unified_product_id` bigint(20) NULL COMMENT "产品id",
  `category_name` varchar(500) NULL COMMENT "分类名称",
  `category_id` bigint(20) NULL COMMENT "分类id",
  `market_code` varchar(500) NULL COMMENT "商店",
  `device_code` varchar(500) NULL COMMENT "设备码",
  `publisher_name` varchar(500) NULL COMMENT "发布商",
  `publisher_id` bigint(20) NULL COMMENT "发布商id",
  `publisher_market` varchar(500) NULL COMMENT "发布市场",
  `publisher_website` varchar(500) NULL COMMENT "发布网站",
  `company_name` varchar(500) NULL COMMENT "公司名",
  `company_id` bigint(20) NULL COMMENT "公司id",
  `parent_company_name` varchar(500) NULL COMMENT "母公司名称",
  `parent_company_id` bigint(20) NULL COMMENT "母公司id",
  `company_stock_symbol` varchar(500) NULL COMMENT "公司股票",
  `company_website` varchar(500) NULL COMMENT "公司网站",
  `company_is_public` boolean NULL COMMENT "",
  `updatetime` datetime NOT NULL COMMENT "更新时间",
  `inittime` datetime NOT NULL COMMENT "写入时间",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "",
  `sr_updatetime` datetime NULL COMMENT ""
) ENGINE=OLAP 
PRIMARY KEY(`product_id`)
COMMENT "product信息维度表"
DISTRIBUTED BY HASH(`product_id`) BUCKETS 5 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "product_id",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);