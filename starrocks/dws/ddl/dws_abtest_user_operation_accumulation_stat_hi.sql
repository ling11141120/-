CREATE TABLE `dws_abtest_user_operation_accumulation_stat_hi` (
  `dt_hour` datetime NOT NULL COMMENT "日期",
  `project_id` int(11) NOT NULL COMMENT "项目ID",
  `exp_id` int(11) NOT NULL COMMENT "实验ID",
  `exp_grp_id` int(11) NOT NULL COMMENT "实验组ID",
  `exp_name` varchar(65533) NOT NULL COMMENT "实验名称",
  `exp_grp_type` int(11) NOT NULL COMMENT "实验组类型",
  `exp_grp_name` varchar(65533) NOT NULL COMMENT "实验组名称",
  `traffic_allocation` decimal(20, 4) NULL COMMENT "流量占比",
  `recharge_times` int(11) NULL COMMENT "充值次数",
  `ifd_oper_recharge_amount` decimal(20, 4) NULL COMMENT "充值金额(分成前)",
  `ifd_oper_money_consume` decimal(20, 4) NULL COMMENT "充值消费:  阅读业务指 type=1：阅币    短剧业务指 type=0：货币",
  `ifd_oper_total_consume` decimal(20, 4) NULL COMMENT "总消费:  阅读业务指如下三种 type= 1：阅币、2：礼券、3：赠送币    短剧业务指如下两种 type=0：货币、1：赠币",
  `etl_time` datetime NOT NULL COMMENT "数据清洗时间"
) ENGINE=OLAP 
PRIMARY KEY(`dt_hour`, `project_id`, `exp_id`, `exp_grp_id`)
COMMENT "AB测试-用户运营--可累加指标--小时汇总表"
DISTRIBUTED BY HASH(`dt_hour`, `project_id`, `exp_id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "project_id, exp_id",
"colocate_with" = "operation_join_group",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"storage_medium" = "SSD",
"compression" = "ZSTD"
);
