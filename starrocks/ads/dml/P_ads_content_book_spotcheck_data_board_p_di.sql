----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_content_book_spotcheck_data_board_p_di
-- workflow_version : 11
-- create_user      : xixg
-- task_name        : ads_content_book_spotcheck_data_board_p_di__p0
-- task_version     : 9
-- update_time      : 2025-05-21 18:14:35
-- sql_path         : \starrocks\tbl_ads_content_book_spotcheck_data_board_p_di\ads_content_book_spotcheck_data_board_p_di__p0
----------------------------------------------------------------
-- SQL语句
-- 打P0标签
INSERT INTO ads.ads_content_book_spotcheck_data_board_p_di
-- 过滤出角色类型为二校、质检、一校抽查、三校抽查的数据
WITH tmp_book AS (
    SELECT
        concat(a.Productid,a.Id) AS unique_id,
        a.*
    FROM ods.ods_edit_book_RemunerationDetail a
    WHERE DATE(a.CreateTime) = '${bf_1_dt}'
    AND a.RoleType  in (3,10,11,12)
    ),
-- 书籍相关信息
    realtime_remuneration AS (
SELECT
    a.unique_id,
    DATE(a.CreateTime) AS dt,
    a.bookId*1000 + a.ToLanguage AS book_id,
    a.CreateTime AS create_time,
    c.BookCode AS book_code,
    c.BookName AS book_name,
    a.ToLanguage AS language_id,
    CASE a.ToLanguage
    WHEN 333 THEN '繁体'
    WHEN 322 THEN '英语'
    WHEN 375 THEN '西语'
    WHEN 409 THEN '葡语'
    WHEN 410 THEN '法语'
    WHEN 412 THEN '德语'
    WHEN 413 THEN '意大利语'
    WHEN 414 THEN '印尼语'
    WHEN 415 THEN '阿拉伯语'
    WHEN 418 THEN '俄语'
    WHEN 419 THEN '日语'
    WHEN 433 THEN '泰语'
    WHEN 435 THEN '越南语'
    WHEN 436 THEN '韩语'
    WHEN 445 THEN '菲律宾语'
    WHEN 447 THEN '印地语'
    WHEN 448 THEN '孟加拉语'
    WHEN 495 THEN '马来西亚语'
    WHEN 497 THEN '土耳其语'
    WHEN 0 THEN '简体'
    ELSE ''  END AS language_name,
    a.RoleType AS role_type,
    a.FontLength AS spot_check_words,
    d.ChapterName AS chapter_name,
    b.PenName AS author_name,
    b.RealName AS real_name
FROM tmp_book a
    LEFT JOIN ods.ods_tidb_shuangwen_xx_objectauthor b
ON  a.productid = b.productid
    AND a.AuthorId = b.AccountId
    AND a.ToLanguage = b.ToLanguage
    LEFT JOIN ods.ods_tidb_shuangwen_en_objectbook c
    ON  a.productid = c.productid
    AND a.bookId = c.SwBookId
    AND a.ToLanguage = c.ToLanguage
    AND c.Status = 1
    LEFT JOIN ods.ods_tidb_shuangwen_xx_objectchapter d
    ON  a.productid = d.productid
    AND c.id = d.ObjectBookId
    AND a.ChapterId = d.Id
    ),

-- 最近60天进过三阶的书
    stage3_before_60d AS (
SELECT  book_id,language_id
FROM
    (SELECT
    CodeId AS book_id,
    CurrentLanguage AS language_id,
    ROW_NUMBER () OVER (PARTITION BY CodeId ORDER BY BeginDate DESC) AS rank_num                   -- 一本书可能近60天多次进3队，取最近的一条数据
    FROM ods.ods_tidb_ad_sharpengine_ads_global_MarketingPlan
    WHERE CodeStage = 3                                                                                -- 进过3阶
    AND DATEDIFF(CURRENT_DATE(), BeginDate) <= 60                                                    -- 近60天进过3阶
    ) a
WHERE a.rank_num = 1
    ),
-- 最近60天进过三阶繁体书
    stage3_ft_source_tmp AS (
SELECT
    a.book_id AS book_id,
    b.book_code AS book_code
FROM stage3_before_60d a
    INNER JOIN dim.dim_shuangwen_book_read_consume_info b
ON a.book_id = b.book_id
WHERE a.language_id = 2                                                                                     -- 最近60天进过3阶的繁体书
    ),
