CREATE TABLE `ads_bi_short_video_action_stat_old` (
  `dt` date NOT NULL COMMENT "日期",
  `md5_key` varchar(65533) NOT NULL COMMENT "主键key",
  `series_id` bigint(20) NULL COMMENT "短剧ID",
  `is_toufang` smallint(6) NULL COMMENT "用户维度(是否引流):0:全部；1：引流；2：非引流",
  `source` varchar(65533) NULL COMMENT "媒体",
  `mt` smallint(6) NULL COMMENT "终端",
  `product_id` smallint(6) NULL COMMENT "产品名称",
  `series_name` varchar(65533) NULL COMMENT "短剧名称",
  `series_language` smallint(6) NULL COMMENT "短剧语言",
  `last_epis` bigint(20) NULL COMMENT "发布剧集",
  `series_code` varchar(65533) NULL COMMENT "短剧代号",
  `series_tp` varchar(65533) NULL COMMENT "短剧分类",
  `publish_tm` datetime NULL COMMENT "上架时间",
  `click_user_bitmap` bitmap NULL COMMENT "点击user的bitmap",
  `exposure_user_bitmap` bitmap NULL COMMENT "曝光user的bitmap",
  `unlock_user_bitmap` bitmap NULL COMMENT "解锁user的bitmap",
  `etl_time` datetime NOT NULL COMMENT "数据清洗时间",
  INDEX index_series_language (`series_language`) USING BITMAP COMMENT '短剧语言索引'
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `md5_key`)
COMMENT "海外短剧行为统计表"
DISTRIBUTED BY HASH(`dt`, `md5_key`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);