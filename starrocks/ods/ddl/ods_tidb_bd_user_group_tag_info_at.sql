CREATE TABLE `ods_tidb_bd_user_group_tag_info_at` (
  `tag_id` bigint(20) NOT NULL COMMENT "标签Id",
  `relate_catalogue_id` bigint(20) NULL DEFAULT "-1" COMMENT "关联目录id",
  `tag_name_zh` varchar(1500) NOT NULL COMMENT "中文名称",
  `tag_name_en` varchar(1500) NOT NULL COMMENT "英文名称",
  `tag_desc` varchar(65533) NULL COMMENT "标签含义",
  `tag_data_type` varchar(255) NULL COMMENT "数据类型",
  `tag_compute_type` smallint(6) NULL DEFAULT "1" COMMENT "标签计算类型 1.离线 2.实时",
  `tag_update_type` smallint(6) NULL DEFAULT "1" COMMENT "数据更新类型 1-每天 2-每周 3-每月 4-手动 ",
  `tag_data_fill_type` smallint(6) NULL COMMENT "数据填充类型 1-不填充 2-模板",
  `tag_information` varchar(65533) NULL COMMENT "特殊信息",
  `create_time` datetime NULL COMMENT "创建时间",
  `create_user` varchar(64) NULL COMMENT "创建人",
  `field_update_time` datetime NULL COMMENT "修改时间",
  `update_user` varchar(64) NULL COMMENT "修改人",
  `data_update_time` datetime NULL COMMENT "标签数据修改时间",
  `tag_option_type` varchar(255) NULL COMMENT "标签选项类型",
  `system_type` smallint(6) NULL DEFAULT "1" COMMENT "系统类别（1阅读、2短剧）",
  `source_table` varchar(65533) NULL COMMENT "来源表",
  `compute_rule` varchar(65533) NULL COMMENT "计算规则",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`tag_id`)
COMMENT "标签信息表-实时"
DISTRIBUTED BY HASH(`tag_id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
