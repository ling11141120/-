----------------------------------------------------------------
-- 目标表： ads.ads_ab_dbd_svsr_ad_cyc_rev
-- 功能： AB测试-运营看板-海剧海阅广告周期收益表
-- 更新方式： 按小时增量更新
-- 负责人： qhr
-- 开发日期： 2023-08-06
----------------------------------------------------------------

INSERT INTO ads.ads_ab_dbd_svsr_ad_cyc_rev
WITH base1 AS (
    SELECT dt                              AS dt
          ,COALESCE(corever, -99)          AS core
          ,COALESCE(period_type, '-99')    AS period_type
          ,SUM(COALESCE(amt, 0))           AS amt
      FROM ads.ads_sv_ad_efficiency_report
     WHERE dt BETWEEN DATE_SUB('${dt}', INTERVAL 120 DAY) AND '${dt}'
  GROUP BY 1, 2, 3
), base2 AS (
    SELECT dt
          ,CASE WHEN corever = '-99' OR corever = '其他' OR corever IS NULL THEN -99
                ELSE CAST(corever AS INT)
            END                                   AS core
          ,COALESCE(period_type, '-99')           AS period_type
          ,SUM(COALESCE(ad_revenue_amount, 0))    AS amt
      FROM ads.ads_ad_user_space_conversion_detail
     WHERE dt BETWEEN DATE_SUB('${dt}', INTERVAL 120 DAY) AND '${dt}'
  GROUP BY 1, 2, 3
), union_base AS (
    SELECT dt
          ,core
          ,3     AS project_id    -- 海剧
          ,period_type
          ,amt
      FROM base1
     UNION ALL
    SELECT dt
          ,core
          ,1     AS project_id    -- 海阅
          ,period_type
          ,amt
      FROM base2
), join_future AS (
    SELECT a1.dt
          ,a1.core
          ,a1.project_id
          ,a1.period_type
          ,a1.amt                    AS day0_amt
          ,a2.dt                     AS future_dt
          ,a2.amt                    AS future_amt
          ,DATEDIFF(a2.dt, a1.dt)    AS days_after
      FROM union_base                AS a1    -- 当天
      JOIN union_base                AS a2    -- 未来
        ON a2.core        = a1.core
       AND a2.project_id  = a1.project_id
       AND a2.period_type = a1.period_type
       AND a2.dt BETWEEN a1.dt AND DATE_ADD(a1.dt, INTERVAL 120 DAY)
), grouped AS (
    SELECT dt
          ,core
          ,project_id
          ,period_type
          ,day0_amt
          ,ARRAY_SORTBY(arr_amt, arr_dt)                                                    AS arr_dt_amt
      FROM (SELECT dt
                  ,core
                  ,project_id
                  ,period_type
                  ,MAX(CASE WHEN days_after = 0 THEN day0_amt END)                          AS day0_amt
                  ,ARRAY_AGG(CASE WHEN days_after BETWEEN 0 AND 120 THEN future_dt END)     AS arr_dt
                  ,ARRAY_AGG(CASE WHEN days_after BETWEEN 0 AND 120 THEN future_amt END)    AS arr_amt
              FROM join_future
             GROUP BY 1, 2, 3, 4
           )                                                                                AS a1
)
SELECT dt                                                                                                     AS dt
      ,core                                                                                                   AS core
      ,project_id                                                                                             AS project_id
      ,period_type                                                                                            AS period_type
      ,day0_amt                                                                                               AS day0_amount_byad
      ,CASE WHEN arr_dt_amt[2]   IS NOT NULL THEN ARRAY_SUM(ARRAY_SLICE(arr_dt_amt, 1, 2))   ELSE NULL END    AS day1_amount_byad
      ,CASE WHEN arr_dt_amt[3]   IS NOT NULL THEN ARRAY_SUM(ARRAY_SLICE(arr_dt_amt, 1, 3))   ELSE NULL END    AS day2_amount_byad
      ,CASE WHEN arr_dt_amt[4]   IS NOT NULL THEN ARRAY_SUM(ARRAY_SLICE(arr_dt_amt, 1, 4))   ELSE NULL END    AS day3_amount_byad
      ,CASE WHEN arr_dt_amt[8]   IS NOT NULL THEN ARRAY_SUM(ARRAY_SLICE(arr_dt_amt, 1, 8))   ELSE NULL END    AS day7_amount_byad
      ,CASE WHEN arr_dt_amt[16]  IS NOT NULL THEN ARRAY_SUM(ARRAY_SLICE(arr_dt_amt, 1, 16))  ELSE NULL END    AS day15_amount_byad
      ,CASE WHEN arr_dt_amt[22]  IS NOT NULL THEN ARRAY_SUM(ARRAY_SLICE(arr_dt_amt, 1, 22))  ELSE NULL END    AS day21_amount_byad
      ,CASE WHEN arr_dt_amt[31]  IS NOT NULL THEN ARRAY_SUM(ARRAY_SLICE(arr_dt_amt, 1, 31))  ELSE NULL END    AS day30_amount_byad
      ,CASE WHEN arr_dt_amt[46]  IS NOT NULL THEN ARRAY_SUM(ARRAY_SLICE(arr_dt_amt, 1, 46))  ELSE NULL END    AS day45_amount_byad
      ,CASE WHEN arr_dt_amt[61]  IS NOT NULL THEN ARRAY_SUM(ARRAY_SLICE(arr_dt_amt, 1, 61))  ELSE NULL END    AS day60_amount_byad
      ,CASE WHEN arr_dt_amt[91]  IS NOT NULL THEN ARRAY_SUM(ARRAY_SLICE(arr_dt_amt, 1, 91))  ELSE NULL END    AS day90_amount_byad
      ,CASE WHEN arr_dt_amt[121] IS NOT NULL THEN ARRAY_SUM(ARRAY_SLICE(arr_dt_amt, 1, 121)) ELSE NULL END    AS day120_amount_byad
  FROM grouped
;