CREATE TABLE `ods_tidb_cr_cdnovel_tidb_xcx_sync_agency_settle_info` (
  `Id` bigint(20) NOT NULL COMMENT "自增ID",
  `_id` varchar(65533) NULL COMMENT "原表主键_id",
  `agency_id` varchar(65533) NULL COMMENT "机构ID 关联用户ID",
  `bank` varchar(65533) NULL COMMENT "开户行",
  `account_name` varchar(65533) NULL COMMENT "收款账户名",
  `account_no` varchar(65533) NULL COMMENT "收款账号",
  `company_address` varchar(65533) NULL COMMENT "公司地址",
  `tax_no` varchar(65533) NULL COMMENT "税号",
  `express_receiver` varchar(65533) NULL COMMENT "快递收件人",
  `express_telephone` varchar(65533) NULL COMMENT "快递联系电话",
  `express_address` varchar(65533) NULL COMMENT "快递收件地址",
  `channel_fee_type` int(11) NULL COMMENT "通道费用类型：0 - 免除，2 - 约定实际支付费用，3 - 约定统一通道费",
  `min_withdraw_amount` int(11) NULL COMMENT "最低提现额度 单位分",
  `pay_tax_rate_gap` int(11) NULL COMMENT "是否补缴税率差额：0 -否，1 - 是",
  `settle_date_type` int(11) NULL COMMENT "结算日期类型 1 - 次周，2 - 次2周，3 - 次月",
  `share_rate` double NULL COMMENT "分成比例",
  `tax_rate_type` int(11) NULL COMMENT "税率:0 - 普票,1 - 专票1%,3 - 专票3%,6 - 专票6%",
  `_add_time` datetime NULL COMMENT "添加时间",
  `_update_time` datetime NULL COMMENT "更新时间",
  `sync_update_time` datetime NULL COMMENT "数据更新时间戳",
  `sr_createtime` datetime NULL COMMENT "sr入库时间",
  `sr_updatetime` datetime NULL COMMENT "sr更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`Id`)
COMMENT "机构结算信息"
DISTRIBUTED BY HASH(`Id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "_add_time",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
