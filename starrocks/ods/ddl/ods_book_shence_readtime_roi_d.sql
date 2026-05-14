CREATE EXTERNAL TABLE `ods_book_shence_readtime_roi_d` (
  `userid` varchar(1048576) NULL COMMENT "用户id",
  `mt` varchar(1048576) NULL COMMENT "终端",
  `corever` varchar(1048576) NULL COMMENT "corever",
  `prodid` varchar(1048576) NULL COMMENT "产品id",
  `appver` varchar(1048576) NULL COMMENT "版本",
  `event` varchar(1048576) NULL COMMENT "事件",
  `createtime` varchar(1048576) NULL COMMENT "记录时间",
  `bookid` varchar(1048576) NULL COMMENT "书籍id",
  `chapterid` varchar(1048576) NULL COMMENT "章节id",
  `time` varchar(1048576) NULL COMMENT "旧埋点阅读时长数据",
  `day` varchar(1048576) NULL COMMENT "分区",
  `productid` varchar(1048576) NULL COMMENT "产品id"
) ENGINE=HIVE 
COMMENT "PARTITION BY (day, productid)"
PROPERTIES (
"database" = "ods",
"table" = "ods_book_shence_readtime_roi_d",
"resource" = "hive0",
"hive.table.serde.lib"  =  "org.apache.hadoop.hive.ql.io.parquet.serde.ParquetHiveSerDe",
"hive.table.column.names"  =  "userid,mt,corever,prodid,appver,event,createtime,bookid,chapterid,time",
"hive.table.column.types"  =  "string#string#string#string#string#string#string#string#string#string",
"transient_lastDdlTime"  =  "1659342871",
"bucketing_version"  =  "2",
"hive.table.input.format"  =  "org.apache.hadoop.hive.ql.io.parquet.MapredParquetInputFormat",
"hive.metastore.uris"  =  "thrift://node21:9083,thrift://node22:9083"
);
