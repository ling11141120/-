CREATE TABLE `ods_tidb_readernovel_tidb_tag_center_activity_news` (
  `Id` int(11) NOT NULL COMMENT "Id",
  `ActivityId` int(11) NOT NULL COMMENT "活动Id",
  `SendType` tinyint(4) NOT NULL COMMENT "发送类型 1：立即发送，2：根据最后登录时间",
  `MaterialId` int(11) NOT NULL COMMENT "素材Id",
  `TitleId` int(11) NOT NULL COMMENT "标题Id",
  `Url` varchar(4096) NOT NULL COMMENT "连接",
  `CreateTime` datetime NOT NULL COMMENT "创建时间",
  `Status` tinyint(4) NOT NULL COMMENT "状态 0：待处理，1已处理，2：处理异常",
  `SendHour` decimal(4, 2) NOT NULL COMMENT "起始时间延误时间",
  `GroupIds` varchar(1024) NULL COMMENT "人群包",
  `ExcludeGroupIds` varchar(1024) NULL COMMENT "排斥人群包",
  `Name` varchar(1024) NULL COMMENT "名称",
  `Timezone` varchar(128) NULL COMMENT "时区",
  `SendTime` datetime NULL COMMENT "发送时间",
  `MaterialType` tinyint(4) NOT NULL COMMENT "素材类型 0：自定义，1：书籍素材策略库",
  `FrequencyType` tinyint(4) NOT NULL COMMENT "频率类型 0 单次，1 活动期间每日",
  `UpdateTime` datetime NULL COMMENT "",
  `UseType` tinyint(4) NOT NULL COMMENT "素材类型 0：书籍推荐，1：书籍更新",
  `ApplyType` int(11) NOT NULL COMMENT "应用类型 0：All，1：正式，2：测试",
  `JGroupIds` varchar(256) NULL COMMENT "极光人群包",
  `ExcludeJGroupIds` varchar(256) NULL COMMENT "极光剔除人群包",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`Id`)
COMMENT "活动动作私信"
DISTRIBUTED BY HASH(`Id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
