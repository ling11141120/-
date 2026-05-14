CREATE TABLE `tmp_check_version` (
  `dt` date NULL COMMENT "",
  `md5_key` varchar(1048576) NULL COMMENT "",
  `ad_show_type` varchar(50) NULL COMMENT "",
  `ad_position_id` bigint(20) NULL COMMENT "",
  `ad_id` varchar(200) NULL COMMENT "",
  `core` varchar(50) NULL COMMENT "",
  `mt` varchar(20) NULL COMMENT "",
  `version` varchar(1048576) NULL COMMENT "",
  `language_id` varchar(20) NULL COMMENT "",
  `reg_country` varchar(50) NULL COMMENT "",
  `ad_show_type_name` varchar(100) NULL COMMENT "",
  `ad_position_name` varchar(200) NULL COMMENT "",
  `mt_name` varchar(1048576) NULL COMMENT "",
  `language_name` varchar(100) NULL COMMENT "",
  `reg_country_name` varchar(100) NULL COMMENT "",
  `ad_request_pv` bigint(20) NULL COMMENT "",
  `ad_request_success_pv` bigint(20) NULL COMMENT "",
  `ad_invocation_pv` bigint(20) NULL COMMENT "",
  `ad_show_success_pv` bigint(20) NULL COMMENT "",
  `total_show_duration` decimal(38, 3) NULL COMMENT "",
  `ad_show_fail_pv` bigint(20) NULL COMMENT "",
  `etl_time` datetime NOT NULL COMMENT "",
  `project_id` bigint(20) NULL COMMENT ""
) ENGINE=OLAP 
DUPLICATE KEY(`dt`, `md5_key`)
DISTRIBUTED BY RANDOM
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "false",
"replicated_storage" = "true",
"compression" = "LZ4"
);
