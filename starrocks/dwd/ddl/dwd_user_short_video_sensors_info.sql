CREATE TABLE `dwd_user_short_video_sensors_info` (
  `account` varchar(100) NOT NULL COMMENT "用户id",
  `last_shortplay` varchar(1048576) NULL COMMENT "最新引流短剧",
  `login_days` int(11) NULL COMMENT "登录天数",
  `recharged` varchar(1048576) NULL COMMENT "有无充值",
  `first_recharge` int(11) NULL COMMENT "首次充值金额",
  `total_recharge` int(11) NULL COMMENT "累计充值金额",
  `recharge_avg` decimal(38, 9) NULL COMMENT "平均充值金额",
  `recharge_max` int(11) NULL COMMENT "历史单笔最大充值金额",
  `last_recharge` int(11) NULL COMMENT "最近一次充值金额",
  `recharge_cnt` int(11) NULL COMMENT "累计充值次数",
  `last_recharge_time` varchar(1048576) NULL COMMENT "最近一次充值时间",
  `purcharse` varchar(1048576) NULL COMMENT "有无消费",
  `last_purcharse_time` varchar(1048576) NULL COMMENT "最近一次消费时间",
  `coin_cnt` int(11) NULL COMMENT "付费货币余额",
  `is_watch` varchar(1048576) NULL COMMENT "有无观看",
  `more_onem_total_watch_shortplay` int(11) NULL COMMENT "累计观看剧部数",
  `total_watch_episode` int(11) NULL COMMENT "累计观看剧集数",
  `total_consumption` bigint(20) NULL COMMENT "观看短剧消费剧集数",
  `last_currentlanguage2` varchar(1048576) NULL COMMENT "最新渠道推广语言",
  `certificate_cnt` int(11) NULL COMMENT "免费货币余额",
  `createtime` varchar(1048576) NULL COMMENT "注册时间(绝对)",
  `coin_consumption` int(11) NULL COMMENT "付费货币消费金额",
  `certificate_consumption` int(11) NULL COMMENT "免费货币消费金额",
  `ads_quality` varchar(1048576) NULL COMMENT "质量",
  `last_media_name` varchar(1048576) NULL COMMENT "最新媒体",
  `charge_mode` int(11) NULL COMMENT "充值众数",
  `latest_attribution_ts` varchar(1048576) NULL COMMENT "归因天数",
  `country_last_login` varchar(1048576) NULL COMMENT "",
  `mt` int(11) NULL COMMENT "最后一次登录的国家	",
  `etl_tm` datetime NOT NULL COMMENT "mt"
) ENGINE=OLAP 
PRIMARY KEY(`account`)
DISTRIBUTED BY HASH(`account`) BUCKETS 10 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);