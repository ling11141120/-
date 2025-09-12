CREATE VIEW `ads_read_user_chapter_view` (
     `dt`          COMMENT    "createtime 分区"
    ,`product_id`  COMMENT    "产品id"
    ,`id`          COMMENT    "自增id"
    ,`book_id`     COMMENT    "书籍id"
    ,`chapter_id`  COMMENT    "章节id"
    ,`user_id`     COMMENT    "用户id"
    ,`prod_id`     COMMENT    "x值（没有用）"
    ,`create_time` COMMENT    "阅读时间"
    ,`appid`       COMMENT    "应用程序id"
    ,`read_times`  COMMENT    "阅读时长（秒）-没有用")
COMMENT "书籍章节阅读记录" 
AS SELECT `ods_log`.`ods_book_user_readchapter`.`dt`
        , `ods_log`.`ods_book_user_readchapter`.`productid`      AS `product_id`
        , `ods_log`.`ods_book_user_readchapter`.`id`
        , if((`ods_log`.`ods_book_user_readchapter`.`bookid` IS NULL) OR (`ods_log`.`ods_book_user_readchapter`.`bookid` = '')
        , -99
        , `ods_log`.`ods_book_user_readchapter`.`bookid`)        AS `book_id`
        , if((`ods_log`.`ods_book_user_readchapter`.`chapterid` IS NULL) OR (`ods_log`.`ods_book_user_readchapter`.`chapterid` = '')
        , -99
        , `ods_log`.`ods_book_user_readchapter`.`chapterid`)     AS `chapter_id`
        , `ods_log`.`ods_book_user_readchapter`.`userid`         AS `user_id`
        , if((`ods_log`.`ods_book_user_readchapter`.`prodid` IS NULL) OR (`ods_log`.`ods_book_user_readchapter`.`prodid` = '')
        , -99
        , `ods_log`.`ods_book_user_readchapter`.`prodid`)        AS `prod_id`
        , `ods_log`.`ods_book_user_readchapter`.`createtime`     AS `create_time`
        , if((`ods_log`.`ods_book_user_readchapter`.`appid` IS NULL) OR (`ods_log`.`ods_book_user_readchapter`.`appid` = '')
        , -99
        , `ods_log`.`ods_book_user_readchapter`.`appid`)         AS `appid`
        , `ods_log`.`ods_book_user_readchapter`.`time`           AS `read_times`
     FROM `ods_log`.`ods_book_user_readchapter`
     ;