CREATE VIEW `dim_fanti_length_updatetime_view` (`update_time` COMMENT "内容发布时间", `book_id` COMMENT "书籍id", `publish_length_cnt` COMMENT "发布字数")
COMMENT "446,449,090繁体书籍内容发布时间信息" AS SELECT `x`.`update_time`, `x`.`book_id`, `x`.`publish_length_cnt`
FROM (SELECT date(`c`.`ChapterUpdateTime`) AS `update_time`, (`ods`.`a`.`bookid` * 1000) + 446 AS `book_id`, sum(if(((`b`.`status` = 2) AND (`b`.`delstatus` = 0)) AND (`b`.`publishtime` < (current_date())), `b`.`fontlength`, 0)) AS `publish_length_cnt`
FROM `ods`.`ods_edit_book` AS `a` LEFT OUTER JOIN (SELECT `ods`.`ods_tidb_shuangwen_xx_chapter`.`BookId`, `ods`.`ods_tidb_shuangwen_xx_chapter`.`ProductId`, `ods`.`ods_tidb_shuangwen_xx_chapter`.`DelStatus`, `ods`.`ods_tidb_shuangwen_xx_chapter`.`SequenceNum`, `ods`.`ods_tidb_shuangwen_xx_chapter`.`FontLength`, `ods`.`ods_tidb_shuangwen_xx_chapter`.`PublishTime`, `ods`.`ods_tidb_shuangwen_xx_chapter`.`Status`
FROM `ods`.`ods_tidb_shuangwen_xx_chapter`
WHERE ((`ods`.`ods_tidb_shuangwen_xx_chapter`.`PublishTime` < (now())) AND (`ods`.`ods_tidb_shuangwen_xx_chapter`.`DelStatus` = 0)) AND (`ods`.`ods_tidb_shuangwen_xx_chapter`.`Status` = 2)) `b` ON (`ods`.`a`.`bookid` = `b`.`bookid`) AND (`ods`.`a`.`productid` = `b`.`ProductId`) LEFT OUTER JOIN (SELECT `ods`.`a`.`id`, `ods`.`a`.`SiteBookId`, `ods`.`b`.`StartNum`, `ods`.`a`.`ChapterUpdateTime`
FROM `ods`.`ods_tidb_shuangwen_en_custombook` AS `a` LEFT OUTER JOIN `ods`.`ods_tidb_shuangwen_en_customchapterplus` AS `b` ON `ods`.`a`.`id` = `ods`.`b`.`BookId`
WHERE (`ods`.`b`.`EnableTime` < (now())) AND (`ods`.`a`.`delstatus` = 0)) `c` ON `ods`.`a`.`bookid` = `c`.`SiteBookId`
WHERE (`ods`.`a`.`productid` = 3311) AND (`ods`.`a`.`siteid` = 446)
GROUP BY 1, 2) `x`
WHERE `x`.`update_time` IS NOT NULL UNION ALL SELECT date(`b`.`UpdateTime`) AS `update_time`, (`ods`.`a`.`bookid` * 1000) + 449 AS `book_id`, sum(if(((`b`.`status` IN (1, 2)) AND (`b`.`delstatus` = 0)) AND (`b`.`publishtime` < (current_date())), `b`.`fontlength`, 0)) AS `publish_length_cnt`
FROM `ods`.`ods_mysql_zhangzhong_xzz_Book` AS `a` INNER JOIN (SELECT `ods`.`ods_mysql_zhangzhong_xzz_Chapter`.`BookId`, `ods`.`ods_mysql_zhangzhong_xzz_Chapter`.`DelStatus`, `ods`.`ods_mysql_zhangzhong_xzz_Chapter`.`FontLength`, `ods`.`ods_mysql_zhangzhong_xzz_Chapter`.`PublishTime`, `ods`.`ods_mysql_zhangzhong_xzz_Chapter`.`Status`, `ods`.`ods_mysql_zhangzhong_xzz_Chapter`.`UpdateTime`
FROM `ods`.`ods_mysql_zhangzhong_xzz_Chapter`
WHERE ((`ods`.`ods_mysql_zhangzhong_xzz_Chapter`.`PublishTime` < (now())) AND (`ods`.`ods_mysql_zhangzhong_xzz_Chapter`.`DelStatus` = 0)) AND (`ods`.`ods_mysql_zhangzhong_xzz_Chapter`.`Status` IN (1, 2))) `b` ON `ods`.`a`.`bookid` = `b`.`bookid`
GROUP BY 1, 2 UNION ALL SELECT date(`b`.`UpdateTime`) AS `update_time`, (`ods`.`a`.`bookid` * 1000) + 90 AS `book_id`, sum(if(((`b`.`status` = 2) AND (`b`.`delstatus` = 0)) AND (`b`.`publishtime` < (current_date())), `b`.`fontlength`, 0)) AS `publish_length_cnt`
FROM `ods`.`ods_mysql_Fmx_Book` AS `a` INNER JOIN (SELECT `ods`.`ods_mysql_Fmx_Chapter`.`BookId`, `ods`.`ods_mysql_Fmx_Chapter`.`DelStatus`, `ods`.`ods_mysql_Fmx_Chapter`.`FontLength`, `ods`.`ods_mysql_Fmx_Chapter`.`PublishTime`, `ods`.`ods_mysql_Fmx_Chapter`.`Status`, `ods`.`ods_mysql_Fmx_Chapter`.`UpdateTime`
FROM `ods`.`ods_mysql_Fmx_Chapter`
WHERE ((`ods`.`ods_mysql_Fmx_Chapter`.`PublishTime` < (now())) AND (`ods`.`ods_mysql_Fmx_Chapter`.`DelStatus` = 0)) AND (`ods`.`ods_mysql_Fmx_Chapter`.`Status` = 2)) `b` ON `ods`.`a`.`bookid` = `b`.`bookid`
GROUP BY 1, 2;
utf8
utf8_general_ci