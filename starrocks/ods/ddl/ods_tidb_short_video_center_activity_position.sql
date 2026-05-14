CREATE TABLE `ods_tidb_short_video_center_activity_position` (
  `Id` bigint(20) NOT NULL COMMENT "主键id",
  `ActivityId` bigint(20) NULL COMMENT "活动Id",
  `ActionType` tinyint(4) NULL COMMENT "资源位类型1：banner，2：悬浮窗，3：弹窗，4：闪屏，5：阅读页触达剧集触达，8：章末推送，9：阅读器返回推，10：串书，11：TAB推荐 , 12 开屏，13 底部TAB;
