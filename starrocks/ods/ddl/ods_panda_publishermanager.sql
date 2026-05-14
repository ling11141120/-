CREATE TABLE `ods_panda_publishermanager` (
  `PublishID` varchar(40) NOT NULL COMMENT "合作商id",
  `yt` date NOT NULL COMMENT "CreateTime年分区",
  `PublishName` varchar(200) NULL COMMENT "合作商名称",
  `Contact` varchar(20) NULL COMMENT "联系人",
  `Phone` varchar(100) NULL COMMENT "手机号",
  `CreateTime` datetime NULL COMMENT "创建时间",
  `IsTraditional` int(11) NULL COMMENT "0 图书 1 小说 2 漫画",
  `SiteID` int(11) NULL COMMENT "语言id",
  `GroupID` int(11) NULL COMMENT "分组id",
  `FCID` int(11) NULL COMMENT "",
  `CheckStatus` smallint(6) NULL COMMENT "0 未审核 1 审核通过 2 审核未通过",
  `Type` int(11) NULL COMMENT "合作商类型",
  `ImgLiccence` varchar(500) NULL COMMENT "经营许可证图片",
  `ImgOrgnization` varchar(500) NULL COMMENT "组织关系图片",
  `ImgPublish` varchar(500) NULL COMMENT "合作商图片",
  `BlockName` varchar(50) NULL COMMENT "栏目名称",
  `flag` int(11) NOT NULL COMMENT "标识",
  `IsCanModifyChapter` tinyint(4) NOT NULL COMMENT "是否可修改章节",
  `IsUpload` tinyint(4) NOT NULL COMMENT "是否自动上架",
  `Language` int(11) NULL COMMENT "0 简体   1 繁体",
  `IsSynchro` int(11) NOT NULL COMMENT "是否同步繁体  0：是     1：否",
  `FtBeginTime` datetime NULL COMMENT "繁体合作开始时间(控制海外销售显示时间，空则显示全部)",
  `IsEffective` int(11) NOT NULL COMMENT "是否有效的合作商 0：是 1 ：否(用与合同到期推送 1 不推送)",
  `GrantStatus` int(11) NULL COMMENT "授权方式  1 授权畅读 2 授权安卓读书 3 全部授权 4 全部未授权",
  `RowVersion` bigint(20) NULL COMMENT "数据版本",
  `IsDownShelf` int(11) NOT NULL COMMENT "书籍合作商 下架状态  1 下架   0默认无（搞不懂只是弄个页面筛选吧）",
  `IsAdSale` int(11) NOT NULL COMMENT "免费小说收入是否结算(广告收入)  0：否  1：是",
  `AdContractTimeBegin` datetime NULL COMMENT "合同开始时间",
  `AdContractTimeEnd` datetime NULL COMMENT "合同结束时间",
  `IsAdUpShelf` int(11) NOT NULL COMMENT " 广告合作商 上架状态  1 上架   0 默认下架",
  `IsOnlyAgent` int(11) NULL COMMENT "是否代运营：0-否，1-是",
  `BookIsGrant` boolean NULL COMMENT "书籍是否授权",
  `OutputBlockName` varchar(50) NULL COMMENT "输出块名",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`PublishID`)
COMMENT "合作商信息表"
DISTRIBUTED BY HASH(`PublishID`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "PublishID",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
