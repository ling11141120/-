CREATE EXTERNAL TABLE `ods_sensors_data_event_stream_new` (
  `_track_id` bigint(20) NULL COMMENT "",
  `time` bigint(20) NULL COMMENT "",
  `alljson` varchar(65533) NULL COMMENT "",
  `event` varchar(65533) NULL COMMENT "",
  `dt` varchar(65533) NULL COMMENT "分区"
) ENGINE=HIVE 
COMMENT "PARTITION BY (dt)"
PROPERTIES (
"database" = "ods_loggateway",
"table" = "ods_sensors_data_event_stream_new",
"resource" = "hive0",
"hive.table.serde.lib"  =  "org.apache.hadoop.hive.ql.io.parquet.serde.ParquetHiveSerDe",
"sink.partition-commit.policy.kind"  =  "metastore,success-file",
"hive.table.column.names"  =  "_track_id,time,type,distinct_id,anonymous_id,identities,login_id,_flush_time,original_track_id,map_id,user_id,recv_time,project_id,dtk,event,rid,lib,alljson",
"hive.table.column.types"  =  "bigint#bigint#string#string#string#string#string#bigint#bigint#string#bigint#bigint#int#array<string>#string#string#string#string",
"transient_lastDdlTime"  =  "1689308981",
"bucketing_version"  =  "2",
"hive.table.input.format"  =  "org.apache.hadoop.hive.ql.io.parquet.MapredParquetInputFormat",
"parquet.compression"  =  "SNAPPY",
"hive.metastore.uris"  =  "thrift://node21:9083,thrift://node22:9083"
);
