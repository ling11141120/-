CREATE TABLE `ods_tidb_sr_cdcreator_tidb_cn_cp_userinfo_ext` (
  `id` bigint(20) NOT NULL COMMENT "自增ID",
  `cp_userinfo_uuid` varchar(65533) NULL COMMENT "关联版权方用户表,cp_userinfo.uuid",
  `cost_rate_1` int(11) NULL COMMENT "国内(短剧/小说),成本系数,计算时需转成百分比除以100",
  `cost_rate_2` int(11) NULL COMMENT "海外(短剧/小说),成本系数,计算时需转成百分比除以100",
  `lang_cfgs_1` varchar(65533) NULL COMMENT "国内(短剧/小说),结算语种,不同语言逗号分隔",
  `lang_cfgs_2` varchar(65533) NULL COMMENT "海外(短剧/小说),结算语种,不同语言逗号分隔",
  `bind_count_1` int(11) NULL COMMENT "绑定国内(短剧/小说)数量",
  `bind_count_2` int(11) NULL COMMENT "绑定海外(短剧/小说)数量",
  `add_user` varchar(65533) NULL COMMENT "添加人",
  `add_time` datetime NULL COMMENT "添加时间",
  `update_user` varchar(65533) NULL COMMENT "更新人",
  `update_time` datetime NULL COMMENT "更新时间",
  `sync_update_time` datetime NULL COMMENT "数据更新时间戳",
  `sr_createtime` datetime NULL COMMENT "sr入库时间",
  `sr_updatetime` datetime NULL COMMENT "sr更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`id`)
COMMENT "各业务线版权方用户扩展信息表"
DISTRIBUTED BY HASH(`id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "add_time",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
