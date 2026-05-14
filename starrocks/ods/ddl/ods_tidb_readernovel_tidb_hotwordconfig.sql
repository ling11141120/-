CREATE TABLE `ods_tidb_readernovel_tidb_hotwordconfig` (
  `product_id` int(11) NOT NULL COMMENT "产品id",
  `Id` int(11) NOT NULL COMMENT "自增id",
  `HotWord` varchar(100) NULL COMMENT "热词",
  `KeyWords` varchar(500) NULL COMMENT "关键词",
  `CreateTime` datetime NULL COMMENT "创建时间",
  `DelFlag` int(11) NULL COMMENT "删除标志",
  `Language` int(11) NULL DEFAULT "3" COMMENT "语言",
  `BookListCfgs` varchar(1500) NULL COMMENT "强推书配置",
  `PopUpBookID` bigint(20) NULL COMMENT "弹窗书籍Id",
  `Flag` int(11) NULL DEFAULT "0" COMMENT "屏蔽标识(1屏蔽 0正常)",
  `SeoHotWord` varchar(300) NULL COMMENT "Seo优化后的热词",
  `UpdateTime` datetime NULL COMMENT "更新时间",
  `sr_updatetime` datetime NULL COMMENT "ods同步时间",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间",
  INDEX idx_hotwordconfig_seohotword (`SeoHotWord`) USING BITMAP,
  INDEX idx_hotwordconfig_hotword (`HotWord`) USING BITMAP
) ENGINE=OLAP 
PRIMARY KEY(`product_id`, `Id`)
COMMENT "seo 热搜词记录"
DISTRIBUTED BY HASH(`product_id`, `Id`) BUCKETS 5 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "CreateTime, UpdateTime",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
