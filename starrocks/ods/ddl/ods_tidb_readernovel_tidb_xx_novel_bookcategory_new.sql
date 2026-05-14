CREATE TABLE `ods_tidb_readernovel_tidb_xx_novel_bookcategory_new` (
  `productid` int(11) NOT NULL COMMENT "产品id",
  `autoid` int(11) NOT NULL COMMENT "自增id",
  `language` int(11) NOT NULL COMMENT "语言",
  `cid` int(11) NOT NULL COMMENT "类别id",
  `sexy` int(11) NULL COMMENT "涉黄等级",
  `cname` varchar(150) NULL COMMENT "类别名称",
  `sort` int(11) NULL COMMENT "排序",
  `ctype` int(11) NULL COMMENT "频道",
  `keyword` varchar(6000) NULL COMMENT "seo 关键字",
  `titleword` varchar(6000) NULL COMMENT "",
  `descriptionword` varchar(6000) NULL COMMENT "描述",
  `cover` varchar(1500) NULL COMMENT "",
  `newcover` varchar(1500) NULL COMMENT "",
  `isdelete` int(11) NULL COMMENT "是否删除",
  `row_update_time` datetime NULL COMMENT "行更新时间",
  `synclanguage` varchar(1200) NULL COMMENT "",
  `newcover2` varchar(1255) NULL COMMENT "",
  `newcover2black` varchar(1255) NULL COMMENT "",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "数仓入库时间",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "数仓更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`productid`, `autoid`, `language`)
DISTRIBUTED BY HASH(`autoid`)
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
