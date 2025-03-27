CREATE TABLE `bigdata_sql_file` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `bigdata_sql_id` varchar(64) COLLATE utf8mb4_bin NOT NULL COMMENT '大数据sql工单ID',
  `filename` varchar(200) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '文件名',
  `sql_content` text COLLATE utf8mb4_bin NOT NULL COMMENT 'sql',
  `tablet` text COLLATE utf8mb4_bin COMMENT 'tablet分析',
  `ai_content` text COLLATE utf8mb4_bin COMMENT 'AI优化建议',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=35 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='大数据sql工单文件'