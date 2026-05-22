----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_content_xzz_book
-- workflow_version : 17
-- create_user      : xixg
-- task_name        : ads_content_xzz_book
-- task_version     : 17
-- update_time      : 2025-08-11 11:40:18
-- sql_path         : \starrocks\tbl_ads_content_xzz_book\ads_content_xzz_book
----------------------------------------------------------------
-- SQL语句
INSERT INTO ads.ads_content_xzz_book
WITH book_sore AS (
    SELECT book_id,
           case when real_time_score = 1 then 'S'
                when real_time_score = 2 then 'A'
                when real_time_score = 3 then 'B'
                when real_time_score = 4 then 'C'
                else '未评级'
               end AS curr_month_socre,
           case
               when score = 1 then 'S'
               when score = 2 then 'A'
               when score = 3 then 'B'
               when score = 4 then 'C'
               else '未评级'
               end AS his_score
    FROM
        (
            select
                t1.book_id,
                max(t2.score) score,
                max(t1.real_time_score) real_time_score,
                max(t1.Real_Time_Score_Time) Real_Time_Score_Time
            from ads.ads_tag_center_book_view t1
                     left join ads.ads_center_book_information t2
                               on t1.book_id = t2.bookid
            group by t1.book_id
        ) a
),

     book_cost AS (
         SELECT
             book_id,
             ifnull(trad_money_total_amount,0) + ifnull(fore_money_total_amount,0) + ifnull(1010_income_amt,0) + ifnull(1013_income_amt,0) AS total_income,
             ifnull(p_1002,0) + ifnull(p_1003,0) + ifnull(p_1004,0) + ifnull(p_1005,0) + ifnull(p_1007,0) + ifnull(p_1008,0) + ifnull(p_1010,0) + ifnull(p_1011,0) +
             ifnull(p_1012,0) + ifnull(p_1013,0) + ifnull(a_0000,0) + ifnull(a_1002,0) + ifnull(a_1003,0) + ifnull(a_1004,0) + ifnull(a_1005,0) + ifnull(a_1007,0) +
             ifnull(a_1008,0) + ifnull(a_1010,0) + ifnull(a_1011,0) + ifnull(a_1012,0) + ifnull(a_1013,0) + ifnull(translation_cost,0) + ifnull(cost_amt,0)*6.5  AS total_cost,
             ifnull(cost_amt,0)*6.5  AS tf_cost
         from  ads.ads_bi_translation_roi
         where dt = '${bf_1_dt}'
     ),

     put_down AS (
         SELECT BookId,
                MAX(sexy2) AS sexy2
         from ods.ods_book_novel_book_m
         where Status = 1
         group by  BookId
     ),

     test_status AS (
         SELECT CodeId AS book_id,
                TestStatus AS test_status,
                CodeStage AS code_stage,
                PlanRound AS plan_round,
                Day0FirstPayNum AS d0_first_pay_num,
                RegNum AS reg_num,
                D0Amount AS d0_amount,
                Spend AS spend,
                row_number() over(partition by CodeId  order by UpdateTime DESC) as rn
         FROM ods.ods_tidb_ad_sharpengine_ads_global_MarketingPlan
        WHERE SourceChl is not null
          AND SourceChl != ''
          AND UpdateTime < '${dt}'
     ),

     author_imp AS (
         SELECT penname_arr
         FROM
             (select
                  '1' as grp_key,
                  array_agg(penname) as penname_arr
              from  ods.`ods_shuangwen_tidb_en_visctargetbookhighpriceconfig`
              where  penname is not null
                and penname != ''
              group by  grp_key) a
     ),

     jt_book_tmp AS(
         SELECT
             '${bf_1_dt}' AS dt,
             (a.BookId *1000 + a.SiteId ) AS book_id,
             '简体' as language,
    a.BookCode as book_code,
    regexp_extract(a.BookCode, '^[A-Za-z]+', 0) AS book_xl,
    CASE a.IsFull
    WHEN 0 THEN '未完本'
    WHEN 1 THEN '已完本'
    ELSE ''
END AS lian_zai_status,
    a.FontLength as font_length,
    a.UpdateTime as update_time,
    CASE a.IsPutdown
        WHEN 0 THEN '下架'
        WHEN 1 THEN '上架'
        ELSE ''
END AS jt_putaway_status,
    CASE
        WHEN b.sexy2=0 THEN '上架'
        WHEN b.sexy2=4 THEN '下架'
        WHEN b.sexy2 > 4 THEN '强制下架'
        ELSE ''
END AS ft_putaway_status,
    CASE
        WHEN b.sexy2=0 THEN '上架'
        WHEN b.sexy2=4 THEN '下架'
        WHEN b.sexy2 > 4 THEN '强制下架'
        ELSE ''
END AS haiwai_jt_putaway_status,
    a.StoryType AS story_type,
    c.test_status,
    null AS price_per_thousand,
    f.PenName AS author_name,
    c.code_stage,
    c.plan_round,
    e.curr_month_socre AS curr_month_score,
    e.his_score AS his_max_score,
    d.total_income,
    d.total_cost,
    d.tf_cost,
    c.d0_first_pay_num,
    c.reg_num,
    c.d0_amount,
    c.spend,
    NOW() as etl_time
FROM ods.ods_mysql_zhangzhong_xzz_Book a
LEFT JOIN put_down b
    ON (a.BookId *1000 + a.SiteId )  = b.BookId
LEFT JOIN (SELECT * FROM test_status WHERE rn = 1) c
    on (a.BookId *1000 + a.SiteId )  = c.book_id
LEFT JOIN book_cost d
    on (a.BookId *1000 + a.SiteId )  = d.book_id
LEFT JOIN book_sore e
          on (a.BookId *1000 + a.SiteId )  = e.book_id
LEFT JOIN ods.ods_mysql_zhangzhong_xzz_Author f
          ON a.AuthorId = f.AccountId
),

