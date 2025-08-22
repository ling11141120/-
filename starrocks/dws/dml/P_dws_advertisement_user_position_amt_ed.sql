-- ==================新增position_id=59 的数据==============================
-- ==================main_strategy_id、event_strategy_id 字段==============================
-- -----------阅读及海外短剧--分广告类型、位置用户粒度广告展现收益表（海外短剧暂时没有分位置）
INSERT INTO dws.dws_advertisement_user_position_amt_ed
-- -------阅读以及海剧的脚本-------------------------------
-- -------统计每日H5点击--------------
WITH ad_click_count AS (
    SELECT dt
          ,app_product_id       AS product_id
          ,login_id             AS user_id
          ,app_core_ver         AS core
          ,mt
          ,appver
          ,5                    AS ad_show_type
          ,59                   AS positions
          ,'Starmobi'           AS ads_name
          ,NULL                 AS main_strategy_id
          ,NULL                 AS event_strategy_id
          ,event_strategy_id    AS programme_id
          ,2                    AS system_type
          ,COUNT(1)             AS ad_click_count
      FROM dwd.dwd_sensors_production_complete_task_click_view
     WHERE dt >= '${bf_1_dt}'
       AND dt <= '${dt}'
       AND element_id = '100772'
       AND type = '121'
     GROUP BY 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13
     UNION ALL
    SELECT dt
          ,app_product_id    AS product_id
          ,login_id          AS user_id
          ,app_core_ver      AS core
          ,mt
          ,appver
          ,5                 AS ad_show_type
          ,ad_position_id    AS positions
          ,'Starmobi'        AS ads_name
          ,main_strategy_id
          ,ad_strategy_id    AS event_strategy_id
          ,programme_id      AS programme_id
          ,2                 AS system_type
          ,COUNT(1)          AS ad_click_count
      FROM dwd.dwd_sensors_production_element_click_view
     WHERE dt >= '${bf_1_dt}'
       AND dt <= '${dt}'
       AND element_id = '100356'
       AND ad_position_id > 0   -- 241113从19、60改为>0
       AND app_product_id IS NOT NULL
     GROUP BY 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13
     UNION ALL
    -- 海剧每日H5点击
    SELECT a.dt
          ,a.product_id
          ,a.user_id
          ,a.core
          ,a.mt
          ,a.appver
          ,a.ad_type             AS ad_show_type
          ,b.ad_position         AS positions
          ,b.ad_position_name    AS ads_name
          ,a.main_strategy_id
          ,a.event_strategy_id
          ,a.programme_id
          ,1                     AS system_type
          ,COUNT(1)              AS ad_click_count
      FROM dwd.dwd_sensors_production_adpositionclick_view    AS a
      LEFT JOIN dim.dim_sv_ads_position_view                  AS b
        ON a.ad_position_id = b.ad_position
     WHERE dt >= '${bf_1_dt}'
       AND dt <= '${dt}'
       AND ad_type = 6
       AND product_id = 6833
     GROUP BY 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13
     UNION ALL
    SELECT a.dt
          ,6833                   AS product_id
          ,login_id               AS user_id
          ,corever                AS core
          ,a.mt
          ,a.appver
          ,6                      AS ad_show_type
          ,NULL                   AS positions
          ,'H5'                   AS ads_name
          ,NULL                   AS main_strategy_id
          ,a.event_strategy_id
          ,NULL                   AS programme_id
          ,1                      AS system_type
          ,COUNT(1)               AS ad_click_count
      FROM dwd.dwd_sensors_production_complete_task_click_view a
     WHERE dt >= '${bf_1_dt}'
       AND dt <= '${dt}'
       AND task_type IN ('9', '浏览第三方页面')
       AND app_product_id IS NULL
     GROUP BY 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13
)
-- -------统计每日H5总收益--------------
,avg_click_amount AS (
    SELECT a.dt
          ,a.system_type
          ,b.ads_name
          ,SUM(a.ad_click_count) AS ad_click_count
          ,SUM(b.revenue_share) AS ad_amt
          ,ROUND(SUM(b.revenue_share) / SUM(a.ad_click_count), 9) AS ad_avg_click_amt
      FROM (SELECT dt
                  ,system_type
                  ,SUM(ad_click_count) AS ad_click_count
              FROM ad_click_count
             GROUP BY dt, system_type
           ) a
      LEFT JOIN (SELECT DATE(day) AS dt
                       ,system_type
                       ,'Starmobi' AS ads_name
                       ,SUM(revenue_share) * 0.7 AS revenue_share
                   FROM dim.dim_sv_ad_advertise_info_view
                  WHERE DATE(day) >= '${bf_1_dt}'
                    AND DATE(day) <= '${dt}'
                  GROUP BY 1, 2, 3
                  UNION ALL
                 SELECT a.`Date` AS dt
                       ,CASE WHEN ProjectType = 0 THEN 2 ELSE ProjectType END AS system_type
                       ,'MobKing' AS ads_name
                       ,SUM(SubNetRevenue) * 0.7 AS revenue_share
                   FROM ods.ods_tidb_mobkingaddata a
                  WHERE Date >= '${bf_1_dt}'
                    AND Date <= '${dt}'
                  GROUP BY 1, 2, 3
                  UNION ALL
                 SELECT `Date` AS dt
                       ,CASE WHEN UrlName = 'moboreels' THEN 1
                             WHEN UrlName = 'moboreader' THEN 2
                         END AS system_type
                       ,'pengpai' AS ads_name
                       ,SUM(RevenueNet) AS revenue_share
                   FROM ods.ods_tidb_SurgeAdData
                  WHERE UrlName IN ('moboreels', 'moboreader')
                    AND Date >= '${bf_1_dt}'
                    AND Date <= '${dt}'
                  GROUP BY 1, 2, 3
                  UNION ALL
                 SELECT dt
                       ,system_type
                       ,'Starmobi_2' AS ads_name
                       ,income AS revenue_share
                   FROM (SELECT DATE(day) AS dt
                               ,system_type
                               ,SUM(ecpm) AS ecpm
                               ,SUM(income) AS income
                               ,SUM(page_view) AS page_view
                           FROM ods.ods_tidb_short_video_log_firefly_income_report
                          GROUP BY 1, 2
                        ) a
                  WHERE dt >= '${bf_1_dt}'
                    AND dt <= '${dt}'
           ) b ON a.dt = b.dt AND a.system_type = b.system_type
     GROUP BY 1, 2, 3
)
,user_info_tmp AS (
    SELECT a.product_id
          ,a.user_id
          ,CASE WHEN (current_language2 IS NULL OR current_language2 = 0) AND product_id = 3311 THEN 6
                WHEN (current_language2 IS NULL OR current_language2 = 0) AND product_id = 3322 THEN 5
                WHEN (current_language2 IS NULL OR current_language2 = 0) AND product_id = 3333 THEN 2
                WHEN (current_language2 IS NULL OR current_language2 = 0) AND product_id = 3366 THEN 3
                WHEN (current_language2 IS NULL OR current_language2 = 0) AND product_id = 3371 THEN 7
                WHEN (current_language2 IS NULL OR current_language2 = 0) AND product_id = 3388 THEN 4
                WHEN (current_language2 IS NULL OR current_language2 = 0) AND product_id = 3501 THEN 11
                WHEN (current_language2 IS NULL OR current_language2 = 0) AND product_id = 3511 THEN 12
                ELSE current_language2
            END AS currentlanguage2
      FROM (SELECT sacc.product_id
                  ,sacc.user_id
                  ,sacc.current_language2
              FROM dim.dim_short_video_user_accountinfo sacc    -- 海外短剧用户信息
            UNION ALL
            SELECT 6883 AS product_id
                  ,account AS user_id
                  ,current_language2
              FROM dim.dim_video_cn_accountinfo_view    -- 国内短剧用户信息
            UNION ALL
            SELECT product_id
                  ,id AS user_id
                  ,current_language2
              FROM dim.dim_user_account_info_view
           ) a
)
SELECT x.dt
      ,x.product_id
      ,x.user_id
      ,x.core
      ,x.mt
      ,CASE WHEN x.product_id = 6833 AND x.positions = 12 THEN 'Starmobi-H5'
            WHEN x.product_id <> 6833 AND x.positions = 59 THEN 'Starmobi-H5'
            ELSE acc.currentlanguage2
        END AS current_language2
      ,x.appver
      ,x.ad_show_type
      ,x.positions
      ,x.ads_name
      ,x.ads_source
      ,x.main_strategy_id
      ,x.event_strategy_id
      ,x.programme_id
      ,MAX(CASE WHEN rk_asc  = 1 THEN amount END) AS fst_amt
      ,MAX(CASE WHEN rk_desc = 1 THEN amount END) AS lst_amt
      ,COUNT(1) AS cnt
      ,SUM(amount) AS amt
      ,NOW() AS etl_tm
  FROM (SELECT a.dt
              ,a.product_id
              ,a.user_id
              ,a.corever AS core
              ,a.mt
              ,a.appver
              ,a.create_tm
              ,a.ad_unit
              ,a.ad_show_type
              ,a.position_id AS positions
              ,a.ad_position_amt AS amount
              ,a.ads_name
              ,COALESCE(b.ads_source_abbr, a.ads_source) AS ads_source
              ,a.main_strategy_id
              ,a.event_strategy_id
              ,a.programme_id
              ,ROW_NUMBER() OVER (PARTITION BY a.dt
                                              ,a.product_id
                                              ,a.user_id
                                              ,a.corever
                                              ,a.mt
                                              ,a.appver
                                              ,a.ad_show_type
                                              ,a.position_id
                                              ,a.ads_name
                                              ,main_strategy_id
                                              ,event_strategy_id
                                      ORDER BY a.create_tm
                                              ,a.ad_unit
                                 ) AS rk_asc
              ,ROW_NUMBER() OVER (PARTITION BY a.dt
                                              ,a.product_id
                                              ,a.user_id
                                              ,a.corever
                                              ,a.mt
                                              ,a.appver
                                              ,a.ad_show_type
                                              ,a.position_id
                                              ,a.ads_name
                                              ,main_strategy_id
                                              ,event_strategy_id
                                      ORDER BY a.create_tm DESC
                                              ,a.ad_unit DESC
                                 ) AS rk_desc
          FROM dwd.dwd_advertisement_user_position_amt_p_di a     -- --------阅读及海外短剧--广告预估收益明细宽表,数据起始时间23年1月
          LEFT JOIN dim.dim_ads_source_abbr b
            ON a.ads_name = b.ads_name
           AND a.ads_source = b.ads_source
         WHERE dt >= '${bf_1_dt}'
           AND dt <= '${dt}'
       ) x
  LEFT JOIN user_info_tmp acc
    ON x.product_id = acc.product_id
   AND x.user_id = acc.user_id
 GROUP BY 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14
 UNION ALL
-- --新增position_id=59 的数据
SELECT a.dt
      ,a.product_id
      ,a.user_id
      ,a.core
      ,CASE WHEN LOWER(a.mt) = 'ios' THEN 1
            WHEN LOWER(a.mt) = 'android' THEN 4
            ELSE a.mt
        END AS mt
      ,acc.currentlanguage2 AS current_language2
      ,a.appver
      ,a.ad_show_type
      ,a.positions
      ,b.ads_name
      ,NULL AS ads_source
      ,a.main_strategy_id
      ,a.event_strategy_id
      ,a.programme_id
      ,NULL AS fst_amt
      ,NULL AS lst_amt
      ,SUM(a.ad_click_count) AS cnt
      ,SUM(a.ad_click_count) * MAX(b.ad_avg_click_amt) AS amt
      ,NOW() AS etl_tm
  FROM ad_click_count a
  LEFT JOIN avg_click_amount b
    ON a.dt = b.dt
   AND a.system_type = b.system_type
  LEFT JOIN user_info_tmp acc
    ON a.product_id = acc.product_id
   AND a.user_id = acc.user_id
 GROUP BY 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16
;