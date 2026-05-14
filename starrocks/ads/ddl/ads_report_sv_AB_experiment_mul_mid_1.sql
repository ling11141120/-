CREATE TABLE `ads_report_sv_AB_experiment_mul_mid_1` (
  `dt` date NOT NULL COMMENT "统计周期",
  `source_types` smallint(6) NOT NULL COMMENT "推荐来源(1 普通弹窗,2 充值返回推,3 剧末推,4 退出观看返回推,5 悬浮窗,6 TAB栏,7 banner,8 push,9 串剧,10 开屏页,11 首页,12 追剧页,13 浏览历史页,14 剧集解锁记录,15 搜索页,16 搜索中间页,17 我的评论页,18 edm,19 for you)",
  `is_toufang` smallint(6) NOT NULL COMMENT "用户维度(是否引流):0:全部；1：引流；2：非引流",
  `product_id` int(11) NOT NULL COMMENT "产品语言",
  `user_id` bigint(20) NOT NULL COMMENT "用户id",
  `series_id` bigint(20) NOT NULL COMMENT "视频id",
  `is_watch` smallint(6) NULL COMMENT "是否观看",
  `total_watch_epis` bitmap NULL COMMENT "观看集数",
  `consume_amount` decimal(38, 6) NULL COMMENT "消耗金额数（观看币、观看券）",
  `consume_epis` bitmap NULL COMMENT "解锁剧集数",
  `consume_money_amount` decimal(38, 6) NULL COMMENT "观看比消耗金额数",
  `charge_money` decimal(38, 6) NULL COMMENT "充值金额（分成前）",
  `etl_time` datetime NULL COMMENT "处理时间"
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `source_types`, `is_toufang`, `product_id`, `user_id`, `series_id`)
COMMENT "海剧算法实验3.0中间表"
DISTRIBUTED BY HASH(`dt`, `user_id`) BUCKETS 5 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);