CREATE TABLE `dws_consume_user_chapter_ulk_td_mid` (
  `dt` date NOT NULL COMMENT "统计日期",
  `product_id` int(11) NOT NULL COMMENT "产品id",
  `user_id` bigint(20) NOT NULL COMMENT "用户id",
  `total_bat_ulk_cnt` int(11) NULL COMMENT "累计批量解锁次数",
  `total_fix_ulk_cnt` int(11) NULL COMMENT "累计一口价解锁次数",
  `sup_ulk_cnt` int(11) NULL COMMENT "超点解锁次数",
  `sup_ulk_sum` decimal(14, 4) NULL COMMENT "超点解锁金额",
  `total_bat_ulk_money` decimal(14, 4) NULL COMMENT "批量解锁阅币金额",
  `start_sup_ulk_chp_cnt` int(11) NULL COMMENT "首次超点解锁章节数（不分货币类型）",
  `start_sup_ulk_chp_money` decimal(14, 4) NULL COMMENT "首次超点解锁金额",
  `start_bat_ulk_gear` int(11) NULL COMMENT "首次批量解锁档位（不分阅币礼券赠送币）：例如用户一次性批量解锁了10章 档位即为10",
  `start_bat_ulk_chp_cnt` int(11) NULL COMMENT "首次批量解锁章节数（不分阅币礼券赠送币）",
  `start_bat_ulk_money` decimal(14, 4) NULL COMMENT "首次批量解锁阅币金额(只包含阅币的)",
  `start_bat_ulk_giftmoney` decimal(14, 4) NULL COMMENT "首次批量解锁礼券金额(只包含礼券的)",
  `start_bat_ulk_time` datetime NULL COMMENT "首次批量解锁时间",
  `start_sup_ulk_chp_time` datetime NULL COMMENT "首次超点解锁时间",
  `etl_time` datetime NULL COMMENT "数据更新时间",
  INDEX index_Product_id (`Product_id`) USING BITMAP COMMENT 'index_Product_id'
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `product_id`, `user_id`)
COMMENT "用户解锁相关指标涉及货币 阅币、礼券、赠送币，"
PARTITION BY RANGE(`dt`)
(PARTITION p20260507 VALUES [("2026-05-07"), ("2026-05-08")),
PARTITION p20260508 VALUES [("2026-05-08"), ("2026-05-09")),
PARTITION p20260509 VALUES [("2026-05-09"), ("2026-05-10")),
PARTITION p20260510 VALUES [("2026-05-10"), ("2026-05-11")),
PARTITION p20260511 VALUES [("2026-05-11"), ("2026-05-12")),
PARTITION p20260512 VALUES [("2026-05-12"), ("2026-05-13")),
PARTITION p20260513 VALUES [("2026-05-13"), ("2026-05-14")),
PARTITION p20260514 VALUES [("2026-05-14"), ("2026-05-15")),
PARTITION p20260515 VALUES [("2026-05-15"), ("2026-05-16")),
PARTITION p20260516 VALUES [("2026-05-16"), ("2026-05-17")),
PARTITION p20260517 VALUES [("2026-05-17"), ("2026-05-18")))
DISTRIBUTED BY HASH(`dt`, `product_id`, `user_id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "user_id",
"dynamic_partition.enable" = "true",
"dynamic_partition.time_unit" = "DAY",
"dynamic_partition.time_zone" = "Asia/Shanghai",
"dynamic_partition.start" = "-7",
"dynamic_partition.end" = "3",
"dynamic_partition.prefix" = "p",
"dynamic_partition.buckets" = "7",
"dynamic_partition.history_partition_num" = "0",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
