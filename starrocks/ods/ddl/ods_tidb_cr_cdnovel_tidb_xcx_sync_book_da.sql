CREATE TABLE `ods_tidb_cr_cdnovel_tidb_xcx_sync_book_da` (
  `Id` bigint(20) NOT NULL COMMENT "自增ID",
  `_id` varchar(65533) NULL COMMENT "原表主键_id",
  `wx_book_id` varchar(65533) NULL COMMENT "微信书籍ID",
  `original_id` varchar(65533) NULL COMMENT "编辑后台书籍原始ID",
  `name` varchar(65533) NULL COMMENT "书名",
  `code` varchar(65533) NULL COMMENT "代号，唯一",
  `title` varchar(65533) NULL COMMENT "标题",
  `cover` varchar(65533) NULL COMMENT "封面",
  `author` varchar(65533) NULL COMMENT "作者",
  `channel` int(11) NULL COMMENT "频道：1 - 女频 2 - 男频 0 - 其他",
  `category_id` varchar(65533) NULL COMMENT "品类，关联 category 表",
  `wx_category_id` varchar(65533) NULL COMMENT "微信品类，关联 wx_category 表",
  `total_chapter` int(11) NULL COMMENT "总章节数",
  `count_word` int(11) NULL COMMENT "总字数",
  `released_chapter` int(11) NULL COMMENT "最新更新章节数",
  `price` int(11) NULL COMMENT "每章价格",
  `paid_start_chapter` int(11) NULL COMMENT "起始收费章节数",
  `introduction` varchar(1048576) NULL COMMENT "介绍",
  `selection` varchar(1048576) NULL COMMENT "精选内容",
  `seq` int(11) NULL COMMENT "排序",
  `status` int(11) NULL COMMENT "状态：1 - 上架，0 - 软下架，-1 - 硬下架",
  `finished` int(11) NULL COMMENT "完结状态：1 - 已完结 0 - 连载中",
  `module_id` varchar(65533) NULL COMMENT "模块ID",
  `visible_in_review` int(11) NULL COMMENT "审核中是否可见：1 - 可见，0 - 不可见。默认 0",
  `_add_time` datetime NULL COMMENT "添加时间",
  `_update_time` datetime NULL COMMENT "更新时间",
  `sync_update_time` datetime NULL COMMENT "数据更新时间戳",
  `sr_createtime` datetime NULL COMMENT "sr入库时间",
  `sr_updatetime` datetime NULL COMMENT "sr更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`Id`)
COMMENT "国阅书籍表"
DISTRIBUTED BY HASH(`Id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "_add_time, _update_time",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
