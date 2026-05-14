CREATE EXTERNAL TABLE `ods_hive_sensors_adcontrol` (
  `app_channel` varchar(1048576) NULL COMMENT "产品core终端渠道",
  `event` varchar(1048576) NULL COMMENT "事件名称",
  `type` varchar(1048576) NULL COMMENT "类型",
  `device_id` varchar(1048576) NULL COMMENT "设备id",
  `login_id` varchar(1048576) NULL COMMENT "login_id",
  `identity_userid` varchar(1048576) NULL COMMENT "identity_userID",
  `os` varchar(1048576) NULL COMMENT "终端",
  `app_core_ver` varchar(1048576) NULL COMMENT "core",
  `app_product_id` varchar(1048576) NULL COMMENT "产品id",
  `app_lang_id` varchar(1048576) NULL COMMENT "语言id",
  `app_name` varchar(1048576) NULL COMMENT "app_name",
  `model` varchar(1048576) NULL COMMENT "型号",
  `brand` varchar(1048576) NULL COMMENT "品牌",
  `rule` varchar(1048576) NULL COMMENT "规则",
  `dt` varchar(1048576) NULL COMMENT "事件时间"
) ENGINE=HIVE 
COMMENT "PARTITION BY (dt)"
PROPERTIES (
"database" = "ods",
"table" = "ods_sensors_adcontrol",
"resource" = "hive0",
"hive.table.serde.lib"  =  "org.apache.hadoop.hive.ql.io.parquet.serde.ParquetHiveSerDe",
"last_modified_time"  =  "1695715082",
"hive.table.column.names"  =  "app_channel,event,type,device_id,login_id,identity_userid,os,app_core_ver,app_product_id,app_lang_id,app_name,model,brand,rule",
"hive.table.column.types"  =  "string#string#string#string#string#string#string#string#string#string#string#string#string#string",
"transient_lastDdlTime"  =  "1695715082",
"bucketing_version"  =  "2",
"hive.table.input.format"  =  "org.apache.hadoop.hive.ql.io.parquet.MapredParquetInputFormat",
"comment"  =  "????????",
"last_modified_by"  =  "hadoop",
"hive.metastore.uris"  =  "thrift://node21:9083,thrift://node22:9083"
);
