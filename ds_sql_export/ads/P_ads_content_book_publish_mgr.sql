----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_content_book_publish_mgr
-- workflow_version : 71
-- create_user      : xixg
-- task_name        : ads_content_book_puslish_mgr__dzw
-- task_version     : 27
-- update_time      : 2025-06-30 17:45:20
-- sql_path         : \starrocks\tbl_ads_content_book_publish_mgr\ads_content_book_puslish_mgr__dzw
----------------------------------------------------------------
-- SQL语句
INSERT INTO ads.ads_content_book_publish_mgr
-- 定制文 书籍统计
SELECT
    '${bf_1_dt}' AS dt,
    a.Id*1000+777 AS book_id,                                                   --书籍ID
    a.BookName AS book_name,                                                    --书籍名称
    a.BookCode AS book_code,                                                    --书籍编码
    CASE SUBSTR(a.BookCode, 1, 1)
        WHEN 'J' THEN '简体'                                                      --J系统的书只有简体中文
        ELSE '繁体'
        END AS language_name,                                                       --书籍语言
    l.book_id,
    l.book_name AS source_book_name,                                            --源书籍名称
    '简体' AS source_language_name,                                               --源书籍语言
    CASE SUBSTR(a.BookCode, 1, 1)
        WHEN 'A' THEN '凤鸣轩'
        WHEN 'R' THEN '精修编辑部'
        WHEN 'L' THEN '精修编辑部'
        WHEN 'N' THEN '福州编辑部'
        WHEN 'J' THEN '版权引入'
        ELSE ''
        END belong_to_dept,                                                     --归属部门
    a.AuthorName,                                                               --作者
    c.total_chapters,                                                           --书籍总章节数
    a.FontLength,                                                               --书籍总字数
    a.FreeChapterNums,                                                          -- 书籍免费章节数
    c.free_words,                                                               -- 书籍免费字数
    c.published_chapters,                                                       --书籍已发布章节数
    c.published_words ,                                                         --书籍已发布字数
    CONCAT('每日常规章节', j.start_num),                                           -- 书籍日更配置
    CASE i.real_time_score
        WHEN 1 THEN 'S'
        WHEN 2 THEN 'A'
        WHEN 3 THEN 'B'
        WHEN 4 THEN 'C'
        ELSE '未评级'
        END AS book_curr_score,                                                     -- 书籍当前评级
    i.real_time_score_time,                                                     -- 实时评级时间
    CASE SUBSTR(a.BookCode, 1, 1)
        WHEN 'J' THEN f.StartTime                                               --J系列书籍则取外采表的开始时间
        ELSE a.CreateTime
        END AS cooperate_date,                                                  --合作日期  取创建日期
    -- a.CreateTime,                                                               --合作日期  取创建日期
    CASE Status
        WHEN 0 THEN '未上架'
        WHEN 1 THEN '上架'
        ELSE ''
        END AS putaway_status,                                                  --上加状态
    a.CreateTime AS putaway_date,                                               --上架日期  取创建日期
    a.ChapterUpdateTime AS submit_latest_date,                                  -- 最近一次提交日期
    ROUND(c.submit_chapters_l7/7,4) AS submit_chapters_l7_avg,                  -- 最近7天日均提交章节数
    ROUND(c.submit_words_l7/7,4) AS submit_words_l7_avg,                        --最近7天日均提交字数
    CASE a.UpdateType
        WHEN 0 THEN '连载'
        WHEN 1 THEN '停更'
        WHEN 2 THEN '完本'
        ELSE ''
        END AS finish_status,                                                   -- 连载状态
    CASE SUBSTR(a.BookCode, 1, 1)
        WHEN 'R' THEN '自研'
        WHEN 'L' THEN '自研'
        WHEN 'N' THEN '自研'
        WHEN 'J' THEN '买断'
        ELSE ''
        END AS collaborate_model,                                               -- 合作模式
    a.FinalAudit AS editor,                                                     -- 责任编辑  取统稿审核人
    CASE WHEN e.cost_amt>0 THEN '是'
         ELSE '否'
        END if_tf,                                                              -- 是否已投放
    c.published_5w_date AS published_5w_date,                               --发布5W字日期
    c.published_10w_date AS published_10w_date,                               --发布10W字日期
    c.published_15w_date AS published_15w_date,                               --发布15W字日期
    c.published_20w_date AS published_20w_date,                               --发布20W字日期
    c.published_25w_date AS published_25w_date,                               --发布25W字日期
    c.published_30w_date AS published_30w_date,                               --发布30W字日期
    c.published_35w_date AS published_35w_date,                               --发布35W字日期
    NOW()
