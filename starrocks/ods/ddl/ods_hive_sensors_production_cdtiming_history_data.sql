CREATE EXTERNAL TABLE `ods_hive_sensors_production_cdtiming_history_data` (
  `id` varchar(65533) NULL COMMENT "nvl(rid,track_id)",
  `track_id` varchar(65533) NULL COMMENT "",
  `rid` varchar(65533) NULL COMMENT "记录ID",
  `event_tm` varchar(65533) NULL COMMENT "事件时间",
  `device_id` varchar(65533) NULL COMMENT "设备id",
  `login_id` varchar(65533) NULL COMMENT "登录用户id",
  `identity_login_id` varchar(65533) NULL COMMENT "identity_login_id",
  `device_lang` varchar(65533) NULL COMMENT "设备语言",
  `event` varchar(65533) NULL COMMENT "事件",
  `distinct_id` varchar(65533) NULL COMMENT "distinct_id",
  `identity_user_id` varchar(65533) NULL COMMENT "identity_userid（用户id）",
  `app_product_id` varchar(65533) NULL COMMENT "包体ID",
  `app_core_ver` varchar(65533) NULL COMMENT "core",
  `os` varchar(65533) NULL COMMENT "终端",
  `app_version` varchar(65533) NULL COMMENT "app版本",
  `app_channel` varchar(65533) NULL COMMENT "渠道编号",
  `app_lang_id` varchar(65533) NULL COMMENT "界面语言",
  `serial` varchar(65533) NULL COMMENT "加载时长(s)",
  `type` varchar(65533) NULL COMMENT "类型 7为页面加载时长8为接口加载时长",
  `position` varchar(65533) NULL COMMENT "页面位置",
  `channelid` varchar(65533) NULL COMMENT "书城特定频道的上报",
  `cdtiming` varchar(65533) NULL COMMENT "CDTiming",
  `dt` varchar(65533) NULL COMMENT "事件时间"
) ENGINE=HIVE 
COMMENT "PARTITION BY (dt)"
PROPERTIES (
"database" = "ods",
"table" = "ods_sensors_production_cdtiming",
"resource" = "hive0",
"hive.table.serde.lib"  =  "org.apache.hadoop.hive.ql.io.parquet.serde.ParquetHiveSerDe",
"hive.table.column.names"  =  "id,track_id,rid,event_tm,device_id,login_id,identity_login_id,device_lang,event,distinct_id,identity_user_id,app_product_id,app_core_ver,os,app_version,app_channel,app_lang_id,serial,type,position,channelid,cdtiming",
"hive.table.column.types"  =  "varchar(65533)#varchar(65533)#varchar(65533)#string#varchar(65533)#varchar(65533)#varchar(65533)#varchar(65533)#varchar(65533)#varchar(65533)#varchar(65533)#varchar(65533)#varchar(65533)#varchar(65533)#varchar(65533)#varchar(65533)#varchar(65533)#varchar(65533)#varchar(65533)#varchar(65533)#varchar(65533)#varchar(65533)",
"transient_lastDdlTime"  =  "1702868831",
"bucketing_version"  =  "2",
"hive.table.input.format"  =  "org.apache.hadoop.hive.ql.io.parquet.MapredParquetInputFormat",
"comment"  =  "event=CDTiming app????????",
"hive.metastore.uris"  =  "thrift://node21:9083,thrift://node22:9083"
);
