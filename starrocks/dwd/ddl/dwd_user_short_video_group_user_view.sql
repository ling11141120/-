CREATE VIEW `dwd_user_short_video_group_user_view` (`id` COMMENT "用户 id", `group_id` COMMENT "人群包 id", `account` COMMENT "账号", `end_ts` COMMENT "用户出包的时间戳", `seq_num` COMMENT "账号在人群包内的序号", `create_time` COMMENT "创建时间", `update_time` COMMENT "更新时间")
COMMENT "海外短剧人群包用户试图" AS SELECT `ods`.`ods_tidb_short_video_group_user_group_user`.`id`, `ods`.`ods_tidb_short_video_group_user_group_user`.`group_id`, `ods`.`ods_tidb_short_video_group_user_group_user`.`account`, `ods`.`ods_tidb_short_video_group_user_group_user`.`end_ts`, `ods`.`ods_tidb_short_video_group_user_group_user`.`seq_num`, `ods`.`ods_tidb_short_video_group_user_group_user`.`create_time`, `ods`.`ods_tidb_short_video_group_user_group_user`.`update_time`
FROM `ods`.`ods_tidb_short_video_group_user_group_user`;
utf8
utf8_general_ci