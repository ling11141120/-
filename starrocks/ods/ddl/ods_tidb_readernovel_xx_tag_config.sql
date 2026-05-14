CREATE TABLE `ods_tidb_readernovel_xx_tag_config` (
  `Id` int(11) NOT NULL COMMENT "",
  `productId` varchar(65533) NOT NULL COMMENT "产品id",
  `Category` varchar(255) NULL COMMENT "分类",
  `Tag` varchar(255) NULL COMMENT "标签",
  `CreatedBy` varchar(255) NULL COMMENT "创建人",
  `CreatedTime` datetime NULL COMMENT "创建时间",
  `UpdatedBy` varchar(255) NULL COMMENT "更新人",
  `UpdatedTime` datetime NULL COMMENT "创建人",
  `IsDelete` int(11) NULL DEFAULT "0" COMMENT "是否删除",
  `RowVersion` bigint(20) NULL COMMENT "版本",
  `SiteId` int(11) NULL DEFAULT "0" COMMENT "书籍语言id",
  `Sort` int(11) NULL DEFAULT "0" COMMENT "排序",
  `Status` int(11) NULL DEFAULT "0" COMMENT "状态",
  `CategoryRemark` varchar(150) NULL DEFAULT "" COMMENT "分类描述",
  `TagRemark` varchar(150) NULL DEFAULT "" COMMENT "描述",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "",
  `sr_updatetime` datetime NULL COMMENT ""
) ENGINE=OLAP 
PRIMARY KEY(`Id`, `productId`)
COMMENT "书籍标签维度表"
DISTRIBUTED BY HASH(`Id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
