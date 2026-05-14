CREATE TABLE `ads_sr_author_resource_active` (
  `dt` date NOT NULL COMMENT "日期",
  `product_id` int(11) NOT NULL COMMENT "产品id",
  `book_id` int(11) NOT NULL COMMENT "书籍id",
  `site_id` int(11) NULL COMMENT "书籍语言id",
  `book_nature` int(11) NULL COMMENT "机翻1，人工2，原创3 cp4 原创拆章5 翻译拆章6 原创图书7  9cp 翻译",
  `author_id` int(11) NULL COMMENT "作者id",
  `author_name` varchar(255) NULL COMMENT "作者笔名",
  `responsibility_id` int(11) NULL COMMENT "责编",
  `network_id` int(11) NULL COMMENT "网编",
  `network_status` int(11) NULL COMMENT "网编启用状态 1 启用 0关闭",
  `check_status` int(11) NULL COMMENT "审核状态(-1未签约/0=待审核/1=通过/2=拒绝/3=已审核(待回签)/4=签订完毕/5=合同签订完毕/6=作者拒签/7=补录审核/8=主编拒签)",
  `apply_time` datetime NULL COMMENT "合同申请时间",
  `contract_start_time` datetime NULL COMMENT "合同开始时间",
  `contract_end_time` datetime NULL COMMENT "合同结束时间",
  `is_sign` int(11) NULL COMMENT "是否签约",
  `sign_type` int(11) NULL COMMENT "签约类型(-1=未签约/0=等待联系编辑/1=独家/2=非独家/3=解约)",
  `is_putdown` int(11) NULL COMMENT "是否下架(0=下架/1=上架)",
  `public_time` datetime NULL COMMENT "发布时间",
  `etl_time` datetime NULL COMMENT "etl时间"
) ENGINE=OLAP 
DUPLICATE KEY(`dt`, `product_id`, `book_id`)
COMMENT "海阅-作者资源活跃情况报表"
DISTRIBUTED BY HASH(`dt`, `product_id`, `book_id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);