CREATE TABLE `dws_flow_exposure_click_task_ed` (
  `dt` date NOT NULL COMMENT "流量时间",
  `user_id` bigint(20) NOT NULL COMMENT "用户id",
  `product_id` int(11) NOT NULL COMMENT "产品id",
  `user_type` int(11) NOT NULL COMMENT "1IAA 2纯白嫖 3付费白嫖 4非白嫖",
  `task_name` varchar(65533) NOT NULL COMMENT "任务名称",
  `corever` int(11) NULL COMMENT "core",
  `mt` int(11) NULL COMMENT "设备",
  `app_ver` varchar(65533) NULL COMMENT "app版本",
  `event` varchar(65533) NULL COMMENT "事件",
  `task_exp_cnt` bigint(20) NOT NULL COMMENT "任务曝光",
  `task_clk_cnt` bigint(20) NOT NULL COMMENT "任务点击",
  `click_get_user` varchar(65533) NULL COMMENT "",
  `wacthuser` varchar(65533) NULL COMMENT "额外观看视频user",
  `points_user_id` bigint(20) NULL COMMENT "任务完成user",
  `etl_tm` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT ""
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `user_id`, `product_id`, `user_type`, `task_name`)
DISTRIBUTED BY HASH(`user_id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
