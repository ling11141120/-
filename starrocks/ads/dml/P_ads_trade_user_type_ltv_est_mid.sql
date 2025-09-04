INSERT INTO ads.ads_trade_user_type_ltv_est_mid
WITH tmp AS(
    SELECT rn-1 AS rn
      FROM (SELECT row_number() OVER () rn
              FROM (SELECT datestr FROM dim.dim_date LIMIT 31) a
           ) b
),rmt AS (
    SELECT stat_period AS dt
          ,lead(stat_period,1,'9999-12-31') OVER (PARTITION BY product_id,user_id ORDER BY stat_period,mt,corever) AS end_day
          ,count(1) OVER (PARTITION BY product_id,user_id) num
          ,product_id
          ,weekofyear(last_day_of_week) AS which_weeks
          ,month(last_day_of_month) which_months
          ,user_id
          ,corever
          ,mt
          ,reg_country
          ,country_level
          ,current_language2
          ,source
          ,user_period
      FROM (SELECT dt AS stat_period
                  ,product_id
                  ,date(date_sub(date_trunc('week',date_add(dt,interval 1 week)),interval 1 day )) AS last_day_of_week
                  ,date(date_sub(date_trunc('month',date_add(dt,interval 1 month)),interval 1 day )) last_day_of_month
                  ,user_id
                  ,corever
                  ,mt
                  ,reg_country
                  ,country_level
                  ,current_language2
                  ,source
                  ,user_period
                  ,row_number() OVER (PARTITION BY dt,product_id,user_id ORDER BY mt,corever) rn
              FROM dws.dws_srsv_wide_user_type_info_est_di
             WHERE dt>=date_sub('${dt}',interval 120 day)
               AND dt<='${dt}'   
               AND user_period=3  
               AND product_id NOT IN(6883)
             UNION ALL
            SELECT stat_period
                  ,product_id
                  ,last_day_of_week
                  ,last_day_of_month
                  ,user_id
                  ,corever
                  ,mt
                  ,reg_country
                  ,country_level
                  ,current_language2
                  ,source
                  ,user_period
                  ,row_number() OVER (PARTITION BY stat_period,product_id,user_id ORDER BY mt,corever) rn
              FROM dws.dws_wide_video_cn_user_type_info_est_ed
             WHERE period_types=1 
               AND user_period=3 
               AND stat_period>=date_sub('${dt}',interval 120 day ) 
               AND stat_period<='${dt}' 
               AND product_id IN(6883)
           ) a
     WHERE rn=1
),sacc AS (
    SELECT '${bf_1_dt}' AS dt
          ,date(a.create_time) AS stat_period
          ,6883 AS product_id
          ,YEAR(a.create_time) AS years
          ,1 AS period_types
          ,date(date_sub(date_trunc('week',date_add(a.create_time,interval 1 week)),interval 1 day )) AS last_day_of_week
          ,date(date_sub(date_trunc('month',date_add(a.create_time,interval 1 month)),interval 1 day )) AS last_day_of_month
          ,a.account AS user_id 
          ,IF(a.CoreVer2 IS NULL OR a.corever2 = 0, 1, a.corever2) AS corever
          ,a.mt2 
          ,IF(a.reg_country = '', 'unknown', a.reg_country) AS reg_country
          ,NULL AS country_level  
          ,current_language2 AS current_language2
          ,1 AS source
          ,1 AS user_period
          ,now() AS etl_time
      FROM dim.dim_video_cn_accountinfo_view a
     WHERE date(date_add(a.create_time,interval -13 hour)) >=date_sub('${dt}',interval 120 day ) 
       AND date(date_add(a.create_time,interval -13 hour))<='${dt}'
)
,acc AS (
    SELECT dt
          ,lead(dt,1,'9999-12-31') OVER (PARTITION BY product_id,user_id ORDER BY dt,mt,corever) AS end_day
          ,count(1) OVER (PARTITION BY product_id,user_id) num
          ,product_id
          ,weekofyear(date(date_sub(date_trunc('week',date_add(dt,interval 1 week)),interval 1 day ))) AS which_weeks
          ,month(date(date_sub(date_trunc('month',date_add(dt,interval 1 month)),interval 1 day ))) which_months
          ,user_id
          ,corever
          ,mt
          ,reg_country
          ,country_level
          ,current_language2
          ,source
          ,user_period
      FROM dws.dws_srsv_wide_user_type_info_est_di
     WHERE dt>=date_sub('${dt}',interval 120 day ) 
       AND dt<='${dt}' 
       AND user_period=1  
       AND product_id NOT IN(6883)
     UNION ALL
    SELECT stat_period AS dt
          ,lead(stat_period,1,'9999-12-31') OVER (PARTITION BY product_id,user_id ORDER BY stat_period,mt2,corever) AS end_day
          ,count(1) OVER (PARTITION BY product_id,user_id) num
          ,product_id
          ,weekofyear(last_day_of_week) AS which_weeks
          ,month(last_day_of_month) which_months
          ,user_id
          ,corever
          ,mt2
          ,reg_country
          ,country_level
          ,current_language2
          ,source
          ,user_period
      FROM sacc
)
SELECT dt
      ,3 AS user_period
      ,product_id
      ,user_id
      ,ifnull(rn,-99) AS pay_days
      ,which_weeks
      ,which_months
      ,corever
      ,mt
      ,reg_country
      ,country_level
      ,current_language2
      ,source
      ,if(pay_days != rn,0,chargemoney) AS amount
      ,sum(if(pay_days != rn,0,chargemoney)) OVER (PARTITION BY dt
                                                               ,product_id
                                                               ,user_id
                                                               ,which_weeks
                                                               ,which_months
                                                               ,corever
                                                               ,mt
                                                               ,reg_country
                                                               ,country_level
                                                               ,current_language2
                                                               ,source
                                                       ORDER BY rn
                                                  ) AS ltv
      ,now() AS etl_time
  FROM (SELECT dt
              ,end_day
              ,product_id
              ,user_id
              ,which_weeks
              ,which_months
              ,corever
              ,mt
              ,reg_country
              ,country_level
              ,current_language2
              ,source
              ,pay_days
              ,chargeitemcount
              ,chargemoney
              ,lead(pay_days) OVER (PARTITION BY dt
                                                ,product_id
                                                ,user_id
                                                ,which_weeks
                                                ,which_months
                                                ,corever
                                                ,mt
                                                ,reg_country
                                                ,country_level
                                                ,current_language2
                                                ,source 
                                        ORDER BY pay_days
                                   ) lead_pay_days
          FROM (SELECT rmt.dt
                      ,rmt.end_day
                      ,rmt.product_id
                      ,user_id
                      ,rmt.which_weeks
                      ,rmt.which_months
                      ,rmt.corever
                      ,rmt.mt
                      ,rmt.reg_country
                      ,rmt.country_level
                      ,rmt.current_language2
                      ,rmt.source
                      ,datediff(b.dt,rmt.dt) AS pay_days
                      ,sum(b.chargeitemcount) AS chargeitemcount, -- 分层前
                      ,sum(b.chargemoney) AS chargemoney -- 分层后
                  FROM rmt
                  LEFT JOIN (SELECT dt
                                   ,Productid
                                   ,userid
                                   ,chargeitemcount
                                   ,chargemoney
                               FROM dws.dws_trade_user_shopitem_charge_est_ed 
                              WHERE dt>=date_sub('${dt}',interval 30 day ) 
                                AND dt<='${dt}'
                              UNION ALL
                             SELECT dt
                                   ,Product_id
                                   ,user_id
                                   ,charge_itemcount
                                   ,charge_money
                               FROM dws.dws_trade_short_viedo_payorder_est_ed 
                              WHERE dt>=date_sub('${dt}',interval 30 day ) 
                                AND dt<='${dt}'
                             UNION ALL
                             SELECT a.dt
                                   ,a.Product_id
                                   ,user_id
                                   ,a.charge_itemcount*7
                                   ,charge_money_rmb
                               FROM dws.dws_trade_viedo_cn_payorder_est_ed a
                              WHERE dt>=date_sub('${dt}',interval 30 day ) 
                                AND dt<='${dt}' 
                                AND self_type=0
                            ) b
                    ON rmt.dt<=b.dt
                   AND rmt.dt>= date_sub(b.dt,interval 30 day )
                   AND rmt.product_id=b.Productid 
                   AND rmt.user_id=b.userid 
                   AND b.dt<end_day
                 WHERE rmt.dt>=date_sub('${dt}',interval 30 day ) 
                   AND rmt.dt<='${dt}'
                 GROUP BY 1,2,3,4,5,6,7,8,9,10,11,12,13
               )c
       ) d 
  LEFT JOIN tmp
    ON d.pay_days <= tmp.rn 
   AND datediff(d.end_day,d.dt)>rn
   AND if(d.lead_pay_days IS NULL, if(datediff('${dt}',d.dt)<31,datediff('${dt}',d.dt)+1,31),d.lead_pay_days) > rn
 UNION ALL
