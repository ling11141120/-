CREATE TABLE `ads_ad_finance_promotion_reconciliation` (
  `dt` date NOT NULL COMMENT "分区日期",
  `level2` int(11) NULL COMMENT "二级代理商id",
  `level2_name` varchar(255) NULL COMMENT "二级代理商名称",
  `fb_account` varchar(100) NULL COMMENT "账号id",
  `country` varchar(50) NULL COMMENT "国家",
  `company_id` int(11) NULL COMMENT "主体公司id",
  `company_name` varchar(255) NULL COMMENT "主体公司名称",
  `account_source_id` int(11) NULL COMMENT "账号来源id",
  `account_source_name` varchar(255) NULL COMMENT "账号来源名称",
  `fb_account_name` varchar(255) NULL COMMENT "账号名称",
  `product_id` int(11) NULL COMMENT "产品id/语言id",
  `mt` int(11) NULL COMMENT "平台",
  `core` int(11) NULL COMMENT "core",
  `spend` decimal(12, 2) NULL COMMENT "花费",
  `ad_optimizer_uid` varchar(255) NULL COMMENT "优化师工号",
  `ads_optimizer` varchar(255) NULL COMMENT "优化师名称",
  `etl_time` datetime NULL COMMENT "etl时间"
) ENGINE=OLAP 
DUPLICATE KEY(`dt`, `level2`)
COMMENT "广告-财务推广对账"
DISTRIBUTED BY HASH(`dt`, `level2`) BUCKETS 30 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);