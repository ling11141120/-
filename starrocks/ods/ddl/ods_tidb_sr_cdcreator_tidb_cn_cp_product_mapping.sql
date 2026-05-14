CREATE TABLE `ods_tidb_sr_cdcreator_tidb_cn_cp_product_mapping` (
  `id` bigint(20) NOT NULL COMMENT "自增ID",
  `cp_userinfo_uuid` varchar(65533) NULL COMMENT "关联版权方用户表,cp_userinfo.uuid",
  `product_type` int(11) NULL COMMENT "产品类型(1-短剧,2-阅读)",
  `source_id` varchar(65533) NULL COMMENT "映射id(国剧/国阅)",
  `source_name` varchar(65533) NULL COMMENT "(国剧/国阅)短剧名称/小说名称",
  `target_id` varchar(65533) NULL COMMENT "映射id（海剧/海阅）",
  `target_name` varchar(65533) NULL COMMENT "(海剧/海阅)短剧名称/小说名称",
  `settle_status` int(11) NULL COMMENT "结算状态(0-未结算,1-已结算)",
  `add_user` varchar(65533) NULL COMMENT "添加人",
  `add_time` datetime NULL COMMENT "添加时间",
  `update_user` varchar(65533) NULL COMMENT "更新人",
  `update_time` datetime NULL COMMENT "更新时间",
  `sync_update_time` datetime NULL COMMENT "数据更新时间戳",
  `sr_createtime` datetime NULL COMMENT "sr入库时间",
  `sr_updatetime` datetime NULL COMMENT "sr更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`id`)
COMMENT "国海剧映射配置"
DISTRIBUTED BY HASH(`id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "add_time",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
