CREATE TABLE `ods_mysql_finedb_fine_authority_object` (
  `id` varchar(255) NOT NULL COMMENT "",
  `tenantId` varchar(255) NULL DEFAULT "default" COMMENT "",
  `expandId` varchar(255) NULL COMMENT "",
  `expandType` int(11) NULL COMMENT "",
  `fullPath` varchar(3000) NULL COMMENT "",
  `parentId` varchar(255) NULL COMMENT "",
  `coverId` varchar(255) NULL COMMENT "",
  `description` varchar(65533) NULL COMMENT "",
  `deviceType` int(11) NULL COMMENT "",
  `displayName` varchar(255) NULL COMMENT "",
  `icon` varchar(255) NULL COMMENT "",
  `mobileIcon` varchar(255) NULL COMMENT "",
  `path` varchar(65533) NULL COMMENT "",
  `sortIndex` bigint(20) NULL COMMENT "",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "",
  `sr_updatetime` datetime NULL COMMENT ""
) ENGINE=OLAP 
PRIMARY KEY(`id`)
COMMENT "finebi数据"
DISTRIBUTED BY HASH(`id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
