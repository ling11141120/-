CREATE TABLE `ads_sv_translate_production` (
  `id` bigint(20) NOT NULL COMMENT "Id",
  `series_id` int(11) NULL COMMENT "短剧id",
  `series_code` varchar(50) NULL COMMENT "短剧代号",
  `object_series_name` varchar(200) NULL COMMENT "爆款-短剧名称",
  `series_name` varchar(1000) NULL COMMENT "短剧名称",
  `language_id` varchar(200) NULL COMMENT "短剧语言id",
  `level` int(11) NULL COMMENT "翻译优先级(1 加急, 2 P0, 3 P1, 4 P2)",
  `last_epis` int(11) NULL COMMENT "发布剧集数",
  `create_time` datetime NULL COMMENT "下单创建时间",
  `begin_time` datetime NULL COMMENT "开始翻译时间",
  `end_time` datetime NULL COMMENT "结束翻译时间",
  `check_time` datetime NULL COMMENT "抽查完成时间",
  `check_inspectors_id` int(11) NULL COMMENT "抽查人员id",
  `check_inspectors_name` varchar(200) NULL COMMENT "抽查人员名称",
  `check_num` int(11) NULL COMMENT "抽查短剧剧集数",
  `etl_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "etl清洗时间"
) ENGINE=OLAP 
PRIMARY KEY(`id`)
COMMENT "海剧-海剧生产报表"
DISTRIBUTED BY HASH(`id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);