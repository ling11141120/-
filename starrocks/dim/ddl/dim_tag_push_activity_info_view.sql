CREATE VIEW `dim_tag_push_activity_info_view` (`push_id` COMMENT "push活动id", `activity_id` COMMENT "活动id", `strategy_id` COMMENT "策略id", `book_id` COMMENT "书籍id", `lang_id` COMMENT "语言id")
COMMENT "tag后台push相关活动配置信息表" AS SELECT `ods`.`a`.`id` AS `push_id`, `ods`.`a`.`ActivityId` AS `activity_id`, `ods`.`b`.`id` AS `strategy_id`, `ods`.`c`.`BookId` AS `book_id`, `ods`.`c`.`LangId` AS `lang_id`
FROM `ods`.`ods_tidb_readernovel_tidb_tag_center_activity_push` AS `a` LEFT OUTER JOIN `ods`.`ods_tidb_readernovel_tidb_tag_center_push` AS `b` ON `ods`.`a`.`ActivityId` = `ods`.`b`.`MainId` LEFT OUTER JOIN `ods`.`ods_tidb_readernovel_tidb_tag_center_activity_recept` AS `c` ON `ods`.`b`.`id` = `ods`.`c`.`ActionId`;
utf8
utf8_general_ci