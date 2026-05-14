CREATE TABLE `feedback_analysis_requirement` (
  `dt` date NOT NULL COMMENT "日期",
  `sheet_name` varchar(255) NOT NULL COMMENT "需求所在的工作表名称",
  `row_index` int(11) NOT NULL COMMENT "需求在工作表中的行号",
  `business_line` varchar(255) NULL COMMENT "业务线",
  `requirement_document` varchar(65533) NULL COMMENT "需求文档的链接或内容",
  `priority` varchar(10) NULL COMMENT "需求的优先级（低、中、高）",
  `difficulty` varchar(10) NULL COMMENT "需求实现的难度（简单、一般、困难）",
  `requester` varchar(255) NULL COMMENT "提出需求的人",
  `business_department` varchar(255) NULL COMMENT "需求所属的业务部门",
  `analyst` varchar(255) NULL COMMENT "负责分析需求的分析师",
  `request_date` date NULL COMMENT "需求提交的时间",
  `expected_completion_date` date NULL COMMENT "期望完成需求的时间",
  `schedule_date` date NULL COMMENT "排期时间",
  `actual_completion_date` date NULL COMMENT "实际完成时间",
  `requirement_summary` varchar(65533) NULL COMMENT "需求简述",
  `report_url` varchar(65533) NULL COMMENT "报告的地址或链接",
  `update_time` datetime NOT NULL COMMENT "更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `sheet_name`, `row_index`)
COMMENT "反馈表1-分析需求"
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