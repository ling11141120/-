----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_content_marketing_plan_p_da
-- workflow_version : 2
-- create_user      : xixg
-- task_name        : ads_content_marketing_plan_p_da
-- task_version     : 2
-- update_time      : 2024-06-29 11:09:05
-- sql_path         : \starrocks\tbl_ads_content_marketing_plan_p_da\ads_content_marketing_plan_p_da
----------------------------------------------------------------
-- SQL语句
INSERT INTO ads.ads_content_marketing_plan_p_da
SELECT
        '${bf_1_dt}' AS dt,
        CodeId AS book_id,
        a.BeginDate AS test_start_time,
        a.EndDate AS test_end_time,
        b.book_code AS book_code,
        b.book_name as book_name,
        CASE b.languageid
            WHEN 15 THEN '菲律宾语'
            WHEN 2 THEN '繁体'
            WHEN 3 THEN '英语'
            WHEN 4 THEN '西语'
            WHEN 5 THEN '葡语'
            WHEN 6 THEN '法语'
            WHEN 7 THEN '俄语'
            WHEN 9 THEN '日语'
            WHEN 11 THEN '印尼语'
            WHEN 12 THEN '泰语'
            WHEN 14 THEN '韩语'
            ELSE ''
        END AS language_name,
        CASE a.CodeStage
            WHEN -1 THEN '禁投'
            WHEN 1 THEN '第一阶段'
            WHEN 2 THEN '第二阶段'
            WHEN 3 THEN '第三阶段'
            ELSE ''
        END AS stage,
        CASE c.channel
            WHEN 1 THEN '女频'
            WHEN 2 THEN '男频'
            ELSE ''
            END AS book_channel,
        CASE a.planround
            WHEN 1 THEN '第1轮测试'
            WHEN 2 THEN '第2轮测试'
            WHEN 3 THEN '第3轮测试'
            ELSE ''
        END AS plan_round,
        CASE a.PlanStatus
            WHEN 0 THEN '待定'
            WHEN 1 THEN '跑出'
            WHEN 2 THEN '未跑出'
            ELSE ''
        END AS status,
        NOW() AS etl_time
FROM ods.ods_tidb_ad_sharpengine_ads_global_MarketingPlan a
LEFT JOIN dim.dim_shuangwen_book_read_consume_info  b
  ON  a.CodeId = b.book_id
LEFT JOIN ods.`ods_tidb_sharpengine_bi_if_books` c
  ON a.CodeId = c.bookid
WHERE a.ProjectCode = 1
 AND a.IsDel = 0;
