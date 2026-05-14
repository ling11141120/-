CREATE TABLE `ads_sr_market_operation_exp_report_di` (
  `dt` date NULL COMMENT "日期",
  `user_id` bigint(20) NULL COMMENT "用户ID",
  `position_id` bigint(20) NULL COMMENT "资源位ID",
  `position_type` int(11) NULL COMMENT "资源位类型 1：banner，2：悬浮窗，3：弹窗，4：闪屏，5：阅读页触达，8：章末推送，9：阅读器返回推，10：串书，11：TAB推荐",
  `position_name` varchar(2048) NULL COMMENT "资源位名称",
  `actity_type` int(11) NULL COMMENT "活动类型 1：充值档位推荐，2：VIP档位推荐,3:签到卡档位推荐,4:自定义活动,5:组合活动,6:推剧(剧目单),7:推剧(指定短剧)",
  `actity_id` varchar(512) NULL COMMENT "活动ID",
  `actity_time` datetime NULL COMMENT "活动创建时间",
  `start_time` datetime NULL COMMENT "活动开始时间",
  `end_time` datetime NULL COMMENT "活动结束时间",
  `action_id` bigint(20) NULL COMMENT "策略ID",
  `action_name` varchar(2048) NULL COMMENT "策略名称",
  `statu` int(11) NULL COMMENT "状态 1：开启，2：关闭",
  `sorted` int(11) NULL COMMENT "排序",
  `create_time` datetime NULL COMMENT "创建时间",
  `tag_group_ids` varchar(512) NULL COMMENT "TAG人群包",
  `jgroup_ids` varchar(512) NULL COMMENT "极光人群包",
  `rules_type` int(11) NULL COMMENT "显示规则类型 1 每日首次推送（只推一次）、2 间隔N章 、 3 立即推送",
  `exposure_rule` int(11) NULL COMMENT "过曝规则",
  `app_type` int(11) NULL COMMENT "应用类型 1：正式，2：测试",
  `strategy_type` int(11) NULL COMMENT "策略类型 0：实验策略，1：固化策略",
  `etl_time` datetime NULL COMMENT "etl时间"
) ENGINE=OLAP 
DUPLICATE KEY(`dt`)
COMMENT "海阅-运营实验报表-关联运营ID"
DISTRIBUTED BY HASH(`dt`, `user_id`, `position_id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);