CREATE TABLE `ods_tidb_cdnovel_tidb_xcx_sync_recharge_history` (
  `Id` bigint(20) NOT NULL COMMENT "自增ID",
  `_id` varchar(65533) NOT NULL COMMENT "原表主键_id",
  `app_id` varchar(65533) NULL DEFAULT "" COMMENT "小程序ID",
  `user_id` varchar(65533) NULL DEFAULT "" COMMENT "用户ID",
  `out_trade_no` varchar(65533) NULL DEFAULT "" COMMENT "订单号，payorder 的CooOrderId一对一关系",
  `transaction_id` varchar(65533) NULL DEFAULT "" COMMENT "交易ID",
  `ad_platform` varchar(65533) NULL DEFAULT "" COMMENT "广告平台：jl - 巨量引擎，gdt - 广点通",
  `tf_id` varchar(1000) NULL DEFAULT "" COMMENT "投放链接ID",
  `agent_id` varchar(1000) NULL DEFAULT "" COMMENT "代理商ID",
  `promotion_id` varchar(1000) NULL DEFAULT "" COMMENT "广告计划ID",
  `echoed` int(11) NULL DEFAULT "0" COMMENT "是否回传：0 - 否 1 - 是",
  `echo_remark` varchar(65533) NULL COMMENT "回传备注",
  `echo_id` varchar(65533) NULL DEFAULT "" COMMENT "回传记录ID，关联 echo_log",
  `echo_params` varchar(65533) NULL COMMENT "回传参数",
  `remark` varchar(65533) NULL COMMENT "备注",
  `os` varchar(65533) NULL DEFAULT "" COMMENT "操作系统",
  `platform` varchar(65533) NULL DEFAULT "" COMMENT "支付平台：tt | wx",
  `channel` int(11) NULL DEFAULT "0" COMMENT "抖音：11 - 微信、12 - 支付宝、13-抖音支付

微信：21 - 默认商户号支付 22 - 虚拟支付",
  `recharge_amount` int(11) NULL DEFAULT "0" COMMENT "充值金额",
  `pay_amount` int(11) NULL DEFAULT "0" COMMENT "支付金额",
  `bean` int(11) NULL DEFAULT "0" COMMENT "金豆数",
  `subject` varchar(65533) NULL DEFAULT "" COMMENT "充值主题",
  `ip` varchar(65533) NULL DEFAULT "" COMMENT "ip",
  `book_id` varchar(65533) NULL DEFAULT "" COMMENT "书籍ID",
  `status` int(11) NOT NULL DEFAULT "0" COMMENT "支付状态：0 - 未支付，1 - 已支付",
  `notify_time` datetime NULL COMMENT "充值回调时间",
  `active_time` datetime NULL COMMENT "广告用户激活时间",
  `_add_time` datetime NOT NULL COMMENT "添加时间",
  `_update_time` datetime NOT NULL COMMENT "更新时间",
  `sync_update_time` datetime NOT NULL COMMENT "数据更新时间戳",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`Id`)
COMMENT "国内小程序阅读-用户充值订单表（原始表）"
DISTRIBUTED BY HASH(`Id`) BUCKETS 1 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "_add_time",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"storage_medium" = "SSD",
"compression" = "ZSTD"
);