--  新掌中的书翻译成英语的书
en_book_id AS (
SELECT c.SwBookId*1000 + ToLanguage AS book_id,
       (a.BookId*1000 + a.SiteId) AS from_book_id,
       CASE a.IsFull
           WHEN 0 THEN '未完本'
           WHEN 1 THEN '已完本'
           ELSE ''
           END AS lian_zai_status,
       a.StoryType AS story_type
FROM ods.ods_mysql_zhangzhong_xzz_Book a
    INNER JOIN ods.ods_tidb_shuangwen_en_objectbook c
    ON (a.BookId*1000 + a.SiteId) = c.BookId
    AND c.Status = 1
    AND c.ObjectBookType = 0
    AND c.FromLanguage = 0
    AND c.ToLanguage = 322
),

en_book_tmp AS(
 SELECT
     '${bf_1_dt}' AS dt,
     a.book_id AS book_id,
     '英语' AS language,
     b.book_code AS book_code,
     regexp_extract(b.book_code, '^[A-Za-z]+', 0) AS book_xl,
     a.lian_zai_status,
     b.public_fontlength as font_length,
     NULL update_time,
     NULL AS jt_putaway_status,
     NULL AS ft_putaway_status,
     NULL AS haiwai_jt_putaway_status,
     a.story_type,
     c.test_status,
     b.price_per_thousand,
     b.author_name,
     c.code_stage,
     c.plan_round,
     e.curr_month_socre AS curr_month_score,
     e.his_score AS his_max_score,
     d.total_income,
     d.total_cost,
     d.tf_cost,
     c.d0_first_pay_num,
     c.reg_num,
     c.d0_amount,
     c.spend,
     NOW() as etl_time
 FROM en_book_id a
          LEFT JOIN dim.dim_shuangwen_book_read_consume_info b
                    ON a.book_id  = b.book_id
          LEFT JOIN (SELECT * FROM test_status WHERE rn = 1) c
                    on a.book_id  = c.book_id
          LEFT JOIN book_cost d
                    on a.book_id  = d.book_id
          LEFT JOIN book_sore e
                    on a.book_id  = e.book_id
          LEFT JOIN ods_tidb_ad_sharpengine_ads_global_MarketingPlan g
                on a.book_id  = g.CodeId
)

SELECT
    a.dt,
    a.book_id,
    a.language,
    a.book_code,
    a.book_xl,
    a.lian_zai_status,
    a.font_length,
    a.update_time,
    a.jt_putaway_status,
    a.ft_putaway_status,
    a.haiwai_jt_putaway_status,
    a.story_type,
    a.test_status,
    a.price_per_thousand,
    array_contains(b.penname_arr, a.author_name)  AS if_important_author,
    a.code_stage,
    a.plan_round,
    a.curr_month_score,
    a.his_max_score,
    a.total_income,
    a.total_cost,
    a.tf_cost,
    a.d0_first_pay_num,
    a.reg_num,
    a.d0_amount,
    a.spend,
    a.etl_time
FROM jt_book_tmp a,author_imp b
UNION ALL
SELECT
    a.dt,
    a.book_id,
    a.language,
    a.book_code,
    a.book_xl,
    a.lian_zai_status,
    a.font_length,
    a.update_time,
    a.jt_putaway_status,
    a.ft_putaway_status,
    a.haiwai_jt_putaway_status,
    a.story_type,
    a.test_status,
    a.price_per_thousand,
    array_contains(b.penname_arr, a.author_name)  AS if_important_author,
    a.code_stage,
    a.plan_round,
    a.curr_month_score,
    a.his_max_score,
    a.total_income,
    a.total_cost,
    a.tf_cost,
    a.d0_first_pay_num,
    a.reg_num,
    a.d0_amount,
    a.spend,
    a.etl_time
FROM en_book_tmp a,author_imp b;
