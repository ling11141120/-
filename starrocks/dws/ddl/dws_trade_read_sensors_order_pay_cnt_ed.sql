CREATE TABLE `dws_trade_read_sensors_order_pay_cnt_ed` (
  `dt` date NOT NULL COMMENT "神策事件日期",
  `event` varchar(65533) NOT NULL COMMENT "神策事件名",
  `payment_method` varchar(65533) NOT NULL COMMENT "支付類型",
  `app_version` varchar(65533) NOT NULL COMMENT "app版本",
  `app_product_id` varchar(65533) NOT NULL COMMENT "語言",
  `app_core_ver` varchar(65533) NOT NULL COMMENT "包体",
  `is_thrid` boolean NOT NULL COMMENT "是否第三方",
  `lib` varchar(65533) NULL COMMENT "iOS, Android, MiniProgram js",
  `event_cnt` bigint(20) NULL COMMENT "事件數量",
  `etl_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "etl清洗时间"
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `event`, `payment_method`, `app_version`, `app_product_id`, `app_core_ver`, `is_thrid`)
COMMENT "神策日誌數據-訂單創建及支付成功統計"
DISTRIBUTED BY HASH(`payment_method`, `event`, `app_version`, `app_product_id`, `app_core_ver`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