FROM ods.ods_tidb_shuangwen_en_custombook a
         LEFT JOIN dws.dws_content_book_submit_publish_stat_p_da c
                   ON a.Id*1000+777 = c.book_id
                       AND c.dt = '${bf_1_dt}'
         LEFT JOIN dim.dim_novel_book_info_view d
                   ON a.Id*1000+777 = d.book_id
         LEFT JOIN (SELECT  book_id ,sum(cost_amt) AS cost_amt FROM dws.dws_advertisement_book_cost_amt_cst_ed GROUP BY book_id) e
                   ON a.Id*1000+777 = e.book_id
         LEFT JOIN ods.ods_tidb_shuangwen_en_TranslateExternalBook f
                   ON a.Id = f.BookId
         LEFT JOIN (
    SELECT  *  FROM (
                        SELECT
                            BookId AS book_id,
                            RealTimeScore AS real_time_score,
                            RealTimeScoreTime AS real_time_score_time,
                            ROW_NUMBER() OVER (PARTITION BY BookId ORDER BY  RealTimeScore) AS rank_num
                        FROM  ods.ods_tidb_readernovel_tidb_tag_center_book
                        WHERE RealTimeScore != 0
                    ) a
    WHERE  a.rank_num = 1
      AND real_time_score IS NOT NULL
) i
                   ON a.Id*1000+777 = i.book_id
         LEFT JOIN (
    SELECT
        book_id,
        start_num
    FROM (
             SELECT
                 BookId AS book_id,
                 StartNum AS start_num,
                 ROW_NUMBER() OVER (PARTITION BY BookId ORDER BY  EnableTime DESC) AS rank_num                                --取启用时间最近的一条记录
             FROM ods.ods_tidb_shuangwen_en_customchapterplus
         ) a
    WHERE a.rank_num = 1
) j
                   ON a.Id = j.book_id
         LEFT JOIN (
    SELECT
        book_id,
        book_code,
        book_name
    FROM
        (
            SELECT
                book_id,
                book_code,
                book_name,
                ROW_NUMBER() OVER (PARTITION BY book_code ORDER BY yt) rank_num                         --取评级最大的那个
            from dim.dim_shuangwen_book_read_consume_info a
            WHERE book_code != '-'
        ) a
    WHERE a.rank_num = 1
) l
                   ON a.BookCode = l.book_code;

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_content_book_publish_mgr
-- workflow_version : 71
-- create_user      : xixg
-- task_name        : ads_content_book_puslish_mgr__fmx
-- task_version     : 20
-- update_time      : 2025-06-30 17:45:20
-- sql_path         : \starrocks\tbl_ads_content_book_publish_mgr\ads_content_book_puslish_mgr__fmx
----------------------------------------------------------------
-- SQL语句
-- 凤鸣轩 书籍统计
    INSERT INTO ads.ads_content_book_publish_mgr