-- 最近60天进过三阶的英语书
    stage3_en_source_tmp AS (
SELECT
    a.book_id AS book_id,
    b.book_code AS book_code
FROM stage3_before_60d a
    INNER JOIN dim.dim_shuangwen_book_read_consume_info b
ON a.book_id = b.book_id
WHERE a.language_id = 3                                                                                     -- 最近60天进过3阶的英语书
    ),

    p0_book_id_tmp AS (
-- 对于繁体源头书，通过书籍代号找到它的英语衍生书
SELECT
    a.book_id
FROM ads.ads_report_book_capacity_rate_stat a
    INNER JOIN stage3_ft_source_tmp b
ON a.book_code = b.book_code
WHERE a.dt = '${bf_1_dt}'
  AND a.publish_length <= 200000                                                                          -- 发布字数小于20万
  AND a.site_id =  322                                                                                    -- 繁体书的衍生书为英语的
  AND a.font_length_curmonth > 0                                                                          -- 本月精修字数大于0
UNION
-- 对于英语源头书，通过书籍代号找到它的小语衍生书
SELECT
    a.book_id
FROM ads.ads_report_book_capacity_rate_stat a
    INNER JOIN stage3_en_source_tmp b
ON a.book_code = b.book_code
WHERE a.dt = '${bf_1_dt}'
  AND a.publish_length <= 200000                                                                          -- 发布字数小于20万
  AND a.site_id !=  322                                                                                   -- 英语源头书的衍生书为除英语外的其它小语言
  AND a.font_length_curmonth > 0                                                                          -- 本月精修字数大于0
    )

SELECT
    a.unique_id,
    a.dt,
    a.book_id,
    a.create_time,
    IFNULL(a.book_code,c.book_code),
    IFNULL(a.book_name,c.book_name),
    a.language_name,
    'P0' AS p_level,
    a.role_type,
    a.spot_check_words,
    a.chapter_name,
    a.author_name,
    a.real_name,
    NOW()
FROM realtime_remuneration a
         INNER JOIN p0_book_id_tmp p0
                    ON a.book_id  = p0.book_id
         LEFT JOIN dim.dim_shuangwen_book_read_consume_info c
                   ON a.book_id = c.book_id;

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_content_book_spotcheck_data_board_p_di
-- workflow_version : 11
-- create_user      : xixg
-- task_name        : ads_content_book_spotcheck_data_board_p_di__p1
-- task_version     : 8
-- update_time      : 2025-05-21 18:14:35
-- sql_path         : \starrocks\tbl_ads_content_book_spotcheck_data_board_p_di\ads_content_book_spotcheck_data_board_p_di__p1
----------------------------------------------------------------
-- SQL语句
-- 打P1标签
    INSERT INTO ads.ads_content_book_spotcheck_data_board_p_di
WITH tmp_book AS (
    SELECT
    concat(a.Productid,a.Id) AS unique_id,
    a.*
    FROM ods.ods_edit_book_RemunerationDetail a
    WHERE DATE(a.CreateTime) = '${bf_1_dt}'
    AND a.RoleType  in (3,10,11,12)
    ),

    realtime_remuneration AS (
    SELECT
    a.unique_id,
    DATE(a.CreateTime) AS dt,
    a.bookId*1000 + a.ToLanguage AS book_id,
    a.CreateTime AS create_time,
    c.BookCode AS book_code,
    c.BookName AS book_name,
    a.ToLanguage AS language_id,
    CASE a.ToLanguage
    WHEN 333 THEN '繁体'
    WHEN 322 THEN '英语'
    WHEN 375 THEN '西语'
    WHEN 409 THEN '葡语'
    WHEN 410 THEN '法语'
    WHEN 412 THEN '德语'
    WHEN 413 THEN '意大利语'
    WHEN 414 THEN '印尼语'
    WHEN 415 THEN '阿拉伯语'
    WHEN 418 THEN '俄语'
    WHEN 419 THEN '日语'
    WHEN 433 THEN '泰语'
    WHEN 435 THEN '越南语'
    WHEN 436 THEN '韩语'
    WHEN 445 THEN '菲律宾语'
    WHEN 447 THEN '印地语'
    WHEN 448 THEN '孟加拉语'
    WHEN 495 THEN '马来西亚语'
    WHEN 497 THEN '土耳其语'
    WHEN 0 THEN '简体'
    ELSE ''  END AS language_name,
    a.RoleType AS role_type,
    a.FontLength AS spot_check_words,
    d.ChapterName AS chapter_name,
    b.PenName AS author_name,
    b.RealName AS real_name
    FROM tmp_book a
    LEFT JOIN ods.ods_tidb_shuangwen_xx_objectauthor b
    ON  a.productid = b.productid
    AND a.AuthorId = b.AccountId
    AND a.ToLanguage = b.ToLanguage
    LEFT JOIN ods.ods_tidb_shuangwen_en_objectbook c
    ON  a.productid = c.productid
    AND a.bookId = c.SwBookId
    AND a.ToLanguage = c.ToLanguage
    AND c.Status = 1
    LEFT JOIN ods.ods_tidb_shuangwen_xx_objectchapter d
    ON  a.productid = d.productid
    AND c.id = d.ObjectBookId
    AND a.ChapterId = d.Id
    ),

    p1_book_id_tmp AS (
    SELECT
    CASE
    WHEN a.site_id = 322 AND a.publish_length < 250000 THEN book_id   -- 英语
    WHEN a.site_id = 375 AND a.publish_length < 200000 THEN book_id   -- 西语
    WHEN a.site_id = 409 AND a.publish_length < 200000 THEN book_id   -- 葡语
    WHEN a.site_id = 333 AND a.publish_length < 350000 THEN book_id   -- 繁体
    WHEN a.site_id = 418 AND a.publish_length < 250000 THEN book_id   -- 俄语
    WHEN a.site_id = 414 AND a.publish_length < 250000 THEN book_id   -- 印尼语
    WHEN a.site_id = 410 AND a.publish_length < 250000 THEN book_id   -- 法语
    WHEN a.site_id = 433 AND a.publish_length < 300000 THEN book_id   -- 泰语
    WHEN a.site_id = 436 AND a.publish_length < 300000 THEN book_id   -- 韩语
    ELSE 'NULL'
    END AS book_id
    FROM ads.ads_report_book_capacity_rate_stat a
    WHERE a.dt = '${bf_1_dt}'
    AND a.book_id not in (SELECT book_id FROM ads.ads_content_book_spotcheck_data_board_p_di WHERE dt = '${bf_1_dt}')
    AND a.font_length_curmonth > 0
    )

