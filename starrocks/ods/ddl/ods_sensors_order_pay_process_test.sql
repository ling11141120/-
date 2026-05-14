CREATE EXTERNAL TABLE `ods_sensors_order_pay_process_test` (
  `rid` varchar(1048576) NULL COMMENT "神策日志唯一id，rid",
  `user_id` bigint(20) NULL COMMENT "用户id",
  `core` smallint(6) NULL COMMENT "app、包",
  `mt` varchar(1048576) NULL COMMENT "mt 端",
  `product_id` varchar(1048576) NULL COMMENT "产品id",
  `dt` varchar(1048576) NULL COMMENT "分区"
) ENGINE=HIVE 
COMMENT "PARTITION BY (dt)"
PROPERTIES (
"database" = "ods",
"table" = "ods_sensors_order_pay_process_test",
"resource" = "hive0",
"hive.table.serde.lib"  =  "org.apache.hadoop.hive.ql.io.parquet.serde.ParquetHiveSerDe",
"hive.table.column.names"  =  "rid,user_id,core,mt,product_id",
"hive.table.column.types"  =  "string#bigint#smallint#string#string",
"transient_lastDdlTime"  =  "1700187228",
"bucketing_version"  =  "2",
"hive.table.input.format"  =  "org.apache.hadoop.hive.ql.io.parquet.MapredParquetInputFormat",
"hive.metastore.uris"  =  "thrift://node21:9083,thrift://node22:9083"
);