SELECT
    '${bf_1_dt}' AS dt,
    cast(concat(a.BookId , '090') as int) AS book_id,                           --书籍ID
    b.book_name AS book_name,                                                   --书籍名称
    b.book_code AS book_code,                                                   --书籍编码
    '繁体' AS language_name,                                                     --书籍语言
    l.book_id,
    l.book_name AS source_book_name,                                            --源书籍名称
    '简体' AS source_language_name,                                              --源书籍语言
    CASE SUBSTR(b.book_code, 1, 1)
        WHEN 'A' THEN '凤鸣轩'
        WHEN 'P' THEN '内容编辑部'
        ELSE ''
        END belong_to_dept,                                                     --归属部门
    f.PenName,                                                                  --作者
    a.ChapterNum,                                                               --书籍总章节数
    a.FontLength,                                                               --书籍总字数
    c.free_chapters,                                                            -- 书籍免费章节数
    c.free_words,                                                                -- 书籍免费字数
    b.normal_chapter_num_f,                                                     --书籍已发布章节数
    b.public_fontlength ,                                                       --书籍已发布字数
    CONCAT( k.PublishChapterNum - j.PublishChapterNum,
            '章  共 ',
            ROUND((k.PublishLength - j.PublishLength)/1000,1),
            'k单词') AS book_daily_conf,                                        --书籍日更配置
    CASE i.real_time_score
        WHEN 1 THEN 'S'
        WHEN 2 THEN 'A'
        WHEN 3 THEN 'B'
        WHEN 4 THEN 'C'
        ELSE '未评级'
        END AS book_curr_score,                                                     -- 书籍当前评级
    i.real_time_score_time,                                                     -- 实时评级时间
    '',                                                                         --合作日期  跟后端确认，没有这个字段
    CASE a.IsSyncSexy
        WHEN 0 THEN '上架'
        WHEN 1 THEN '上架'
        ELSE ''
        END AS putaway_status,                                                  --上加状态
    d.build_time AS putaway_date,                                               --上架日期
    a.LastUpdateTime AS submit_latest_date,                                     -- 最近一次提交日期
    ROUND(c.submit_chapters_l7/7,4) AS submit_chapters_l7_avg,                  -- 最近7天日均提交章节数
    ROUND(c.submit_words_l7/7,4) AS submit_words_l7_avg,                        --最近7天日均提交字数
    CASE a.IsFull
        WHEN 0 THEN '未完本'
        WHEN 1 THEN '已完本'
        ELSE ''
        END AS finish_status,                                                   -- 连载状态
    CASE
        WHEN a.SignType =0 THEN '买断'
        WHEN a.SignType =1 THEN 'A签'
        WHEN a.SignType =2 THEN 'B签'
        WHEN a.SignType =4 THEN '保底分成'
        WHEN a.SignType =5 THEN '新保底分成'
        ELSE ''
        END AS collaborate_model,                                               -- 合作模式
    '' AS editor,                                                               -- 责任编辑   跟需求人陈星确认凤鸣轩书没有责任编辑，所以字段为空
    CASE WHEN e.cost_amt>0 THEN '是'
         ELSE '否'
        END if_tf,                                                              -- 是否已投放
    c.published_5w_date AS published_5w_date,                               --发布5W字日期
    c.published_10w_date AS published_10w_date,                               --发布10W字日期
    c.published_15w_date AS published_15w_date,                               --发布15W字日期
    c.published_20w_date AS published_20w_date,                               --发布20W字日期
    c.published_25w_date AS published_25w_date,                               --发布25W字日期
    c.published_30w_date AS published_30w_date,                               --发布30W字日期
    c.published_35w_date AS published_35w_date,                               --发布35W字日期
    NOW()
FROM ods.ods_mysql_Fmx_Book a
         LEFT JOIN dim.dim_shuangwen_book_read_consume_info b
                   ON cast(concat(a.BookId , '090') as int) = b.book_id
         LEFT JOIN dws.dws_content_book_submit_publish_stat_p_da c
                   ON cast(concat(a.BookId , '090') as int) = c.book_id
                       AND c.dt = '${bf_1_dt}'
         LEFT JOIN dim.dim_novel_book_info_view d
                   ON cast(concat(a.BookId , '090') as int) = d.book_id
         LEFT JOIN (SELECT  book_id ,sum(cost_amt) AS cost_amt FROM dws.dws_advertisement_book_cost_amt_cst_ed GROUP BY book_id) e
                   ON cast(concat(a.BookId , '090') as int) = e.book_id
         LEFT JOIN ods.ods_tidb_Fmx_Author f
                   ON a.AuthorId = f.AccountId
         LEFT JOIN (
    SELECT  *  FROM (
                        SELECT
                            BookId AS book_id,
                            RealTimeScore AS real_time_score,
                            RealTimeScoreTime AS real_time_score_time,
                            ROW_NUMBER() OVER (PARTITION BY BookId ORDER BY  RealTimeScore) AS rank_num         --取评级最大的那个
                        FROM  ods.ods_tidb_readernovel_tidb_tag_center_book
                        WHERE RealTimeScore != 0
                    ) a
    WHERE  a.rank_num = 1
      AND real_time_score IS NOT NULL
) i
                   ON cast(concat(a.BookId , '090') as int) = i.book_id
         LEFT JOIN ods.ods_tidb_ad_sharpengine_bi_if_date_books j
                   ON cast(concat(a.BookId , '090') as int) = j.bookid
                       AND j.datekey = '${bf_2_dt}'
         LEFT JOIN ods.ods_tidb_ad_sharpengine_bi_if_date_books k
                   ON cast(concat(a.BookId , '090') as int) = k.bookid
                       AND k.datekey = '${bf_1_dt}'
         LEFT JOIN (
    SELECT
        book_id,
        book_code,
        book_name
    FROM
        (
            SELECT
                book_id,
                book_code,
                book_name,
                ROW_NUMBER() OVER (PARTITION BY book_code ORDER BY yt) rank_num
            from dim.dim_shuangwen_book_read_consume_info a
            WHERE book_code != '-'
        ) a
    WHERE a.rank_num = 1
) l
ON b.book_code = l.book_code;

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_content_book_publish_mgr
-- workflow_version : 71
-- create_user      : xixg
-- task_name        : ads_content_book_puslish_mgr__xzz
-- task_version     : 21
-- update_time      : 2025-06-30 17:45:20
-- sql_path         : \starrocks\tbl_ads_content_book_publish_mgr\ads_content_book_puslish_mgr__xzz
----------------------------------------------------------------
-- SQL语句
-- 凤鸣轩的书会迁移到新学中  所以上面先计算凤鸣轩的书，然后再计算新掌中的书插入最新数据覆盖
-- 新掌中 书籍统计
    INSERT INTO ads.ads_content_book_publish_mgr
