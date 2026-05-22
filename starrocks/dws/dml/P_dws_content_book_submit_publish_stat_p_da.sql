----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dws_content_book_submit_publish_stat_p_da
-- workflow_version : 32
-- create_user      : xixg
-- task_name        : dws_content_book_submit_publish_stat_p_da__dyy
-- task_version     : 14
-- update_time      : 2024-08-08 19:35:47
-- sql_path         : \starrocks\tbl_dws_content_book_submit_publish_stat_p_da\dws_content_book_submit_publish_stat_p_da__dyy
----------------------------------------------------------------
-- SQL语句
-- 多语言相关书籍统计
INSERT INTO dws.dws_content_book_submit_publish_stat_p_da

-- 书籍免费章节字数相关统计
with dyy_free_chapter_tmp AS (
SELECT
        a.BookId*1000+a.SiteId AS book_id,
        MAX(a.FreeChapterNum) AS free_chapters,
        SUM(b.font_length) AS free_words
FROM ods.ods_edit_book a
LEFT JOIN (
            SELECT
                product_id,
                book_id,
                chapter_id,
                font_length
            FROM(
                    SELECT
                            a.productid AS product_id,
                            a.BookId*1000+a.SiteId AS book_id,
                            b.ChapterId AS chapter_id,
                            a.FreeChapterNum AS free_chapters,
                            b.FontLength AS font_length,
                            ROW_NUMBER () OVER (PARTITION BY b.ProductId,b.BookId ORDER BY SequenceNum ) rank_num       --按章节序号排序
                     FROM ods.ods_edit_book a
                    INNER JOIN ods.ods_tidb_shuangwen_xx_chapter b
                     ON a.productid  = b.ProductId
                     AND a.BookId = b.BookId
                     AND b.DelStatus = 0
                     AND b.Status = 2
                    ) a
            WHERE a.rank_num <= a.free_chapters
            ) b
  ON a.BookId*1000+a.SiteId = b.book_id
GROUP BY a.BookId*1000+a.SiteId
),

-- 书籍提交发布相关统计
dyy_submit_chapter_tmp AS (
SELECT
        a.BookId*1000+a.SiteId AS book_id,                                                                                            --书籍ID
        MAX(a.BookName) AS book_name,                                                                                   --书籍名称
        SUM(IF(DATEDIFF(NOW(),c.dt) between 0 and 7,c.proofread_number_today,0)) AS submit_chapters_l7,                 -- 最近7天提交章节数  多语言是算最近7天的二校章节数
        SUM(IF(DATEDIFF(NOW(),c.dt) between 0 and 7,c.proofread_length_today,0)) AS submit_words_l7                     -- 最近7天提交字数 多语言是算最近7天的二校字数
 FROM ods.ods_edit_book a
 LEFT JOIN dwd.dwd_content_book_capacity_daily c
   ON a.BookId*1000+a.SiteId = c.to_book_id
  AND c.dt >= DATE_FORMAT(DATE_SUB(NOW(),INTERVAL 8 DAY),'%Y-%m-%d')   -- 过滤出最近7天二校章节数据，由于 NOW是第二天凌晨，所以是减8天
GROUP BY a.BookId*1000+a.SiteId
),

words_5w_tmp AS (
    SELECT
        book_id,
        publish_time
    FROM (
    SELECT
        a.BookId*1000+a.SiteId AS book_id,                                                                               --书籍ID
        b.PublishTime AS publish_time,
        SUM(b.FontLength) OVER (PARTITION BY a.productid,a.BookId ORDER BY b.PublishTime) AS published_words                     -- 书籍已发布字数
    FROM ods.ods_edit_book a
    LEFT JOIN ods.ods_tidb_shuangwen_xx_chapter b
        ON a.productid  = b.ProductId
        AND a.BookId = b.BookId
        AND b.DelStatus = 0
        AND b.Status = 2
    ) d
    WHERE d.published_words >=50000
),

words_5w_time AS (
    SELECT
    *
    FROM  (
            SELECT
            book_id,
            publish_time,
            ROW_NUMBER() OVER (PARTITION BY book_id order by publish_time ) rank_num
            FROM words_5w_tmp
            ) d
    WHERE rank_num = 1
),

words_10w_tmp AS (
    SELECT
    book_id,
    publish_time
    FROM (
    SELECT
    a.BookId*1000+a.SiteId AS book_id,                                                                               --书籍ID
    b.PublishTime AS publish_time,
    SUM(b.FontLength) OVER (PARTITION BY a.productid,a.BookId ORDER BY b.PublishTime) AS published_words                     -- 书籍已发布字数
    FROM ods.ods_edit_book a
    LEFT JOIN ods.ods_tidb_shuangwen_xx_chapter b
    ON a.productid  = b.ProductId
    AND a.BookId = b.BookId
    AND b.DelStatus = 0
    AND b.Status = 2
    ) d
    WHERE d.published_words >=100000
),

words_10w_time AS (
    SELECT
    *
    FROM  (
    SELECT
    book_id,
    publish_time,
    ROW_NUMBER() OVER (PARTITION BY book_id order by publish_time ) rank_num
    FROM words_10w_tmp
    ) d
    WHERE rank_num = 1
),

words_15w_tmp AS (
    SELECT
    book_id,
    publish_time
    FROM (
    SELECT
    a.BookId*1000+a.SiteId AS book_id,                                                                               --书籍ID
    b.PublishTime AS publish_time,
    SUM(b.FontLength) OVER (PARTITION BY a.productid,a.BookId ORDER BY b.PublishTime) AS published_words                     -- 书籍已发布字数
    FROM ods.ods_edit_book a
    LEFT JOIN ods.ods_tidb_shuangwen_xx_chapter b
    ON a.productid  = b.ProductId
    AND a.BookId = b.BookId
    AND b.DelStatus = 0
    AND b.Status = 2
    ) d
    WHERE d.published_words >=150000
),

words_15w_time AS (
    SELECT
    *
    FROM  (
    SELECT
    book_id,
    publish_time,
    ROW_NUMBER() OVER (PARTITION BY book_id order by publish_time ) rank_num
    FROM words_15w_tmp
    ) d
    WHERE rank_num = 1
),

