CREATE TABLE `dwd_advertisement_admobmediationreport` (
  `dt` date NOT NULL COMMENT "日期，来自createdtime字段",
  `id` bigint(20) NOT NULL COMMENT "自增id",
  `date_dt` varchar(65533) NULL COMMENT "日期",
  `ad_unit` varchar(65533) NULL COMMENT "广告单元id",
  `country` varchar(65533) NULL COMMENT "国家",
  `platform` varchar(65533) NULL COMMENT "系统",
  `ad_source` varchar(65533) NULL COMMENT "广告来源",
  `app` varchar(65533) NULL COMMENT "appid",
  `ad_requests` int(11) NULL COMMENT "请求的数量。该值是一个整数。",
  `clicks` int(11) NULL COMMENT "用户点击广告的次数。该值是一个整数。",
  `estimated_earnings` bigint(20) NULL COMMENT "admob 发布商的估算收入 例如，6.50 美元将表示为 6500000",
  `impressions` int(11) NULL COMMENT "向用户展示的广告总数。该值是一个整数。",
  `matched_requests` int(11) NULL COMMENT "响应请求而返回广告的次数。该值是一个整数。",
  `match_rate` double NULL COMMENT "匹配的广告请求与总广告请求的比率。该值是双精度（近似）十进制值。",
  `observed_ecpm` bigint(20) NULL COMMENT "第三方广告网络的估计平均 ecpm 例如，$2.30 将表示为 2300000",
  `account` varchar(65533) NULL COMMENT "广告账户",
  `created_tm` datetime NULL COMMENT "创建时间",
  `updated_tm` datetime NULL COMMENT "更新时间",
  `etl_tm` datetime NULL COMMENT "数据创建时间"
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `id`)
COMMENT "Admob中介报告表"
PARTITION BY RANGE(`dt`)
(PARTITION p2022 VALUES [("2022-01-01"), ("2023-01-01")),
PARTITION p2023 VALUES [("2023-01-01"), ("2024-01-01")),
PARTITION p2024 VALUES [("2024-01-01"), ("2025-01-01")),
PARTITION p2025 VALUES [("2025-01-01"), ("2026-01-01")),
PARTITION p2026 VALUES [("2026-01-01"), ("2027-01-01")),
PARTITION p2027 VALUES [("2027-01-01"), ("2028-01-01")),
PARTITION p2028 VALUES [("2028-01-01"), ("2029-01-01")),
PARTITION p2029 VALUES [("2029-01-01"), ("2030-01-01")))
DISTRIBUTED BY HASH(`dt`, `id`) BUCKETS 5 
PROPERTIES (
"replication_num" = "3",
"dynamic_partition.enable" = "true",
"dynamic_partition.time_unit" = "YEAR",
"dynamic_partition.time_zone" = "Asia/Shanghai",
"dynamic_partition.start" = "-10",
"dynamic_partition.end" = "3",
"dynamic_partition.prefix" = "p",
"dynamic_partition.history_partition_num" = "0",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);