SELECT
    '${bf_1_dt}' AS dt,
    a.BookId*1000+a.SiteId AS book_id,                                      --书籍ID
    b.book_name AS book_name,                                               --书籍名称
    a.BookCode AS book_code,                                                --书籍编码
    '繁体' AS language_name,                                                 --书籍语言
    l.book_id,
    l.book_name AS source_book_name,                                        --源书籍名称
    '简体' AS source_language_name,                                          --源书籍语言
    CASE SUBSTR(a.BookCode, 1, 1)
        WHEN 'A' THEN '凤鸣轩'
        WHEN 'P' THEN '内容编辑部'
        ELSE ''
        END belong_to_dept,                                                     --归属部门
    f.PenName,                                                              --作者
    a.ChapterNum,                                                           --书籍总章节数
    a.FontLength,                                                           --书籍总字数
    c.free_chapters,                                                        -- 书籍免费章节数
    c.free_words,                                                           -- 书籍免费字数
    b.normal_chapter_num_f,                                                 --书籍已发布章节数
    b.public_fontlength ,                                                   --书籍已发布字数
    CONCAT( k.PublishChapterNum - j.PublishChapterNum,
            '章  共 ',
            ROUND((k.PublishLength - j.PublishLength)/1000,1),
            'k单词') AS book_daily_conf,                                      --书籍日更配置
    CASE i.real_time_score
        WHEN 1 THEN 'S'
        WHEN 2 THEN 'A'
        WHEN 3 THEN 'B'
        WHEN 4 THEN 'C'
        ELSE '未评级'
        END AS book_curr_score,                                                 -- 书籍当前评级
    i.real_time_score_time,                                                 -- 实时评级时间
    a.SignTime,                                                             --合作日期
    CASE a.IsPutdown
        WHEN 0 THEN '下架'
        WHEN 1 THEN '上架'
        ELSE ''
        END AS putaway_status,                                                  --上加状态
    d.build_time AS putaway_date,                                           --上架日期   关联novel_book
    a.UpdateTime AS submit_latest_date,                                     -- 最近一次提交日期
    ROUND(c.submit_chapters_l7/7,4) AS submit_chapters_l7_avg,              -- 最近7天日均提交章节数
    ROUND(c.submit_words_l7/7,4) AS submit_words_l7_avg,                    --最近7天日均提交字数
    CASE a.IsFull
        WHEN 0 THEN '未完本'
        WHEN 1 THEN '已完本'
        ELSE ''
        END AS finish_status,                                                   -- 连载状态
    CASE
        WHEN a.SignType =-1 THEN '未签约'
        WHEN a.SignType =0 THEN '买断'
        WHEN a.SignType =1 THEN '分成'
        WHEN a.SignType =4 THEN '未签约'
        WHEN a.SignType =5 AND a.CpMode = 0  THEN '保底'
        WHEN a.SignType =5 AND a.CpMode = 1  THEN '分成'
        ELSE ''
        END AS collaborate_model,                                               -- 合作模式
    h.EditorName AS editor,                                                 -- 责任编辑
    CASE WHEN e.cost_amt>0 THEN '是'
         ELSE '否'
        END if_tf,                                                              -- 是否已投放
    c.published_5w_date AS published_5w_date,                               --发布5W字日期
    c.published_10w_date AS published_10w_date,                               --发布10W字日期
    c.published_15w_date AS published_15w_date,                               --发布15W字日期
    c.published_20w_date AS published_20w_date,                               --发布20W字日期
    c.published_25w_date AS published_25w_date,                               --发布25W字日期
    c.published_30w_date AS published_30w_date,                               --发布30W字日期
    c.published_35w_date AS published_35w_date,                               --发布35W字日期
    NOW()
