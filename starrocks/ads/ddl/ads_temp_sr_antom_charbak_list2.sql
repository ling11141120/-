CREATE TABLE `ads_temp_sr_antom_charbak_list2` (
  `dispute_id` varchar(255) NULL COMMENT "",
  `chargeback_alert_type` varchar(255) NULL COMMENT "",
  `defendable` varchar(255) NULL COMMENT "",
  `automatic_defense` varchar(255) NULL COMMENT "",
  `amount` varchar(255) NULL COMMENT "",
  `dispute_status` varchar(255) NULL COMMENT "",
  `dispute_creation_date` varchar(255) NULL COMMENT "",
  `due_date` varchar(255) NULL COMMENT "",
  `reason_type` varchar(255) NULL COMMENT "",
  `reason_code` varchar(255) NULL COMMENT "",
  `dispute_last_updated` varchar(255) NULL COMMENT "",
  `transaction_id` varchar(255) NULL COMMENT "",
  `transaction_date` varchar(255) NULL COMMENT "",
  `transaction_currency` varchar(255) NULL COMMENT "",
  `transaction_amount` varchar(255) NULL COMMENT "",
  `merchant_id` varchar(255) NULL COMMENT "",
  `merchant_payment_request_id` varchar(255) NULL COMMENT "",
  `arn` varchar(255) NULL COMMENT "",
  `captureid` varchar(255) NULL COMMENT ""
) ENGINE=OLAP 
DUPLICATE KEY(`dispute_id`)
DISTRIBUTED BY HASH(`dispute_id`)
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);