CREATE VIEW `dwd_sr_user_consume_info_view` (`dt`, `product_id`, `user_id`, `book_id`, `amount`) AS SELECT `ods_log`.`ods_book_log_usermoneylog`.`dt`, `ods_log`.`ods_book_log_usermoneylog`.`ProductId` AS `product_id`, `ods_log`.`ods_book_log_usermoneylog`.`UserId` AS `user_id`, `ods_log`.`ods_book_log_usermoneylog`.`BookId` AS `book_id`, `ods_log`.`ods_book_log_usermoneylog`.`Amount`
FROM `ods_log`.`ods_book_log_usermoneylog`
WHERE `ods_log`.`ods_book_log_usermoneylog`.`dt` > '2024-12-01';
utf8
utf8_general_ci