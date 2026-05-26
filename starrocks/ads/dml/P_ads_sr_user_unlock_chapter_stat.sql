----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_sr_user_unlock_chapter_stat
-- workflow_version : 13
-- create_user      : xixg
-- task_name        : ads_sr_user_unlock_chapter_stat
-- task_version     : 13
-- update_time      : 2024-12-02 16:24:09
-- sql_path         : \starrocks\tbl_ads_sr_user_unlock_chapter_stat\ads_sr_user_unlock_chapter_stat
----------------------------------------------------------------
-- SQL语句
INSERT INTO ads.ads_sr_user_unlock_chapter_stat
-- 先计算出2023年后每个产品活跃的用户
WITH product_active_user AS (
    SELECT
          product_id,
          user_id
    from dws.dws_user_wide_active_ed
    where  dt >= '2023-01-01'
    GROUP BY 1,2
),
-- 每个产品，每个用户 解锁了哪些书，每本书取最新解锁时间
 book_latest_unlock AS (
    SELECT
        product_id,
        user_id,
        book_id,
        MAX(unlock_time) AS unlock_time
   FROM (
            SELECT product_id, Pid AS user_id, BookId AS book_id, MAX(UnlockTime) AS unlock_time FROM ods.ods_tidb_readernovel_tidb_xx_adunlockchapter GROUP BY 1,2,3
            UNION ALL
            SELECT ProductId AS product_id, UserId AS user_id, BookId AS book_id, MAX(CreateTime) AS unlock_time FROM ods_log.ods_book_log_usermoneylog WHERE BookId > 0 GROUP BY 1,2,3
            UNION ALL
            SELECT ProductId AS product_id, UserId AS user_id, BookId AS book_id, MAX(CreateTime) AS unlock_time FROM ods_log.ods_book_log_usergiftmoneylog WHERE BookId > 0 GROUP BY 1,2,3
            UNION ALL
            SELECT ProductId AS product_id, UserId AS user_id, BookId AS book_id, MAX(CreateTime) AS unlock_time FROM ods_log.ods_book_log_userawardmoneylog WHERE BookId > 0 GROUP BY 1,2,3
            UNION ALL
            SELECT ProductId AS product_id, UserId AS user_id, BookId AS book_id, MAX(CreateTime) AS unlock_time FROM ods.ods_tidb_Log_BookExclusivelyGiftLog WHERE BookId > 0 AND Type=1 GROUP BY 1,2,3
        ) a
    GROUP BY 1,2,3
),
-- 2023年以后活跃用户每个product_id解锁的最新3本书
active_user_latest_3book AS (
    SELECT
        product_id,
        user_id,
        book_id,
        unlock_time
    FROM (
            SELECT
                 a.product_id,
                 a.user_id,
                 a.book_id,
                 a.unlock_time,
                 ROW_NUMBER() OVER(PARTITION BY a.product_id, a.user_id ORDER BY a.unlock_time DESC) AS rank
            FROM book_latest_unlock  a
            INNER JOIN  product_active_user b
                ON a.product_id = b.product_id
                    AND a.user_id = b.user_id
          ) a
    WHERE rank <= 3
),

-- 2023年后每个活跃用户 每本书解锁章节数
book_unlock_count AS (
    SELECT a.product_id, a.user_id, a.book_id, SUM(unlock_count) AS unlock_count
    FROM
    (
    SELECT a.productid AS product_id, a.UserId AS user_id, a.BookId AS book_id, array_length(split(a.Indexs,',')) AS unlock_count
    FROM ods.ods_tidb_readernovel_tidb_xx_userbuybookhistory a
    INNER JOIN  product_active_user b
        ON a.productid = b.product_id AND a.UserId = b.user_id
    UNION ALL
    SELECT a.product_id, a.Pid AS user_id, a.BookId AS book_id, SUM(a.UnlockCount) AS unlock_count
    FROM ods.ods_tidb_readernovel_tidb_xx_adunlockchapter a
        INNER JOIN  product_active_user b
            ON a.product_id = b.product_id AND a.Pid = b.user_id
    GROUP BY a.product_id, a.Pid, a.BookId
    ) a
    GROUP BY 1,2,3
),
-- 2023年后每个活跃用户所有书累计解锁章节数
user_total_unlock_count AS (
 SELECT
     product_id,
     user_id,
     SUM(unlock_count) AS total_unlock_count
 FROM book_unlock_count
 GROUP BY product_id, user_id
),

-- 每个产品，每个用户 最新3本书的信息（json字符串）
user_last3_book_info AS (
SELECT
    a.product_id,
    a.user_id,
    group_concat('{"book_id": ',a.book_id,',"unlock_time": "',a.unlock_time,'","unlock_count":',b.unlock_count,'}') AS book_info
FROM active_user_latest_3book a
INNER JOIN book_unlock_count b
ON a.product_id = b.product_id
AND a.user_id = b.user_id
AND a.book_id = b.book_id
GROUP BY a.product_id, a.user_id
),

result_tmp AS (
SELECT
    a.product_id,
    a.user_id,
    b.total_unlock_count AS total_unlock_chapter_count,
    concat('[', c.book_info, ']') AS latest_unlock_book_info,
    NOW()
FROM product_active_user a
LEFT JOIN user_total_unlock_count b
  ON a.product_id = b.product_id
  AND a.user_id = b.user_id
LEFT JOIN user_last3_book_info c
ON a.product_id = c.product_id
  AND a.user_id = c.user_id
)

SELECT * FROM result_tmp WHERE total_unlock_chapter_count IS NOT NULL OR latest_unlock_book_info IS NOT NULL;
