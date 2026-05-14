CREATE TABLE `dwd_reco_user_predict_log_xxg_3` (
  `dt` date NOT NULL COMMENT "",
  `userId` varchar(65533) NOT NULL COMMENT "",
  `event_time` datetime NOT NULL COMMENT "",
  `reqstr` varchar(65533) NULL COMMENT "",
  `bookId` varchar(65533) NULL COMMENT "",
  `traceId` varchar(65533) NULL COMMENT "",
  `event_name` varchar(65533) NULL COMMENT "",
  `metadata` varchar(65533) NULL COMMENT "",
  `beat` varchar(65533) NULL COMMENT "",
  `source` varchar(65533) NULL COMMENT "",
  `message` varchar(65533) NULL COMMENT "",
  `host` varchar(65533) NULL COMMENT "",
  `index` varchar(65533) NULL COMMENT "",
  `extendMap` varchar(65533) NULL COMMENT "",
  `rankFeature` varchar(65533) NULL COMMENT "",
  `pageId` varchar(65533) NULL COMMENT "",
  `timestamp_c` datetime NULL COMMENT ""
) ENGINE=OLAP 
DUPLICATE KEY(`dt`, `userId`)
DISTRIBUTED BY HASH(`dt`) BUCKETS 14 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);