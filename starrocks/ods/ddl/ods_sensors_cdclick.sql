CREATE EXTERNAL TABLE `ods_sensors_cdclick` (
  `mt` varchar(65533) NULL COMMENT "终端",
  `appLangId` varchar(65533) NULL COMMENT "app界面语言",
  `appid` varchar(65533) NULL COMMENT "应用程序id",
  `appCoreVer` varchar(65533) NULL COMMENT "产品包",
  `app_version` varchar(65533) NULL COMMENT "应用版本",
  `app_id` varchar(65533) NULL COMMENT "app_id",
  `app_name` varchar(65533) NULL COMMENT "app_name",
  `CDClickPath` varchar(65533) NULL COMMENT "埋点其他信息",
  `identity_userID` varchar(65533) NULL COMMENT "identity_userID",
  `event_tm` varchar(65533) NULL COMMENT "事件时间",
  `rid` varchar(65533) NULL COMMENT "rid",
  `user_id` varchar(65533) NULL COMMENT "user_id",
  `os` varchar(65533) NULL COMMENT "os",
  `login_id` varchar(65533) NULL COMMENT "login_id",
  `event` varchar(65533) NULL COMMENT "event",
  `model` varchar(65533) NULL COMMENT "型号",
  `brand` varchar(65533) NULL COMMENT "品牌",
  `app_product_id` varchar(65533) NULL COMMENT "",
  `track_id` bigint(20) NULL COMMENT "",
  `dt` varchar(65533) NULL COMMENT "分区时间"
) ENGINE=HIVE 
COMMENT "神策CDClick数据"
PROPERTIES (
"database" = "ods",
"table" = "ods_sensors_cdclick",
"resource" = "hive0",
"hive.table.serde.lib"  =  "org.apache.hadoop.hive.ql.io.parquet.serde.ParquetHiveSerDe",
"last_modified_time"  =  "1698211978",
"hive.table.column.names"  =  "mt,applangid,appid,appcorever,app_version,app_id,app_name,cdclickpath,identity_userid,event_tm,rid,user_id,os,login_id,event,model,brand,app_product_id,track_id,sendid,position",
"hive.table.column.types"  =  "string#string#string#string#string#string#string#string#string#string#string#string#string#string#string#string#string#string#bigint#string#string",
"transient_lastDdlTime"  =  "1698211978",
"bucketing_version"  =  "2",
"hive.table.input.format"  =  "org.apache.hadoop.hive.ql.io.parquet.MapredParquetInputFormat",
"comment"  =  "??CDClick??",
"last_modified_by"  =  "hadoop",
"hive.metastore.uris"  =  "thrift://node21:9083,thrift://node22:9083"
);
