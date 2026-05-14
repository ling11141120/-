CREATE TABLE `ods_tidb_readernovel_tidb_xx_recoment_detail` (
  `productid` int(11) NOT NULL COMMENT "",
  `id` bigint(20) NOT NULL COMMENT "",
  `bookid` bigint(20) NOT NULL COMMENT "书本id",
  `Language` int(11) NOT NULL COMMENT "语言",
  `title` varchar(600) NULL COMMENT "标题",
  `recomment_order` int(11) NULL COMMENT "推荐顺序",
  `update_time` datetime NULL COMMENT "更新时间",
  `publish_time` datetime NULL COMMENT "发布时间",
  `positionid` bigint(20) NULL COMMENT "书籍位置id",
  `IsDelete` int(11) NULL COMMENT "是否删除",
  `row_update_time` datetime NULL COMMENT "行更新信息",
  `SyncLanguage` varchar(600) NULL COMMENT "无用",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "",
  `sr_updatetime` datetime NULL COMMENT ""
) ENGINE=OLAP 
PRIMARY KEY(`productid`, `id`, `bookid`, `Language`)
DISTRIBUTED BY HASH(`id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