SELECT d.dt
      ,3 AS user_period
      ,d.product_id
      ,d.user_id
      ,ifnull(pay_days,-99) AS pay_days
      ,d.which_weeks
      ,d.which_months
      ,d.corever
      ,d.mt
      ,d.reg_country
      ,d.country_level
      ,d.current_language2
      ,d.source
      ,amount
      ,ltv
      ,now() AS etl_time
  FROM (SELECT dt
              ,product_id
              ,user_id
              ,which_weeks
              ,which_months
              ,corever
              ,mt
              ,reg_country
              ,country_level
              ,current_language2
              ,source
              ,split(tmp2.unnest,'_')[1] pay_days 
              ,NULL AS amount
              ,split(tmp2.unnest,'_')[2] AS ltv
          FROM (SELECT rmt.dt
                      ,rmt.product_id
                      ,user_id
                      ,rmt.which_weeks
                      ,rmt.which_months
                      ,rmt.corever
                      ,rmt.mt
                      ,rmt.reg_country
                      ,rmt.country_level
                      ,rmt.current_language2
                      ,rmt.source
                      ,sum(if(datediff(b.dt,rmt.dt)<=45,b.chargemoney,0)) AS ltv45
                      ,sum(if(datediff(b.dt,rmt.dt)<=60,b.chargemoney,0)) AS ltv60
                      ,sum(if(datediff(b.dt,rmt.dt)<=90,b.chargemoney,0)) AS ltv90
                      ,sum(if(datediff(b.dt,rmt.dt)<=120,b.chargemoney,0)) AS ltv120
                      ,split(concat_ws('$'
                                       ,concat_ws('_',45,sum(if(datediff(b.dt,rmt.dt)<=45,b.chargemoney,0)))
                                       ,concat_ws('_',60,sum(if(datediff(b.dt,rmt.dt)<=60,b.chargemoney,0)))
                                       ,concat_ws('_',90,sum(if(datediff(b.dt,rmt.dt)<=90,b.chargemoney,0)))
                                       ,concat_ws('_',120,sum(if(datediff(b.dt,rmt.dt)<=120,b.chargemoney,0)))
                                      ),'$'
                            ) AS arr
                  FROM rmt
                  LEFT JOIN (SELECT dt
                                   ,Productid
                                   ,userid
                                   ,chargeitemcount
                                   ,chargemoney
                               FROM dws.dws_trade_user_shopitem_charge_est_ed 
                              WHERE dt>=date_sub('${dt}',interval 120 day ) 
                                AND dt<='${dt}'
                              UNION ALL
                             SELECT dt
                                   ,Product_id
                                   ,user_id
                                   ,charge_itemcount
                                   ,charge_money
                               FROM dws.dws_trade_short_viedo_payorder_est_ed 
                              WHERE dt>=date_sub('${dt}',interval 120 day ) 
                                AND dt<='${dt}'
                              UNION ALL
                             SELECT a.dt
                                   ,a.Product_id
                                   ,user_id
                                   ,a.charge_itemcount*7
                                   ,charge_money_rmb
                               FROM dws.dws_trade_viedo_cn_payorder_est_ed a
                              WHERE dt>=date_sub('${dt}',interval 120 day ) 
                                AND dt<='${dt}' 
                                AND self_type=0
                            ) b 
                    ON rmt.dt<=b.dt 
                   AND rmt.dt>= date_sub(b.dt,interval 120 day )
                   AND rmt.product_id=b.Productid 
                   AND rmt.user_id=b.userid 
                   AND b.dt<end_day
                 GROUP BY 1,2,3,4,5,6,7,8,9,10,11
              )c
          ,unnest(arr) tmp2
       )d
 INNER JOIN rmt 
    ON d.dt=rmt.dt
   AND d.product_id=rmt.product_id
   AND d.user_id=rmt.user_id
   AND d.pay_days<datediff(rmt.end_day,rmt.dt) -- 处理不超过end_day的逻辑
 WHERE pay_days<=datediff('${dt}',rmt.dt) -- 过滤时间还没到的pay_days
 UNION ALL
