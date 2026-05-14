CREATE TABLE `dws_cr_user_login_di` (
  `dt` date NOT NULL COMMENT "createtime 分区",
  `product_id` int(11) NOT NULL COMMENT "产品id",
  `user_id` varchar(65533) NOT NULL COMMENT "用户id",
  `self_type` smallint(6) NOT NULL COMMENT "自营类别 0：总 ",
  `app_id` varchar(65533) NULL COMMENT "小程序id",
  `plat_form` varchar(65533) NULL COMMENT "平台：weixin - 微信，toutiao - 抖音, 默认 none",
  `corever2` int(11) NULL COMMENT "包体",
  `current_language2` int(11) NULL COMMENT "投放语言",
  `mt2` int(11) NULL COMMENT "平台（终端）",
  `reg_country` varchar(255) NULL COMMENT "注册国家",
  `reg_tm` datetime NULL COMMENT "注册时间",
  `chl2` varchar(255) NULL COMMENT "渠道值",
  `os` varchar(255) NULL COMMENT "系统",
  `reg_days` int(11) NULL COMMENT "登录时间-注册时间",
  `login_cnt` int(11) NULL COMMENT "登录次数",
  `fst_login_tm` datetime NULL COMMENT "首次登录时间",
  `lst_login_tm` datetime NULL COMMENT "末次登录时间",
  `etl_tm` datetime NULL COMMENT "清洗时间"
) ENGINE=OLAP 
PRIMARY KEY(`dt`, `product_id`, `user_id`, `self_type`)
COMMENT "国内小程序阅读-用户登录活跃轻度汇总表"
DISTRIBUTED BY HASH(`dt`, `product_id`, `user_id`)
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "dt",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"storage_medium" = "SSD",
"compression" = "ZSTD"
);
