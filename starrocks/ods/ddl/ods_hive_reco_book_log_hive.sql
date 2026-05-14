CREATE EXTERNAL TABLE `ods_hive_reco_book_log_hive` (
  `reqtime` varchar(65533) NULL COMMENT "",
  `trace_id` varchar(65533) NULL COMMENT "",
  `user_id` varchar(65533) NULL COMMENT "",
  `book_id` varchar(65533) NULL COMMENT "",
  `index` varchar(65533) NULL COMMENT "",
  `reqstr` varchar(65533) NULL COMMENT "",
  `extend_map` varchar(65533) NULL COMMENT "",
  `rank_feature` varchar(65533) NULL COMMENT "",
  `host` varchar(65533) NULL COMMENT "",
  `page_id` varchar(65533) NULL COMMENT "",
  `dt` varchar(65533) NULL COMMENT ""
) ENGINE=HIVE 
COMMENT "hive 算法 数据"
PROPERTIES (
"database" = "alg",
"table" = "dwd_reco_book_log",
"resource" = "hive0",
"hive.table.serde.lib"  =  "org.apache.hadoop.hive.ql.io.parquet.serde.ParquetHiveSerDe",
"last_modified_time"  =  "1690368009",
"hive.table.column.names"  =  "reqtime,trace_id,user_id,book_id,index,reqstr,extend_map,rank_feature,host,page_id",
"EXTERNAL"  =  "TRUE",
"hive.table.column.types"  =  "string#string#string#string#string#string#string#string#string#string",
"transient_lastDdlTime"  =  "1690368009",
"bucketing_version"  =  "2",
"hive.table.input.format"  =  "org.apache.hadoop.hive.ql.io.parquet.MapredParquetInputFormat",
"comment"  =  "",
"last_modified_by"  =  "hadoop",
"hive.metastore.uris"  =  "thrift://node21:9083,thrift://node22:9083"
);
