CREATE TABLE `ods_tidb_sharpengine_analysis_tidb_ads_tts2s_notify` (
  `Id` bigint(20) NOT NULL COMMENT "自增id",
  `CreateTime` datetime NULL COMMENT "创建时间",
  `pixelid` varchar(65533) NULL COMMENT "像素Id",
  `ttp` varchar(65533) NULL COMMENT "ttp",
  `ttclid` varchar(65533) NULL COMMENT "tiktok的clickid",
  `ua` varchar(65533) NULL COMMENT "UserAgent",
  `ip` varchar(65533) NULL COMMENT "客户端IP",
  `TraceId` varchar(65533) NULL COMMENT "追踪的数据Id",
  `RawUrl` varchar(65533) NULL COMMENT "广告请求的原始参数",
  `adid` varchar(65533) NULL COMMENT "广告Id",
  `bookid` varchar(65533) NULL COMMENT "书籍id",
  `url` varchar(65533) NULL COMMENT "页面地址参数",
  `pageversion` varchar(65533) NULL COMMENT "页面版本",
  `device` varchar(65533) NULL COMMENT "设备型号",
  `sysversion` varchar(65533) NULL COMMENT "系统版本",
  `os_major` varchar(65533) NULL COMMENT "操作系统大版本号",
  `checksign` varchar(65533) NULL COMMENT "UA的字符做Md5,用处不大",
  `mt` int(11) NULL COMMENT "设备：1苹果 4安卓",
  `core` int(11) NULL COMMENT "core",
  `appid` bigint(20) NULL COMMENT "服务器定义的9位AppId",
  `c2rtime` datetime NULL COMMENT "用户点击continue to read 按钮的时间，相当于点击跳到商店页的按钮",
  `chapterindex` varchar(65533) NULL COMMENT "章节序号",
  `pageid` varchar(65533) NULL COMMENT "落地页id",
  `picid` bigint(20) NULL COMMENT "图片id",
  `picid2` bigint(20) NULL COMMENT "图片id2",
  `docid` bigint(20) NULL COMMENT "文案id",
  `btnid` bigint(20) NULL COMMENT "按钮id",
  `abtestpageid` varchar(1024) NULL COMMENT "abtest的页面编号",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "sr数据创建时间",
  `sr_updatetime` datetime NULL COMMENT "sr数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`Id`)
COMMENT "TikTok广告推送点击表"
DISTRIBUTED BY HASH(`Id`) BUCKETS 700 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "bookid",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
