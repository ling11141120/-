CREATE TABLE `dws_user_charge_first_last_sensors_a` (
  `userid` bigint(20) NOT NULL COMMENT "用户ID",
  `itemcount` int(11) NULL COMMENT "充值金额众数",
  `charge_cnt` bigint(20) NULL COMMENT "充值次数",
  `last_charge_time` datetime NULL COMMENT "最近充值时间",
  `first_charge_time` datetime NULL COMMENT "首次充值时间",
  `frist_itemcount` int(11) NULL COMMENT "首次充值金额",
  `first_read_time` datetime NULL COMMENT "首次阅读时间",
  `etl_tm` datetime NOT NULL COMMENT ""
) ENGINE=OLAP 
PRIMARY KEY(`userid`)
COMMENT "用户充值首冲 最近充值"
DISTRIBUTED BY HASH(`userid`) BUCKETS 12 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "ZSTD"
);
