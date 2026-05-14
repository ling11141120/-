CREATE TABLE `ads_content_task_center` (
  `md5_key` varchar(65533) NOT NULL COMMENT "唯一主键",
  `dt` date NOT NULL COMMENT "统计日期（任务中心页面中的添加时间）",
  `site_id` bigint(20) NOT NULL COMMENT "语言ID",
  `author_id` bigint(20) NULL COMMENT "译员ID（被抽查人ID）",
  `role_type` bigint(20) NOT NULL COMMENT "角色类型1：译员、2：外籍一校、3：二校、4：三校、5：PM、6：初译审核、7：初校审核、8：国内测试稿审核、9：国外测试稿审核、10：三校抽查、11：一校抽查、12：质检抽查",
  `check_model` bigint(20) NOT NULL COMMENT "抽查模型  7：新签约的质检  8：新签约的一校  9：新签约的二校",
  `pen_name` varchar(765) NULL COMMENT "被抽查人",
  `etl_time` datetime NOT NULL COMMENT "数据清洗时间"
) ENGINE=OLAP 
PRIMARY KEY(`md5_key`)
DISTRIBUTED BY HASH(`md5_key`) BUCKETS 14 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "false",
"replicated_storage" = "true",
"compression" = "LZ4"
);