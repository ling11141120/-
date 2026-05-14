CREATE TABLE `ods_tidb_cdvideo_tidb_xcx_sync_ad_reward_video_log_da` (
  `Id` bigint(20) NOT NULL COMMENT "自增ID",
  `_id` varchar(65533) NULL COMMENT "原表主键_id",
  `ad_unit_id` varchar(65533) NULL COMMENT "平台广告资源位id",
  `position_id` int(11) NULL COMMENT "1-播放页 2-福利中心页",
  `bonus_amount` int(11) NULL COMMENT "奖励赠豆数量",
  `user_id` varchar(65533) NULL COMMENT "用户id",
  `tv_id` varchar(65533) NULL COMMENT "剧目id",
  `appid` varchar(65533) NULL COMMENT "小程序id",
  `series` int(11) NULL COMMENT "当前第几集",
  `series_id` varchar(65533) NULL COMMENT "剧集id",
  `status` int(11) NULL COMMENT "状态：1-开始播放 2-播放完毕",
  `return_status` int(11) NULL COMMENT "回传结果：-1 回传失败 2回传成功",
  `pay_id` varchar(65533) NULL COMMENT "关联的解锁剧集记录Id",
  `platform` varchar(65533) NULL COMMENT "激励视频广告平台：mp-toutiao 抖音,mp-weixin 微信",
  `tfid` varchar(65533) NULL COMMENT "投放链接ID",
  `invite_code` varchar(65533) NULL COMMENT "代理商id",
  `middleman_id` varchar(65533) NULL COMMENT "机构id",
  `promotion_id` varchar(65533) NULL COMMENT "广告计划ID",
  `project_id` varchar(65533) NULL COMMENT "广告项目ID",
  `aid` varchar(65533) NULL COMMENT "广告信息",
  `cid` varchar(65533) NULL COMMENT "广告信息",
  `ad_id` varchar(65533) NULL COMMENT "广告信息",
  `clickid` varchar(65533) NULL COMMENT "点击id",
  `clue_token` varchar(65533) NULL COMMENT "clue_token",
  `user_active_time` datetime NULL COMMENT "用户激活时间",
  `ecpm_time` datetime NULL COMMENT "获取ecpm的时间",
  `ecpm` bigint(20) NULL COMMENT "根据ecpm接口返回的cost，进行格式化的数据",
  `ad_cost` varchar(65533) NULL COMMENT "广告消耗，单位为：十万分之一元",
  `ad_event_time` datetime NULL COMMENT "广告计费发生时间戳，单位秒",
  `ad_type` varchar(65533) NULL COMMENT "小程序广告类型",
  `_add_time` datetime NULL COMMENT "添加时间",
  `_update_time` datetime NULL COMMENT "更新时间",
  `sync_update_time` datetime NULL COMMENT "数据更新时间戳",
  `sr_createtime` datetime NULL COMMENT "sr入库时间",
  `sr_updatetime` datetime NULL COMMENT "sr更新时间"
) ENGINE=OLAP 
PRIMARY KEY(`Id`)
COMMENT "广告激励视频播放记录"
DISTRIBUTED BY HASH(`Id`) BUCKETS 30 
PROPERTIES (
"replication_num" = "3",
"bloom_filter_columns" = "_add_time",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);
