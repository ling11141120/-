CREATE TABLE `ods_tidb_sharpengine_ads_global_ltvcountrydailyinsight` (
  `dt` date NOT NULL COMMENT "数据日期",
  `id` bigint(20) NOT NULL COMMENT "主键",
  `adid` varchar(150) NULL COMMENT "广告ID",
  `adstatus` varchar(150) NOT NULL COMMENT "广告状态",
  `date_start` varchar(150) NOT NULL COMMENT "数据开始日期,格式：YYYY-MM-DD",
  `date_stop` varchar(150) NOT NULL COMMENT "数据结束日期,格式：YYYY-MM-DD",
  `adname` varchar(1500) NULL COMMENT "广告名称",
  `spend` decimal(10, 2) NOT NULL COMMENT "花费金额,USD",
  `putdata` varchar(65533) NOT NULL COMMENT "原始上报数据,JSON格式",
  `installs` int(11) NOT NULL COMMENT "安装次数,应用安装事件",
  `clicks` int(11) NOT NULL COMMENT "总点击次数",
  `linkclick` int(11) NOT NULL COMMENT "链接点击次数,落地页点击",
  `impressions` int(11) NOT NULL COMMENT "展示次数",
  `cpc` varchar(150) NULL COMMENT "每次点击成本",
  `cpm` varchar(150) NULL COMMENT "每千次展示成本",
  `cpp` varchar(150) NULL COMMENT "每次转化成本",
  `ctr` varchar(150) NULL COMMENT "点击率",
  `updatetime` datetime NOT NULL COMMENT "数据更新时间,含毫秒",
  `mt` int(11) NOT NULL COMMENT "媒体类型标识",
  `core` int(11) NOT NULL COMMENT "core",
  `productid` int(11) NOT NULL COMMENT "产品ID",
  `roas` decimal(10, 2) NOT NULL COMMENT "广告支出回报率",
  `adsetid` varchar(384) NULL COMMENT "广告组ID",
  `adcampid` varchar(384) NULL COMMENT "广告系列ID",
  `country` varchar(150) NULL COMMENT "国家",
  `amount` decimal(10, 2) NOT NULL COMMENT "归因转化金额,本地归因",
  `sourcechl` varchar(150) NULL COMMENT "来源渠道",
  `chl2` varchar(384) NULL COMMENT "二级渠道",
  `createuser` varchar(60) NULL COMMENT "创建用户",
  `createtype` int(11) NOT NULL COMMENT "创建类型",
  `createnum` int(11) NOT NULL COMMENT "创建数量",
  `rowversion` bigint(20) NULL COMMENT "行版本号",
  `currentlanguage2` int(11) NULL COMMENT "当前语言2",
  `isremarketing` int(11) NULL COMMENT "是否再营销广告",
  `account` varchar(300) NULL COMMENT "账号",
  `conversion` int(11) NOT NULL COMMENT "转化次数，通用转化事件",
  `registration` int(11) NOT NULL COMMENT "去重注册数",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `id`)
COMMENT "媒体API国家维度数据"
PARTITION BY date_trunc('month', dt)
DISTRIBUTED BY HASH(`dt`)
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