words_20w_tmp AS (
    SELECT
    book_id,
    publish_time
    FROM (
    SELECT
    a.BookId*1000+a.SiteId AS book_id,                                                                               --书籍ID
    b.PublishTime AS publish_time,
    SUM(b.FontLength) OVER (PARTITION BY a.productid,a.BookId ORDER BY b.PublishTime) AS published_words                     -- 书籍已发布字数
    FROM ods.ods_edit_book a
    LEFT JOIN ods.ods_tidb_shuangwen_xx_chapter b
    ON a.productid  = b.ProductId
    AND a.BookId = b.BookId
    AND b.DelStatus = 0
    AND b.Status = 2
    ) d
    WHERE d.published_words >=200000
),

words_20w_time AS (
    SELECT
    *
    FROM  (
    SELECT
    book_id,
    publish_time,
    ROW_NUMBER() OVER (PARTITION BY book_id order by publish_time ) rank_num
    FROM words_20w_tmp
    ) d
    WHERE rank_num = 1
),

words_25w_tmp AS (
    SELECT
    book_id,
    publish_time
    FROM (
    SELECT
    a.BookId*1000+a.SiteId AS book_id,                                                                               --书籍ID
    b.PublishTime AS publish_time,
    SUM(b.FontLength) OVER (PARTITION BY a.productid,a.BookId ORDER BY b.PublishTime) AS published_words                     -- 书籍已发布字数
    FROM ods.ods_edit_book a
    LEFT JOIN ods.ods_tidb_shuangwen_xx_chapter b
    ON a.productid  = b.ProductId
    AND a.BookId = b.BookId
    AND b.DelStatus = 0
    AND b.Status = 2
    ) d
    WHERE d.published_words >=250000
),

words_25w_time AS (
    SELECT
    *
    FROM  (
    SELECT
    book_id,
    publish_time,
    ROW_NUMBER() OVER (PARTITION BY book_id order by publish_time ) rank_num
    FROM words_25w_tmp
    ) d
    WHERE rank_num = 1
),

words_30w_tmp AS (
    SELECT
    book_id,
    publish_time
    FROM (
    SELECT
    a.BookId*1000+a.SiteId AS book_id,                                                                               --书籍ID
    b.PublishTime AS publish_time,
    SUM(b.FontLength) OVER (PARTITION BY a.productid,a.BookId ORDER BY b.PublishTime) AS published_words                     -- 书籍已发布字数
    FROM ods.ods_edit_book a
    LEFT JOIN ods.ods_tidb_shuangwen_xx_chapter b
    ON a.productid  = b.ProductId
    AND a.BookId = b.BookId
    AND b.DelStatus = 0
    AND b.Status = 2
    ) d
    WHERE d.published_words >=300000
),

words_30w_time AS (
    SELECT
    *
    FROM  (
    SELECT
    book_id,
    publish_time,
    ROW_NUMBER() OVER (PARTITION BY book_id order by publish_time ) rank_num
    FROM words_30w_tmp
    ) d
    WHERE rank_num = 1
),

words_35w_tmp AS (
    SELECT
    book_id,
    publish_time
    FROM (
    SELECT
    a.BookId*1000+a.SiteId AS book_id,                                                                               --书籍ID
    b.PublishTime AS publish_time,
    SUM(b.FontLength) OVER (PARTITION BY a.productid,a.BookId ORDER BY b.PublishTime) AS published_words                     -- 书籍已发布字数
    FROM ods.ods_edit_book a
    LEFT JOIN ods.ods_tidb_shuangwen_xx_chapter b
    ON a.productid  = b.ProductId
    AND a.BookId = b.BookId
    AND b.DelStatus = 0
    AND b.Status = 2
    ) d
    WHERE d.published_words >=350000
),

words_35w_time AS (
    SELECT
    *
    FROM  (
    SELECT
    book_id,
    publish_time,
    ROW_NUMBER() OVER (PARTITION BY book_id order by publish_time ) rank_num
    FROM words_35w_tmp
    ) d
    WHERE rank_num = 1
)

SELECT
        DATE_FORMAT ('${bf_1_dt}', '%Y-%m-%d'),
        a.book_id AS book_id,
        a.book_name,
        '',
        0 total_chapters,
        b.free_chapters,
        b.free_words,
        0 AS published_chapters,
        0 AS published_words,
        a.submit_chapters_l7,
        a.submit_words_l7,
        d.publish_time AS published_5w_date,
        e.publish_time AS published_10w_date,
        f.publish_time AS published_15w_date,
        g.publish_time AS published_20w_date,
        h.publish_time AS published_25w_date,
        i.publish_time AS published_30w_date,
        j.publish_time AS published_35w_date,
        NOW()
FROM dyy_submit_chapter_tmp a
LEFT JOIN dyy_free_chapter_tmp b
 ON a.book_id = b.book_id
LEFT JOIN words_5w_time d
          ON a.book_id = d.book_id
LEFT JOIN words_10w_time e
          ON a.book_id = e.book_id
LEFT JOIN words_15w_time f
          ON a.book_id = f.book_id
LEFT JOIN words_20w_time g
          ON a.book_id = g.book_id
LEFT JOIN words_25w_time h
          ON a.book_id = h.book_id
LEFT JOIN words_30w_time i
          ON a.book_id = i.book_id
LEFT JOIN words_35w_time j
          ON a.book_id = j.book_id;

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dws_content_book_submit_publish_stat_p_da
-- workflow_version : 32
-- create_user      : xixg
-- task_name        : dws_content_book_submit_publish_stat_p_da__dzw
-- task_version     : 12
-- update_time      : 2024-08-13 18:36:46
-- sql_path         : \starrocks\tbl_dws_content_book_submit_publish_stat_p_da\dws_content_book_submit_publish_stat_p_da__dzw
----------------------------------------------------------------
-- SQL语句
-- 定制文相关书籍统计
INSERT INTO dws.dws_content_book_submit_publish_stat_p_da
WITH dzw_total_chapter_tmp AS (
SELECT
         a.Id*1000+777 AS book_id,                                                                                      --书籍ID
         MAX(a.BookName) AS book_name,                                                                                  --书籍名称
         COUNT(DISTINCT c.Id) AS total_chapters                                                                         -- 书籍总章节数
FROM ods.ods_tidb_shuangwen_en_custombook a
LEFT JOIN ods.ods_tidb_shuangwen_en_customchapter c
  ON a.Id = c.BookId
 AND c.Status = 1                                                                                                       --章节为已发布
 AND c.DelStatus = 0                                                                                                    -- 章节状态为非删除
WHERE a.DelStatus  = 0                                                                                                  -- 书的状态为非删除
GROUP BY a.Id*1000+777
 ),

