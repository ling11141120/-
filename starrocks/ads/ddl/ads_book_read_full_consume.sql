CREATE TABLE `ads_book_read_full_consume` (
  `dt` datetime NOT NULL COMMENT "日期",
  `book_id` bigint(20) NOT NULL COMMENT "书籍id",
  `site_id` int(11) NOT NULL COMMENT "书籍语言 ",
  `new_cid` int(11) NULL COMMENT "书籍分类id",
  `channel` int(11) NULL COMMENT "频道",
  `is_full` tinyint(4) NULL COMMENT "完结状态",
  `full_time` datetime NULL COMMENT "完结时间",
  `sexy2` int(11) NULL COMMENT "上架状态",
  `build_time` datetime NULL COMMENT "上架时间",
  `sign_type` int(11) NULL COMMENT "签约状态",
  `languageid` int(11) NULL COMMENT "书籍语言",
  `public_fontlength` int(11) NULL COMMENT "书籍发布总字数",
  `book_update_time` datetime NULL COMMENT "书籍更新时间",
  `consume_1d` int(11) NULL COMMENT "近1日阅币+礼券+赠送币+VIP消费消耗",
  `consume_7d` int(11) NULL COMMENT "近7日阅币+礼券+赠送币+VIP消费消耗",
  `consume_30d` int(11) NULL COMMENT "近30日阅币+礼券+赠送币+VIP消费消耗",
  `consume_td` int(11) NULL COMMENT "历史阅币+礼券+赠送币+VIP消费消耗",
  `read_1d` int(11) NULL COMMENT "近1日阅读人数",
  `read_7d` int(11) NULL COMMENT "近7日阅读人数",
  `read_30d` int(11) NULL COMMENT "近30日阅读人数",
  `read_td` int(11) NULL COMMENT "历史阅读人数",
  `update_word_count_1d` int(11) NULL COMMENT "近1日更新字数",
  `update_word_count_7d` int(11) NULL COMMENT "近7日更新字数",
  `update_word_count_30d` int(11) NULL COMMENT "近30日更新字数",
  `etl_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "etl清洗时间",
  `book_nature` int(11) NULL COMMENT "书籍来源 1：机翻 2：人工 3：原创 4：cp 5：原创拆章 6：翻译拆章 7：原创图书 8：有声书籍 9：cp翻译 0：未知",
  `score_type` int(11) NULL COMMENT "书籍评级  未评级 = 0, S = 1, A = 2, B = 3, C = 4",
  INDEX index_book_id (`book_id`) USING BITMAP COMMENT 'index_book_id'
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `book_id`, `site_id`)
COMMENT "书籍维度阅读消耗数-全量消费类型"
DISTRIBUTED BY HASH(`dt`, `book_id`, `site_id`)
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "site_id, book_id",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);