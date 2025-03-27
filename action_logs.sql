CREATE TABLE `action_logs` (
  `id` bigint NOT NULL COMMENT '唯一ID',
  `employee_id` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL DEFAULT '' COMMENT '工号',
  `project_id` bigint DEFAULT NULL COMMENT '项目ID',
  `uri` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '操作的uri',
  `function_desc` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT '' COMMENT '功能描述',
  `origin_data` text CHARACTER SET utf8mb4 COLLATE utf8mb4_bin COMMENT '提交的数据',
  `ip` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT 'ip',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_eid` (`employee_id`) USING BTREE,
  KEY `idx_uri` (`uri`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='操作日志表'