dzw_publish_chapter_tmp AS (
SELECT
        a.Id*1000+777 AS book_id,                                                                                       --书籍ID
        MAX(a.BookName) AS book_name,                                                                                   --书籍名称
        COUNT(DISTINCT c.Id) AS published_chapters,                                                                     -- 书籍已发布章节数
        SUM(c.FontLength) AS published_words                                                                            -- 书籍已发布字数
FROM ods.ods_tidb_shuangwen_en_custombook a
LEFT JOIN ods.ods_tidb_shuangwen_en_customchapter c
  ON a.Id = c.BookId
 AND c.DelStatus = 0     -- 章节状态为非删除
WHERE a.DelStatus  = 0                                                                                                  -- 书的状态为非删除
GROUP BY a.Id*1000+777
),

dzw_submit_chapter_tmp AS (
SELECT
         a.Id*1000+777 AS book_id,                                                                                      --书籍ID
         SUM(IF(DATEDIFF(NOW(),c.CreateTime) between 0 and 7,1,0)) AS submit_chapters_l7,                               -- 最近7天提交章节数
         SUM(IF(DATEDIFF(NOW(),c.CreateTime) between 0 and 7,c.FontLength,0)) AS submit_words_l7                        -- 最近7天提交字数
 FROM ods.ods_tidb_shuangwen_en_custombook a
 LEFT JOIN ods.ods_tidb_shuangwen_en_customchapter c
   ON a.Id = c.BookId
  AND c.DelStatus = 0     -- 章节状态为非删除
WHERE a.DelStatus  = 0                                                                                                  -- 书的状态为非删除
GROUP BY a.Id*1000+777
),

words_5w_tmp AS (
SELECT
        book_id,
        sort_id,
        publish_time
FROM (
        SELECT
                a.Id*1000+777 AS book_id,                                                                               --书籍ID
                c.CreateTime AS publish_time,
                b.Sort AS sort_id,
                SUM(b.FontLength) OVER (PARTITION BY a.Id ORDER BY c.CreateTime) AS published_words                     -- 书籍已发布字数
        FROM ods.ods_tidb_shuangwen_en_custombook a
        LEFT JOIN ods.ods_tidb_shuangwen_en_customchapter b
          ON a.Id = b.BookId
         AND b.DelStatus = 0     -- 章节状态为非删除
        LEFT JOIN ods.ods_tidb_shuangwen_en_CustomChapterLog_da c
         ON a.id = c.BookId
         AND b.Id = c.ChapterId
         AND c.LogType = 5
        WHERE a.DelStatus  = 0                                                                                                  -- 书的状态为非删除
        ORDER BY b.Sort
        ) d
WHERE d.published_words >=50000
ORDER BY sort_id
),

words_5w_time AS (
SELECT
        *
FROM  (
        SELECT
        book_id,
        publish_time,
        ROW_NUMBER() OVER (PARTITION BY book_id order by sort_id ) rank_num
        FROM words_5w_tmp
        ) d
WHERE rank_num = 1
),

words_10w_tmp AS (
SELECT
        book_id,
        sort_id,
        publish_time
FROM (
        SELECT
                a.Id*1000+777 AS book_id,                                                                               --书籍ID
                c.CreateTime AS publish_time,
                b.Sort AS sort_id,
                SUM(b.FontLength) OVER (PARTITION BY a.Id ORDER BY c.CreateTime) AS published_words                     -- 书籍已发布字数
        FROM ods.ods_tidb_shuangwen_en_custombook a
        LEFT JOIN ods.ods_tidb_shuangwen_en_customchapter b
          ON a.Id = b.BookId
         AND b.DelStatus = 0     -- 章节状态为非删除
        LEFT JOIN ods.ods_tidb_shuangwen_en_CustomChapterLog_da c
            ON a.id = c.BookId
            AND b.Id = c.ChapterId
            AND c.LogType = 5
        WHERE a.DelStatus  = 0                                                                                                  -- 书的状态为非删除
        ) d
WHERE d.published_words >=100000
ORDER BY sort_id
),

words_10w_time AS (
SELECT
        *
FROM  (
        SELECT
                book_id,
                publish_time,
                ROW_NUMBER() OVER (PARTITION BY book_id order by sort_id ) rank_num
        FROM words_10w_tmp
        ) d
WHERE rank_num = 1
),

words_15w_tmp AS (
SELECT
        book_id,
        sort_id,
        publish_time
FROM (
        SELECT
                a.Id*1000+777 AS book_id,                                                                               --书籍ID
                c.CreateTime AS publish_time,
                b.Sort AS sort_id,
                SUM(b.FontLength) OVER (PARTITION BY a.Id ORDER BY c.CreateTime) AS published_words                     -- 书籍已发布字数
        FROM ods.ods_tidb_shuangwen_en_custombook a
        LEFT JOIN ods.ods_tidb_shuangwen_en_customchapter b
         ON a.Id = b.BookId
         AND b.DelStatus = 0     -- 章节状态为非删除
        LEFT JOIN ods.ods_tidb_shuangwen_en_CustomChapterLog_da c
            ON a.id = c.BookId
            AND b.Id = c.ChapterId
            AND c.LogType = 5
        WHERE a.DelStatus  = 0                                                                                                  -- 书的状态为非删除
        ) d
WHERE d.published_words >=150000
ORDER BY sort_id
),

words_15w_time AS (
SELECT
        *
FROM  (
        SELECT
                book_id,
                publish_time,
                ROW_NUMBER() OVER (PARTITION BY book_id order by sort_id ) rank_num
        FROM words_15w_tmp
        ) d
WHERE rank_num = 1
),

