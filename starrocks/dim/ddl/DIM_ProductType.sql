CREATE TABLE `DIM_ProductType` (
  `KeyProductType` int(11) NOT NULL COMMENT "type值",
  `ProductTypeName` varchar(50) NULL COMMENT "产品名称",
  `ProductTypeCode` int(11) NULL COMMENT "",
  `Productid` int(11) NULL COMMENT "产品id",
  `langid` int(11) NULL COMMENT "产品语言",
  `abbreviation` varchar(50) NULL COMMENT "语言",
  `book_langid` int(11) NULL COMMENT "书籍语言",
  INDEX index_productid (`productid`) USING BITMAP COMMENT 'index_productid'
) ENGINE=OLAP 
PRIMARY KEY(`KeyProductType`)
COMMENT "产品维度信息表"
DISTRIBUTED BY HASH(`KeyProductType`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);