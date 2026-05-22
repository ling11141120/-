----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_content_book_plevel_capacity_p_da
-- workflow_version : 48
-- create_user      : xixg
-- task_name        : ads_content_book_plevel_capacity_p_da__P0
-- task_version     : 31
-- update_time      : 2025-07-18 14:17:34
-- sql_path         : \starrocks\tbl_ads_content_book_plevel_capacity_p_da\ads_content_book_plevel_capacity_p_da__P0
----------------------------------------------------------------
-- 前置SQL语句
delete from ads.ads_content_book_plevel_capacity_p_da WHERE  dt = '${bf_1_dt}';

-- SQL语句
-- 打P0标签的书
INSERT INTO ads.ads_content_book_plevel_capacity_p_da
-- 最近60天进过三阶的书
WITH stage3_before_60d AS (
    SELECT  book_id,language_id
    FROM
        (SELECT
             CodeId AS book_id,
             CurrentLanguage AS language_id,
             ROW_NUMBER () OVER (PARTITION BY CodeId ORDER BY SourceChl ASC, BeginDate DESC) AS rank_num                   -- 一本书可能近60天多次进3队，取最近的一条数据
         FROM ods.ods_tidb_ad_sharpengine_ads_global_MarketingPlan
         WHERE CodeStage = 3                                                                                -- 进过3阶
           AND IsDel != 1  AND (SourceChl = 'fb'  or  SourceChl = 'tt')
           AND DATEDIFF('${bf_1_dt}', BeginDate) <= 60                                                    -- 近60天进过3阶
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

-- 打P0标签的书
SELECT
    '${bf_1_dt}' AS dt,
    a.book_id,
    a.to_book_name,
    a.book_code,
    'P0'  AS  plevel,
    CASE a.site_id
        WHEN 445 THEN '菲律宾语'
        WHEN 333 THEN '繁体'
        WHEN 322 THEN '英语'
        WHEN 375 THEN '西语'
        WHEN 409 THEN '葡语'
        WHEN 410 THEN '法语'
        WHEN 412 THEN '德语'
        WHEN 413 THEN '意大利语'
        WHEN 415 THEN '阿拉伯语'
        WHEN 418 THEN '俄语'
        WHEN 419 THEN '日语'
        WHEN 414 THEN '印尼语'
        WHEN 433 THEN '泰语'
        WHEN 435 THEN '越南语'
        WHEN 436 THEN '韩语'
        WHEN 445 THEN '菲律宾语'
        WHEN 497 THEN '土耳其语'
        ELSE ''
        END  AS language_name,                                                                                  --书籍语言
    CASE WHEN IFNULL(f.proofreadLength,0)-IFNULL(e.proofreadLength,0) < 0 THEN 0
        ELSE IFNULL(f.proofreadLength,0)-IFNULL(e.proofreadLength,0)
    END AS today_proofread_words,                                                                               --今日精修字数
    CASE WHEN IFNULL(h.amount_YTD,0)-IFNULL(g.amount_YTD,0) < 0 THEN 0
        ELSE IFNULL(h.amount_YTD,0)-IFNULL(g.amount_YTD,0)
    END AS today_income,                                                                                        --今日收入
    a.font_length_curmonth AS currmonth_proofread_words,                                                        --本月精修字数
    a.amount_curmon AS currmonth_income,                                                                        --本月收入
    NOW()
FROM ads.ads_report_book_capacity_rate_stat a
INNER JOIN p0_book_id_tmp p0
  ON a.book_id = p0.book_id
 AND a.dt = '${bf_1_dt}'
  AND a.font_length_curmonth > 0                                                                          -- 本月精修字数大于0
LEFT JOIN ods.ods_tidb_shuangwen_en_bookcapacitymonitoring e
  ON a.book_id = e.ToBookId * 1000 + e.ToLanguage
    AND e.dt = '${bf_2_dt}'
LEFT JOIN ods.ods_tidb_shuangwen_en_bookcapacitymonitoring f
    ON a.book_id = f.ToBookId * 1000 + f.ToLanguage
    AND f.dt = '${bf_1_dt}'
LEFT JOIN ads.`ads_report_cost_income` g
    ON a.book_id = g.book_id
    AND g.dt = '${bf_2_dt}'
LEFT JOIN ads.`ads_report_cost_income` h
    ON a.book_id = h.book_id
    AND h.dt = '${bf_1_dt}';

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_content_book_plevel_capacity_p_da
-- workflow_version : 48
-- create_user      : xixg
-- task_name        : ads_content_book_plevel_capacity_p_da__P0_3zt
-- task_version     : 20
-- update_time      : 2025-07-18 10:53:04
-- sql_path         : \starrocks\tbl_ads_content_book_plevel_capacity_p_da\ads_content_book_plevel_capacity_p_da__P0_3zt
----------------------------------------------------------------
-- SQL语句
-- 打P0-三阶在投书
INSERT INTO ads.ads_content_book_plevel_capacity_p_da
-- 每本书最新的一条记录
WITH latest_book AS (
    SELECT  book_id,language_id,code_stage
    FROM (
            SELECT
                    CodeId AS book_id,
                    CurrentLanguage AS language_id,
                    CodeStage AS code_stage,
                    ROW_NUMBER () OVER (PARTITION BY CodeId ORDER BY SourceChl ASC, BeginDate DESC) AS rank_num        -- 一本书可能近60天多次进3队，取最近的一条数据
             FROM ods.ods_tidb_ad_sharpengine_ads_global_MarketingPlan
             WHERE IsDel != 1  AND (SourceChl = 'fb'  or  SourceChl = 'tt')
    ) a
    WHERE a.rank_num = 1
)
  SELECT
      '${bf_1_dt}' AS dt,
      a.book_id,
      a.to_book_name,
      a.book_code,
      'P0-三阶在投'  AS  plevel,
      CASE a.site_id
          WHEN 445 THEN '菲律宾语'
          WHEN 333 THEN '繁体'
          WHEN 322 THEN '英语'
          WHEN 375 THEN '西语'
          WHEN 409 THEN '葡语'
          WHEN 410 THEN '法语'
          WHEN 412 THEN '德语'
          WHEN 413 THEN '意大利语'
          WHEN 415 THEN '阿拉伯语'
          WHEN 418 THEN '俄语'
          WHEN 419 THEN '日语'
          WHEN 414 THEN '印尼语'
          WHEN 433 THEN '泰语'
          WHEN 435 THEN '越南语'
          WHEN 436 THEN '韩语'
          WHEN 445 THEN '菲律宾语'
          WHEN 497 THEN '土耳其语'
          ELSE ''
          END  AS language_name,                                                                      --书籍语言
      CASE WHEN IFNULL(f.proofreadLength,0)-IFNULL(e.proofreadLength,0) < 0 THEN 0
           ELSE IFNULL(f.proofreadLength,0)-IFNULL(e.proofreadLength,0)
          END AS today_proofread_words,                                                                               --今日精修字数
      CASE WHEN IFNULL(h.amount_YTD,0)-IFNULL(g.amount_YTD,0) < 0 THEN 0
           ELSE IFNULL(h.amount_YTD,0)-IFNULL(g.amount_YTD,0)
          END AS today_income,                                                                                        --今日收入
      a.font_length_curmonth AS currmonth_proofread_words,                                              --本月精修字数
      a.amount_curmon AS currmonth_income,                                                              --本月收入
      NOW()
 FROM ads.ads_report_book_capacity_rate_stat a
INNER JOIN latest_book b
   ON a.book_id = b.book_id
 AND a.dt = '${bf_1_dt}'
 AND a.font_length_curmonth > 0                                                                         -- 本月精修字数大于0
 AND b.code_stage = 3                                                                                   -- 阶段为第三阶段
 AND a.book_id not in (SELECT book_id FROM ads.ads_content_book_plevel_capacity_p_da WHERE dt = '${bf_1_dt}')
LEFT JOIN ods.ods_tidb_shuangwen_en_bookcapacitymonitoring e
          ON a.book_id = e.ToBookId * 1000 + e.ToLanguage
              AND e.dt = '${bf_2_dt}'
LEFT JOIN ods.ods_tidb_shuangwen_en_bookcapacitymonitoring f
          ON a.book_id = f.ToBookId * 1000 + f.ToLanguage
              AND f.dt = '${bf_1_dt}'
LEFT JOIN ads.`ads_report_cost_income` g
          ON a.book_id = g.book_id
              AND g.dt = '${bf_2_dt}'
LEFT JOIN ads.`ads_report_cost_income` h
          ON a.book_id = h.book_id
              AND h.dt = '${bf_1_dt}';

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_content_book_plevel_capacity_p_da
-- workflow_version : 48
-- create_user      : xixg
-- task_name        : ads_content_book_plevel_capacity_p_da__P1
-- task_version     : 19
-- update_time      : 2025-07-18 14:17:34
-- sql_path         : \starrocks\tbl_ads_content_book_plevel_capacity_p_da\ads_content_book_plevel_capacity_p_da__P1
----------------------------------------------------------------
-- SQL语句
-- 打P1标签书
     INSERT INTO ads.ads_content_book_plevel_capacity_p_da
  WITH book_id_tmp AS (
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
      WHEN a.site_id = 412 AND a.publish_length < 250000 THEN book_id   -- 德语
      WHEN a.site_id = 445 AND a.publish_length < 250000 THEN book_id   -- 菲律宾语
      WHEN a.site_id = 435 AND a.publish_length < 250000 THEN book_id   -- 越南语
      WHEN a.site_id = 419 AND a.publish_length < 250000 THEN book_id   -- 日语
      WHEN a.site_id = 497 AND a.publish_length < 200000 THEN book_id   -- 土耳其语
      ELSE 'NULL'
      END AS book_id
      FROM ads.ads_report_book_capacity_rate_stat a
      WHERE a.dt = '${bf_1_dt}'
      AND a.book_id not in (SELECT book_id FROM ads.ads_content_book_plevel_capacity_p_da WHERE dt = '${bf_1_dt}')
      )

SELECT
    '${bf_1_dt}' AS dt,
    a.book_id,
    a.to_book_name,
    a.book_code,
    'P1'  AS  plevel,
    CASE a.site_id
        WHEN 445 THEN '菲律宾语'
        WHEN 333 THEN '繁体'
        WHEN 322 THEN '英语'
        WHEN 375 THEN '西语'
        WHEN 409 THEN '葡语'
        WHEN 410 THEN '法语'
        WHEN 412 THEN '德语'
        WHEN 413 THEN '意大利语'
        WHEN 415 THEN '阿拉伯语'
        WHEN 418 THEN '俄语'
        WHEN 419 THEN '日语'
        WHEN 414 THEN '印尼语'
        WHEN 433 THEN '泰语'
        WHEN 435 THEN '越南语'
        WHEN 436 THEN '韩语'
        WHEN 445 THEN '菲律宾语'
        WHEN 497 THEN '土耳其语'
        ELSE ''
        END  AS language_name,                                                                          --书籍语言
    CASE WHEN IFNULL(f.proofreadLength,0)-IFNULL(e.proofreadLength,0) < 0 THEN 0
         ELSE IFNULL(f.proofreadLength,0)-IFNULL(e.proofreadLength,0)
        END AS today_proofread_words,                                                                               --今日精修字数
    CASE WHEN IFNULL(h.amount_YTD,0)-IFNULL(g.amount_YTD,0) < 0 THEN 0
         ELSE IFNULL(h.amount_YTD,0)-IFNULL(g.amount_YTD,0)
        END AS today_income,                                                                                        --今日收入
    a.font_length_curmonth AS currmonth_proofread_words,                                                --本月精修字数
    a.amount_curmon AS currmonth_income,                                                                --本月收入
    NOW()
FROM ads.ads_report_book_capacity_rate_stat a
         INNER JOIN (SELECT book_id FROM book_id_tmp WHERE book_id != 'NULL') b
                    ON a.book_id = b.book_id
                        AND a.dt = '${bf_1_dt}'
                        AND a.font_length_curmonth > 0                                                                       -- 本月精修字数大于0
         LEFT JOIN ods.ods_tidb_shuangwen_en_bookcapacitymonitoring e
                   ON a.book_id = e.ToBookId * 1000 + e.ToLanguage
                       AND e.dt = '${bf_2_dt}'
         LEFT JOIN ods.ods_tidb_shuangwen_en_bookcapacitymonitoring f
                   ON a.book_id = f.ToBookId * 1000 + f.ToLanguage
                       AND f.dt = '${bf_1_dt}'
         LEFT JOIN ads.`ads_report_cost_income` g
                   ON a.book_id = g.book_id
                       AND g.dt = '${bf_2_dt}'
         LEFT JOIN ads.`ads_report_cost_income` h
                   ON a.book_id = h.book_id
                       AND h.dt = '${bf_1_dt}';

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_content_book_plevel_capacity_p_da
-- workflow_version : 48
-- create_user      : xixg
-- task_name        : ads_content_book_plevel_capacity_p_da__P1tfz
-- task_version     : 20
-- update_time      : 2025-07-18 10:53:04
-- sql_path         : \starrocks\tbl_ads_content_book_plevel_capacity_p_da\ads_content_book_plevel_capacity_p_da__P1tfz
----------------------------------------------------------------
-- SQL语句
-- 打P1-投放中
INSERT INTO ads.ads_content_book_plevel_capacity_p_da
WITH book_id_tmp AS (
    SELECT
    CASE
        WHEN a.publish_length < 500000 THEN book_id
        ELSE 'NULL'
    END AS book_id
    FROM ads.ads_report_book_capacity_rate_stat a
    WHERE a.dt = '${bf_1_dt}'
    AND a.book_id not in (SELECT book_id FROM ads.ads_content_book_plevel_capacity_p_da WHERE dt = '${bf_1_dt}')
    AND DATEDIFF('${bf_1_dt}', publish_time) <= 90                                                            --近3个朋上架
    ),

latest_book AS (
    SELECT
            book_id,
            language_id,
            code_stage,
            begin_date,
            end_date
    FROM(
        SELECT
                CodeId AS book_id,
                CurrentLanguage AS language_id,
                CodeStage AS code_stage,
                BeginDate AS begin_date,
                EndDate AS end_date,
                ROW_NUMBER () OVER (PARTITION BY CodeId ORDER BY SourceChl ASC, BeginDate DESC) AS rank_num                -- 一本书可能近60天多次进3队，取最近的一条数据
        FROM ods.ods_tidb_ad_sharpengine_ads_global_MarketingPlan
        WHERE IsDel != 1  AND (SourceChl = 'fb'  or  SourceChl = 'tt')

    ) a
    WHERE a.rank_num = 1
)

SELECT
    '${bf_1_dt}' AS dt,
    a.book_id,
    a.to_book_name,
    a.book_code,
    'P1-投放中'  AS  plevel,
    CASE a.site_id
        WHEN 445 THEN '菲律宾语'
        WHEN 333 THEN '繁体'
        WHEN 322 THEN '英语'
        WHEN 375 THEN '西语'
        WHEN 409 THEN '葡语'
        WHEN 410 THEN '法语'
        WHEN 412 THEN '德语'
        WHEN 413 THEN '意大利语'
        WHEN 415 THEN '阿拉伯语'
        WHEN 418 THEN '俄语'
        WHEN 419 THEN '日语'
        WHEN 414 THEN '印尼语'
        WHEN 433 THEN '泰语'
        WHEN 435 THEN '越南语'
        WHEN 436 THEN '韩语'
        WHEN 445 THEN '菲律宾语'
        WHEN 497 THEN '土耳其语'
        ELSE ''
        END  AS language_name,                                                                               --书籍语言
    CASE WHEN IFNULL(f.proofreadLength,0)-IFNULL(e.proofreadLength,0) < 0 THEN 0
         ELSE IFNULL(f.proofreadLength,0)-IFNULL(e.proofreadLength,0)
        END AS today_proofread_words,                                                                               --今日精修字数
    CASE WHEN IFNULL(h.amount_YTD,0)-IFNULL(g.amount_YTD,0) < 0 THEN 0
         ELSE IFNULL(h.amount_YTD,0)-IFNULL(g.amount_YTD,0)
        END AS today_income,                                                                                        --今日收入
    a.font_length_curmonth AS currmonth_proofread_words,                                                    --本月精修字数
    a.amount_curmon AS currmonth_income,                                                                    --本月收入
    NOW()
FROM ads.ads_report_book_capacity_rate_stat a
INNER JOIN latest_book b
  ON a.book_id = b.book_id
 AND b.code_stage !=-1                                                                                      -- 阶段不等于禁投
 AND DATE_FORMAT (b.begin_date, '%Y-%m') = DATE_FORMAT('${bf_1_dt}', '%Y-%m')                             -- 开始时间等于当前月
 AND b.end_date > '${bf_1_dt}'                                                                            --测试结束时间小于当前系统时间
INNER JOIN (SELECT book_id FROM book_id_tmp WHERE book_id != 'NULL') bb
  ON a.book_id = bb.book_id
 AND a.dt = '${bf_1_dt}'
 AND a.font_length_curmonth > 0                                                                             -- 本月精修字数大于0
LEFT JOIN ods.ods_tidb_shuangwen_en_bookcapacitymonitoring e
          ON a.book_id = e.ToBookId * 1000 + e.ToLanguage
              AND e.dt = '${bf_2_dt}'
LEFT JOIN ods.ods_tidb_shuangwen_en_bookcapacitymonitoring f
          ON a.book_id = f.ToBookId * 1000 + f.ToLanguage
              AND f.dt = '${bf_1_dt}'
LEFT JOIN ads.`ads_report_cost_income` g
          ON a.book_id = g.book_id
              AND g.dt = '${bf_2_dt}'
LEFT JOIN ads.`ads_report_cost_income` h
          ON a.book_id = h.book_id
              AND h.dt = '${bf_1_dt}';

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_content_book_plevel_capacity_p_da
-- workflow_version : 48
-- create_user      : xixg
-- task_name        : ads_content_book_plevel_capacity_p_da__P2
-- task_version     : 18
-- update_time      : 2025-07-18 10:53:04
-- sql_path         : \starrocks\tbl_ads_content_book_plevel_capacity_p_da\ads_content_book_plevel_capacity_p_da__P2
----------------------------------------------------------------
-- SQL语句
-- 打P2
INSERT INTO ads.ads_content_book_plevel_capacity_p_da
SELECT
    '${bf_1_dt}' AS dt,
    a.book_id,
    a.to_book_name,
    a.book_code,
    'P2'  AS  plevel,
    CASE a.site_id
        WHEN 445 THEN '菲律宾语'
        WHEN 333 THEN '繁体'
        WHEN 322 THEN '英语'
        WHEN 375 THEN '西语'
        WHEN 409 THEN '葡语'
        WHEN 410 THEN '法语'
        WHEN 412 THEN '德语'
        WHEN 413 THEN '意大利语'
        WHEN 415 THEN '阿拉伯语'
        WHEN 418 THEN '俄语'
        WHEN 419 THEN '日语'
        WHEN 414 THEN '印尼语'
        WHEN 433 THEN '泰语'
        WHEN 435 THEN '越南语'
        WHEN 436 THEN '韩语'
        WHEN 445 THEN '菲律宾语'
        WHEN 497 THEN '土耳其语'
        ELSE ''
        END  AS language_name,                                                                              --书籍语言
    CASE WHEN IFNULL(f.proofreadLength,0)-IFNULL(e.proofreadLength,0) < 0 THEN 0
         ELSE IFNULL(f.proofreadLength,0)-IFNULL(e.proofreadLength,0)
        END AS today_proofread_words,                                                                               --今日精修字数
    CASE WHEN IFNULL(h.amount_YTD,0)-IFNULL(g.amount_YTD,0) < 0 THEN 0
         ELSE IFNULL(h.amount_YTD,0)-IFNULL(g.amount_YTD,0)
        END AS today_income,                                                                                        --今日收入
    a.font_length_curmonth AS currmonth_proofread_words,                                                    --本月精修字数
    a.amount_curmon AS currmonth_income,                                                                    --本月收入
    NOW()
FROM ads.ads_report_book_capacity_rate_stat a
INNER JOIN ads.ads_content_translate_remuneration_plan_p_da b
 ON a.book_id = b.target_book_id
 AND a.dt = '${bf_1_dt}'
  AND a.font_length_curmonth > 0                                                                            -- 本月精修字数大于0
  AND b.dt = '${bf_1_dt}'
  AND b.chapters_l20_publish_l7d > 10000                                                                        -- chapters_l20_publish_l7d 字段>1w的书
  AND a.book_id not in (SELECT book_id FROM ads.ads_content_book_plevel_capacity_p_da WHERE dt = '${bf_1_dt}')
LEFT JOIN ods.ods_tidb_shuangwen_en_bookcapacitymonitoring e
  ON a.book_id = e.ToBookId * 1000 + e.ToLanguage
    AND e.dt = '${bf_2_dt}'
LEFT JOIN ods.ods_tidb_shuangwen_en_bookcapacitymonitoring f
    ON a.book_id = f.ToBookId * 1000 + f.ToLanguage
    AND f.dt = '${bf_1_dt}'
LEFT JOIN ads.`ads_report_cost_income` g
    ON a.book_id = g.book_id
    AND g.dt = '${bf_2_dt}'
LEFT JOIN ads.`ads_report_cost_income` h
    ON a.book_id = h.book_id
    AND h.dt = '${bf_1_dt}';

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_content_book_plevel_capacity_p_da
-- workflow_version : 48
-- create_user      : xixg
-- task_name        : ads_content_book_plevel_capacity_p_da__P2tfz
-- task_version     : 20
-- update_time      : 2025-07-18 10:53:04
-- sql_path         : \starrocks\tbl_ads_content_book_plevel_capacity_p_da\ads_content_book_plevel_capacity_p_da__P2tfz
----------------------------------------------------------------
-- SQL语句
-- 打P2-投放中
INSERT INTO ads.ads_content_book_plevel_capacity_p_da
WITH book_id_tmp AS (
    SELECT
            book_id AS book_id
    FROM ads.ads_report_book_capacity_rate_stat a
    WHERE a.dt = '${bf_1_dt}'
    AND a.book_id not in (SELECT book_id FROM ads.ads_content_book_plevel_capacity_p_da WHERE dt = '${bf_1_dt}')
    AND DATEDIFF('${bf_1_dt}', publish_time) > 90                                                            --近3个朋上架
),

latest_book AS (
    SELECT
        book_id,
        language_id,
        code_stage,
        begin_date,
        end_date
    FROM(
        SELECT
                CodeId AS book_id,
                CurrentLanguage AS language_id,
                CodeStage AS code_stage,
                BeginDate AS begin_date,
                EndDate AS end_date,
                ROW_NUMBER () OVER (PARTITION BY CodeId ORDER BY SourceChl ASC, BeginDate DESC) AS rank_num                -- 一本书可能近60天多次进3队，取最近的一条数据
        FROM ods.ods_tidb_ad_sharpengine_ads_global_MarketingPlan
       WHERE IsDel != 1  AND (SourceChl = 'fb'  or  SourceChl = 'tt')

        ) a
    WHERE a.rank_num = 1
)

SELECT
    '${bf_1_dt}' AS dt,
    a.book_id,
    a.to_book_name,
    a.book_code,
    'P2-投放中'  AS  plevel,
    CASE a.site_id
        WHEN 445 THEN '菲律宾语'
        WHEN 333 THEN '繁体'
        WHEN 322 THEN '英语'
        WHEN 375 THEN '西语'
        WHEN 409 THEN '葡语'
        WHEN 410 THEN '法语'
        WHEN 412 THEN '德语'
        WHEN 413 THEN '意大利语'
        WHEN 415 THEN '阿拉伯语'
        WHEN 418 THEN '俄语'
        WHEN 419 THEN '日语'
        WHEN 414 THEN '印尼语'
        WHEN 433 THEN '泰语'
        WHEN 435 THEN '越南语'
        WHEN 436 THEN '韩语'
        WHEN 445 THEN '菲律宾语'
        WHEN 497 THEN '土耳其语'
        ELSE ''
        END  AS language_name,                                                                              --书籍语言
    CASE WHEN IFNULL(f.proofreadLength,0)-IFNULL(e.proofreadLength,0) < 0 THEN 0
         ELSE IFNULL(f.proofreadLength,0)-IFNULL(e.proofreadLength,0)
        END AS today_proofread_words,                                                                               --今日精修字数
    CASE WHEN IFNULL(h.amount_YTD,0)-IFNULL(g.amount_YTD,0) < 0 THEN 0
         ELSE IFNULL(h.amount_YTD,0)-IFNULL(g.amount_YTD,0)
        END AS today_income,                                                                                        --今日收入
    a.font_length_curmonth AS currmonth_proofread_words,                                                    --本月精修字数
    a.amount_curmon AS currmonth_income,                                                                    --本月收入
    NOW()
 FROM ads.ads_report_book_capacity_rate_stat a
INNER JOIN latest_book b
   ON a.book_id = b.book_id
  AND b.code_stage !=-1                                                                                     -- 阶段不等于禁投
  AND DATE_FORMAT (b.begin_date, '%Y-%m') = DATE_FORMAT('${bf_1_dt}', '%Y-%m')                            -- 开始时间等于当前月
  AND b.end_date > '${bf_1_dt}'                                                                           --测试结束时间小于当前系统时间
INNER JOIN (SELECT book_id FROM book_id_tmp WHERE book_id != 'NULL') c
   ON a.book_id = c.book_id
  AND a.dt = '${bf_1_dt}'
 AND a.font_length_curmonth > 0                                                                         -- 本月精修字数大于0
LEFT JOIN ods.ods_tidb_shuangwen_en_bookcapacitymonitoring e
          ON a.book_id = e.ToBookId * 1000 + e.ToLanguage
              AND e.dt = '${bf_2_dt}'
LEFT JOIN ods.ods_tidb_shuangwen_en_bookcapacitymonitoring f
          ON a.book_id = f.ToBookId * 1000 + f.ToLanguage
              AND f.dt = '${bf_1_dt}'
LEFT JOIN ads.`ads_report_cost_income` g
          ON a.book_id = g.book_id
              AND g.dt = '${bf_2_dt}'
LEFT JOIN ads.`ads_report_cost_income` h
          ON a.book_id = h.book_id
              AND h.dt = '${bf_1_dt}';

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_content_book_plevel_capacity_p_da
-- workflow_version : 48
-- create_user      : xixg
-- task_name        : ads_content_book_plevel_capacity_p_da__qt
-- task_version     : 15
-- update_time      : 2025-07-18 10:53:04
-- sql_path         : \starrocks\tbl_ads_content_book_plevel_capacity_p_da\ads_content_book_plevel_capacity_p_da__qt
----------------------------------------------------------------
-- SQL语句
-- 打其它标签
INSERT INTO ads.ads_content_book_plevel_capacity_p_da
SELECT
    '${bf_1_dt}' AS dt,
    a.book_id,
    a.to_book_name,
    a.book_code,
    '其它'  AS  plevel,
    CASE a.site_id
        WHEN 445 THEN '菲律宾语'
        WHEN 333 THEN '繁体'
        WHEN 322 THEN '英语'
        WHEN 375 THEN '西语'
        WHEN 409 THEN '葡语'
        WHEN 410 THEN '法语'
        WHEN 412 THEN '德语'
        WHEN 413 THEN '意大利语'
        WHEN 415 THEN '阿拉伯语'
        WHEN 418 THEN '俄语'
        WHEN 419 THEN '日语'
        WHEN 414 THEN '印尼语'
        WHEN 433 THEN '泰语'
        WHEN 435 THEN '越南语'
        WHEN 436 THEN '韩语'
        WHEN 445 THEN '菲律宾语'
        WHEN 497 THEN '土耳其语'
        ELSE ''
        END  AS language_name,                                                                               --书籍语言
    CASE WHEN IFNULL(f.proofreadLength,0)-IFNULL(e.proofreadLength,0) < 0 THEN 0
         ELSE IFNULL(f.proofreadLength,0)-IFNULL(e.proofreadLength,0)
        END AS today_proofread_words,                                                                               --今日精修字数
    CASE WHEN IFNULL(h.amount_YTD,0)-IFNULL(g.amount_YTD,0) < 0 THEN 0
         ELSE IFNULL(h.amount_YTD,0)-IFNULL(g.amount_YTD,0)
        END AS today_income,                                                                                        --今日收入
    a.font_length_curmonth AS currmonth_proofread_words,                                                    --本月精修字数
    a.amount_curmon AS currmonth_income,                                                                    --本月收入
    NOW()
FROM ads.ads_report_book_capacity_rate_stat a
LEFT JOIN ods.ods_tidb_shuangwen_en_bookcapacitymonitoring e
    ON a.book_id = e.ToBookId * 1000 + e.ToLanguage
    AND e.dt = '${bf_2_dt}'
LEFT JOIN ods.ods_tidb_shuangwen_en_bookcapacitymonitoring f
    ON a.book_id = f.ToBookId * 1000 + f.ToLanguage
    AND f.dt = '${bf_1_dt}'
LEFT JOIN ads.`ads_report_cost_income` g
    ON a.book_id = g.book_id
    AND g.dt = '${bf_2_dt}'
LEFT JOIN ads.`ads_report_cost_income` h
    ON a.book_id = h.book_id
    AND h.dt = '${bf_1_dt}'
WHERE a.dt = '${bf_1_dt}'
  AND a.font_length_curmonth > 0                                                                            -- 本月精修字数大于0
  AND a.book_id not in (SELECT book_id FROM ads.ads_content_book_plevel_capacity_p_da WHERE dt = '${bf_1_dt}');
