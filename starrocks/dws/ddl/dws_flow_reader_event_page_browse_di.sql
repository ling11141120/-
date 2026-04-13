CREATE TABLE `dws_flow_reader_event_page_browse_di` (
  `dt` date NULL COMMENT "createtime 分区",
  `product_id` int(11) NOT NULL COMMENT "产品id",
  `event` varchar(255) NULL COMMENT "事件名 readerExposure:阅读器事件,itemClick:点击事件,element_click:控件点击",
  `mt` varchar(255) NULL COMMENT "平台（终端）",
  `appver` varchar(255) NULL COMMENT "版本号",
  `corever` int(11) NULL COMMENT "包体",
  `page_id` int(11) NULL COMMENT "页面id 10005：书架首页，100656：投放归因成功，100655：自然用户，10006：书籍详情页",
  `page_name` varchar(255) NULL COMMENT "页面名称",
  `page_view_cnt` int(11) NULL COMMENT "打开、点击次数",
  `etl_tm` datetime NULL COMMENT "清洗时间",
  INDEX index_productid (`product_id`) USING BITMAP COMMENT 'index_productid'
) ENGINE=OLAP
DUPLICATE KEY(`dt`, `product_id`)
COMMENT "进入阅读器事件及各页面浏览数据统计"
DISTRIBUTED BY HASH(`dt`, `product_id`) BUCKETS 3
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"storage_medium" = "SSD",
"compression" = "ZSTD"
);