CREATE TABLE `ods_sharpengine_bi_syncbi_reader_ads_marketing_plan` (
  `source_chl` varchar(500) NOT NULL COMMENT "媒体",
  `book_id` varchar(500) NOT NULL COMMENT "书籍ID",
  `code_stage` int(11) NULL COMMENT "代号阶段 海阅最大3阶 国剧就1阶, -1=最终阶段禁投",
  `code_lv` varchar(100) NULL COMMENT "最高阶段投放等级 B|A|S|SS",
  `etl_time` datetime NULL COMMENT "数据清洗时间",
  `begin_time` datetime NULL COMMENT "投放开始时间",
  `test_status` int(11) NULL COMMENT "测试状态 -1=无状态|0=未开始测试|1=正在测试|2=结束测试|3=停投",
  `is_auto_creation` int(11) NULL COMMENT "是否开启自动创编 0=否|1=自动创编|2=小预算自动创编|3=小预算VIP自动创编",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "sr入库时间",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`source_chl`, `book_id`)
COMMENT "海阅-超前点播章节策略自动化"
DISTRIBUTED BY HASH(`source_chl`, `book_id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
