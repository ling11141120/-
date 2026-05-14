CREATE TABLE `dwd_center_push_position_gen_msg_convert_rate_di` (
  `dt` date NOT NULL COMMENT "分区日期",
  `id` bigint(20) NOT NULL COMMENT "主键id",
  `push_position_id` bigint(20) NULL COMMENT "push资源位id。center_push_position表id",
  `generate_day` varchar(512) NULL COMMENT "记录生成日期（西五区），格式：yyyyMMdd,20240724",
  `group_ids` varchar(512) NULL COMMENT "选中人群包id（逗号分割）",
  `exclude_group_ids` varchar(512) NULL COMMENT "剔除人群包id（逗号分割）",
  `activity_interaction_group_id` varchar(512) NULL COMMENT "push资源位的人群包与活动策略的人群包的交集人群包",
  `cur_index` int(11) NULL COMMENT "当前所有人群包（如上）对应的分片。取值：0~255",
  `cur_index_all_send_msg` int(11) NULL COMMENT "当前人群包（如上）分片中，预计需要生成的消息总数。目前cur_index_all_send_msg=cur_index_all_user_count；后续如果一个策略对于一个用户需要发送多条消息，则cur_index_all_send_msg>cur_index_all_user_count。cur_index_all_send_msg=cur_index_succes_gen_count+cur_index_fail_gen_count+cur_index_has_send_count",
  `cur_index_all_user_count` int(11) NULL COMMENT "当前人群包（如上）分片中，需要发送消息的总人数",
  `cur_index_success_gen_count` int(11) NULL COMMENT "当前人群包（如上）分片中，实际生成消息成功的总数",
  `cur_index_fail_gen_count` int(11) NULL COMMENT "当前人群包（如上）分片中，生成消息失败的总数",
  `cur_index_has_send_count` int(11) NULL COMMENT "当前人群包（如上）分片中，已经发送的总数",
  `cur_index_non_token` json NULL COMMENT "当前人群包（如上）分片中，缺少token的用户id。多个用户用逗号隔开。key为ids，value多个用户用逗号隔开",
  `cur_index_condition_non_match` json NULL COMMENT "当前人群包（如上）分片中，用户的mtlangidcoreverid与资源位(或者策略条件，目前仅有Core)条件不匹配的用户id。key为ids，value多个用户用逗号隔开",
  `cur_index_non_active_or_register_time` json NULL COMMENT "当前人群包（如上）分片中，用户的最后活跃时间或者注册时间（创建时间）不存在的用户id。key为ids，value多个用户用逗号隔开",
  `cur_index_sendTime_non_match` json NULL COMMENT "当前人群包（如上）分片中，用户的消息发送时间与比系统生成消息系统时间还要晚30min，不生成消息。保存用户id,sendTime。key为ids，value多个用户,发送时间用分号隔开",
  `cur_index_non_token_count` int(11) NULL COMMENT "当前人群包（如上）分片中，缺少token的用户id个数",
  `cur_index_condition_non_match_count` int(11) NULL COMMENT "当前人群包（如上）分片中，用户的mtlangidcoreverid与资源位(或者策略条件，目前仅有Core)条件不匹配的用户id个数",
  `cur_index_non_active_or_register_time_count` int(11) NULL COMMENT "当前人群包（如上）分片中，用户的最后活跃时间或者注册时间（创建时间）不存在的用户id个数",
  `cur_index_sendTime_non_match_count` int(11) NULL COMMENT "当前人群包（如上）分片中，用户的消息发送时间与比系统生成消息系统时间还要晚30min，不生成消息的消息数",
  `remark` varchar(1024) NULL COMMENT "备注:对当前命中策略、人群包、执行情况的说明",
  `create_time` datetime NULL COMMENT "创建时间",
  `update_time` datetime NULL COMMENT "更新时间",
  `etl_tm` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "清洗时间"
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `id`)
COMMENT "push资源位生成消息日转化率统计表"
PARTITION BY RANGE(`dt`)
(PARTITION p2024 VALUES [("2024-01-01"), ("2025-01-01")),
PARTITION p2025 VALUES [("2025-01-01"), ("2026-01-01")),
PARTITION p2026 VALUES [("2026-01-01"), ("2027-01-01")),
PARTITION p2027 VALUES [("2027-01-01"), ("2028-01-01")),
PARTITION p2028 VALUES [("2028-01-01"), ("2029-01-01")),
PARTITION p2029 VALUES [("2029-01-01"), ("2030-01-01")))
DISTRIBUTED BY HASH(`dt`, `id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"dynamic_partition.enable" = "true",
"dynamic_partition.time_unit" = "YEAR",
"dynamic_partition.time_zone" = "Asia/Shanghai",
"dynamic_partition.start" = "-92",
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