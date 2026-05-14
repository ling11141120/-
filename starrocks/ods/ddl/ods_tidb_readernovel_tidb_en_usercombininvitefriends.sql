CREATE TABLE `ods_tidb_readernovel_tidb_en_usercombininvitefriends` (
  `dt` date NOT NULL COMMENT "分区",
  `product_id` int(11) NOT NULL COMMENT "产品id",
  `id` bigint(20) NOT NULL COMMENT "id",
  `pid` bigint(20) NOT NULL COMMENT "用户id",
  `actid` bigint(20) NULL COMMENT "组合活动id",
  `inviteuserid` bigint(20) NULL COMMENT "邀请用户id",
  `inviteaccount` varchar(50) NULL COMMENT "邀请用户account",
  `createtime` datetime NOT NULL COMMENT "创建时间",
  `actbegintime` datetime NULL COMMENT "活动开始时间",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `product_id`, `id`)
COMMENT "组合活动邀请活动用户列表"
PARTITION BY date_trunc('year', dt)
DISTRIBUTED BY HASH(`dt`, `product_id`, `id`)
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
