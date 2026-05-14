CREATE TABLE `ads_cvsv_video_income_expand` (
  `dt` date NOT NULL COMMENT "日期(事件时间)",
  `source_series_id` bigint(20) NOT NULL COMMENT "海剧视频",
  `cn_source_series_id` varchar(65533) NOT NULL COMMENT "国剧视频",
  `rights_holder_id` varchar(65533) NULL COMMENT "版权方id(当前)",
  `sv_income` decimal(18, 2) NULL COMMENT "海剧收入",
  `sv_income2` decimal(18, 2) NULL COMMENT "原始海剧收入",
  `sv_expand` decimal(18, 2) NULL COMMENT "海剧支出",
  `cn_income` decimal(18, 2) NULL COMMENT "国剧收入",
  `cn_income2` decimal(18, 2) NULL COMMENT "原始国剧收入",
  `cn_expand` decimal(18, 2) NULL COMMENT "国剧支出",
  `cn_distribute_expand` decimal(18, 2) NULL COMMENT "剧分销支出金额（人民币）",
  `createtime` datetime NULL COMMENT "创建时间",
  `revenue_mapping` varchar(1024) NULL COMMENT "收入映射",
  `income_coef` decimal(18, 2) NULL COMMENT "海剧收入系数",
  `cn_income_coef` decimal(18, 2) NULL COMMENT "国剧收入系数",
  `sv_lang_ids` varchar(1024) NULL COMMENT "结算语种",
  `cn_series_ids` varchar(1024) NULL COMMENT "国剧结算（结算时的所有主剧)",
  `etl_time` datetime NULL COMMENT "处理时间"
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `source_series_id`, `cn_source_series_id`)
COMMENT "海国剧收支数据"
DISTRIBUTED BY HASH(`dt`, `source_series_id`, `cn_source_series_id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);