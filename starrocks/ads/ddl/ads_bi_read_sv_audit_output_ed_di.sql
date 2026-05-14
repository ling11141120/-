CREATE TABLE `ads_bi_read_sv_audit_output_ed_di` (
  `dt` date NOT NULL COMMENT "日期(事件时间)",
  `to_language` int(11) NOT NULL COMMENT "语言",
  `real_name` varchar(65533) NOT NULL COMMENT "姓名",
  `pen_name` varchar(65533) NULL COMMENT "译名",
  `book_product` bigint(20) NULL COMMENT "阅读的产能，字数",
  `book_choucha_product` bigint(20) NULL COMMENT "阅读(抽查)的产能，字数",
  `book_chuyi_product` bigint(20) NULL COMMENT "阅读(初译)的产能，字数",
  `short_video_product` bigint(20) NULL COMMENT "短剧的产能，字数",
  `short_video_choucha_product` bigint(20) NULL COMMENT "短剧(抽查)的产能，字数",
  `short_video_chuyi_product` bigint(20) NULL COMMENT "短剧(初译)的产能，字数",
  `test_draft` bigint(20) NULL COMMENT "测试稿份数",
  `monthtarget` bigint(20) NULL COMMENT "月度目标",
  `translate_num` bigint(20) NULL COMMENT "已完成翻译字数",
  `clean_water_cnt` bigint(20) NULL COMMENT "清水状态份数",
  `etl_time` datetime NULL COMMENT "处理时间"
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `to_language`, `real_name`)
COMMENT "审核产出指标表"
DISTRIBUTED BY HASH(`dt`, `to_language`, `real_name`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);