CREATE TABLE `user_opt_recharge_daily_report` (
  `dt` date NOT NULL COMMENT "日期",
  `group_name` varchar(1048576) NOT NULL COMMENT "分组名称",
  `total_user_count` bigint(20) NULL COMMENT "总人数",
  `pay_user_count` bigint(20) NULL COMMENT "支付人数",
  `pay_amount` decimal(38, 19) NULL COMMENT "总金额",
  `pay_rate` decimal(16, 6) NULL COMMENT "转化率",
  `arpu` decimal(16, 6) NULL COMMENT "arpu",
  `arppu` decimal(16, 6) NULL COMMENT "arppu",
  `1arpu` decimal(16, 6) NULL COMMENT "1元档位arpu",
  `3arpu` decimal(16, 6) NULL COMMENT "3元档位arpu",
  `5arpu` decimal(16, 6) NULL COMMENT "5元档位arpu",
  `10arpu` decimal(16, 6) NULL COMMENT "10元档位arpu",
  `20arpu` decimal(16, 6) NULL COMMENT "20元档位arpu",
  `30arpu` decimal(16, 6) NULL COMMENT "30元档位arpu",
  `50arpu` decimal(16, 6) NULL COMMENT "50元档位arpu",
  `100arpu` decimal(16, 6) NULL COMMENT "100元档位arpu",
  `other_arpu` decimal(16, 6) NULL COMMENT "其他档位arpu"
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `group_name`)
COMMENT "首复充每日效果日志"
DISTRIBUTED BY HASH(`dt`, `group_name`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);