CREATE EXTERNAL TABLE `ods_first_comm_time_hive` (
  `userid` bigint(20) NULL COMMENT "",
  `last_common_time` varchar(65533) NULL COMMENT "",
  `last_common_productid` varchar(65533) NULL COMMENT ""
) ENGINE=HIVE 
COMMENT "用户最后操作时间"
PROPERTIES (
"database" = "tmp",
"table" = "tmp_common_zuijin_time",
"resource" = "hive0",
"hive.table.serde.lib"  =  "org.apache.hadoop.hive.ql.io.parquet.serde.ParquetHiveSerDe",
"hive.table.column.names"  =  "userid,last_common_time,last_common_productid",
"hive.table.column.types"  =  "bigint#string#string",
"spark.sql.sources.schema.part.0"  =  "{\"type\":\"struct\",\"fields\":[{\"name\":\"userid\",\"type\":\"long\",\"nullable\":true,\"metadata\":{}},{\"name\":\"last_common_time\",\"type\":\"string\",\"nullable\":true,\"metadata\":{}},{\"name\":\"last_common_productid\",\"type\":\"string\",\"nullable\":true,\"metadata\":{}}]}",
"transient_lastDdlTime"  =  "1685923218",
"hive.table.input.format"  =  "org.apache.hadoop.hive.ql.io.parquet.MapredParquetInputFormat",
"hive.metastore.uris"  =  "thrift://node21:9083,thrift://node22:9083",
"spark.sql.sources.schema.numParts"  =  "1",
"spark.sql.create.version"  =  "3.0.1"
);
