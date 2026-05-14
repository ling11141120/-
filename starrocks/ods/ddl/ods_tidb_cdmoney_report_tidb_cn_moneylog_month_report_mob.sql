CREATE TABLE `ods_tidb_cdmoney_report_tidb_cn_moneylog_month_report_mob` (
  `id` bigint(20) NOT NULL COMMENT "自增ID",
  `dt` int(11) NULL COMMENT "账期(yyyyMM)",
  `dt_year` int(11) NULL COMMENT "账期(yyyy)",
  `product_id` int(11) NULL COMMENT "产品id",
  `pre_cost` bigint(20) NULL COMMENT "阅币存点（期初）",
  `recharge` bigint(20) NULL COMMENT "本月充值阅币,getmoneylog.realget",
  `cost` bigint(20) NULL COMMENT "本月消耗阅币, usermoneylog.amount",
  `next_cost` bigint(20) NULL COMMENT "阅币存点（期末）",
  `add_time` datetime NULL COMMENT "添加时间",
  `sync_update_time` datetime NULL COMMENT "数据更新时间戳",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`id`)
COMMENT "进销存统计表(人工),author:510161"
DISTRIBUTED BY HASH(`id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