words_20w_tmp AS (
SELECT
        book_id,
        sort_id,
        publish_time
FROM (
        SELECT
                a.Id*1000+777 AS book_id,                                                                               --书籍ID
                c.CreateTime AS publish_time,
                b.Sort AS sort_id,
                SUM(b.FontLength) OVER (PARTITION BY a.Id ORDER BY c.CreateTime) AS published_words                     -- 书籍已发布字数
        FROM ods.ods_tidb_shuangwen_en_custombook a
        LEFT JOIN ods.ods_tidb_shuangwen_en_customchapter b
         ON a.Id = b.BookId
         AND b.DelStatus = 0     -- 章节状态为非删除
        LEFT JOIN ods.ods_tidb_shuangwen_en_CustomChapterLog_da c
            ON a.id = c.BookId
            AND b.Id = c.ChapterId
            AND c.LogType = 5
        WHERE a.DelStatus  = 0                                                                                                  -- 书的状态为非删除
        ) d
WHERE d.published_words >=200000
ORDER BY sort_id
),

words_20w_time AS (
SELECT
        *
FROM  (
        SELECT
                book_id,
                publish_time,
                ROW_NUMBER() OVER (PARTITION BY book_id order by sort_id ) rank_num
        FROM words_20w_tmp
        ) d
WHERE rank_num = 1
),

words_25w_tmp AS (
SELECT
        book_id,
        sort_id,
        publish_time
FROM (
        SELECT
                a.Id*1000+777 AS book_id,                                                                               --书籍ID
                c.CreateTime AS publish_time,
                b.Sort AS sort_id,
                SUM(b.FontLength) OVER (PARTITION BY a.Id ORDER BY c.CreateTime) AS published_words                     -- 书籍已发布字数
        FROM ods.ods_tidb_shuangwen_en_custombook a
        LEFT JOIN ods.ods_tidb_shuangwen_en_customchapter b
          ON a.Id = b.BookId
         AND b.DelStatus = 0     -- 章节状态为非删除
        LEFT JOIN ods.ods_tidb_shuangwen_en_CustomChapterLog_da c
            ON a.id = c.BookId
            AND b.Id = c.ChapterId
            AND c.LogType = 5
        WHERE a.DelStatus  = 0                                                                                                  -- 书的状态为非删除
        ) d
WHERE d.published_words >=250000
ORDER BY sort_id
),

words_25w_time AS (
SELECT
        *
FROM  (
        SELECT
                book_id,
                publish_time,
                ROW_NUMBER() OVER (PARTITION BY book_id order by sort_id ) rank_num
        FROM words_25w_tmp
        ) d
WHERE rank_num = 1
),

words_30w_tmp AS (
SELECT
        book_id,
        sort_id,
        publish_time
FROM (
        SELECT
                a.Id*1000+777 AS book_id,                                                                               --书籍ID
                c.CreateTime AS publish_time,
                b.Sort AS sort_id,
                SUM(b.FontLength) OVER (PARTITION BY a.Id ORDER BY c.CreateTime) AS published_words                     -- 书籍已发布字数
        FROM ods.ods_tidb_shuangwen_en_custombook a
        LEFT JOIN ods.ods_tidb_shuangwen_en_customchapter b
          ON a.Id = b.BookId
         AND b.DelStatus = 0     -- 章节状态为非删除
        LEFT JOIN ods.ods_tidb_shuangwen_en_CustomChapterLog_da c
            ON a.id = c.BookId
            AND b.Id = c.ChapterId
            AND c.LogType = 5
        WHERE a.DelStatus  = 0                                                                                                  -- 书的状态为非删除
        ) d
WHERE d.published_words >=300000
ORDER BY sort_id
),

words_30w_time AS (
SELECT
        *
FROM  (
        SELECT
                book_id,
                publish_time,
                ROW_NUMBER() OVER (PARTITION BY book_id order by sort_id ) rank_num
        FROM words_30w_tmp
        ) d
WHERE rank_num = 1
),

words_35w_tmp AS (
SELECT
        book_id,
        sort_id,
        publish_time
FROM (
        SELECT
                a.Id*1000+777 AS book_id,                                                                               --书籍ID
                c.CreateTime AS publish_time,
                b.Sort AS sort_id,
                SUM(b.FontLength) OVER (PARTITION BY a.Id ORDER BY c.CreateTime) AS published_words                     -- 书籍已发布字数
        FROM ods.ods_tidb_shuangwen_en_custombook a
        LEFT JOIN ods.ods_tidb_shuangwen_en_customchapter b
          ON a.Id = b.BookId
         AND b.DelStatus = 0     -- 章节状态为非删除
        LEFT JOIN ods.ods_tidb_shuangwen_en_CustomChapterLog_da c
            ON a.id = c.BookId
            AND b.Id = c.ChapterId
            AND c.LogType = 5
        WHERE a.DelStatus  = 0                                                                                                  -- 书的状态为非删除
        ) d
WHERE d.published_words >=350000
ORDER BY sort_id
),

words_35w_time AS (
SELECT
        *
FROM  (
        SELECT
                book_id,
                publish_time,
                ROW_NUMBER() OVER (PARTITION BY book_id order by sort_id ) rank_num
        FROM words_35w_tmp
        ) d
WHERE rank_num = 1
)

SELECT
        DATE_FORMAT ('${bf_1_dt}', '%Y-%m-%d'),
        b.book_id,
        b.book_name,
        '',
        a.total_chapters AS total_chapters,
        0,
        0,
        b.published_chapters,
        b.published_words,
        c.submit_chapters_l7,
        c.submit_words_l7,
        d.publish_time AS published_5w_date,
        e.publish_time AS published_10w_date,
        f.publish_time AS published_15w_date,
        g.publish_time AS published_20w_date,
        h.publish_time AS published_25w_date,
        i.publish_time AS published_30w_date,
        j.publish_time AS published_35w_date,
        NOW()
FROM  dzw_total_chapter_tmp a
LEFT JOIN  dzw_publish_chapter_tmp b
  ON a.book_id = b.book_id
LEFT JOIN  dzw_submit_chapter_tmp c
  ON b.book_id = c.book_id
LEFT JOIN words_5w_time d
          ON a.book_id = d.book_id
LEFT JOIN words_10w_time e
          ON a.book_id = e.book_id
LEFT JOIN words_15w_time f
          ON a.book_id = f.book_id
LEFT JOIN words_20w_time g
          ON a.book_id = g.book_id
LEFT JOIN words_25w_time h
          ON a.book_id = h.book_id
LEFT JOIN words_30w_time i
          ON a.book_id = i.book_id
