CREATE TABLE `ads_report_position_reward_load_time` (
  `dt` date NOT NULL COMMENT "事件分区",
  `product_id` int(11) NULL COMMENT "产品id",
  `adid` varchar(65533) NULL COMMENT "广告id",
  `app_position` varchar(65533) NULL COMMENT "广告位置",
  `corever` int(11) NULL COMMENT "corever",
  `mt` int(11) NULL COMMENT "终端",
  `app_ver` varchar(512) NULL COMMENT "手机串码",
  `avg_num` decimal(20, 6) NULL COMMENT "上报时长均值",
  `counts` int(11) NULL COMMENT "上报次数",
  `positions` int(11) NULL COMMENT "位置",
  `types` int(11) NULL COMMENT "1:客户端",
  `etl_time` datetime NOT NULL COMMENT "数据清洗时间",
  `ad_plat_form` int(11) NULL COMMENT "广告平台（1admob激励广告，100华为激励广告，101google adsense展示广告，20tradplus聚合广告，102xh-ad广告，103topon聚合平台，104max聚合平台）"
) ENGINE=OLAP 
DUPLICATE KEY(`dt`, `product_id`)
COMMENT "沙盘：广告位置上报时长"
DISTRIBUTED BY HASH(`dt`, `product_id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);