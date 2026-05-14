CREATE TABLE `dwd_reco_user_predict_log_xxg` (
  `dt` date NOT NULL COMMENT "分区时间",
  `userId` varchar(65533) NOT NULL COMMENT "用户id",
  `event_time` datetime NOT NULL COMMENT "请求算法时间",
  `reqstr` varchar(65533) NULL COMMENT "请求串",
  `bookId` varchar(65533) NULL COMMENT "推荐书籍id",
  `traceId` varchar(65533) NULL COMMENT "traceId",
  `event_name` varchar(65533) NULL COMMENT "算法名称",
  `metadata` varchar(65533) NULL COMMENT "metadata",
  `beat` varchar(65533) NULL COMMENT "类型",
  `source` varchar(65533) NULL COMMENT "路径",
  `message` varchar(65533) NULL COMMENT "请求消息",
  `host` varchar(65533) NULL COMMENT "请求机器host",
  `index` varchar(65533) NULL COMMENT "推荐书籍位序",
  `extendMap` varchar(65533) NULL COMMENT "扩展埋点",
  `rankFeature` varchar(65533) NULL COMMENT "排序特征",
  `pageId` varchar(65533) NULL COMMENT "推荐场景",
  `timestamp_c` datetime NULL COMMENT "写入时间"
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `userId`, `event_time`)
COMMENT "event=user_predict 用户预测"
PARTITION BY RANGE(`dt`)
(PARTITION p20260504 VALUES [("2026-05-04"), ("2026-05-05")),
PARTITION p20260505 VALUES [("2026-05-05"), ("2026-05-06")),
PARTITION p20260506 VALUES [("2026-05-06"), ("2026-05-07")),
PARTITION p20260507 VALUES [("2026-05-07"), ("2026-05-08")),
PARTITION p20260508 VALUES [("2026-05-08"), ("2026-05-09")),
PARTITION p20260509 VALUES [("2026-05-09"), ("2026-05-10")),
PARTITION p20260510 VALUES [("2026-05-10"), ("2026-05-11")),
PARTITION p20260511 VALUES [("2026-05-11"), ("2026-05-12")),
PARTITION p20260512 VALUES [("2026-05-12"), ("2026-05-13")),
PARTITION p20260513 VALUES [("2026-05-13"), ("2026-05-14")),
PARTITION p20260514 VALUES [("2026-05-14"), ("2026-05-15")),
PARTITION p20260515 VALUES [("2026-05-15"), ("2026-05-16")),
PARTITION p20260516 VALUES [("2026-05-16"), ("2026-05-17")),
PARTITION p20260517 VALUES [("2026-05-17"), ("2026-05-18")))
DISTRIBUTED BY HASH(`dt`, `userId`, `event_time`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"dynamic_partition.enable" = "true",
"dynamic_partition.time_unit" = "DAY",
"dynamic_partition.time_zone" = "Asia/Shanghai",
"dynamic_partition.start" = "-10",
"dynamic_partition.end" = "3",
"dynamic_partition.prefix" = "p",
"dynamic_partition.buckets" = "3",
"dynamic_partition.history_partition_num" = "0",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);