LEFT JOIN words_35w_time j
          ON a.book_id = j.book_id;

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dws_content_book_submit_publish_stat_p_da
-- workflow_version : 32
-- create_user      : xixg
-- task_name        : dws_content_book_submit_publish_stat_p_da__fmx
-- task_version     : 12
-- update_time      : 2024-08-08 20:21:59
-- sql_path         : \starrocks\tbl_dws_content_book_submit_publish_stat_p_da\dws_content_book_submit_publish_stat_p_da__fmx
----------------------------------------------------------------
-- SQL语句
-- 凤鸣轩相关书籍统计
INSERT INTO dws.dws_content_book_submit_publish_stat_p_da
WITH fmx_free_chapter_tmp AS (
    SELECT
        cast(concat(a.BookId , '090') as int) AS book_id,                                                              --书籍ID
        MAX(a.BookName) AS book_name,                                                                                  --书籍名称
        '' AS book_code,                                                                                               --书籍编码
        COUNT(DISTINCT ChapterId) AS free_chapters,                                                                    -- 书籍免费章节数
        SUM(c.FontLength) AS free_words                                                                                -- 书籍免费字数
    FROM ods.ods_mysql_Fmx_Book a
             LEFT JOIN ods.ods_mysql_Fmx_Chapter c
                       ON a.BookId = c.BookId
                           AND c.IsVip = 0         --章节为非VIP
                           AND c.DelStatus = 0     -- 章节状态为非删除
    WHERE  a.DelStatus  = 0                                                                                             -- 书的状态为非删除
    GROUP BY cast(concat(a.BookId , '090') as int)
),

     fmx_publish_chapter_tmp AS (
         SELECT
             cast(concat(a.BookId , '090') as int) AS book_id,                                                              --书籍ID
             COUNT(DISTINCT ChapterId) AS published_chapters,                                                               -- 书籍已发布章节数
             SUM(c.FontLength) AS published_words                                                                           -- 书籍已发布字数
         FROM ods.ods_mysql_Fmx_Book a
                  LEFT JOIN ods.ods_mysql_Fmx_Chapter c
                            ON a.BookId = c.BookId
                                AND c.Status = 2           --章节为已发布
                                AND c.DelStatus = 0        -- 章节状态为非删除
         WHERE  a.DelStatus  = 0                                                                                             -- 书的状态为非删除
         GROUP BY cast(concat(a.BookId , '090') as int)
     ),

     fmx_submit_chapter_tmp AS (
         SELECT
             cast(concat(a.BookId , '090') as int) AS book_id,                                                              --书籍ID
             SUM(IF(DATEDIFF(NOW(),c.CreateTime) between 0 and 7,1,0)) AS submit_chapters_l7,                               -- 最近7天提交章节数
             SUM(IF(DATEDIFF(NOW(),c.CreateTime) between 0 and 7,c.FontLength,0)) AS submit_words_l7                        -- 最近7天提交字数
         FROM ods.ods_mysql_Fmx_Book a
                  LEFT JOIN ods.ods_mysql_Fmx_Chapter c
                            ON a.BookId = c.BookId
                                AND c.DelStatus = 0     -- 章节状态为非删除
         WHERE  a.DelStatus  = 0                                                                                             -- 书的状态为非删除
         GROUP BY cast(concat(a.BookId , '090') as int)
     ),

     words_5w_tmp AS (
         SELECT
             book_id,
             publish_time
         FROM (
                  SELECT
                      CAST(CONCAT(a.BookId , '090') AS INT) AS book_id,                                                           --书籍ID
                      c.PublishTime AS publish_time,
                      SUM(c.FontLength) OVER (PARTITION BY a.BookId ORDER BY c.PublishTime) AS published_words                    -- 书籍已发布字数
                  FROM ods.ods_mysql_Fmx_Book a
                           LEFT JOIN ods.ods_mysql_Fmx_Chapter c
                                     ON a.BookId = c.BookId
                                         AND c.DelStatus = 0     -- 章节状态为非删除
                  WHERE  a.DelStatus  = 0                                                                                             -- 书的状态为非删除
              ) d
         WHERE d.published_words >=50000
     ),

     words_5w_time AS (
         SELECT
             *
         FROM  (
                   SELECT
                       book_id,
                       publish_time,
                       ROW_NUMBER() OVER (PARTITION BY book_id order by publish_time ) rank_num
                   FROM words_5w_tmp
               ) d
         WHERE rank_num = 1
     ),

     words_10w_tmp AS (
         SELECT
             book_id,
             publish_time
         FROM (
                  SELECT
                      CAST(CONCAT(a.BookId , '090') AS INT) AS book_id,                                                           --书籍ID
                      c.PublishTime AS publish_time,
                      SUM(c.FontLength) OVER (PARTITION BY a.BookId ORDER BY c.PublishTime) AS published_words                    -- 书籍已发布字数
                  FROM ods.ods_mysql_Fmx_Book a
                           LEFT JOIN ods.ods_mysql_Fmx_Chapter c
                                     ON a.BookId = c.BookId
                                         AND c.DelStatus = 0     -- 章节状态为非删除
                  WHERE  a.DelStatus  = 0                                                                                             -- 书的状态为非删除
              ) d
         WHERE d.published_words >=100000
     ),

     words_10w_time AS (
         SELECT
             *
         FROM  (
                   SELECT
                       book_id,
                       publish_time,
                       ROW_NUMBER() OVER (PARTITION BY book_id order by publish_time ) rank_num
                   FROM words_10w_tmp
               ) d
         WHERE rank_num = 1
     ),

     words_15w_tmp AS (
         SELECT
             book_id,
             publish_time
         FROM (
                  SELECT
                      CAST(CONCAT(a.BookId , '090') AS INT) AS book_id,                                                          --书籍ID
                      c.PublishTime AS publish_time,
                      SUM(c.FontLength) OVER (PARTITION BY a.BookId ORDER BY c.PublishTime) AS published_words                    -- 书籍已发布字数
                  FROM ods.ods_mysql_Fmx_Book a
                           LEFT JOIN ods.ods_mysql_Fmx_Chapter c
                                     ON a.BookId = c.BookId
                                         AND c.DelStatus = 0     -- 章节状态为非删除
                  WHERE  a.DelStatus  = 0                                                                                             -- 书的状态为非删除
              ) d
         WHERE d.published_words >=150000
     ),

     words_15w_time AS (
         SELECT
             *
         FROM  (
                   SELECT
                       book_id,
                       publish_time,
                       ROW_NUMBER() OVER (PARTITION BY book_id order by publish_time ) rank_num
                   FROM words_15w_tmp
               ) d
         WHERE rank_num = 1
     ),

     words_20w_tmp AS (
         SELECT
             book_id,
             publish_time
         FROM (
                  SELECT
                      CAST(CONCAT(a.BookId , '090') AS INT) AS book_id,                                                           --书籍ID
                      c.PublishTime AS publish_time,
                      SUM(c.FontLength) OVER (PARTITION BY a.BookId ORDER BY c.PublishTime) AS published_words                    -- 书籍已发布字数
                  FROM ods.ods_mysql_Fmx_Book a
                           LEFT JOIN ods.ods_mysql_Fmx_Chapter c
                                     ON a.BookId = c.BookId
                                         AND c.DelStatus = 0     -- 章节状态为非删除
                  WHERE  a.DelStatus  = 0                                                                                             -- 书的状态为非删除
              ) d
         WHERE d.published_words >=200000
     ),

     words_20w_time AS (
         SELECT
             *
         FROM  (
                   SELECT
                       book_id,
                       publish_time,
                       ROW_NUMBER() OVER (PARTITION BY book_id order by publish_time ) rank_num
                   FROM words_20w_tmp
               ) d
         WHERE rank_num = 1
     ),

     words_25w_tmp AS (
         SELECT
             book_id,
             publish_time
         FROM (
                  SELECT
                      CAST(CONCAT(a.BookId , '090') AS INT) AS book_id,                                                       --书籍ID
                      c.PublishTime AS publish_time,
                      SUM(c.FontLength) OVER (PARTITION BY a.BookId ORDER BY c.PublishTime) AS published_words                -- 书籍已发布字数
                  FROM ods.ods_mysql_Fmx_Book a
                           LEFT JOIN ods.ods_mysql_Fmx_Chapter c
                                     ON a.BookId = c.BookId
                                         AND c.DelStatus = 0     -- 章节状态为非删除
                  WHERE  a.DelStatus  = 0                                                                                             -- 书的状态为非删除
              ) d
         WHERE d.published_words >=250000
     ),

     words_25w_time AS (
         SELECT
             *
         FROM  (
                   SELECT
                       book_id,
                       publish_time,
                       ROW_NUMBER() OVER (PARTITION BY book_id order by publish_time ) rank_num
                   FROM words_25w_tmp
               ) d
         WHERE rank_num = 1
     ),

     words_30w_tmp AS (
         SELECT
             book_id,
             publish_time
         FROM (
                  SELECT
                      CAST(CONCAT(a.BookId , '090') AS INT) AS book_id,                                                       --书籍ID
                      c.PublishTime AS publish_time,
                      SUM(c.FontLength) OVER (PARTITION BY a.BookId ORDER BY c.PublishTime) AS published_words                -- 书籍已发布字数
                  FROM ods.ods_mysql_Fmx_Book a
                           LEFT JOIN ods.ods_mysql_Fmx_Chapter c
                                     ON a.BookId = c.BookId
                                         AND c.DelStatus = 0     -- 章节状态为非删除
                  WHERE  a.DelStatus  = 0                                                                                             -- 书的状态为非删除
              ) d
         WHERE d.published_words >=300000
     ),

     words_30w_time AS (
         SELECT
             *
         FROM  (
                   SELECT
                       book_id,
                       publish_time,
                       ROW_NUMBER() OVER (PARTITION BY book_id order by publish_time ) rank_num
                   FROM words_30w_tmp
               ) d
         WHERE rank_num = 1
     ),

     words_35w_tmp AS (
         SELECT
             book_id,
             publish_time
         FROM (
                  SELECT
                      CAST(CONCAT(a.BookId , '090') AS INT) AS book_id,                                                       --书籍ID
                      c.PublishTime AS publish_time,
                      SUM(c.FontLength) OVER (PARTITION BY a.BookId ORDER BY c.PublishTime) AS published_words                -- 书籍已发布字数
                  FROM ods.ods_mysql_Fmx_Book a
                           LEFT JOIN ods.ods_mysql_Fmx_Chapter c
                                     ON a.BookId = c.BookId
                                         AND c.DelStatus = 0     -- 章节状态为非删除
                  WHERE  a.DelStatus  = 0                                                                                             -- 书的状态为非删除
              ) d
         WHERE d.published_words >=350000
     ),

     words_35w_time AS (
         SELECT
             *
         FROM  (
                   SELECT
                       book_id,
                       publish_time,
                       ROW_NUMBER() OVER (PARTITION BY book_id order by publish_time ) rank_num
                   FROM words_35w_tmp
               ) d
         WHERE rank_num = 1
     )