-- 新用户
SELECT dt
      ,1 AS user_period
      ,product_id
      ,user_id
      ,ifnull(rn,-99) AS pay_days
      ,which_weeks
      ,which_months
      ,corever
      ,mt
      ,reg_country
      ,country_level
      ,current_language2
      ,source
      ,if(pay_days != rn,0,chargemoney) AS amount
      ,sum(if(pay_days != rn,0,chargemoney)) OVER (PARTITION BY dt
                                                               ,product_id
                                                               ,user_id
                                                               ,which_weeks
                                                               ,which_months
                                                               ,corever
                                                               ,mt
                                                               ,reg_country
                                                               ,country_level
                                                               ,current_language2
                                                               ,source
                                                       ORDER BY rn
                                                  ) AS ltv
      ,now() AS etl_time
  FROM (SELECT dt
              ,end_day
              ,product_id
              ,user_id
              ,which_weeks
              ,which_months
              ,corever
              ,mt
              ,reg_country
              ,country_level
              ,current_language2
              ,source
              ,pay_days
              ,chargeitemcount
              ,chargemoney
              ,lead(pay_days) OVER (PARTITION BY dt
                                                ,product_id
                                                ,user_id
                                                ,which_weeks
                                                ,which_months
                                                ,corever
                                                ,mt
                                                ,reg_country
                                                ,country_level
                                                ,current_language2
                                                ,source 
                                        ORDER BY pay_days
                                   ) lead_pay_days
          FROM (SELECT acc.dt
                      ,acc.end_day
                      ,acc.product_id
                      ,user_id
                      ,acc.which_weeks
                      ,acc.which_months
                      ,acc.corever
                      ,acc.mt
                      ,acc.reg_country
                      ,acc.country_level
                      ,acc.current_language2
                      ,acc.source
                      ,datediff(b.dt,acc.dt) AS pay_days
                      ,sum(b.chargeitemcount) AS chargeitemcount
                      ,sum(b.chargemoney) AS chargemoney
                  FROM acc
                  LEFT JOIN (SELECT dt
                                   ,Productid
                                   ,userid
                                   ,chargeitemcount
                                   ,chargemoney
                              FROM dws.dws_trade_user_shopitem_charge_est_ed 
                             WHERE dt>=date_sub('${dt}',interval 30 day ) 
                               AND dt<='${dt}'
                            UNION ALL
                            SELECT dt
                                  ,Product_id
                                  ,user_id
                                  ,charge_itemcount
                                  ,charge_money
                              FROM dws.dws_trade_short_viedo_payorder_est_ed 
                             WHERE dt>=date_sub('${dt}',interval 30 day ) 
                               AND dt<='${dt}'
                            UNION ALL
                            SELECT a.dt
                                  ,a.Product_id
                                  ,user_id
                                  ,a.charge_itemcount*7
                                  ,charge_money_rmb
                              FROM dws.dws_trade_viedo_cn_payorder_est_ed a
                             WHERE dt>=date_sub('${dt}',interval 30 day ) 
                               AND dt<='${dt}' 
                               AND self_type=0
                            ) b 
                    ON acc.dt<=b.dt
                   AND acc.dt>= date_sub(b.dt,interval 30 day )
                   AND acc.product_id=b.Productid 
                   AND acc.user_id=b.userid 
                   AND b.dt<acc.end_day
                 WHERE acc.dt>=date_sub('${dt}',interval 30 day ) 
                   AND acc.dt<='${dt}'
                 GROUP BY 1,2,3,4,5,6,7,8,9,10,11,12,13
              )c
       )d 
       LEFT JOIN tmp
         ON d.pay_days <= tmp.rn 
        AND datediff(d.end_day,d.dt)>rn
        AND if(d.lead_pay_days IS NULL, if(datediff('${dt}',d.dt)<31,datediff('${dt}',d.dt)+1,31),d.lead_pay_days) > rn
