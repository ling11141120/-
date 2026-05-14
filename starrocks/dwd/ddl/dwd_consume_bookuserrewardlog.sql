CREATE TABLE `dwd_consume_bookuserrewardlog` (
  `dt` date NOT NULL COMMENT "createtime 分区",
  `product_id` int(11) NOT NULL COMMENT "产品id",
  `id` bigint(20) NOT NULL COMMENT "自增id",
  `user_id` bigint(20) NULL COMMENT "用户id",
  `book_id` bigint(20) NULL COMMENT "书籍id",
  `total_money` int(11) NULL COMMENT "打赏总阅币数",
  `money` int(11) NULL COMMENT "打赏阅币数",
  `award_money` int(11) NULL COMMENT "打赏赠送币数",
  `type` int(11) NULL COMMENT "打赏类型",
  `create_tm` datetime NULL COMMENT "创建时间",
  `app_id` int(11) NULL COMMENT "应用程序id",
  `point` int(11) NULL COMMENT "打赏积分数",
  `app_id_account` int(11) NULL COMMENT "项目id，core，语言",
  `mt` int(11) NULL COMMENT "平台 0未知 1iphone 4安卓 9书城",
  `is_has_charge` tinyint(4) NULL COMMENT "是否充过值",
  `corever` int(11) NULL COMMENT "版本号",
  `current_language` int(11) NULL COMMENT "用户当前语言",
  `current_language2` int(11) NULL COMMENT "注册时语言",
  `reg_country` varchar(65533) NULL COMMENT "注册时国家",
  `regdate` datetime NULL COMMENT "用户的注册时间",
  `prod_id` varchar(65533) NULL COMMENT "产品id",
  `device_guid` varchar(65533) NULL COMMENT "设备guid",
  `app_ver` varchar(65533) NULL COMMENT "app版本",
  `ver` int(11) NULL COMMENT "客户端版本号",
  `ads_type` varchar(60) NULL COMMENT "用户广告标签ADSTYPE",
  `ads_quality` int(11) NULL COMMENT "用户广告标签",
  `is_negative_user` int(11) NULL COMMENT "是否白嫖用户",
  `etl_tm` datetime NULL COMMENT ""
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `product_id`, `id`)
COMMENT "用户打赏书籍记录表"
PARTITION BY RANGE(`dt`)
(PARTITION p2022 VALUES [("2022-01-01"), ("2023-01-01")),
PARTITION p2023 VALUES [("2023-01-01"), ("2024-01-01")),
PARTITION p2024 VALUES [("2024-01-01"), ("2025-01-01")),
PARTITION p2025 VALUES [("2025-01-01"), ("2026-01-01")),
PARTITION p2026 VALUES [("2026-01-01"), ("2027-01-01")),
PARTITION p2027 VALUES [("2027-01-01"), ("2028-01-01")),
PARTITION p2028 VALUES [("2028-01-01"), ("2029-01-01")),
PARTITION p2029 VALUES [("2029-01-01"), ("2030-01-01")))
DISTRIBUTED BY HASH(`id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "create_tm",
"dynamic_partition.enable" = "true",
"dynamic_partition.time_unit" = "YEAR",
"dynamic_partition.time_zone" = "Asia/Shanghai",
"dynamic_partition.start" = "-10",
"dynamic_partition.end" = "3",
"dynamic_partition.prefix" = "p",
"dynamic_partition.history_partition_num" = "0",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);