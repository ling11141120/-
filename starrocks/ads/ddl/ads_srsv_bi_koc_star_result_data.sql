CREATE TABLE `ads_srsv_bi_koc_star_result_data` (
  `dt` date NOT NULL COMMENT "日期",
  `business_mode` varchar(255) NOT NULL COMMENT "业务模式",
  `institution_id` varchar(65533) NOT NULL COMMENT "机构id",
  `country_type` int(11) NOT NULL COMMENT "国家地区 0无 1国内  2国外",
  `new_star_num` int(11) NULL COMMENT "新增达人数量",
  `etl_tm` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间"
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `business_mode`, `institution_id`, `country_type`)
COMMENT "KOC达人统计转化报表"
DISTRIBUTED BY HASH(`dt`, `institution_id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "false",
"replicated_storage" = "true",
"compression" = "LZ4"
);