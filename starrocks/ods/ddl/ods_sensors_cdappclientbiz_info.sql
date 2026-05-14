CREATE EXTERNAL TABLE `ods_sensors_cdappclientbiz_info` (
  `userid` varchar(1048576) NULL COMMENT "",
  `mt` varchar(1048576) NULL COMMENT "",
  `corever` varchar(1048576) NULL COMMENT "",
  `prodid` varchar(1048576) NULL COMMENT "",
  `appver` varchar(1048576) NULL COMMENT "",
  `appid` varchar(1048576) NULL COMMENT "",
  `event` varchar(1048576) NULL COMMENT "",
  `createtime` varchar(1048576) NULL COMMENT "",
  `adstyps` varchar(1048576) NULL COMMENT "",
  `adid` varchar(1048576) NULL COMMENT "",
  `adpositionc1c2` varchar(1048576) NULL COMMENT "",
  `adpositionc3` varchar(1048576) NULL COMMENT "",
  `errortype1` varchar(1048576) NULL COMMENT "",
  `errortype4` varchar(1048576) NULL COMMENT "",
  `errorcode1` varchar(1048576) NULL COMMENT "",
  `errorcode4` varchar(1048576) NULL COMMENT "",
  `adintermediary` varchar(1048576) NULL COMMENT "",
  `placementid` varchar(1048576) NULL COMMENT "??ID",
  `bizmsg` varchar(1048576) NULL COMMENT "errorvalues",
  `dt` varchar(1048576) NULL COMMENT "事件时间",
  `productid` varchar(1048576) NULL COMMENT "产品ID"
) ENGINE=HIVE 
COMMENT "PARTITION BY (dt, productid)"
PROPERTIES (
"database" = "ods",
"table" = "ods_sensors_cdappclientbiz_info",
"resource" = "hive0",
"hive.table.serde.lib"  =  "org.apache.hadoop.hive.ql.io.parquet.serde.ParquetHiveSerDe",
"hive.table.column.names"  =  "userid,mt,corever,prodid,appver,appid,event,createtime,adstyps,adid,adpositionc1c2,adpositionc3,errortype1,errortype4,errorcode1,errorcode4,adintermediary,placementid,bizmsg",
"hive.table.column.types"  =  "string#string#string#string#string#string#string#string#string#string#string#string#string#string#string#string#string#string#string",
"transient_lastDdlTime"  =  "1689824402",
"bucketing_version"  =  "2",
"hive.table.input.format"  =  "org.apache.hadoop.hive.ql.io.parquet.MapredParquetInputFormat",
"comment"  =  "?????????????",
"hive.metastore.uris"  =  "thrift://node21:9083,thrift://node22:9083"
);
