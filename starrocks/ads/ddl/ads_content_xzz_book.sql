CREATE TABLE `ads_content_xzz_book` (
  `dt` date NOT NULL COMMENT "统计日期",
  `book_id` int(11) NOT NULL COMMENT "书籍ID",
  `language` varchar(128) NULL COMMENT "书籍语言",
  `book_code` varchar(128) NULL COMMENT "书籍编码",
  `book_xl` varchar(128) NULL COMMENT "书籍系列",
  `lian_zai_status` varchar(128) NULL COMMENT "连载状态",
  `font_length` bigint(20) NULL COMMENT "发布字数",
  `update_time` datetime NULL COMMENT "更新时间",
  `jt_putaway_status` varchar(128) NULL COMMENT "简体上架状态",
  `ft_putaway_status` varchar(128) NULL COMMENT "繁体上架状态",
  `haiwai_jt_putaway_status` varchar(128) NULL COMMENT "海外简体上架状态",
  `story_type` int(11) NULL COMMENT "类型0长篇小说 1短篇小说",
  `test_status` int(11) NULL DEFAULT "0" COMMENT "测试状态 0=未开始|1=测试中|2=已结束 3=停投  -1表示null或者空串",
  `price_per_thousand` int(11) NULL COMMENT "千字价格",
  `if_important_author` int(11) NULL COMMENT "是否是重点作者 1是  0否",
  `code_stage` int(11) NULL COMMENT "测试阶段 海阅最大3阶 海剧最大2阶 国剧就1阶",
  `plan_round` int(11) NULL COMMENT "测试轮次1|2|3",
  `curr_month_score` varchar(100) NULL COMMENT "当月评级",
  `his_max_score` varchar(100) NULL COMMENT "历史最高评级",
  `total_income` decimal(20, 4) NULL COMMENT "总收入",
  `total_cost` decimal(20, 4) NULL COMMENT "总成本",
  `tf_cost` decimal(20, 4) NULL COMMENT "投放成本",
  `d0_first_pay_num` int(11) NULL COMMENT "Day0付费人数",
  `reg_num` int(11) NULL COMMENT "注册人数",
  `d0_amount` decimal(20, 4) NULL COMMENT "d0收入",
  `spend` decimal(20, 4) NULL COMMENT "花费",
  `etl_time` datetime NOT NULL COMMENT "数据清洗时间"
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `book_id`)
COMMENT "作品管理"
DISTRIBUTED BY HASH(`book_id`) BUCKETS 7 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "book_id",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);