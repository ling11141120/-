----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_content_book_stage3_published_stat_p_da
-- workflow_version : 19
-- create_user      : xixg
-- task_name        : ads_content_book_stage3_published_stat_p_da
-- task_version     : 19
-- update_time      : 2025-07-03 16:51:09
-- sql_path         : \starrocks\tbl_ads_content_book_stage3_published_stat_p_da\ads_content_book_stage3_published_stat_p_da
----------------------------------------------------------------
-- SQL语句
INSERT INTO ads.ads_content_book_stage3_published_stat_p_da
WITH stage3_book AS (
    SELECT
        book_id,
        language_id,
        code_stage,
        D0Amount,
        Spend
    FROM
        (SELECT
             CodeId AS book_id,
             CurrentLanguage AS language_id,
             CodeStage AS code_stage,
             D0Amount,
             Spend,
             ROW_NUMBER () OVER (PARTITION BY CodeId ORDER BY BeginDate DESC) AS rank_num                   -- 一本书可能多次进阶段，取最近的一条数据
         FROM ods.ods_tidb_ad_sharpengine_ads_global_MarketingPlan
         WHERE ProjectCode=1 and IsDel=0
        ) a
    WHERE a.rank_num = 1
),

     roi_tmp AS (
         select
             ae.BookId AS book_id,
             sum(costamount) cost_amount,
             sum(Day0Amount) day0_amount,
             sum(Day0AmountByAd * ifnull(iaas.Ratio, 1)) day0_amount_byad,
             sum(Day0Amount + Day0AmountByAd) day0_total_amount,
             sum(Day0Amount + Day0AmountByAd * ifnull(iaas.Ratio, 1))/ sum(costamount) AS d0_roi
         from  ods.ods_tidb_sharpengine_ads_global_fbadroiinstallreferrer ltv
                   left join ods.ods_tidb_sharpengine_ads_global_FbAccount fa
                             on  ltv.FbAccount = fa.Account
                   left join ods.ods_tidb_sharpengine_ads_global_adext ae
                             on  ltv.AdId = ae.AdId
                                 and ltv.ProductId = ae.ProductId
                   left join ods.ods_ad_sharpengine_ads_global_AdMobScale iaas                                                         -- 广告收入放大表
                             on ltv.ProductId = iaas.ProductId
                                 and ltv.Mt = iaas .Mt
                                 and ltv.Core = iaas.Core
                                 and ltv.CreateTime = iaas.AmountDateStr
         where ltv.ProductId in (
             select
                 ProductId
             from ods.ods_ad_sharpengine_ads_global_ProjectProduct
             where ProjectCode = 1                                                                   -- 海阅产品语言过滤
         )
           and ltv.CreateTime = '${bf_1_dt}'                                                                                -- 数据日期过滤
           and (fa.FbAccountType = 0 or fa.FbAccountType is null)                                                            -- 过滤掉facebook的再营销数据
         group by 1
     )

SELECT
    '${bf_1_dt}' AS dt,
    a.book_id AS book_id,
    c.book_name,
    c.book_code,
    CASE a.language_id
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
    3  AS  stage,                                                                                       --书籍所属阶段 3阶段
    ROUND(f.d0_roi ,4) AS d0_roi,
    c.public_fontlength AS total_published_words,                                                       --累计至今发布字数
    CASE WHEN IFNULL(e.PublishLength,0)-IFNULL(d.PublishLength,0) < 0 THEN 0
         ELSE IFNULL(e.PublishLength,0)-IFNULL(d.PublishLength,0)
        END AS today_published_words,                                                                       --当日发布字数  当前发布字数减去昨天发布字数
    f.cost_amount,
    f.day0_amount,
    f.day0_amount_byad,
    f.day0_total_amount,
    NOW()
FROM stage3_book a
         LEFT JOIN dim.dim_shuangwen_book_read_consume_info c
                   ON a.book_id = c.book_id
         LEFT JOIN ods.ods_tidb_shuangwen_en_bookcapacitymonitoring d
                   ON a.book_id = d.ToBookId * 1000 + d.ToLanguage
                       AND d.dt = '${bf_1_dt}'
         LEFT JOIN ods.ods_tidb_shuangwen_en_bookcapacitymonitoring e
                   ON a.book_id = e.ToBookId * 1000 + e.ToLanguage
                       AND e.dt = '${dt}'
         LEFT JOIN roi_tmp f
                   ON a.book_id = f.book_id
WHERE a.code_stage = 3;
