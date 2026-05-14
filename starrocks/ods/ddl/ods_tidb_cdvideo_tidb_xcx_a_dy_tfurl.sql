CREATE TABLE `ods_tidb_cdvideo_tidb_xcx_a_dy_tfurl` (
  `Id` bigint(20) NOT NULL COMMENT "自增ID",
  `tfid` varchar(65533) NULL COMMENT "投放",
  `tfurl` varchar(65533) NULL COMMENT "投放链接",
  `agentId` varchar(65533) NULL COMMENT "代理商id",
  `agent_username` varchar(65533) NULL COMMENT "代理商名称",
  `agent_nickname` varchar(65533) NULL COMMENT "代理商昵称",
  `ad_id` varchar(65533) NULL COMMENT "广告id",
  `descs` varchar(65533) NULL COMMENT "a_dy_tfurl.desc",
  `middleman_id` varchar(65533) NULL COMMENT "机构id",
  `middleman_username` varchar(65533) NULL COMMENT "机构名称",
  `middleman_nickname` varchar(65533) NULL COMMENT "机构昵称",
  `appid` varchar(65533) NULL COMMENT "appid",
  `appname` varchar(65533) NULL COMMENT "appname",
  `tv_id` varchar(65533) NULL COMMENT "tv_id",
  `tv_name` varchar(65533) NULL COMMENT "tv_name",
  `series` varchar(65533) NULL COMMENT "series",
  `follow` varchar(65533) NULL COMMENT "follow",
  `gzhId` varchar(65533) NULL COMMENT "gzhId",
  `path` varchar(65533) NULL COMMENT "路径",
  `platform` varchar(65533) NULL COMMENT "平添",
  `start_needpay` varchar(65533) NULL COMMENT "start_needpay",
  `how_much` varchar(65533) NULL COMMENT "价格",
  `back_setting_id` varchar(65533) NULL COMMENT "back_setting_id",
  `create_time` datetime NULL COMMENT "创建时间",
  `url_link` varchar(65533) NULL COMMENT "url_link",
  `url_link_expire_time` datetime NULL COMMENT "url_link_expire_time",
  `xcxpath` varchar(65533) NULL COMMENT "xcxpath",
  `bind_first_recharge_text` varchar(65533) NULL COMMENT "bind_first_recharge_text",
  `bind_again_recharge_text` varchar(65533) NULL COMMENT "bind_again_recharge_text",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间",
  `sr_updatetime` datetime NULL COMMENT "starrocks数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`Id`)
COMMENT "国剧投放链接表"
DISTRIBUTED BY HASH(`Id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "tfid",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
