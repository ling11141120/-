CREATE EXTERNAL TABLE `ods_alg_log_full_hive` (
  `host` varchar(65533) NULL COMMENT "",
  `source` varchar(65533) NULL COMMENT "",
  `message` varchar(65533) NULL COMMENT "",
  `dt` varchar(65533) NULL COMMENT ""
) ENGINE=HIVE 
COMMENT "hive ods_alg_log_full 数据"
PROPERTIES (
"database" = "ods",
"table" = "ods_alg_log_full",
"resource" = "hive0",
"hive.table.serde.lib"  =  "org.apache.hadoop.hive.ql.io.parquet.serde.ParquetHiveSerDe",
"sink.partition-commit.policy.kind"  =  "metastore,success-file",
"hive.table.column.names"  =  "host,source,message",
"hive.table.column.types"  =  "string#string#string",
"transient_lastDdlTime"  =  "1689393753",
"bucketing_version"  =  "2",
"hive.table.input.format"  =  "org.apache.hadoop.hive.ql.io.parquet.MapredParquetInputFormat",
"parquet.compression"  =  "SNAPPY",
"hive.metastore.uris"  =  "thrift://node21:9083,thrift://node22:9083"
);
