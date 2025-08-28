INSERT INTO dws.dws_user_short_video_wide_active_period_west5_ed
-- -----------------------ctt活跃用户的主表 ------------------------
WITH active AS (
    SELECT a.dt
          ,a.product_id
          ,a.user_id
          ,a.corever
          ,a.mt
          ,a.current_language
          ,a.current_language2
          ,a.reg_country
          ,a.country_level
          ,a.reg_time
          ,a.reg_days
          ,a.sex
          ,a.is_acc_login
          ,a.is_has_email
          ,a.popularize_series_code
          ,CASE WHEN a.reg_days =  0 THEN 'D0'
                WHEN a.reg_days >= 1  AND a.reg_days <= 7  THEN 'D1-D7'
                WHEN a.reg_days >= 8  AND a.reg_days <= 30 THEN 'D8-D30'
                WHEN a.reg_days >= 31 AND b.user_id IS NOT NULL THEN 'D31+_stock_user'
                WHEN a.reg_days >= 31 AND b.user_id IS NULL THEN 'D31+_backflow_user'
                ELSE 'D31+_backflow_user' 
            END AS user_type
          ,IF(b.user_id IS NOT NULL,1,0) AS is_l7_active
      FROM (SELECT dt
                  ,product_id
                  ,user_id
                  ,corever
                  ,mt
                  ,current_language
                  ,current_language2
                  ,reg_country
                  ,country_level
                  ,reg_time
                  ,reg_days
                  ,sex
                  ,is_acc_login
                  ,is_has_email
                  ,popularize_series_code
              FROM dws.dws_user_short_video_wide_active_west5_ed
             WHERE dt = '${bf_1_dt}'
           ) a
      LEFT JOIN (SELECT product_id
                       ,user_id
                  FROM dws.dws_user_short_video_wide_active_west5_ed
                 WHERE dt >= date_sub('${bf_1_dt}',interval 7 day)
                   AND dt < '${bf_1_dt}'
                 GROUP BY product_id, user_id
                ) b
        ON a.product_id = b.product_id
       AND a.user_id = b.user_id
)
,rmt AS (
    SELECT product_id
          ,user_id
          ,MAX(dt) AS install_dt
      FROM dws.dws_srsv_wide_user_type_info_di
     WHERE dt>=date_sub('${bf_1_dt}',interval 6 month)
       AND dt <='${bf_1_dt}'
       AND user_period=3
       AND product_id IN(6833)
     GROUP BY 1,2
     UNION ALL
    SELECT product_id
           ,user_id
           ,MAX(stat_period) AS install_dt
      FROM dws.dws_wide_video_cn_user_type_info_ed
     WHERE user_period=3
       AND period_types=1
       AND stat_period>=date_sub('${bf_1_dt}',interval 6 month)
       AND stat_period <='${bf_1_dt}'
       AND product_id IN(6883)
     GROUP BY 1,2
)
-- -----------rmt用户主表，来源于 active 子查询 -------------------------------
,rmt_user_type AS (
    SELECT a.dt
          ,a.product_id
          ,a.user_id
          ,a.corever
          ,a.mt
          ,a.current_language
          ,a.current_language2
          ,a.reg_country
          ,a.country_level
          ,a.reg_time
          ,a.reg_days
          ,a.sex
          ,a.is_acc_login
          ,a.is_has_email
          ,a.popularize_series_code
          ,CASE WHEN datediff(a.dt,b.install_dt)=0 THEN 'D0'
                WHEN datediff(a.dt,b.install_dt)>=1 AND datediff(a.dt,b.install_dt)<=7 THEN 'D1-D7'
                WHEN datediff(a.dt,b.install_dt)>=8 AND datediff(a.dt,b.install_dt)<=30 THEN 'D8-D30'
                WHEN datediff(a.dt,b.install_dt)>=31 AND is_l7_active=1 THEN 'D31+_stock_user'
                ELSE 'D31+_backflow_user'
            END AS user_type
          ,IF(b.user_id IS NOT NULL,1,0) AS is_rmt
      FROM active      AS a
      LEFT JOIN rmt    AS b
        ON a.product_id = b.product_id
       AND a.user_id = b.user_id
)
SELECT a.dt
      ,'ctt' AS period_type
      ,a.product_id
      ,a.user_id
      ,a.user_type
      ,a.corever
      ,a.mt
      ,a.current_language
      ,a.current_language2
      ,b.source_chl AS source_chl
      ,a.reg_country
      ,a.country_level
      ,a.reg_time
      ,a.reg_days
      ,a.sex
      ,a.is_acc_login
      ,a.is_has_email
      ,a.popularize_series_code
      ,NOW() AS etl_time
  FROM active a
  LEFT JOIN dim.dim_short_video_user_accountinfo b
    ON a.product_id = b.product_id
   AND a.user_id = b.user_id
 UNION ALL
SELECT a.dt
      ,'rmt' AS period_type
      ,a.product_id
      ,a.user_id
      ,a.user_type
      ,a.corever
      ,a.mt
      ,a.current_language
      ,a.current_language2
      ,b.source_chl AS source_chl
      ,a.reg_country
      ,a.country_level
      ,a.reg_time
      ,a.reg_days
      ,a.sex
      ,a.is_acc_login
      ,a.is_has_email
      ,a.popularize_series_code
      ,NOW() AS etl_time
  FROM rmt_user_type a
  LEFT JOIN dim.dim_short_video_user_accountinfo b
    ON a.product_id = b.product_id
   AND a.user_id = b.user_id
;