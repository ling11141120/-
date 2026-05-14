CREATE TABLE `feedback_report_issue` (
  `dt` date NOT NULL COMMENT "日期",
  `sheet_name` varchar(255) NOT NULL COMMENT "需求所在的工作表名称",
  `row_index` int(11) NOT NULL COMMENT "需求在工作表中的行号",
  `product` varchar(255) NULL COMMENT "相关的产品",
  `issue_description` varchar(65533) NULL COMMENT "问题描述",
  `issue_screenshot` varchar(65533) NULL COMMENT "问题截图链接或内容",
  `issue_cause` varchar(65533) NULL COMMENT "问题原因",
  `issue_category` varchar(255) NULL COMMENT "问题分类（如：数据错误、格式问题等）",
  `urgency_level` varchar(50) NULL COMMENT "紧急程度（如：低、中、高）",
  `requester` varchar(255) NULL COMMENT "提需人",
  `request_date` date NULL COMMENT "提需时间",
  `follower` varchar(255) NULL COMMENT "跟进人",
  `status` varchar(50) NULL COMMENT "状态（如：未处理、处理中、已解决）",
  `resolution_date` date NULL COMMENT "解决时间",
  `update_time` datetime NOT NULL COMMENT "更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `sheet_name`, `row_index`)
COMMENT "反馈表3-报表问题"
DISTRIBUTED BY HASH(`dt`, `sheet_name`, `row_index`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"fast_schema_evolution" = "true",
"storage_medium" = "SSD",
"compression" = "ZSTD"
);