CREATE TABLE `ads_user_charge_1d` (
  `dt` date NULL COMMENT "createtime 分区",
  `product_id` int(11) NOT NULL COMMENT "产品id",
  `corever` int(11) NULL COMMENT "corever",
  `current_language` int(11) NULL COMMENT "当前语言",
  `current_language2` int(11) NULL COMMENT "注册时语言",
  `app_ver` varchar(50) NULL COMMENT "版本号",
  `mt` int(11) NULL COMMENT "平台",
  `ver` varchar(50) NULL COMMENT "服务端版本号",
  `reg_country` varchar(50) NULL COMMENT "注册时国家",
  `charge_num` int(11) NOT NULL COMMENT "充值人数",
  `charge_money` decimal(20, 6) NULL COMMENT "",
  `charge_itemcount` int(11) NULL COMMENT "分成前充值金额",
  `fisrt_charge_num` int(11) NULL COMMENT "首充用户数（该在当前日期之前从未有过充值的用户",
  `fisrt_charge_money` decimal(20, 6) NULL COMMENT "",
  `fisrt_charge_itemcount` int(11) NULL COMMENT "分成前首充金额（该在当前日期之前从未有过充值的用户）",
  `etl_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "etl清洗时间",
  INDEX index_productid (`product_id`) USING BITMAP COMMENT '产品id索引'
) ENGINE=OLAP 
DUPLICATE KEY(`dt`, `product_id`)
COMMENT "按天维度：统计充值用户数以及充值金额"
DISTRIBUTED BY HASH(`dt`, `product_id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "dt",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);