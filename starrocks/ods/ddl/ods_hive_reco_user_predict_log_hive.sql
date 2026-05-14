CREATE EXTERNAL TABLE `ods_hive_reco_user_predict_log_hive` (
  `reqtime` varchar(65533) NULL COMMENT "",
  `event_name` varchar(65533) NULL COMMENT "",
  `user_id` varchar(65533) NULL COMMENT "",
  `reqstr` varchar(65533) NULL COMMENT "",
  `extend_map` varchar(65533) NULL COMMENT "",
  `rank_feature` varchar(65533) NULL COMMENT "",
  `host` varchar(65533) NULL COMMENT "",
  `dt` varchar(65533) NULL COMMENT ""
) ENGINE=HIVE 
COMMENT "hive 算法 数据"
PROPERTIES (
"database" = "alg",
"table" = "dwd_reco_user_predict_log",
"resource" = "hive0",
"hive.table.serde.lib"  =  "org.apache.hadoop.hive.ql.io.parquet.serde.ParquetHiveSerDe",
"last_modified_time"  =  "1689319586",
"hive.table.column.names"  =  "reqtime,event_name,user_id,reqstr,extend_map,rank_feature,host",
"EXTERNAL"  =  "TRUE",
"hive.table.column.types"  =  "string#string#string#string#string#string#string",
"transient_lastDdlTime"  =  "1689319458",
"bucketing_version"  =  "2",
"hive.table.input.format"  =  "org.apache.hadoop.hive.ql.io.parquet.MapredParquetInputFormat",
"comment"  =  "",
"last_modified_by"  =  "hadoop",
"hive.metastore.uris"  =  "thrift://node21:9083,thrift://node22:9083"
);
