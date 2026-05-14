CREATE TABLE `ods_tidb_sharpengine_ads_global_adsadgroupcountrydailyinsight` (
  `dt` date NOT NULL COMMENT "数据日期",
  `id` bigint(20) NOT NULL COMMENT "主键ID",
  `adgroupid` varchar(150) NOT NULL COMMENT "广告组ID",
  `account` varchar(384) NOT NULL COMMENT "广告账号",
  `date_start` varchar(150) NOT NULL COMMENT "数据日期",
  `date_stop` varchar(150) NOT NULL COMMENT "数据日期结束（同 date_start）",
  `adgroupname` varchar(1500) NULL COMMENT "广告组名称",
  `countrycode` varchar(30) NOT NULL COMMENT "国家代码，ISO两字母，如US、CN",
  `spend` decimal(10, 2) NOT NULL COMMENT "花费",
  `installs` int(11) NOT NULL COMMENT "注册/安装转化数",
  `clicks` int(11) NOT NULL COMMENT "点击数",
  `impressions` int(11) NOT NULL COMMENT "展示数",
  `amount` decimal(10, 2) NOT NULL COMMENT "充值金额（转化价值）",
  `updatetime` datetime NOT NULL COMMENT "更新时间",
  `createtime` datetime NOT NULL COMMENT "创建时间",
  `mt` int(11) NOT NULL COMMENT "媒体类型（1=iOS,4=Android）",
  `productid` varchar(150) NULL COMMENT "产品ID",
  `campid` varchar(384) NULL COMMENT "广告系列ID",
  `rowversion` bigint(20) NULL COMMENT "行版本号",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `id`)
COMMENT "谷歌国家维度花费表,author:742337"
PARTITION BY date_trunc('month', dt)
DISTRIBUTED BY HASH(`id`)
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
