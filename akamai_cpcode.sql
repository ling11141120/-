CREATE TABLE `akamai_cpcode` (
  `cpcode_id` int NOT NULL DEFAULT '0' COMMENT 'cpcodeId',
  `cpcode_name` varchar(50) COLLATE utf8mb4_bin NOT NULL COMMENT '域名',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`cpcode_name`,`cpcode_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin ROW_FORMAT=DYNAMIC COMMENT='akamai cpcode数据'