CREATE TABLE `ods_tidb_short_video_tt_vip_subscribe_event_log` (
  `id` bigint(20) NOT NULL COMMENT "主键ID",
  `tt_open_id` bigint(20) NULL COMMENT "tt用户openid",
  `event_type` int(11) NULL COMMENT "事件类型：0-创建，1-更改，2-重新激活，3-成功续订，4-已暂停，5-已过期，6-退款",
  `content` varchar(30000) NULL COMMENT "事件内容",
  `create_time` datetime NULL COMMENT "创建时间",
  `update_time` datetime NULL COMMENT "更新时间",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`id`)
COMMENT "海剧-TikTok订阅回调事件表"
DISTRIBUTED BY HASH(`id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
