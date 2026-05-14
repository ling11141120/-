CREATE TABLE `dws_flow_cv_exposure_recharge_di` (
  `dt` date NOT NULL COMMENT "事件时间",
  `ads_optimizer` varchar(65533) NULL COMMENT "优化师名称",
  `cz_template_id` varchar(65533) NULL COMMENT "充值模板ID",
  `cz_template_name` varchar(65533) NULL COMMENT "充值模板名称",
  `product_tps` varchar(65533) NULL COMMENT "产品类型",
  `real_recharge` varchar(65533) NULL COMMENT "档位金额",
  `exp_user` varchar(65533) NULL COMMENT "曝光用户id",
  `recharge_user` varchar(65533) NULL COMMENT "充值用户id",
  `shortplay_id` varchar(65533) NULL COMMENT "短剧id",
  `tv_name` varchar(65533) NULL COMMENT "短剧名称",
  `recharge_tps` int(11) NULL COMMENT "充值来源 1:自营 2：分销 3：星图，4：小程序推广",
  `etl_tm` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "清洗时间"
) ENGINE=OLAP 
DUPLICATE KEY(`dt`)
COMMENT "国剧-充值档位曝光充值转化数据"
DISTRIBUTED BY HASH(`dt`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"storage_medium" = "SSD",
"compression" = "ZSTD"
);
