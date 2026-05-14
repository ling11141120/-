CREATE TABLE `ods_tidb_shuangwen_tidb_en_viscfocusbookconfig` (
  `id` int(11) NOT NULL COMMENT "自增id",
  `bookid` bigint(20) NOT NULL COMMENT "爽文书籍id",
  `siteid` int(11) NOT NULL COMMENT "站点id",
  `bookname` varchar(1500) NOT NULL COMMENT "书籍名称",
  `bookcode` varchar(1500) NULL COMMENT "书籍代号",
  `monthtime` datetime NOT NULL COMMENT "月份",
  `createtime` datetime NOT NULL COMMENT "创建时间",
  `resourcetype` int(11) NOT NULL COMMENT "资源位置",
  `lengthtarget` int(11) NOT NULL COMMENT "字数目标",
  `delstatus` int(11) NOT NULL COMMENT "是否删除",
  `estimateddeliverydate` datetime NULL COMMENT "预计交付日期",
  `priority` int(11) NULL COMMENT "优先级 p0  p1  p2 ",
  `translationtype` int(11) NULL COMMENT "翻译类型（1机翻，2机翻+精修（外籍）,3机翻+精修（非外籍）,4常规翻译,5其他）",
  `deliverytype` int(11) NULL COMMENT "交付类型（1MAI、2测试题材、3英语小测、4原创衍生、5其他）",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks入库时间",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`id`)
COMMENT "聚焦书籍配置表"
DISTRIBUTED BY HASH(`id`)
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
