CREATE TABLE `ods_tidb_Shuangwen_BookEditorTask` (
  `dt` datetime NOT NULL COMMENT "分区日期",
  `product_id` int(11) NOT NULL COMMENT "产品id",
  `Id` bigint(20) NOT NULL COMMENT "自增id,",
  `BookId` bigint(20) NULL COMMENT "书籍id",
  `UserId` bigint(20) NULL COMMENT "网编账号",
  `Config` varchar(65533) NULL COMMENT "配置信息",
  `SignType` int(11) NULL COMMENT "签约类型0非独家1独家",
  `TaskId` varchar(65533) NULL COMMENT "任务id",
  `TaskStatus` int(11) NULL COMMENT "任务状态0完成1待执行",
  `Status` int(11) NULL COMMENT "完成状态0初始1条件完成2发放3未完成4未签约",
  `TaskTime` datetime NULL COMMENT "任务执行时间",
  `Language` int(11) NULL COMMENT "语言",
  `RewardType` int(11) NULL COMMENT "完结奖励，签约奖励，字数奖励，月度绩效",
  `ExecTime` datetime NULL COMMENT "执行时间",
  `CreateTime` datetime NULL COMMENT "新增时间",
  `RewardMoeny` double NULL COMMENT "奖励金额",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间",
  INDEX index_ProductId (`product_id`) USING BITMAP COMMENT 'index_Product_Id'
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `product_id`, `Id`)
COMMENT "网编书籍任务表"
DISTRIBUTED BY HASH(`product_id`, `Id`) BUCKETS 5 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "CreateTime",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
