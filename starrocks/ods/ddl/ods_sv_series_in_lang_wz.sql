CREATE TABLE `ods_sv_series_in_lang_wz` (
  `type` varchar(50) NOT NULL COMMENT "分类",
  `number` int(11) NOT NULL COMMENT "序号",
  `series_name` varchar(500) NULL COMMENT "短剧名称",
  `series_name_en` varchar(500) NULL COMMENT "短剧名称（EN）",
  `cooperation_model` varchar(50) NULL COMMENT "合作模式",
  `status` varchar(50) NULL COMMENT "作品状态",
  `authorization_period` varchar(500) NULL COMMENT "授权期限",
  `series_code` varchar(50) NULL COMMENT "代号",
  `series_id_en` varchar(50) NULL COMMENT "en-id"
) ENGINE=OLAP 
PRIMARY KEY(`type`, `number`)
COMMENT "根据代号查到对应剧已授权的语言id-0522王植需求"
DISTRIBUTED BY HASH(`type`, `number`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
