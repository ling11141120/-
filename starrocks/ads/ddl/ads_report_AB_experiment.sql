CREATE TABLE `ads_report_AB_experiment` (
  `dt` date NOT NULL COMMENT "统计周期",
  `app_lang_id` int(11) NOT NULL COMMENT "界面语言",
  `page_name` varchar(65533) NOT NULL COMMENT "页面名称",
  `recommet_unt` bitmap NULL COMMENT "推荐人数",
  `read_unt` bitmap NULL COMMENT "阅读人数（曝光之后20秒内有阅读）",
  `consume_unt` bitmap NULL COMMENT "消耗人数",
  `total_consume` bigint(20) NULL COMMENT "总消耗",
  `total_csum_num` bigint(20) NULL COMMENT "解锁章节数",
  `csum_avg_exposure` decimal(16, 2) NULL COMMENT "人均消费/曝光",
  `csum_avg_read` decimal(16, 2) NULL COMMENT "阅读转化率",
  `csum_avg_csum` decimal(16, 2) NULL COMMENT "消费转化率",
  `user_money_consume` bigint(20) NULL COMMENT "阅币消耗",
  `user_money_consume_unt` bitmap NULL COMMENT "阅币消耗人数",
  `charge_unt` bitmap NULL COMMENT "充值人数",
  `charge_money` bigint(20) NULL COMMENT "充值金额",
  `etl_time` datetime NULL COMMENT "处理时间"
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `app_lang_id`, `page_name`)
DISTRIBUTED BY HASH(`dt`, `app_lang_id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);