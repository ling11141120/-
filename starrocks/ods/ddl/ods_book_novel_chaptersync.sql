CREATE TABLE `ods_book_novel_chaptersync` (
  `yt` date NOT NULL COMMENT "create_time按年分区",
  `AutoId` bigint(20) NOT NULL COMMENT "自增id",
  `chapter_id` bigint(20) NOT NULL COMMENT "章节id",
  `book_id` bigint(20) NOT NULL COMMENT "书籍id",
  `chapter_name` varchar(65533) NOT NULL COMMENT "章节名称",
  `chapter_length` int(11) NOT NULL COMMENT "章节字数",
  `chapter_content` varchar(65533) NOT NULL COMMENT "章节内容",
  `status` int(11) NOT NULL COMMENT "状态",
  `vip` int(11) NOT NULL COMMENT "是否vip",
  `create_time` datetime NOT NULL COMMENT "创建时间",
  `update_time` datetime NOT NULL COMMENT "更新时间",
  `timer` datetime NULL COMMENT "更新时间（例如章节字数有发生变化，时间会更新）",
  `public_time` datetime NULL COMMENT "更新时间",
  `serial_number` int(11) NOT NULL COMMENT "章节序号",
  `m_flag` int(11) NOT NULL COMMENT "没用字段",
  `site_id` int(11) NOT NULL COMMENT "书籍id",
  `is_lock` int(11) NULL COMMENT "没用字段",
  `IsSyncFt` int(11) NULL COMMENT "是否同步",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间",
  INDEX index_bookid (`book_id`) USING BITMAP COMMENT '书籍id索引'
) ENGINE=OLAP 
PRIMARY KEY(`yt`, `AutoId`)
COMMENT "繁体书籍章节信息表-按年分区"
DISTRIBUTED BY HASH(`yt`, `AutoId`) BUCKETS 15 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "create_time, book_id",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
