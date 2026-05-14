CREATE VIEW `ads_sr_bi_user_read_chapter_view` (`dt` COMMENT "日期", `product_id` COMMENT "产品id", `book_id` COMMENT "书籍id", `serial_number` COMMENT "章节序号 3，5，10，30", `user_id` COMMENT "bitmap类型")
COMMENT "阅读线，书籍特定章节阅读人数，应用于bi书籍消费统计表" AS SELECT `dws`.`a`.`dt`, `dws`.`a`.`product_id`, `dws`.`a`.`book_id`, `b`.`serial_number`, `dws`.`a`.`user_id`
FROM `dws`.`dws_read_book_chapter_ed` AS `a` INNER JOIN (SELECT `dim`.`dim_book_chapter_info`.`book_id`, `dim`.`dim_book_chapter_info`.`chapter_id`, `dim`.`dim_book_chapter_info`.`serial_number`
FROM `dim`.`dim_book_chapter_info`
WHERE `dim`.`dim_book_chapter_info`.`serial_number` IN (3, 5, 10, 30)) `b` ON (`dws`.`a`.`book_id` = `b`.`book_id`) AND (`dws`.`a`.`chapter_id` = `b`.`chapter_id`);