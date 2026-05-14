CREATE TABLE `ods_tidb_shuangwen_xx_tagbookinfo` (
  `product_id` int(11) NOT NULL COMMENT "产品id",
  `id` bigint(20) NOT NULL COMMENT "id",
  `bookid` bigint(20) NULL COMMENT "书籍id",
  `tagid` bigint(20) NULL COMMENT "标签id",
  `creator` varchar(150) NULL COMMENT "创建人",
  `creationtime` datetime NULL COMMENT "创建时间",
  `isdelete` int(11) NULL COMMENT "是否删除",
  `rowversion` datetime NULL COMMENT "行版本",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks入库时间",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`product_id`, `id`)
COMMENT "书籍id-标签映射表"
DISTRIBUTED BY HASH(`product_id`, `id`)
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
