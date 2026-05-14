CREATE TABLE `ads_book_remarket_attribution_analysis_ed` (
  `dt` date NULL COMMENT "统计日期",
  `book_id` bigint(20) NULL COMMENT "书籍id",
  `product_id` int(11) NULL COMMENT "产品id",
  `ad_id` varchar(1000) NULL COMMENT "广告id",
  `install_num` int(11) NULL COMMENT "归因人数（这本书这个adid带来的用户数）",
  `charge_itemcount` decimal(18, 2) NULL COMMENT "充值金额",
  `charge_num` int(11) NULL COMMENT "充值人数",
  `charge_count` int(11) NULL COMMENT "充值次数（订单数）",
  `recharge_num` int(11) NULL COMMENT "充值次数>=2的人数",
  `charge_num_10` int(11) NULL COMMENT "充值>=10美金的用户数",
  `charge_count_10` int(11) NULL COMMENT "充值>=10美金的订单数",
  `read_num` int(11) NULL COMMENT "阅读人数",
  `read_num_2` int(11) NULL COMMENT "阅读大于2章的人数",
  `read_pay_num` int(11) NULL COMMENT "付费章节阅读uv",
  `consume_num` int(11) NULL COMMENT "消费uv",
  `consume_pay_num` int(11) NULL COMMENT "阅币消费uv",
  `read_num_5` int(11) NULL COMMENT "阅读大于5章的人数",
  `read_num_8` int(11) NULL COMMENT "阅读大于8章的人数",
  `consume_amount` int(11) NULL COMMENT "阅币+礼券消耗数量",
  `consume_pay_amount` int(11) NULL COMMENT "阅币消耗数量",
  `etl_time` datetime NULL COMMENT "数据更新时间",
  INDEX index_book_id (`book_id`) USING BITMAP COMMENT 'index_book_id'
) ENGINE=OLAP 
DUPLICATE KEY(`dt`, `book_id`)
COMMENT "24小时广告书籍数据表-- 新用户：广告书籍的归因数据，按天统计这些书带来的充值、阅读人数、消耗数量等"
DISTRIBUTED BY HASH(`dt`, `book_id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "dt, product_id, book_id",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);