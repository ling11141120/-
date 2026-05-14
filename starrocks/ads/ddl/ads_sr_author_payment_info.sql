CREATE TABLE `ads_sr_author_payment_info` (
  `language_name` varchar(50) NOT NULL COMMENT "语言",
  `author_id` varchar(50) NOT NULL COMMENT "作者id",
  `billing_period` date NOT NULL COMMENT "账期",
  `payment_month` date NOT NULL COMMENT "付款月",
  `author_name` varchar(255) NOT NULL COMMENT "作者笔名",
  `payment_method` varchar(50) NOT NULL COMMENT "支付方式",
  `payee_name` varchar(255) NULL COMMENT "收款人姓名",
  `payment_account` varchar(255) NULL COMMENT "打款账号",
  `bank_name` varchar(255) NULL COMMENT "银行名称",
  `bank_branch` varchar(255) NULL COMMENT "开户银行",
  `swift_code` varchar(255) NULL COMMENT "Swift Code",
  `bank_location` varchar(1000) NULL COMMENT "银行所在地",
  `current_address` varchar(1000) NULL COMMENT "现居地址",
  `country` varchar(255) NULL COMMENT "所属国家",
  `remuneration_amount` decimal(12, 2) NULL COMMENT "稿酬金额",
  `payment_status` varchar(50) NULL COMMENT "支付状态",
  `etl_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "处理时间"
) ENGINE=OLAP 
DUPLICATE KEY(`language_name`)
COMMENT "爆款内容-原创明细-财务导入"
DISTRIBUTED BY HASH(`language_name`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);