UNION ALL
SELECT d.dt,
       1 AS user_period,
       d.product_id,
       d.user_id,
       ifnull(pay_days,-99) AS pay_days,
       d.which_weeks,
       d.which_months,
       d.corever,
       d.mt,
       d.reg_country,
       d.country_level,
       d.current_language2,
       d.source,
       amount,
       ltv,
       now() AS etl_time
  FROM(
            SELECT dt,
                   product_id,
                   user_id,
                   which_weeks,
                   which_months,
                   corever,
                   mt,
                   reg_country,
                   country_level,
                   current_language2,
                   source,
                   split(tmp2.unnest,'_')[1] pay_days ,
                   NULL AS amount,
                   split(tmp2.unnest,'_')[2] AS ltv
              FROM(
                    SELECT acc.dt,
                           acc.product_id,
                           acc.user_id,
                           acc.which_weeks,
                           acc.which_months,
                           acc.corever,
                           acc.mt,
                           acc.reg_country,
                           acc.country_level,
                           acc.current_language2,
                           acc.source,
                           sum(if(datediff(b.dt,acc.dt)<=45,b.chargemoney,0)) AS ltv45,
                           sum(if(datediff(b.dt,acc.dt)<=60,b.chargemoney,0)) AS ltv60,
                           sum(if(datediff(b.dt,acc.dt)<=90,b.chargemoney,0)) AS ltv90,
                           sum(if(datediff(b.dt,acc.dt)<=120,b.chargemoney,0)) AS ltv120,
                           split(concat_ws('$',
                                   concat_ws('_',45,sum(if(datediff(b.dt,acc.dt)<=45,b.chargemoney,0))),
                                   concat_ws('_',60,sum(if(datediff(b.dt,acc.dt)<=60,b.chargemoney,0))),
                                   concat_ws('_',90,sum(if(datediff(b.dt,acc.dt)<=90,b.chargemoney,0))),
                                   concat_ws('_',120,sum(if(datediff(b.dt,acc.dt)<=120,b.chargemoney,0)))
                                         ),
                               '$') AS arr
                      FROM acc
                      LEFT JOIN (SELECT dt
                                       ,Productid
                                       ,userid
                                       ,chargeitemcount
                                       ,chargemoney
                                  FROM dws.dws_trade_user_shopitem_charge_est_ed 
                                 WHERE dt>=date_sub('${dt}',interval 120 day ) 
                                   AND dt<='${dt}'
                                UNION ALL
                                SELECT dt,
                                       Product_id,
                                       user_id,
                                       charge_itemcount,
                                       charge_money
                                  FROM dws.dws_trade_short_viedo_payorder_est_ed 
                                 WHERE dt>=date_sub('${dt}',interval 120 day ) 
                                   AND dt<='${dt}'
                                UNION ALL
                                SELECT a.dt,
                                       a.Product_id,
                                       user_id,
                                       a.charge_itemcount*7,
                                       charge_money_rmb
                                  FROM dws.dws_trade_viedo_cn_payorder_est_ed a
                                 WHERE dt>=date_sub('${dt}',interval 120 day ) 
                                   AND dt<='${dt}' 
                                   AND self_type=0
                               ) b 
                        ON acc.dt<=b.dt 
                       AND acc.dt>= date_sub(b.dt,interval 120 day )
                       AND acc.product_id=b.Productid 
                       AND acc.user_id=b.userid 
                       AND b.dt<acc.end_day
                     GROUP BY 1,2,3,4,5,6,7,8,9,10,11
                  )c,
                  unnest(arr) tmp2
        )d 
        INNER JOIN acc ON d.dt=acc.dt 
                       AND d.product_id=acc.product_id 
                       AND d.user_id=acc.user_id 
                       AND d.pay_days<datediff(acc.end_day,acc.dt) -- 处理不超过end_day的逻辑,新用户的不存在end_day
 WHERE pay_days<=datediff('${dt}',acc.dt);-- 过滤时间还没到的pay_days