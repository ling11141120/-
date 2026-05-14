CREATE TABLE `ods_tidb_readernovel_xx_activitygameapplication` (
  `dt` datetime NOT NULL COMMENT "分区日期",
  `product_id` int(11) NOT NULL COMMENT "产品id",
  `Id` int(11) NOT NULL COMMENT "编号",
  `AppGameId` bigint(20) NULL COMMENT "",
  `ActType` int(11) NULL COMMENT "1新人福利活动、2邮箱绑定活动、3月卡活动、4召回活动、5盲盒、6书籍pk",
  `Title` varchar(65533) NULL COMMENT "",
  `StartTime` datetime NOT NULL COMMENT "",
  `EndTime` datetime NOT NULL COMMENT "",
  `Link` varchar(65533) NULL COMMENT "跳转链接",
  `LinkType` int(11) NULL COMMENT "",
  `Icon` varchar(65533) NULL COMMENT "",
  `TopPositionImg` varchar(65533) NULL COMMENT "头部图片",
  `MiddlePositionImg` varchar(65533) NULL COMMENT "中间图片",
  `BottomPositionImg` varchar(65533) NULL COMMENT "底部图片",
  `BottomPositionRecommendImg` varchar(65533) NULL COMMENT "底部推荐图片",
  `Core` varchar(65533) NULL COMMENT "",
  `MinVer` int(11) NULL COMMENT "",
  `MaxVer` int(11) NULL COMMENT "",
  `Platform` int(11) NULL COMMENT "",
  `Description` varchar(65533) NULL COMMENT "",
  `ModifId` varchar(65533) NULL COMMENT "",
  `ModifyTime` datetime NULL COMMENT "",
  `CreateId` varchar(65533) NULL COMMENT "",
  `CreateTime` datetime NULL COMMENT "",
  `DelFlag` int(11) NULL COMMENT "0默认 1删除",
  `MoreGameSort` int(11) NULL COMMENT "更多游戏内的排序",
  `RpsMoreGameImg` varchar(65533) NULL COMMENT "包剪锤更多游戏图片",
  `PlayGamePositionImg` varchar(65533) NULL COMMENT "玩游戏任务图片",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间",
  INDEX index_ProductId (`product_id`) USING BITMAP COMMENT 'index_Product_Id'
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `product_id`, `Id`)
DISTRIBUTED BY HASH(`product_id`, `Id`) BUCKETS 5 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "CreateTime",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