SELECT
    a.unique_id,
    a.dt,
    a.book_id,
    a.create_time,
    IFNULL(a.book_code,c.book_code),
    IFNULL(a.book_name,c.book_name),
    a.language_name,
    'P1' AS p_level,
    a.role_type,
    a.spot_check_words,
    a.chapter_name,
    a.author_name,
    a.real_name,
    NOW()
FROM realtime_remuneration a
         INNER JOIN (SELECT book_id FROM p1_book_id_tmp WHERE book_id != 'NULL') b
                    ON a.book_id  = b.book_id
         LEFT JOIN dim.dim_shuangwen_book_read_consume_info c
                   ON a.book_id = c.book_id;

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_content_book_spotcheck_data_board_p_di
-- workflow_version : 11
-- create_user      : xixg
-- task_name        : ads_content_book_spotcheck_data_board_p_di__p2
-- task_version     : 10
-- update_time      : 2025-05-21 18:14:35
-- sql_path         : \starrocks\tbl_ads_content_book_spotcheck_data_board_p_di\ads_content_book_spotcheck_data_board_p_di__p2
----------------------------------------------------------------
-- SQL语句
-- 打P2标签
    INSERT INTO ads.ads_content_book_spotcheck_data_board_p_di
WITH tmp_book AS (
    SELECT
    concat(a.Productid,a.Id) AS unique_id,
    a.*
    FROM ods.ods_edit_book_RemunerationDetail a
    WHERE DATE(a.CreateTime) = '${bf_1_dt}'
    AND a.RoleType  in (3,10,11,12)
    ),

    realtime_remuneration AS (
    SELECT
    a.unique_id,
    DATE(a.CreateTime) AS dt,
    a.bookId*1000 + a.ToLanguage AS book_id,
    a.CreateTime AS create_time,
    c.BookCode AS book_code,
    c.BookName AS book_name,
    CASE a.ToLanguage
    WHEN 333 THEN '繁体'
    WHEN 322 THEN '英语'
    WHEN 375 THEN '西语'
    WHEN 409 THEN '葡语'
    WHEN 410 THEN '法语'
    WHEN 412 THEN '德语'
    WHEN 413 THEN '意大利语'
    WHEN 414 THEN '印尼语'
    WHEN 415 THEN '阿拉伯语'
    WHEN 418 THEN '俄语'
    WHEN 419 THEN '日语'
    WHEN 433 THEN '泰语'
    WHEN 435 THEN '越南语'
    WHEN 436 THEN '韩语'
    WHEN 445 THEN '菲律宾语'
    WHEN 447 THEN '印地语'
    WHEN 448 THEN '孟加拉语'
    WHEN 495 THEN '马来西亚语'
    WHEN 497 THEN '土耳其语'
    WHEN 0 THEN '简体'
    ELSE ''  END AS language_name,
    a.RoleType AS role_type,
    a.FontLength AS spot_check_words,
    d.ChapterName AS chapter_name,
    b.PenName AS author_name,
    b.RealName AS real_name
    FROM tmp_book a
    LEFT JOIN ods.ods_tidb_shuangwen_xx_objectauthor b
    ON  a.productid = b.productid
    AND a.AuthorId = b.AccountId
    AND a.ToLanguage = b.ToLanguage
    LEFT JOIN ods.ods_tidb_shuangwen_en_objectbook c
    ON  a.productid = c.productid
    AND a.bookId = c.SwBookId
    AND a.ToLanguage = c.ToLanguage
    AND c.Status = 1
    LEFT JOIN ods.ods_tidb_shuangwen_xx_objectchapter d
    ON  a.productid = d.productid
    AND c.id = d.ObjectBookId
    AND a.ChapterId = d.Id
    )

SELECT
    a.unique_id,
    a.dt,
    a.book_id,
    a.create_time,
    IFNULL(a.book_code,c.book_code),
    IFNULL(a.book_name,c.book_name),
    a.language_name,
    'P2' AS p_level,
    a.role_type,
    a.spot_check_words,
    a.chapter_name,
    a.author_name,
    a.real_name,
    NOW()
FROM realtime_remuneration a
         LEFT JOIN dim.dim_shuangwen_book_read_consume_info c
                   ON a.book_id = c.book_id
WHERE a.book_id not in (SELECT book_id FROM ads.ads_content_book_spotcheck_data_board_p_di WHERE dt = '${bf_1_dt}');
