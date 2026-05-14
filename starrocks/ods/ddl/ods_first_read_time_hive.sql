CREATE EXTERNAL TABLE `ods_first_read_time_hive` (
  `userid` bigint(20) NULL COMMENT "",
  `createtime` varchar(65533) NULL COMMENT "",
  `timecount` bigint(20) NULL COMMENT ""
) ENGINE=HIVE 
COMMENT "用户首次阅读时间"
PROPERTIES (
"database" = "tmp",
"table" = "tmp_user_read_info_1",
"resource" = "hive0",
"hive.table.serde.lib"  =  "org.apache.hadoop.hive.ql.io.parquet.serde.ParquetHiveSerDe",
"hive.table.column.names"  =  "userid,createtime,timecount",
"hive.table.column.types"  =  "bigint#string#bigint",
"spark.sql.sources.schema.part.0"  =  "{\"type\":\"struct\",\"fields\":[{\"name\":\"userid\",\"type\":\"long\",\"nullable\":true,\"metadata\":{\"comment\":\"??id\"}},{\"name\":\"createtime\",\"type\":\"string\",\"nullable\":true,\"metadata\":{\"comment\":\"????\"}},{\"name\":\"timecount\",\"type\":\"long\",\"nullable\":true,\"metadata\":{\"comment\":\"????????\"}}]}",
"transient_lastDdlTime"  =  "1702860073",
"hive.table.input.format"  =  "org.apache.hadoop.hive.ql.io.parquet.MapredParquetInputFormat",
"hive.metastore.uris"  =  "thrift://node21:9083,thrift://node22:9083",
"spark.sql.sources.schema.numParts"  =  "1",
"spark.sql.create.version"  =  "3.0.1"
);
