CREATE TABLE `ods_tidb_short_video_customer_message` (
  `Id` bigint(20) NOT NULL COMMENT "主键ID",
  `Project` varchar(200) NULL COMMENT "项目 短剧：sv",
  `LangId` int(11) NULL COMMENT "语言",
  `Account` varchar(200) NULL COMMENT "账号",
  `NickName` varchar(200) NULL COMMENT "昵称",
  `Mt` int(11) NULL COMMENT "最新平台号,1为iOS 4为安卓",
  `AppVer` varchar(200) NULL COMMENT "版本号",
  `core` int(11) NULL COMMENT "core",
  `MsgType` varchar(200) NULL COMMENT "message/reply/ignore/autoReply",
  `ContentType` int(11) NULL COMMENT "内容类型 1文本 2字段",
  `Content` varchar(65533) NULL COMMENT "内容短剧简介",
  `CreateTime` bigint(20) NULL COMMENT "创建时间",
  `UpdateTime` bigint(20) NULL COMMENT "更新时间",
  `Staff` varchar(200) NULL COMMENT "客服人员",
  `StaffType` int(11) NULL COMMENT "客服类型：0-客服；1-ChatGpt(AI客服)",
  `HasReply` int(11) NULL COMMENT "是否已回复",
  `AccountId` bigint(20) NULL COMMENT "账号id",
  `Picture` varchar(500) NULL COMMENT "图片",
  `BigPicture` varchar(500) NULL COMMENT "大图",
  `DeviceInfo` varchar(200) NULL COMMENT "设备信息",
  `regionId` int(11) NULL DEFAULT "1" COMMENT "归属区域 id，1：香港，2：北美；",
  `Country` varchar(500) NULL DEFAULT "未知国家" COMMENT "国家,保存中文",
  `IsRecharge` int(11) NULL COMMENT "是否充值：0-否，1-是",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`Id`)
COMMENT "广告自动关闭规则 操作日志,author:742337"
DISTRIBUTED BY HASH(`Id`) BUCKETS 20 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