SELECT
    DATE_FORMAT ('${bf_1_dt}', '%Y-%m-%d'),
    a.book_id,
    a.book_name,
    a.book_code,
    0 AS total_chapters,
    a.free_chapters,
    a.free_words,
    b.published_chapters,
    b.published_words,
    c.submit_chapters_l7,
    c.submit_words_l7,
    d.publish_time AS published_5w_date,
    e.publish_time AS published_10w_date,
    f.publish_time AS published_15w_date,
    g.publish_time AS published_20w_date,
    h.publish_time AS published_25w_date,
    i.publish_time AS published_30w_date,
    j.publish_time AS published_35w_date,
    NOW()
FROM fmx_free_chapter_tmp a
         LEFT JOIN  fmx_publish_chapter_tmp b
                    ON a.book_id = b.book_id
         LEFT JOIN  fmx_submit_chapter_tmp c
                    ON a.book_id = c.book_id
         LEFT JOIN words_5w_time d
                   ON a.book_id = d.book_id
         LEFT JOIN words_10w_time e
                   ON a.book_id = e.book_id
         LEFT JOIN words_15w_time f
                   ON a.book_id = f.book_id
         LEFT JOIN words_20w_time g
                   ON a.book_id = g.book_id
         LEFT JOIN words_25w_time h
                   ON a.book_id = h.book_id
         LEFT JOIN words_30w_time i
                   ON a.book_id = i.book_id
         LEFT JOIN words_35w_time j
                   ON a.book_id = j.book_id;

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dws_content_book_submit_publish_stat_p_da
-- workflow_version : 32
-- create_user      : xixg
-- task_name        : dws_content_book_submit_publish_stat_p_da__xzz
-- task_version     : 12
-- update_time      : 2024-08-08 20:26:55
-- sql_path         : \starrocks\tbl_dws_content_book_submit_publish_stat_p_da\dws_content_book_submit_publish_stat_p_da__xzz
----------------------------------------------------------------
-- SQL语句
-- 新掌中相关书籍统计
INSERT INTO dws.dws_content_book_submit_publish_stat_p_da
WITH xzz_chapter AS (
SELECT BookId,ChapterId,CreateTime,PublishTime,FontLength,IsVip,Status,DelStatus FROM ods.ods_mysql_zhangzhong_xzz_Chapter
UNION ALL
SELECT BookId,ChapterId,CreateTime,PublishTime,FontLength,IsVip,Status,DelStatus FROM ods.ods_mysql_zhangzhong_xzz_Chapter_090
),
-- 书籍提交发布相关统计
xzz_free_chapter_tmp AS (
SELECT
        a.BookId*1000+a.SiteId AS book_id,                                                                              --书籍ID
        MAX(a.BookName) AS book_name,                                                                                   --书籍名称
        MAX(a.BookCode) AS book_code,                                                                                   --书籍编码
        COUNT(DISTINCT ChapterId) AS free_chapters,                                                                     -- 书籍免费章节数
        SUM(c.FontLength) AS free_words                                                                                 -- 书籍免费字数
FROM ods.ods_mysql_zhangzhong_xzz_Book a
LEFT JOIN xzz_chapter c
  ON a.BookId = c.BookId
 AND c.IsVip = 0         --章节为非VIP
 AND c.DelStatus = 0     -- 章节状态为非删除
WHERE a.DelStatus  = 0                                                                                                  -- 书的状态为非删除
GROUP BY a.BookId*1000+a.SiteId
),