FROM ods.ods_mysql_zhangzhong_xzz_Book a
         LEFT JOIN dim.dim_shuangwen_book_read_consume_info b
                   ON a.BookId*1000+a.SiteId = b.book_id
         LEFT JOIN dws.dws_content_book_submit_publish_stat_p_da c
                   ON a.BookId*1000+a.SiteId = c.book_id
                       AND c.dt = '${bf_1_dt}'
         LEFT JOIN dim.dim_novel_book_info_view d
                   ON a.BookId*1000+a.SiteId = d.book_id
         LEFT JOIN (SELECT  book_id ,sum(cost_amt) AS cost_amt FROM dws.dws_advertisement_book_cost_amt_cst_ed GROUP BY book_id) e
                   ON a.BookId*1000+a.SiteId = e.book_id
         LEFT JOIN ods.ods_mysql_zhangzhong_xzz_Author f
                   ON a.AuthorId = f.AccountId
         LEFT JOIN ods.ods_mysql_zhangzhong_xzz_BookEditorRight g
                   ON a.BookId = g.BookId
         LEFT JOIN ods.ods_mysql_zhangzhong_xzz_AuthorEditorRole h
                   ON g.UserId = h.UserId
         LEFT JOIN (
    SELECT  *  FROM (
                        SELECT
                            BookId AS book_id,
                            RealTimeScore AS real_time_score,
                            RealTimeScoreTime AS real_time_score_time,
                            ROW_NUMBER() OVER (PARTITION BY BookId ORDER BY  RealTimeScore) AS rank_num        --取评级最大的那个
                        FROM  ods.ods_tidb_readernovel_tidb_tag_center_book
                        WHERE RealTimeScore != 0
                    ) a
    WHERE  a.rank_num = 1
      AND real_time_score IS NOT NULL
) i
                   ON a.BookId*1000+a.SiteId = i.book_id
         LEFT JOIN ods.ods_tidb_ad_sharpengine_bi_if_date_books j
                   ON a.BookId*1000+a.SiteId = j.bookid
                       AND j.datekey = '${bf_2_dt}'
         LEFT JOIN ods.ods_tidb_ad_sharpengine_bi_if_date_books k
                   ON a.BookId*1000+a.SiteId = k.bookid
                       AND k.datekey = '${bf_1_dt}'
         LEFT JOIN (
    SELECT
        book_id,
        book_code,
        book_name
    FROM
        (
            SELECT
                book_id,
                book_code,
                book_name,
                ROW_NUMBER() OVER (PARTITION BY book_code ORDER BY yt) rank_num
            from dim.dim_shuangwen_book_read_consume_info a
            WHERE book_code != '-'
        ) a
    WHERE a.rank_num = 1
) l
                   ON a.BookCode = l.book_code;

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_content_book_publish_mgr
-- workflow_version : 71
-- create_user      : xixg
-- task_name        : ads_content_book_puslish_mgr_dyy
-- task_version     : 42
-- update_time      : 2025-09-26 11:32:02
-- sql_path         : \starrocks\tbl_ads_content_book_publish_mgr\ads_content_book_puslish_mgr_dyy
----------------------------------------------------------------
-- SQL语句
INSERT INTO ads.ads_content_book_publish_mgr
WITH tmp_bookeditorright AS (
    select
        ProductId,
        BookId,
        UserId,
        language
from ods.ods_tidb_shuangwen_xx_bookeditorright
where  EditorType = 0 and InUse = 1
group by ProductId,BookId,UserId,language
),
tmp_authoreditorrole AS (
select
    ProductId,
    UserId,
    Language,
    RealName
from ods.ods_tidb_shuangwen_en_authoreditorrole
where EditorType=0 and status = 0
group by ProductId,UserId,Language,RealName
),
tmp_author_data AS (
select
    a.ProductId,
    a.BookId,
    a.UserId,
    a.language,
    b.RealName
from tmp_bookeditorright a
    left join tmp_authoreditorrole b
ON  a.ProductId = b.ProductId
    AND a.UserId = b.UserId
    AND a.language = b.Language
),
tmp_booknature AS (
select COALESCE( dic_booknature.enum_name ,t1.book_nature) as book_nature,
    t1.languageid,
    t1.book_id
from dim.dim_shuangwen_book_read_consume_info  t1
    left join dim.dim_dic  dic_booknature  -- 书籍来源
on t1.book_nature = dic_booknature.enum_id
    and dic_booknature.table_name = 'dim_shuangwen_book_read_consume_info'
    and dic_booknature.dic_column = 'book_nature'
)
-- 多语言 书籍统计
SELECT
    '${bf_1_dt}' AS dt,
    a.BookId*1000 + a.SiteId AS book_id,                                            -- 书籍ID
    a.BookName AS book_name,
    CASE WHEN a.BookCode IS NULL THEN b.book_code
         WHEN a.BookCode='' THEN  b.book_code
         ELSE a.BookCode
        END AS book_code,                                                               -- 书籍编码
    case a.SiteId
        when 90 then '繁体（凤鸣轩）'
        when 446 then '繁体（复制书籍）'
        when 450 then '繁体（cp繁体）'
        when 449 then '海剧简体'
        else replace(h.ProductTypeName, '阅读', '')
    end AS language_name, -- 书籍语言
    f.from_book_id,
    f.from_book_name AS source_book_name,                                       -- 源书籍名称
    CASE f.from_language
        WHEN 445 THEN '菲律宾语'
        WHEN 333 THEN '繁体'
        WHEN 322 THEN '英语'
        WHEN 375 THEN '西语'
        WHEN 409 THEN '葡语'
        WHEN 410 THEN '法语'
        WHEN 418 THEN '俄语'
        WHEN 419 THEN '日语'
        WHEN 414 THEN '印尼语'
        WHEN 433 THEN '泰语'
        WHEN 436 THEN '韩语'
        WHEN 412 THEN '德语'
        WHEN 0 THEN '简体'                                                   -- 0表示中文简体
        ELSE ''
        END  AS source_language_name,                                           -- 源书籍语言
    CASE l.book_nature
        WHEN 'cp' THEN 'CP'
        WHEN 'cp翻译' THEN '翻译'
        WHEN '翻译拆章' THEN '翻译'
        WHEN '机翻' THEN '翻译'
        WHEN '人工' THEN '翻译'
        WHEN '原创' THEN '原创'
        WHEN '原创拆章' THEN '原创'
        WHEN '原创图书' THEN '原创'
        ELSE  '其它'
        END belong_to_dept,                                                     -- 归属部门
    m.PenName AS author_name,                                                                     -- 作者  跟陈星确认多语言书作者为空
    a.ChapterNum,                                                           -- 书籍总章节数
    a.FontLength,                                                           -- 书籍总字数
    a.FreeChapterNum,                                                       -- 书籍免费章节数
    c.free_words,                                                           -- 书籍免费字数
    b.normal_chapter_num_f,                                                 -- 书籍已发布章节数
    b.public_fontlength ,                                                   -- 书籍已发布字数
    ''AS  book_daily_conf,                                                  -- 书籍日更配置
    CASE i.real_time_score
        WHEN 1 THEN 'S'
        WHEN 2 THEN 'A'
        WHEN 3 THEN 'B'
        WHEN 4 THEN 'C'
        ELSE '未评级'
        END AS book_curr_score,                                                 -- 书籍当前评级
    i.real_time_score_time,                                                 -- 实时书籍评级时间
    CASE l.book_nature
        WHEN '原创' THEN a.ContractStartTime
        WHEN '原创拆章' THEN a.ContractStartTime
        WHEN '原创图书' THEN a.ContractStartTime
        ELSE   a.CreateTime
    END
    AS cooperate_date,                                                           -- 合作日期  取创建日期
    CASE a.IsPutdown
        WHEN 0 THEN '下架'
        WHEN 1 THEN '上架'
        ELSE ''
        END AS putaway_status,                                              -- 上加状态
    IFNULL(j.publish_time,g.build_time) AS putaway_date,                    -- 上架日期
    a.UpdateTime AS submit_latest_date,                                     -- 最近一次提交日期  ods_edit_book_RemunerationDetail  dwd_trade_author_translate_remuneration
    ROUND(c.submit_chapters_l7/7,4) AS submit_chapters_l7_avg,              -- 最近7天日均提交章节数
    ROUND(c.submit_words_l7/7,4) AS submit_words_l7_avg,                    -- 最近7天日均提交字数
    CASE a.IsFull
        WHEN 0 THEN '未完本'
        WHEN 1 THEN '已完本'
        ELSE ''
        END AS finish_status,                                               -- 连载状态
    CASE a.SignType
        WHEN 0 THEN '独家'
        WHEN 1 THEN '独家'
        WHEN 2 THEN '非独家'
        WHEN 3 THEN '解约'
        WHEN -1 THEN '未签约'
        END  AS collaborate_model,                                                -- 合作模式  待确认这个字段对于原创团队是否有作用
    k.RealName AS editor,                                               -- 责任编辑
    CASE WHEN e.cost_amt>0 THEN '是'
         ELSE '否'
        END if_tf,                                                          -- 是否已投放
    IFNULL(d.published_5w_date,c.published_5w_date) AS published_5w_date,                                     -- 发布5W字日期
    IFNULL(d.published_10w_date,c.published_10w_date) AS published_10w_date,                                   -- 发布10W字日期
    IFNULL(d.published_15w_date,c.published_15w_date) AS published_15w_date,                                   -- 发布15W字日期
    IFNULL(d.published_20w_date,c.published_20w_date) AS published_20w_date,                                   -- 发布20W字日期
    IFNULL(d.published_25w_date,c.published_25w_date) AS published_25w_date,                                   -- 发布25W字日期
    IFNULL(d.published_30w_date,c.published_30w_date) AS published_30w_date,                                   -- 发布30W字日期
    IFNULL(d.published_35w_date,c.published_35w_date) AS published_35w_date,                                   -- 发布35W字日期
    NOW()
