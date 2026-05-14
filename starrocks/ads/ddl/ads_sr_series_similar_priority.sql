CREATE TABLE `ads_sr_series_similar_priority` (
  `book_id` varchar(255) NOT NULL COMMENT "书籍id",
  `mt` int(11) NOT NULL COMMENT "终端id",
  `book_code2` varchar(255) NOT NULL COMMENT "相似剧code",
  `days_max2` int(11) NULL COMMENT "相似剧最大投放天数",
  `cost_sum2` decimal(14, 4) NULL COMMENT "相似剧累计花费",
  `roi_0to1_2` decimal(14, 4) NULL COMMENT "相似剧D1/D0",
  `roi_0to3_2` decimal(14, 4) NULL COMMENT "相似剧D3/D0",
  `roi_0to7_2` decimal(14, 4) NULL COMMENT "相似剧D7/D0",
  `std_r0to7` decimal(14, 4) NULL COMMENT "相似剧 D7标准/D0标准",
  `std_r7to90` decimal(14, 4) NULL COMMENT "相似剧 D90目标/D7标准",
  `dpt0_rate2` decimal(14, 4) NULL COMMENT "相似剧 DPT的D0收入/D0总收入",
  `new_amt_rate2` decimal(14, 4) NULL COMMENT "相似书 new收入D0/（new收入D0+rmt收入D0+dpt收入）",
  `rt_rate2` decimal(14, 4) NULL COMMENT "相似剧 次留率",
  `ltv0_2` decimal(14, 4) NULL COMMENT "相似剧 D0 ltv",
  `consume_rate_2` decimal(14, 4) NULL COMMENT "D0推广书消费占比",
  `r0_std2` decimal(14, 4) NULL COMMENT "相似剧 D0标准",
  `r7_std2` decimal(14, 4) NULL COMMENT "相似剧 D7标准",
  `roi_0to1_diff` decimal(14, 4) NULL COMMENT "D1/D0，主书 - 相似书",
  `roi_0to3_diff` decimal(14, 4) NULL COMMENT "D3/D0，主书 - 相似书",
  `roi_0to7_diff` decimal(14, 4) NULL COMMENT "D7/D0，主书 - 相似书",
  `std_r0to7_diff` decimal(14, 4) NULL COMMENT "D7标准/D0标准，主书 - 相似书",
  `std_r7to90_diff` decimal(14, 4) NULL COMMENT "D90目标/D7标准，主书 - 相似书",
  `new_amt_rate_dpt_diff` decimal(14, 4) NULL COMMENT "new收入D0/（new收入D0+rmt收入D0+dpt收入），主书 - 相似书",
  `dpt0_rate_diff` decimal(14, 4) NULL COMMENT "DPT的D0收入/D0总收入，主书 - 相似书",
  `rt_rate_diff` decimal(14, 4) NULL COMMENT "次留率，主书 - 相似书",
  `ltv0_diff` decimal(14, 4) NULL COMMENT "D0 ltv，主书 - 相似书",
  `consume_rate_diff` decimal(14, 4) NULL COMMENT "D0推广书消费占比，主书 - 相似书",
  `score` decimal(14, 4) NULL COMMENT "相似剧 主剧和相似剧的差异分",
  `rn` int(11) NULL COMMENT "相似剧 按差异分升序，差异分越小，排名越靠前",
  `etl_tm` datetime NULL COMMENT "数据清洗时间"
) ENGINE=OLAP 
PRIMARY KEY(`book_id`, `mt`, `book_code2`)
COMMENT "相似剧的标准推荐优先级"
DISTRIBUTED BY HASH(`book_id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "book_id",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);