xzz_publish_chapter_tmp AS (
SELECT
        a.BookId*1000+a.SiteId AS book_id,                                                                              --书籍ID
        COUNT(DISTINCT ChapterId) AS published_chapters,                                                                -- 书籍已发布章节数
        SUM(c.FontLength) AS published_words                                                                            -- 书籍已发布字数
FROM ods.ods_mysql_zhangzhong_xzz_Book a
LEFT JOIN xzz_chapter c
  ON a.BookId = c.BookId
 AND c.Status = 2         --章节为已发布
 AND c.DelStatus = 0     -- 章节状态为非删除
WHERE a.DelStatus  = 0                                                                                                  -- 书的状态为非删除
GROUP BY a.BookId*1000+a.SiteId
),

xzz_submit_chapter_tmp AS (
SELECT
        a.BookId*1000+a.SiteId AS book_id,                                                                              --书籍ID
        SUM(IF(DATEDIFF(NOW(),c.CreateTime) between 0 and 7,1,0)) AS submit_chapters_l7,                                -- 最近7天提交章节数
        SUM(IF(DATEDIFF(NOW(),c.CreateTime) between 0 and 7,c.FontLength,0)) AS submit_words_l7                         -- 最近7天提交字数
FROM ods.ods_mysql_zhangzhong_xzz_Book a
LEFT JOIN xzz_chapter c
  ON a.BookId = c.BookId
 AND c.DelStatus = 0     -- 章节状态为非删除
WHERE a.DelStatus  = 0                                                                                                  -- 书的状态为非删除
GROUP BY a.BookId*1000+a.SiteId
),

words_5w_tmp AS (
SELECT
        book_id,
        publish_time
FROM (
        SELECT
            a.BookId*1000+a.SiteId AS book_id,                                                                          --书籍ID
            c.PublishTime AS publish_time,
            SUM(c.FontLength) OVER (PARTITION BY a.BookId ORDER BY c.PublishTime) AS published_words                    -- 书籍已发布字数
        FROM ods.ods_mysql_zhangzhong_xzz_Book a
        LEFT JOIN xzz_chapter c
               ON a.BookId = c.BookId
               AND c.Status = 2         --章节为已发布
               AND c.DelStatus = 0     -- 章节状态为非删除
        WHERE a.DelStatus  = 0                                                                                          -- 书的状态为非删除
        ) d
WHERE d.published_words >=50000
),

words_5w_time AS (
SELECT
    *
FROM  (
        SELECT
             book_id,
             publish_time,
             ROW_NUMBER() OVER (PARTITION BY book_id order by publish_time ) rank_num
         FROM words_5w_tmp
     ) d
 WHERE rank_num = 1
),

words_10w_tmp AS (
 SELECT
     book_id,
     publish_time
 FROM (
          SELECT
              a.BookId*1000+a.SiteId AS book_id,                                                  --书籍ID
              c.PublishTime AS publish_time,
              SUM(c.FontLength) OVER (PARTITION BY a.BookId ORDER BY c.PublishTime) AS published_words                                -- 书籍已发布字数
          FROM ods.ods_mysql_zhangzhong_xzz_Book a
                   LEFT JOIN xzz_chapter c
                             ON a.BookId = c.BookId
                                 AND c.Status = 2         --章节为已发布
                                 AND c.DelStatus = 0     -- 章节状态为非删除
        WHERE a.DelStatus  = 0                                                                                          -- 书的状态为非删除
      ) d
 WHERE d.published_words >=100000
),

words_10w_time AS (
 SELECT
     *
 FROM  (
           SELECT
               book_id,
               publish_time,
               ROW_NUMBER() OVER (PARTITION BY book_id order by publish_time ) rank_num
           FROM words_10w_tmp
       ) d
 WHERE rank_num = 1
),

words_15w_tmp AS (
 SELECT
     book_id,
     publish_time
 FROM (
          SELECT
              a.BookId*1000+a.SiteId AS book_id,                                                  --书籍ID
              c.PublishTime AS publish_time,
              SUM(c.FontLength) OVER (PARTITION BY a.BookId ORDER BY c.PublishTime) AS published_words                                -- 书籍已发布字数
          FROM ods.ods_mysql_zhangzhong_xzz_Book a
                   LEFT JOIN xzz_chapter c
                             ON a.BookId = c.BookId
                                 AND c.Status = 2         --章节为已发布
                                 AND c.DelStatus = 0     -- 章节状态为非删除
         WHERE a.DelStatus  = 0                                                                                          -- 书的状态为非删除
      ) d
 WHERE d.published_words >=150000
),

