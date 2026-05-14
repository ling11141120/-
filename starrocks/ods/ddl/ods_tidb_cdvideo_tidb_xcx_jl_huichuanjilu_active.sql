CREATE TABLE `ods_tidb_cdvideo_tidb_xcx_jl_huichuanjilu_active` (
  `Id` bigint(20) NOT NULL COMMENT "自增ID",
  `huichuanjilu_id` varchar(150) NULL COMMENT "huichuanjilu._id",
  `huichuanjilu_type` varchar(150) NULL COMMENT "huichuanjilu.type",
  `huichuanjilu_user_id` varchar(150) NULL COMMENT "huichuanjilu.user_id",
  `user_id` bigint(20) NULL COMMENT "外键accountinfo.id",
  `platform` varchar(150) NULL COMMENT "huichuanjilu.platform",
  `reback` int(11) NULL COMMENT "huichuanjilu.reback,-1代表转成int失败",
  `manual` int(11) NULL COMMENT "huichuanjilu.manual,-1代表转成bool失败",
  `req_id` varchar(150) NULL COMMENT "huichuanjilu.req_id",
  `promotion_id` varchar(150) NULL COMMENT "huichuanjilu.promotion_id",
  `project_id` varchar(150) NULL COMMENT "huichuanjilu.project_id",
  `create_time` datetime NULL COMMENT "huichuanjilu._add_time",
  `reback_time` datetime NULL COMMENT "huichuanjilu.reback_time",
  `SendToAds` int(11) NULL DEFAULT "0" COMMENT "是否已经处理到广告系统",
  `MiddleManId` varchar(300) NULL COMMENT "huichuanjilu.middleman_id",
  `tv_id` varchar(150) NULL COMMENT "a_ad_login_log.tv_id",
  `invite_code` varchar(150) NULL COMMENT "a_ad_login_log.invite_code",
  `tfid` varchar(150) NULL COMMENT "huichuanjilu.tfid",
  `os` varchar(300) NULL COMMENT "huichuanjilu.os系统",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "",
  `sr_updatetime` datetime NULL COMMENT ""
) ENGINE=OLAP 
PRIMARY KEY(`Id`)
COMMENT "国剧用户激活表"
DISTRIBUTED BY HASH(`Id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
