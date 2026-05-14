CREATE TABLE `feedback_report_requirement` (
  `dt` date NOT NULL COMMENT "日期",
  `sheet_name` varchar(255) NOT NULL COMMENT "需求所在的工作表名称",
  `row_index` int(11) NOT NULL COMMENT "需求在工作表中的行号",
  `product` varchar(255) NULL COMMENT "产品",
  `report_name` varchar(255) NULL COMMENT "报表名称",
  `priority` varchar(10) NULL COMMENT "优先级",
  `difficulty` varchar(10) NULL COMMENT "难度（简单、一般、困难）",
  `requester` varchar(255) NULL COMMENT "提需人",
  `requestor_side` varchar(255) NULL COMMENT "提需方",
  `maker` varchar(255) NULL COMMENT "制作人",
  `base_table_maker` varchar(255) NULL COMMENT "底表制作",
  `request_date` date NULL COMMENT "提需时间",
  `expected_date` date NULL COMMENT "期望时间",
  `schedule_date` date NULL COMMENT "排期时间",
  `online_date` date NULL COMMENT "上线时间",
  `requirement_document` varchar(65533) NULL COMMENT "需求文档",
  `report_url` varchar(65533) NULL COMMENT "报表地址",
  `update_time` datetime NOT NULL COMMENT "更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `sheet_name`, `row_index`)
COMMENT "反馈表4-报表需求"
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