CREATE TABLE `ods_edit_shuangwen_chapter_temp` (
  `Productid` int(11) NOT NULL COMMENT "产品id",
  `book_id` bigint(20) NOT NULL COMMENT "书籍id",
  `chapter_id` bigint(20) NOT NULL COMMENT "章节id",
  `site_id` int(11) NOT NULL COMMENT "siteid",
  `chapter_name` varchar(65533) NULL COMMENT "章节名称",
  `chapter_length` int(11) NULL COMMENT "章节字数",
  `chapter_content` varchar(1048576) NULL COMMENT "章节内容",
  `status` int(11) NULL COMMENT "状态",
  `vip` int(11) NULL COMMENT " 是否收费",
  `create_time` datetime NULL COMMENT "创建时间",
  `update_time` datetime NULL COMMENT "更新时间",
  `timer` datetime NULL COMMENT "更新时间（例如章节字数有发生变化，时间会更新）",
  `public_time` datetime NULL COMMENT "发布时间",
  `serial_number` int(11) NULL COMMENT "章节号",
  `m_flag` int(11) NULL COMMENT "是否立即更新",
  `is_lock` int(11) NULL COMMENT "",
  `Translator` varchar(500) NULL COMMENT "翻译者",
  `Editor` varchar(500) NULL COMMENT "校对者",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`Productid`, `book_id`, `chapter_id`, `site_id`)
COMMENT "章节信息表"
DISTRIBUTED BY HASH(`Productid`, `book_id`) BUCKETS 5 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "create_time, Translator, Editor",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
