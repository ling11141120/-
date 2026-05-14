CREATE TABLE `ads_srsv_bi_ad_optimizer_priority_v1` (
  `dt` datetime NULL COMMENT "统计日期，广告账户时区",
  `product` varchar(50) NULL COMMENT "项目：海剧，海阅",
  `source2` varchar(255) NULL COMMENT "媒体平台：meta，tiktok",
  `current_language` varchar(255) NULL COMMENT "语言",
  `book_code` varchar(255) NULL COMMENT "书籍代号",
  `code_id` varchar(255) NULL COMMENT "书籍id",
  `code_stage` varchar(255) NULL COMMENT "书籍阶段",
  `nick_name` varchar(255) NULL COMMENT "优化师名称",
  `ad_optimizer_uid` varchar(255) NULL COMMENT "优化师id",
  `ad_optimizer_group` varchar(255) NULL COMMENT "优化师组",
  `frt_nickname` varchar(255) NULL COMMENT "首个测试优化师",
  `nick_name_max` varchar(255) NULL COMMENT "截止当前花费最大的优化师",
  `r0_all` varchar(65533) NULL COMMENT "排序roi达标率，有历史数据则为历史新老广告总达标率/90%，否则为100%+（-1%~1%）",
  `rn` int(11) NULL COMMENT "以r0_all，进行排序",
  `etl_tm` datetime NULL COMMENT "清洗时间"
) ENGINE=OLAP 
DUPLICATE KEY(`dt`, `product`)
COMMENT "海阅海剧 广告基建，每日书籍未投放优化师候补优先级"
DISTRIBUTED BY HASH(`dt`, `product`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"storage_medium" = "SSD",
"compression" = "ZSTD"
);