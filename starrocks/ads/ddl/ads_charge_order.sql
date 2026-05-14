CREATE TABLE `ads_charge_order` (
  `datetypes` int(11) NOT NULL COMMENT "",
  `charge_money` decimal(18, 2) NULL COMMENT "",
  `charge_money_rmb` decimal(18, 2) NULL COMMENT "",
  `charge_order` int(11) NULL COMMENT "",
  `charge_num` int(11) NULL COMMENT "",
  `etl_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "etl清洗时间"
) ENGINE=OLAP 
PRIMARY KEY(`datetypes`)
COMMENT "OLAP"
DISTRIBUTED BY HASH(`datetypes`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);