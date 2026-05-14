CREATE TABLE `ads_report_negative_user_info` (
  `dt` date NOT NULL COMMENT "事件分区",
  `product_id` int(11) NULL COMMENT "产品id",
  `mt` int(11) NULL COMMENT "终端",
  `corever` int(11) NULL COMMENT "corever",
  `dau` int(11) NULL COMMENT "活跃用户数",
  `pay_dau` int(11) NULL COMMENT "活跃且付费用户",
  `free_dau` int(11) NULL COMMENT "活跃且非付费用户",
  `iaa_dau` int(11) NULL COMMENT " 产品定义 ads_type!=' and ads_quality=0 and is_has_charge=0 来源 dim_user_all_info_a",
  `iap_dau` int(11) NULL COMMENT "白嫖且付费用户 is_negative_user=1  and  is_has_charge=1  来源 dim_user_all_info_a",
  `negative_dau` int(11) NULL COMMENT "is_negative_user =1 白嫖用户",
  `etl_time` datetime NOT NULL COMMENT "数据清洗时间"
) ENGINE=OLAP 
DUPLICATE KEY(`dt`, `product_id`)
COMMENT "沙盘-白嫖用户日报"
DISTRIBUTED BY HASH(`dt`, `product_id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);