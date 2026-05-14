CREATE TABLE `ods_tidb_short_video_center_push_position` (
  `id` bigint(20) NOT NULL COMMENT "主键id",
  `push_position_name` varchar(1000) NULL COMMENT "push资源位名称",
  `strategy_begin_time` datetime NULL COMMENT "策略消息投递开始时间",
  `strategy_end_time` datetime NULL COMMENT "策略消息投递结束时间",
  `push_type` int(11) NULL COMMENT "推送场景类型：1-活动推送；2-短剧推送；3-召回推送",
  `activity_type` int(11) NULL COMMENT "活动类型：5:组合活动，6-推剧(剧目单)，7-推剧(指定短剧)",
  `activity_id` bigint(20) NULL COMMENT "活动Id。即center_activity_main表id",
  `series_bill_id` bigint(20) NULL COMMENT "推送短剧的剧目库id",
  `push_frequency` int(11) NULL COMMENT "推送频率：1-单次；2-活动期间每日一次。当推送场景=活动推送时，可选择单次、活动期间每日一次；当推送场景=短剧推送时，可选择单次",
  `push_count` int(11) NULL COMMENT "活动期间每日N值",
  `filter_type` varchar(500) NULL COMMENT "过滤条件，多选逗号拼接。取值：NULL-不限制；1-过滤已购买的短剧；2-过滤加入追剧的短剧；4-过滤看完短剧（过滤观看记录是最后一集的所有完结剧）；6-过滤曝光短剧；7-过滤点击短剧",
  `push_strategy_type` int(11) NULL COMMENT "推送策略（类型）：1-全量统一；2-用户所属时区；3-注册时间；4-活跃时间",
  `send_time` datetime NULL COMMENT "发送时间。当推送策略为固定时间推送，即（全量统一和用户所属时区），该值必填；否则为null",
  `send_time_param_json` varchar(2000) NULL COMMENT "推送n次扩展json",
  `delay_send_time` decimal(20, 1) NULL COMMENT "延迟推送的小时数。-12＜X＜12，最小单位为0.1。当推送策略为延时时间推送，即（3-注册时间；4-活跃时间），该值必填；否则为null",
  `title_id` bigint(20) NULL COMMENT "标题Id",
  `content_id` bigint(20) NULL COMMENT "内容Id",
  `material_id` bigint(20) NULL COMMENT "图片素材Id",
  `url` varchar(5000) NULL COMMENT "链接url(图片素材URL？)",
  `group_ids` varchar(300) NULL COMMENT "选中人群包id（逗号分割）",
  `exclude_group_ids` varchar(300) NULL COMMENT "剔除人群包id（逗号分割）",
  `off_line_group_ids` varchar(300) NULL COMMENT "离线人群包（北头人群包）选中人群包id（逗号分割）",
  `off_line_exclude_group_ids` varchar(300) NULL COMMENT "离线人群包（北斗人群包）剔除人群包id（逗号分割）",
  `sort` int(11) NULL COMMENT "排序。值越小，排序越高",
  `status` int(11) NULL COMMENT "状态1 开启，2 关闭",
  `app_type` int(11) NULL COMMENT "应用类型： 1：短剧，2：阅读",
  `create_time` datetime NULL COMMENT "创建时间",
  `update_time` datetime NULL COMMENT "更新时间",
  `page_type` int(11) NULL COMMENT "承接页面；0：自定义，1：首页，2：福利中心，3：商店页，4：最近观看的剧",
  `page_macro` varchar(2000) NULL COMMENT "宏定义配置",
  `material_source` int(11) NULL COMMENT "素材来源：1-运营后台；2-内容后台。默认值为：1-运营后台",
  `material_type` int(11) NULL COMMENT "素材类型：1-PUSH推剧；其他-暂定。默认值为：1-push推剧",
  `sr_createtime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据注入时间",
  `sr_updatetime` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT "starrocks数据更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`id`)
COMMENT "海剧-push资源位表"
DISTRIBUTED BY HASH(`id`) BUCKETS 3 
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