FROM ods.ods_edit_book a
         LEFT JOIN dim.dim_shuangwen_book_read_consume_info b
                   ON a.BookId*1000 + a.SiteId = b.book_id
         LEFT JOIN dws.dws_content_book_submit_publish_stat_p_da c
                   ON a.BookId*1000 + a.SiteId = c.book_id
                       AND c.dt = '${bf_1_dt}'
         LEFT JOIN dws.dws_content_book_translate_words_stat_p_da d
                   ON a.BookId*1000 + a.SiteId = d.book_id
         LEFT JOIN (SELECT  book_id ,sum(cost_amt) AS cost_amt FROM dws.dws_advertisement_book_cost_amt_cst_ed GROUP BY book_id) e
                   ON a.BookId*1000 + a.SiteId = e.book_id
         LEFT JOIN dwd.dwd_edit_book_languagebooktotal_da f
                   ON a.BookId*1000 + a.SiteId = f.to_book_id
                       AND f.dt = '${bf_1_dt}'
         LEFT JOIN dim.dim_novel_book_info_view g
                   ON a.BookId*1000 + a.SiteId = g.book_id
         LEFT JOIN tmp_author_data k
                   ON a.productid = k.ProductId
                       and  a.BookId = k.BookId
                       AND a.Language = k.language
         LEFT JOIN tmp_booknature l
                   ON a.BookId*1000 + a.SiteId = l.book_id
                       AND a.Language = l.languageid
         LEFT JOIN ods.ods_edit_author m
                   ON a.productid = m.productid
                       AND a.AuthorId = m .AccountId
         LEFT JOIN (
    SELECT  *  FROM (
                        SELECT
                            BookId AS book_id,
                            RealTimeScore AS real_time_score,
                            RealTimeScoreTime AS real_time_score_time,
                            ROW_NUMBER() OVER (PARTITION BY BookId ORDER BY  RealTimeScore) AS rank_num         -- 取评级最大的那个
                        FROM  ods.ods_tidb_readernovel_tidb_tag_center_book
                        WHERE RealTimeScore != 0
                    ) a
    WHERE  a.rank_num = 1
      AND real_time_score IS NOT NULL
) i
                   ON a.BookId*1000+a.SiteId = i.book_id
         LEFT JOIN ads.ads_report_book_capacity_rate_stat j
                   ON a.BookId*1000 + a.SiteId = j.book_id
                       AND j.dt = '${bf_1_dt}'
left join dim.DIM_ProductType h
on a.SiteId = h.book_langid;
