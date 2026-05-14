CREATE TABLE `ods_tidb_cdvideo_tidb_xcx_accountinfo` (
  `Id` bigint(20) NOT NULL COMMENT "自增id",
  `Account` varchar(65533) NOT NULL COMMENT "账户id",
  `Nick` varchar(65533) NOT NULL COMMENT "昵称",
  `Sex` int(11) NOT NULL COMMENT "性别",
  `CreateTime` datetime NOT NULL COMMENT "创建时间",
  `LastLoginTime` datetime NOT NULL COMMENT "上次登录时间",
  `Chl2` varchar(65533) NOT NULL COMMENT "chl2",
  `Mt2` int(11) NOT NULL COMMENT "设备",
  `UniqueCdReaderId` varchar(65533) NULL COMMENT "唯一设备id，account以及video_user_id一致",
  `CurrentLanguage2` int(11) NULL COMMENT "注册时语言",
  `CoreVer2` int(11) NULL COMMENT "corever2",
  `VideoUserId` varchar(65533) NOT NULL COMMENT "用户id",
  `AdId` varchar(65533) NULL COMMENT "广告id",
  `Status` int(11) NULL COMMENT "用户状态：0 正常，1 禁用，2 审核中，3 审核拒绝",
  `SourceChl` varchar(65533) NULL COMMENT "来源",
  `RegCountry` varchar(65533) NULL COMMENT "注册国家",
  `Agent` int(11) NULL COMMENT "渠道商标识，来自uni-id-users.agent，Agent>=0为渠道商",
  `project_id` varchar(65533) NULL COMMENT "渠道商标识，来自uni-id-users.agent，Agent>=0为渠道商",
  `promotion_id` varchar(65533) NULL COMMENT "",
  `TFID` varchar(65533) NULL COMMENT "投放Id",
  `ReqId` varchar(65533) NULL COMMENT "req_id",
  `MiddleManId` varchar(65533) NULL COMMENT "uni-id-users.middleman_id",
  `PlusType` int(11) NULL COMMENT "会员类型",
  `PlusExpireTime` datetime NULL COMMENT "会员过期时间",
  `LastLoginOS` varchar(65533) NULL COMMENT "最后登录系统",
  `RebackTime` datetime NULL COMMENT "回传时间",
  `RebackActiveTime` datetime NULL COMMENT "回传激活时间",
  `Reback` int(11) NULL COMMENT "是否回传",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间",
  `sr_updatetime` datetime NULL COMMENT "starrocks数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`Id`)
COMMENT "国内短剧用户信息表"
DISTRIBUTED BY HASH(`Id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
