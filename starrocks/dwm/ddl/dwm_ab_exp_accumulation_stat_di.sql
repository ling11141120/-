drop table if exists tmp.dwm_ab_exp_accumulation_stat_di;
CREATE TABLE tmp.dwm_ab_exp_accumulation_stat_di (
  dt date NOT NULL COMMENT "日期天分区",
  exp_id int(11) NOT NULL COMMENT "实验ID",
  exp_grp_id int(11) NOT NULL COMMENT "实验组ID",
  exp_grp_ver_id bigint(20) NOT NULL COMMENT "实验组版本ID",
  unlock_amount bigint(20) NULL COMMENT "解锁数量"
)
PRIMARY KEY(dt, exp_id, exp_grp_id, exp_grp_ver_id)
COMMENT "海剧-AB实验-核心指标-可累加指标-小时统计"
PARTITION BY RANGE(dt)
(PARTITION p20260303 values less than ("2026-03-04"))
DISTRIBUTED BY HASH(exp_id, exp_grp_id, exp_grp_ver_id) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "exp_id, exp_grp_id, exp_grp_ver_id",
"dynamic_partition.enable" = "true",
"dynamic_partition.time_unit" = "DAY",
"dynamic_partition.time_zone" = "Asia/Shanghai",
"dynamic_partition.start" = "-365",
"dynamic_partition.end" = "3",
"dynamic_partition.prefix" = "p",
"dynamic_partition.buckets" = "3",
"dynamic_partition.history_partition_num" = "0",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"storage_medium" = "SSD",
"compression" = "ZSTD"
);