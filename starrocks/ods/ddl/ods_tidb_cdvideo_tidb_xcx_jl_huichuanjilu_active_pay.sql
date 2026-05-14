CREATE TABLE `ods_tidb_cdvideo_tidb_xcx_jl_huichuanjilu_active_pay` (
  `Id` bigint(20) NOT NULL COMMENT "自增ID",
  `huichuanjilu_id` varchar(150) NULL COMMENT "huichuanjilu._id",
  `huichuanjilu_type` varchar(150) NULL COMMENT "huichuanjilu.type",
  `huichuanjilu_user_id` varchar(150) NULL COMMENT "huichuanjilu.user_id",
  `user_id` bigint(20) NULL COMMENT "外键accountinfo.id",
  `tfid` varchar(150) NULL COMMENT "huichuanjilu.tfid",
  `agent_id` varchar(150) NULL COMMENT "huichuanjilu.agent_id",
  `adid` varchar(150) NULL COMMENT "huichuanjilu.adid",
  `out_trade_no` varchar(150) NULL COMMENT "huichuanjilu.out_trade_no",
  `money` int(11) NULL COMMENT "huichuanjilu.money",
  `reback` int(11) NULL COMMENT "huichuanjilu.reback,-1代表转成int失败",
  `MiddleManId` varchar(100) NULL COMMENT "huichuanjilu.middleman_id",
  `SendToAds` int(11) NULL DEFAULT "0" COMMENT "是否已经处理到广告系统",
  `create_time` datetime NULL COMMENT "huichuanjilu._add_time",
  `reback_time` datetime NULL COMMENT "huichuanjilu.reback_time",
  `platform` varchar(150) NULL COMMENT "huichuanjilu.platform",
  `manual` int(11) NULL COMMENT "huichuanjilu.manual,-1代表转成bool失败",
  `promotion_id` varchar(150) NULL COMMENT "huichuanjilu.promotion_id",
  `project_id` varchar(150) NULL COMMENT "huichuanjilu.project_id",
  `os` varchar(300) NULL COMMENT "huichuanjilu.os系统",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "",
  `sr_updatetime` datetime NULL COMMENT ""
) ENGINE=OLAP 
PRIMARY KEY(`Id`)
DISTRIBUTED BY HASH(`Id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
