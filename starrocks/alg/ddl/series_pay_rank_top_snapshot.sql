CREATE TABLE `series_pay_rank_top_snapshot` (
  `dimension_type` varchar(32) NOT NULL COMMENT "维度类型：LANGUAGE / COUNTRY_LANGUAGE",
  `country` varchar(32) NOT NULL DEFAULT "" COMMENT "国家，LANGUAGE 维度时为空串",
  `language` varchar(32) NOT NULL DEFAULT "" COMMENT "语言",
  `series_id` bigint(20) NOT NULL COMMENT "剧ID",
  `series_name` varchar(255) NOT NULL DEFAULT "" COMMENT "剧名",
  `unlock_count` bigint(20) NOT NULL DEFAULT "0" COMMENT "近24小时解锁次数",
  `user_count` bigint(20) NOT NULL DEFAULT "0" COMMENT "近24小时解锁用户数",
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT "创建时间",
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT "更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`dimension_type`, `country`, `language`)
COMMENT "付费榜top1中间表"
DISTRIBUTED BY HASH(`dimension_type`, `country`, `language`)
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);