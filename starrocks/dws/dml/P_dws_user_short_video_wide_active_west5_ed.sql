-- 脚本
-- 脚本
INSERT INTO dws.dws_user_short_video_wide_active_west5_ed

-- 活跃用户
WITH active_user_tmp AS (
    SELECT dt
          ,Product_id
          ,User_Id
      FROM (SELECT DATE(date_add(create_time, INTERVAL -13 HOUR)) AS dt
                  ,product_id
                  ,user_id
              FROM dwd.dwd_user_short_video_user_login_view    -- 海外短剧登录表
             WHERE dt >= '${bf_3_dt}'
               AND dt <= '${dt}'
               AND user_id >= 0
             UNION ALL
            SELECT DATE(date_add(create_time, INTERVAL -13 HOUR)) AS dt
                 ,product_id
                 ,user_id
              FROM dwd.dwd_trade_short_video_payorder    -- 海外短剧支付表
             WHERE dt >= '${bf_3_dt}'
               AND dt <= '${dt}'
               AND product_id = 6833
               AND status = 0
               AND test_flag = 0
               AND user_id >= 0
             UNION ALL
            SELECT DATE(date_add(create_time, INTERVAL -13 HOUR)) AS dt
                  ,6833 AS product_id
                  ,account_id AS user_id
              FROM dwd.dwd_sv_consume_user_consume_bill_pdi    -- 海外短剧消耗表
             WHERE dt >= '${bf_3_dt}'
               AND dt <= '${dt}'
               AND account_id >= 0
             UNION ALL
            SELECT DATE(date_add(create_time, INTERVAL -13 HOUR)) AS dt
                  ,6833 AS product_id
                  ,account_id AS user_id
              FROM dwd.dwd_video_short_video_epis_history    -- 海外短剧观看记录表
             WHERE date(create_time) >= '${bf_3_dt}'
               AND date(create_time) < '${dt}'
               AND account_id >= 0
           ) a
     GROUP BY 1, 2, 3
)
-- 用户信息
,user_info_tmp AS (
    -- 海外短剧用户信息
    SELECT sacc.product_id
          ,sacc.user_id
          ,sacc.corever AS corever
          ,sacc.mt2     AS mt
          ,sacc.current_language
          ,sacc.current_language2
          ,sacc.reg_country
          ,ifnull(lev.level, 2) AS level
          ,sacc.create_time
          ,sacc.sex
          ,sacc.third_party_id
          ,sacc.pass_word
          ,sacc.email
          ,sacc.bind_email
      FROM dim.dim_short_video_user_accountinfo sacc
      LEFT JOIN (SELECT product_id
                       ,short_name
                       ,level
                   FROM dim.dim_countrylevel
                  WHERE product_id = 6833
                ) lev
        ON sacc.product_id = lev.product_id
       AND sacc.reg_country = lev.short_name
),
-- 用户第一次安装时的剧ID
sv_user_series_id AS (
    SELECT user_id
         , series_id
      FROM (
               SELECT user_id
                    , book_id AS series_id
                    , ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY install_date) AS rank
                 FROM ads.ads_user_install_info_view
                WHERE product_id = 6833
           ) a
    WHERE a.rank = 1
),
-- 关联剧编码
sv_user_video_code AS (
    SELECT a.user_id  AS user_id
         , a.series_id AS series_id
         , b.source_series_code AS series_code
      FROM sv_user_series_id a
      LEFT JOIN dim.dim_sv_series_hi b
        ON a.series_id = b.series_id
)


SELECT dt
     , b.product_id
     , b.user_id
     , acc.corever
     , acc.mt
     , acc.current_language AS current_language
     , acc.currentlanguage2 AS currentlanguage2
     , acc.reg_country
     , acc.level
     , acc.create_time
     , datediff(dt, acc.create_time) AS reg_days
     , acc.sex
     , if(third_party_id IN (1, 2, 3) OR pass_word IS NOT NULL, 1, 0) AS is_acc_login
     , if(email IS NOT NULL OR bind_email IS NOT NULL, 1, 0)          AS is_has_email
     , c.series_code
     , now()                                                          AS etl_time
  FROM active_user_tmp b
  LEFT JOIN (
               SELECT a.product_id
                    , a.user_id
                    , if(a.corever IS NULL OR a.CoreVer = 0, 1, a.CoreVer) AS corever
                    , a.mt
                    , a.current_language
                    , CASE WHEN (current_language2 IS NULL OR current_language2 = 0) AND product_id = 3311 THEN 6
                           WHEN (current_language2 IS NULL OR current_language2 = 0) AND product_id = 3322 THEN 5
                           WHEN (current_language2 IS NULL OR current_language2 = 0) AND product_id = 3333 THEN 2
                           WHEN (current_language2 IS NULL OR current_language2 = 0) AND product_id = 3366 THEN 3
                           WHEN (current_language2 IS NULL OR current_language2 = 0) AND product_id = 3371 THEN 7
                           WHEN (current_language2 IS NULL OR current_language2 = 0) AND product_id = 3388 THEN 4
                           WHEN (current_language2 IS NULL OR current_language2 = 0) AND product_id = 3501 THEN 11
                           WHEN (current_language2 IS NULL OR current_language2 = 0) AND product_id = 3511 THEN 12
                           ELSE current_language2
                      END AS currentlanguage2
                    , a.reg_country
                    , a.level
                    , a.create_time
                    , a.sex
                    , a.third_party_id
                    , a.pass_word
                    , a.email
                    , a.bind_email
                 FROM user_info_tmp a
           ) acc
    ON b.product_id = acc.product_id
   AND b.user_id = acc.user_id
  LEFT JOIN sv_user_video_code c
    ON b.user_id = c.user_id
;