words_15w_time AS (
 SELECT
     *
 FROM  (
           SELECT
               book_id,
               publish_time,
               ROW_NUMBER() OVER (PARTITION BY book_id order by publish_time ) rank_num
           FROM words_15w_tmp
       ) d
 WHERE rank_num = 1
),

words_20w_tmp AS (
 SELECT
     book_id,
     publish_time
 FROM (
          SELECT
              a.BookId*1000+a.SiteId AS book_id,                                                  --书籍ID
              c.PublishTime AS publish_time,
              SUM(c.FontLength) OVER (PARTITION BY a.BookId ORDER BY c.PublishTime) AS published_words                                -- 书籍已发布字数
          FROM ods.ods_mysql_zhangzhong_xzz_Book a
                   LEFT JOIN xzz_chapter c
                             ON a.BookId = c.BookId
                                 AND c.Status = 2         --章节为已发布
                                 AND c.DelStatus = 0     -- 章节状态为非删除
         WHERE a.DelStatus  = 0                                                                                          -- 书的状态为非删除
      ) d
 WHERE d.published_words >=200000
),

words_20w_time AS (
 SELECT
     *
 FROM  (
           SELECT
               book_id,
               publish_time,
               ROW_NUMBER() OVER (PARTITION BY book_id order by publish_time ) rank_num
           FROM words_20w_tmp
       ) d
 WHERE rank_num = 1
),

words_25w_tmp AS (
 SELECT
     book_id,
     publish_time
 FROM (
          SELECT
              a.BookId*1000+a.SiteId AS book_id,                                                  --书籍ID
              c.PublishTime AS publish_time,
              SUM(c.FontLength) OVER (PARTITION BY a.BookId ORDER BY c.PublishTime) AS published_words                                -- 书籍已发布字数
          FROM ods.ods_mysql_zhangzhong_xzz_Book a
                   LEFT JOIN xzz_chapter c
                             ON a.BookId = c.BookId
                                 AND c.Status = 2         --章节为已发布
                                 AND c.DelStatus = 0     -- 章节状态为非删除
        WHERE a.DelStatus  = 0                                                                                          -- 书的状态为非删除
      ) d
 WHERE d.published_words >=250000
),

words_25w_time AS (
 SELECT
     *
 FROM  (
           SELECT
               book_id,
               publish_time,
               ROW_NUMBER() OVER (PARTITION BY book_id order by publish_time ) rank_num
           FROM words_25w_tmp
       ) d
 WHERE rank_num = 1
),

words_30w_tmp AS (
 SELECT
     book_id,
     publish_time
 FROM (
          SELECT
              a.BookId*1000+a.SiteId AS book_id,                                                  --书籍ID
              c.PublishTime AS publish_time,
              SUM(c.FontLength) OVER (PARTITION BY a.BookId ORDER BY c.PublishTime) AS published_words                                -- 书籍已发布字数
          FROM ods.ods_mysql_zhangzhong_xzz_Book a
                   LEFT JOIN xzz_chapter c
                             ON a.BookId = c.BookId
                                 AND c.Status = 2         --章节为已发布
                                 AND c.DelStatus = 0     -- 章节状态为非删除
        WHERE a.DelStatus  = 0                                                                                          -- 书的状态为非删除
      ) d
 WHERE d.published_words >=300000
),

words_30w_time AS (
 SELECT
     *
 FROM  (
           SELECT
               book_id,
               publish_time,
               ROW_NUMBER() OVER (PARTITION BY book_id order by publish_time ) rank_num
           FROM words_30w_tmp
       ) d
 WHERE rank_num = 1
),

words_35w_tmp AS (
 SELECT
     book_id,
     publish_time
 FROM (
          SELECT
              a.BookId*1000+a.SiteId AS book_id,                                                  --书籍ID
              c.PublishTime AS publish_time,
              SUM(c.FontLength) OVER (PARTITION BY a.BookId ORDER BY c.PublishTime) AS published_words                                -- 书籍已发布字数
          FROM ods.ods_mysql_zhangzhong_xzz_Book a
                   LEFT JOIN xzz_chapter c
                             ON a.BookId = c.BookId
                                 AND c.Status = 2         --章节为已发布
                                 AND c.DelStatus = 0     -- 章节状态为非删除
         WHERE a.DelStatus  = 0                                                                                          -- 书的状态为非删除
      ) d
 WHERE d.published_words >=350000
),

words_35w_time AS (
 SELECT
     *
 FROM  (
           SELECT
               book_id,
               publish_time,
               ROW_NUMBER() OVER (PARTITION BY book_id order by publish_time ) rank_num
           FROM words_35w_tmp
       ) d
 WHERE rank_num = 1
)
SELECT
        DATE_FORMAT ('${bf_1_dt}', '%Y-%m-%d'),
        a.book_id,
        a.book_name,
        a.book_code,
        0 AS total_chapters,
        a.free_chapters,
        a.free_words,
        b.published_chapters,
        b.published_words,
        c.submit_chapters_l7,
        c.submit_words_l7,
        d.publish_time AS published_5w_date,
        e.publish_time AS published_10w_date,
        f.publish_time AS published_15w_date,
        g.publish_time AS published_20w_date,
        h.publish_time AS published_25w_date,
        i.publish_time AS published_30w_date,
        j.publish_time AS published_35w_date,
        NOW()
FROM xzz_free_chapter_tmp a
LEFT JOIN  xzz_publish_chapter_tmp b
  ON a.book_id = b.book_id
LEFT JOIN  xzz_submit_chapter_tmp c
  ON a.book_id = c.book_id
LEFT JOIN words_5w_time d
          ON a.book_id = d.book_id
LEFT JOIN words_10w_time e
          ON a.book_id = e.book_id
LEFT JOIN words_15w_time f
          ON a.book_id = f.book_id
LEFT JOIN words_20w_time g
          ON a.book_id = g.book_id
LEFT JOIN words_25w_time h
          ON a.book_id = h.book_id
LEFT JOIN words_30w_time i
          ON a.book_id = i.book_id
LEFT JOIN words_35w_time j
          ON a.book_id = j.book_id;
