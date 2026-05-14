CREATE VIEW `dim_koc_invitationcode_view` (`Id` COMMENT "主键ID", `code` COMMENT "邀请码", `star_id` COMMENT "达人ID", `user_id` COMMENT "用户id", `change_limit` COMMENT "已经换绑次数", `etl_tm` COMMENT "清洗时间") AS SELECT `ods`.`ods_tidb_kocdb_koc_invitationcode`.`Id`, `ods`.`ods_tidb_kocdb_koc_invitationcode`.`Code`, `ods`.`ods_tidb_kocdb_koc_invitationcode`.`StarId` AS `star_id`, `ods`.`ods_tidb_kocdb_koc_invitationcode`.`UserId` AS `user_id`, `ods`.`ods_tidb_kocdb_koc_invitationcode`.`ChangeLimit` AS `change_limit`, now() AS `etl_tm`
FROM `ods`.`ods_tidb_kocdb_koc_invitationcode`;
utf8
utf8_general_ci