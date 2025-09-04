insert into  ads.ads_bi_sv_recharge_user_detail_west5_di
-- 活跃表
WITH t123 AS (
    SELECT t1.dt
          ,t1.user_id
          ,period_type
          ,user_type
          ,dic_lang.remarks
          ,CASE WHEN country_level = 1 THEN 'T1'
                WHEN country_level = 2 THEN 'T2'
                ELSE '其他'
            END AS country_level
          ,dic_mt.enum_name
          ,COALESCE(t1.corever, '其他') AS corever
      FROM dws.dws_user_short_video_wide_active_period_west5_ed t1
      LEFT JOIN dim.dim_dic dic_lang  -- 注册/投放语言
        ON t1.current_language2 = dic_lang.enum_id
       AND dic_lang.table_name = 'dim_producttype'
       AND dic_lang.dic_column = 'language_id'
      LEFT JOIN dim.dim_dic dic_mt
        ON t1.mt = dic_mt.enum_id
       AND dic_mt.table_name = 'dim_user_accountinfo_df'
       AND dic_mt.dic_column = 'mt'
      LEFT JOIN dim.dim_country_dic b
        ON t1.reg_country = b.code
     WHERE dt = '${bf_1_dt}'
       AND product_id = 6833
     GROUP BY 1, 2, 3, 4, 5, 6, 7, 8
)
-- 订单表数据
,t2 AS (
    SELECT '${bf_1_dt}' AS dt
          ,a.create_time
          ,a.user_id
          ,a.corever2
          ,dic_mt.enum_name
          ,CASE WHEN a.item_count < 10 THEN CONCAT('00', CAST(a.item_count AS VARCHAR))
                WHEN a.item_count < 100 THEN CONCAT('0', CAST(a.item_count AS VARCHAR))
                ELSE CAST(a.item_count AS VARCHAR)
            END AS item_count
          ,a.base_amount / 100 base_amount
          ,a.shop_item
          ,a.package_id
          ,CASE WHEN SPLIT(get_json_string(a.custom_data, '$.sendId'), '_')[1] = '201300' THEN '商店页'
                WHEN SPLIT(get_json_string(a.custom_data, '$.sendId'), '_')[1] = '200900' THEN '半屏'
                WHEN SPLIT(get_json_string(a.custom_data, '$.sendId'), '_')[1] = '203300' THEN 'H5'
                WHEN SPLIT(get_json_string(a.custom_data, '$.sendId'), '_')[1] IS NULL THEN '半屏'
                WHEN SPLIT(get_json_string(a.custom_data, '$.sendId'), '_')[1] = '202100' AND SPLIT(get_json_string(a.custom_data, '$.sendId'), '_')[2] IN ('0', '1') THEN '普通弹窗'
                WHEN SPLIT(get_json_string(a.custom_data, '$.sendId'), '_')[1] = '202100'
                     AND SPLIT(get_json_string(a.custom_data, '$.sendId'), '_')[2] IN ('3') THEN '充值返回推弹窗'
                ELSE '其他'
            END AS recharge_source
          ,get_json_string(a.custom_data, '$.activityId') activity_id
          ,get_json_string(a.custom_data, '$.strategyId') strategy_id
          ,get_json_string(a.cooorder_extinfo, '$.SubscribeStatus') SubscribeStatus
          ,CASE WHEN a.shop_item = 0 THEN '普通充值'
                WHEN a.shop_item = 810 THEN 'SVIP'
                WHEN a.shop_item = 840 THEN '签到卡'
                ELSE '其他'
            END AS shop_item_type
          ,IFNULL(b.vip_type, CASE WHEN datediff(a.vip_expire_time, a.create_time) >= 25 AND datediff(a.vip_expire_time, a.create_time) <= 35 THEN 1 -- 月卡
                                   WHEN datediff(a.vip_expire_time, a.create_time) >= 80 AND datediff(a.vip_expire_time, a.create_time) <= 100 THEN 2 -- 季卡
                                   WHEN datediff(a.vip_expire_time, a.create_time) >= 350 AND datediff(a.vip_expire_time, a.create_time) <= 380 THEN 3 -- 年卡
                                   WHEN datediff(a.vip_expire_time, a.create_time) >= 1 AND datediff(a.vip_expire_time, a.create_time) <= 9 THEN 4 -- 周卡
                               END
                 ) AS vip_type
          ,a.subpay_type
          ,seconds_diff(c.FinishTime, a.create_time) AS finish_time
      FROM ads.ads_short_video_payorder_view a  -- dwd_trade_short_video_payorder
      LEFT JOIN (SELECT item_id
                       ,shop_item_id
                       ,vip_type
                   FROM dim.dim_short_video_goods_view
                  WHERE shop_item_id IN (840, 810)
                    AND is_remove = 0
                  GROUP BY 1, 2, 3
                 ) b
        ON SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(ExtInfo, '|', -1)
                                                                           , 'com.changdu.mobovideo.', -1
                                                                          )
                                                           , 'com.changdu.moboshort.', -1
                                                          )
                                           , 'com.changjian.moboshortcj.', -1
                                          )
                           , 'third.', -1
                          ) = b.item_id
       AND a.shop_item = b.shop_item_id
      LEFT JOIN dim.dim_dic dic_mt  -- mt
        ON a.mt = dic_mt.enum_id
       AND dic_mt.table_name = 'dim_user_accountinfo_df'
       AND dic_mt.dic_column = 'mt'
      LEFT JOIN ods.ods_tidb_sr_sharpengine_pay_hk_sync_payorder_di c
        ON a.order_id = c.OrderSerialId
     WHERE a.test_flag = 0
       AND a.dt >= '${bf_1_dt}'
       AND a.dt <= '${dt}'
       AND DATE(date_sub(a.create_time, INTERVAL 13 HOUR)) = '${bf_1_dt}'
)
-- 充值档位曝光事件
, t3 AS (
    SELECT '${bf_1_dt}' AS dt
          ,CASE WHEN element_id = '200900' OR page_id = '200900' THEN '半屏'
                WHEN page_id = '201300' THEN '商店页'
                WHEN page_id = '203300' THEN 'H5'
                WHEN element_id = '202100' AND element_type IN ('0', '1') THEN '普通弹窗'
                WHEN element_id = '202100' AND element_type IN ('3') THEN '充值返回推弹窗'
                ELSE '其他'
            END AS recharge_source
          ,event_strategy_id strategy_id
          ,login_id user_id
          ,core
          ,os
          ,COUNT(login_id) AS exposure_pv
     FROM ads.ads_sensors_cd_video_rechargeexposure_view
    WHERE dt >= '${bf_1_dt}'
      AND dt <= '${dt}'
      AND DATE(date_add(event_tm, INTERVAL -13 HOUR)) = '${bf_1_dt}'
      AND product_id = '6833'
    GROUP BY 1, 2, 3, 4, 5, 6
)
-- 广告曝光事件
, t3a AS (
    SELECT '${bf_1_dt}' AS dt
          ,CASE WHEN element_id = '200900' OR page_id = '200900' THEN '半屏'
                WHEN page_id = '201300' THEN '商店页'
                WHEN page_id = '203300' THEN 'H5'
                WHEN element_id = '202100' AND element_type IN ('0', '1') THEN '普通弹窗'
                WHEN element_id = '202100' AND element_type IN ('3') THEN '充值返回推弹窗'
                ELSE '其他'
            END AS recharge_source
          ,main_strategy_id strategy_id
          ,login_id user_id
          ,core
          ,os
          ,COUNT(login_id) AS ad_exposure_pv
      FROM ads.ads_sensors_cd_video_adpositionexposure_view
     WHERE dt >= '2025-03-26' --改功能03.26上线
       AND dt >= '${bf_1_dt}'
       AND dt <= '${dt}'
       AND DATE(date_add(event_tm, INTERVAL -13 HOUR)) = '${bf_1_dt}'
       AND product_id = '6833'
       AND main_strategy_id IS NOT NULL
     GROUP BY 1, 2, 3, 4, 5, 6
)
-- 广告收益数据
, t3b AS (
    SELECT dt
          ,'半屏' AS recharge_source
          ,main_strategy_id strategy_id
          ,user_id
          ,core
          ,dic_mt.enum_name
          ,SUM(amt) AS amt
     FROM dws.dws_advertisement_user_position_amt_west5_ed a
     LEFT JOIN dim.dim_dic dic_mt  -- mt
       ON a.mt = dic_mt.enum_id
      AND dic_mt.table_name = 'dim_user_accountinfo_df'
      AND dic_mt.dic_column = 'mt'
    WHERE dt = '${bf_1_dt}'
      AND product_id = 6833
      AND main_strategy_id IS NOT NULL
    GROUP BY 1, 2, 3, 4, 5, 6
)
-- 创建订单事件
, t4 AS (
    SELECT CASE WHEN element_id = '200900' OR page_id = '200900' THEN '半屏'
                WHEN page_id = '201300' THEN '商店页'
                WHEN page_id = '203300' THEN 'H5'
                WHEN element_id = '202100' AND element_type IN ('0', '1') THEN '普通弹窗'
                WHEN element_id = '202100' AND element_type IN ('3') THEN '充值返回推弹窗'
                ELSE '其他'
            END AS recharge_source
          ,CASE WHEN CAST(real_recharge AS FLOAT) < 10 THEN CONCAT('00', real_recharge)
                WHEN CAST(real_recharge AS FLOAT) < 100 THEN CONCAT('0', real_recharge)
                ELSE real_recharge
            END AS item_count
          ,event_strategy_id strategy_id
          ,CASE WHEN czlx = 'vip' THEN 'SVIP'
                WHEN czlx = '签到卡充值' THEN '签到卡'
                ELSE '普通充值'
            END AS shop_item_type
          ,login_id user_id
          ,core
          ,os AS mt
          ,'${bf_1_dt}' AS dt
          ,zffs AS subpay_type
          ,send_id
      FROM ads.ads_sensors_cd_video_ordercreateaction_view
     WHERE dt >= '${bf_1_dt}'
       AND dt <= '${dt}'
       AND DATE(date_add(event_tm, INTERVAL -13 HOUR)) = '${bf_1_dt}'
       AND app_id = 683001001
     GROUP BY 1, 2, 3, 4, 5, 6, 7, 8, 9, 10
)
-- 活跃关联曝光
, z1 AS (
    SELECT dt
          ,period_type
          ,user_id
          ,user_type
          ,remarks
          ,country_level
          ,mt
          ,corever
          ,recharge_source
          ,strategy_id
          ,MAX(exposure_uv) AS exposure_uv
          ,MAX(exposure_pv) AS exposure_pv
          ,MAX(ad_exposure_uv) AS ad_exposure_uv
          ,MAX(ad_exposure_pv) AS ad_exposure_pv
      FROM (SELECT t3.dt
                  ,t123.period_type
                  ,t123.user_id
                  ,t123.user_type
                  ,t123.remarks
                  ,t123.country_level
                  ,IFNULL(t3.os, t123.enum_name) AS mt
                  ,IFNULL(t3.core, t123.corever) AS corever
                  ,CASE WHEN t3.strategy_id IS NULL THEN '续订(或策略id为空)'
                        WHEN t3.strategy_id IN (21907679071567884,21412617518317655,21412110712176725,21411962535805011
                                               ,59996164203217021,90064658960220161,72785256107606176
                                               ) THEN '商店页'
                        ELSE t3.recharge_source
                    END AS recharge_source
                  ,CASE
                       WHEN t3.strategy_id IS NULL THEN '续订(或策略id为空)'
                       ELSE t3.strategy_id
                   END AS strategy_id
                  ,1 AS exposure_uv
                  ,SUM(t3.exposure_pv) AS exposure_pv
                  ,0 AS ad_exposure_uv
                  ,0 AS ad_exposure_pv
              FROM t123
              LEFT JOIN t3
                ON t123.user_id = t3.user_id
               AND t123.dt = t3.dt
             GROUP BY 1, 2, 3, 4, 5, 6, 7, 8, 9, 10
             UNION ALL
            SELECT t3a.dt
                  ,t123.period_type
                  ,t123.user_id
                  ,t123.user_type
                  ,t123.remarks
                  ,t123.country_level
                  ,IFNULL(t3a.os, t123.enum_name) AS mt
                  ,IFNULL(t3a.core, t123.corever) AS corever
                  ,CASE WHEN t3a.strategy_id IS NULL THEN '续订(或策略id为空)'
                        WHEN t3a.strategy_id IN (21907679071567884,21412617518317655,21412110712176725,21411962535805011
                                                 ,59996164203217021,90064658960220161,72785256107606176
                                                ) THEN '商店页'
                        ELSE t3a.recharge_source
                   END AS recharge_source
                  ,CASE WHEN t3a.strategy_id IS NULL THEN '续订(或策略id为空)'
                        ELSE t3a.strategy_id
                    END AS strategy_id
                  ,0 AS exposure_uv
                  ,0 AS exposure_pv
                  ,1 AS ad_exposure_uv
                  ,SUM(t3a.ad_exposure_pv) AS ad_exposure_pv
              FROM t123
             INNER JOIN t3a
                ON t123.user_id = t3a.user_id
               AND t123.dt = t3a.dt
             GROUP BY 1, 2, 3, 4, 5, 6, 7, 8, 9, 10
           ) z1a
     WHERE 1 = 1
     GROUP BY 1, 2, 3, 4, 5, 6, 7, 8, 9, 10
)
-- 活跃关联充值
, z2 AS (
    SELECT *
      FROM (SELECT t2.dt
                  ,t123.period_type
                  ,t123.user_id
                  ,t123.user_type
                  ,t123.remarks
                  ,t123.country_level
                  ,ifnull(t2.enum_name, t123.enum_name) AS mt
                  ,ifnull(t2.corever2, t123.corever)    AS corever
                  ,CASE WHEN strategy_id IS NULL THEN '续订(或策略id为空)'
                        WHEN SubscribeStatus = 2 AND shop_item_type IN ('SVIP','签到卡') THEN '续订(或策略id为空)'
                        WHEN strategy_id IN (21907679071567884,21412617518317655,21412110712176725,21411962535805011
                                             ,59996164203217021,90064658960220161,72785256107606176
                                            ) THEN '商店页'
                        WHEN strategy_id IN (119945781576073372,119945781576073373,119945781576073374,119945781576073375,119945781576073376,119945781576073377,119945781576073378
                                            ,119945781576073379,119945781576073380,119945781576073381,119945781576073382,119945781576073383,119741098431744170,119741098431744171
                                            ) THEN 'H5'
                        ELSE recharge_source
                    END recharge_source
                  ,CASE WHEN strategy_id IS NULL THEN '续订(或策略id为空)'
                        ELSE strategy_id
                    END strategy_id
                  ,shop_item_type                         -- 档位类型
                  ,vip_type
                  ,ifnull(subpay_type, '三方支付')        AS subpay_type
                  ,item_count                             -- 充值档位
                  ,1                                      AS recharge_un
                  ,count(t2.user_id)                      AS recharge_times       -- 充值次数
                  ,sum(base_amount)                       AS recharge_amount      -- 充值金额
                  ,sum(CASE WHEN shop_item_type = '普通充值' THEN base_amount END)     AS normal_recharge_amount   -- 充值金额-普通充值
                  ,sum(CASE WHEN shop_item_type = '签到卡' THEN base_amount END)       AS signin_recharge_amount    -- 充值金额-签到卡
                  ,sum(CASE WHEN shop_item_type = 'SVIP' THEN base_amount END)         AS svip_recharge_amount      -- 充值金额-SVIP
                  ,count(CASE WHEN shop_item_type = '普通充值' THEN t2.user_id END)    AS normal_recharge_times    -- 充值次数-普通充值
                  ,count(CASE WHEN shop_item_type = '签到卡' THEN t2.user_id END)      AS signin_recharge_times     -- 充值次数-签到卡
                  ,count(CASE WHEN shop_item_type = 'SVIP' THEN t2.user_id END)        AS svip_recharge_times       -- 充值次数-SVIP
                  ,sum(CASE WHEN shop_item_type = '普通充值' THEN 1 END)               AS normal_recharge_un        -- 充值人数-普通充值
                  ,sum(DISTINCT CASE WHEN shop_item_type = '签到卡' THEN 1 END)        AS signin_recharge_un        -- 充值人数-签到卡
                  ,sum(DISTINCT CASE WHEN shop_item_type = 'SVIP' THEN 1 END)          AS svip_recharge_un          -- 充值人数-SVIP
                  ,sum(DISTINCT CASE WHEN shop_item_type != '普通充值' THEN 1 END)     AS recharge_un_subscription  -- 充值人数-订阅
                  ,avg(finish_time)                       AS finish_time
              FROM t123
             INNER JOIN t2
                ON t123.user_id = t2.user_id
               AND t123.dt = t2.dt
             GROUP BY 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14
           ) z2a
     WHERE 1 = 1
)
-- 活跃关联广告收益
, z3 AS (
    SELECT *
      FROM (SELECT t3b.dt
                  ,t123.period_type
                  ,t123.user_id
                  ,t123.user_type
                  ,t123.remarks
                  ,t123.country_level
                  ,ifnull(t3b.enum_name, t123.enum_name) AS mt
                  ,ifnull(t3b.core, t123.corever)        AS corever
                  ,recharge_source
                  ,strategy_id
                  ,sum(amt)                              AS ad_amt
              FROM t123
             INNER JOIN t3b
                ON t123.user_id = t3b.user_id
               AND t123.dt = t3b.dt
             GROUP BY 1, 2, 3, 4, 5, 6, 7, 8, 9, 10
           ) z3a
     WHERE 1 = 1
)
,z4 AS (
    SELECT account_id          AS user_id
          ,value_micros * 1000 AS sv_last_preload_ecpm
      FROM (SELECT account_id
                  ,value_micros
                  ,create_time
                  ,ROW_NUMBER() OVER (PARTITION BY account_id ORDER BY ID DESC) AS rn
              FROM dwd.dwd_sv_advertise_ad_preload_revenue_di_view -- ods_tidb_sv_short_video_log_ad_preload_revenue_di
           ) t
     WHERE rn = 1
)
,z5 AS (
    SELECT user_id
          ,recharge_amount AS recharge_mode
      FROM (SELECT user_id
                  ,item_count  AS recharge_amount
                  ,Frequency
                  ,ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY Frequency DESC) AS rn
              FROM (SELECT user_id
                          ,item_count
                          ,COUNT(1) AS Frequency
                      FROM dwd.dwd_trade_short_video_payorder   -- dwd_trade_short_video_payorder
                     GROUP BY 1, 2
                   ) t1
           ) t2
      WHERE rn = 1
)
-- 活跃关联创建订单
, z6 AS (
    SELECT coalesce(z1.dt, z2.dt)                              AS dt
          ,coalesce(z1.period_type, z2.period_type)            AS period_type                 -- 周期类型
          ,coalesce(z1.strategy_id, z2.strategy_id)            AS strategy_id                 -- 策略ID
          ,coalesce(z1.recharge_source, z2.recharge_source)    AS recharge_source             -- 充值来源
          ,coalesce(z1.user_id, z2.user_id)                    AS user_id                     -- 用户id
          ,coalesce(z1.user_type, z2.user_type)                AS user_type                   -- 用户类型
          ,coalesce(z1.remarks, z2.remarks)                    AS remarks                     -- 投放语言
          ,coalesce(z1.country_level, z2.country_level)        AS country_level               -- 国家等级
          ,coalesce(z1.mt, z2.mt)                              AS mt                          -- 终端
          ,coalesce(z1.corever, z2.corever)                    AS corever                     -- core
          ,z2.shop_item_type                                   AS shop_item_type              -- 档位类型
          ,z2.vip_type
          ,z2.subpay_type
          ,z2.item_count                                       AS item_count                  -- 充值档位
          ,z2.recharge_un                                      AS recharge_un                 -- 充值人数
          ,z2.recharge_times                                   AS recharge_times              -- 充值次数
          ,z2.recharge_amount                                  AS recharge_amount             -- 充值金额
          ,z2.normal_recharge_amount                           AS normal_recharge_amount      -- 充值金额-普通充值
          ,z2.signin_recharge_amount                           AS signin_recharge_amount      -- 充值金额-签到卡
          ,z2.svip_recharge_amount                             AS svip_recharge_amount        -- 充值金额-SVIP
          ,z2.normal_recharge_times                            AS normal_recharge_times       -- 充值次数-普通充值
          ,z2.signin_recharge_times                            AS signin_recharge_times       -- 充值次数-签到卡
          ,z2.svip_recharge_times                              AS svip_recharge_times         -- 充值次数-SVIP
          ,z2.normal_recharge_un                               AS normal_recharge_un          -- 充值人数-普通充值
          ,z2.signin_recharge_un                               AS signin_recharge_un          -- 充值人数-签到卡
          ,z2.svip_recharge_un                                 AS svip_recharge_un            -- 充值人数-SVIP
          ,z2.recharge_un_subscription                         AS recharge_un_subscription    -- 充值人数-订阅
          ,z2.finish_time                                      AS finish_time                 -- 订单完成用时
          ,z1.create_order_num
      FROM (SELECT t4.dt
                  ,t123.period_type
                  ,t123.user_id
                  ,t123.user_type
                  ,t123.remarks
                  ,t123.country_level
                  ,ifnull(t4.mt, t123.enum_name)       AS mt
                  ,ifnull(t4.core, t123.corever)       AS corever
                  ,CASE WHEN t4.strategy_id IS NULL THEN '续订(或策略id为空)'
                        WHEN t4.strategy_id IN (21907679071567884,21412617518317655,21412110712176725
                                               ,21411962535805011,59996164203217021,90064658960220161,72785256107606176
                                               ) THEN '商店页'
                        ELSE t4.recharge_source
                    END recharge_source
                  ,CASE WHEN t4.strategy_id IS NULL THEN '续订(或策略id为空)'
                        ELSE t4.strategy_id
                    END strategy_id
                  ,shop_item_type                     -- 档位类型
                  ,item_count                         -- 充值档位
                  ,subpay_type
                  ,count(1)                            AS create_order_num
              FROM t123
             INNER JOIN t4
                ON t123.user_id = t4.user_id
               AND t123.dt = t4.dt
             GROUP BY 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13
           ) z1
      FULL JOIN z2
        ON z1.strategy_id = z2.strategy_id
       AND z1.recharge_source = z2.recharge_source
       AND z1.dt = z2.dt
       AND z1.period_type = z2.period_type
       AND z1.user_id = z2.user_id
       AND z1.shop_item_type = z2.shop_item_type
       AND z1.item_count = z2.item_count
       AND z1.subpay_type = z2.subpay_type
     WHERE 1 = 1
)
,date AS (
    SELECT dt
          ,period_type
          ,strategy_id
          ,recharge_source
          ,z13.user_id
          ,row_1
          ,6833                                     AS product_id
          ,user_type
          ,remarks                                  AS put_language
          ,country_level
          ,mt
          ,corever
          ,NULL                                     AS strategy_name
          ,NULL                                     AS strategy_weight
          ,NULL                                     AS strategy_code
          ,z4.sv_last_preload_ecpm
          ,z5.recharge_mode
          ,IF(row_1 = 1, exposure_uv, 0)            AS exposure_uv
          ,IF(row_1 = 1, exposure_pv, 0)            AS exposure_pv
          ,IF(row_1 = 1, ad_exposure_uv, 0)         AS ad_exposure_uv
          ,IF(row_1 = 1, ad_exposure_pv, 0)         AS ad_exposure_pv
          ,IF(row_1 = 1, ad_amt, 0)                 AS ad_amt
          ,IFNULL(shop_item_type, 0)                AS shop_item_type
          ,IFNULL(vip_type, 0)                      AS vip_type
          ,IFNULL(subpay_type, '三方支付')          AS subpay_type
          ,IFNULL(item_count, 0)                    AS item_count
          ,IFNULL(recharge_un, 0)                   AS recharge_un
          ,IFNULL(recharge_times, 0)                AS recharge_times
          ,IFNULL(recharge_amount, 0)               AS recharge_amount
          ,IFNULL(normal_recharge_amount, 0)        AS normal_recharge_amount
          ,IFNULL(signin_recharge_amount, 0)        AS signin_recharge_amount
          ,IFNULL(svip_recharge_amount, 0)          AS svip_recharge_amount
          ,IFNULL(normal_recharge_times, 0)       AS normal_recharge_times
          ,IFNULL(signin_recharge_times, 0)       AS signin_recharge_times
          ,IFNULL(svip_recharge_times, 0)         AS svip_recharge_times
          ,IFNULL(normal_recharge_un, 0)          AS normal_recharge_un
          ,IFNULL(signin_recharge_un, 0)          AS signin_recharge_un
          ,IFNULL(svip_recharge_un, 0)            AS svip_recharge_un
          ,IFNULL(recharge_un_subscription, 0)    AS recharge_un_subscription
          ,IF(recharge_amount > 0, 1, 0)            AS is_recharge
          ,finish_time
          ,create_order_num
          ,NOW()                                    AS etl_time
      FROM (SELECT z12.*
                 ,ROW_NUMBER() OVER(PARTITION BY dt, recharge_source, strategy_id, period_type, user_id
                                        ORDER BY shop_item_type, vip_type
                                   ) AS row_1
              FROM (SELECT coalesce(z1.dt, z6.dt)                              AS dt
                          ,coalesce(z1.period_type, z6.period_type)            AS period_type        -- 周期类型
                          ,coalesce(z1.strategy_id, z6.strategy_id)            AS strategy_id        -- 策略ID
                          ,coalesce(z1.recharge_source, z6.recharge_source)    AS recharge_source    -- 充值来源
                          ,coalesce(z1.user_id, z6.user_id)                    AS user_id            -- 用户id
                          ,coalesce(z1.user_type, z6.user_type)                AS user_type          -- 用户类型
                          ,coalesce(z1.remarks, z6.remarks)                    AS remarks            -- 投放语言
                          ,coalesce(z1.country_level, z6.country_level)        AS country_level      -- 国家等级
                          ,coalesce(z1.mt, z6.mt)                              AS mt                 -- 终端
                          ,coalesce(z1.corever, z6.corever)                    AS corever            -- core
                          ,coalesce(z1.exposure_uv, 0)                         AS exposure_uv        -- 曝光UV
                          ,coalesce(z1.exposure_pv, 0)                         AS exposure_pv        -- 曝光PV
                          ,coalesce(z1.ad_exposure_uv, 0)                      AS ad_exposure_uv     -- 广告曝光UV
                          ,coalesce(z1.ad_exposure_pv, 0)                      AS ad_exposure_pv     -- 广告曝光PV
                          ,coalesce(z3.ad_amt, 0)                              AS ad_amt             -- 广告收益
                          ,z6.shop_item_type                                                         -- 档位类型
                          ,z6.vip_type
                          ,z6.subpay_type
                          ,z6.item_count                                                             -- 充值档位
                          ,z6.recharge_un                                                            -- 充值人数
                          ,z6.recharge_times                                                         -- 充值次数
                          ,z6.recharge_amount                                                        -- 充值金额
                          ,z6.normal_recharge_amount                                                 -- 充值金额-普通充值
                          ,z6.signin_recharge_amount                                                 -- 充值金额-签到卡
                          ,z6.svip_recharge_amount                                                   -- 充值金额-SVIP
                          ,z6.normal_recharge_times                                                  -- 充值次数-普通充值
                          ,z6.signin_recharge_times                                                  -- 充值次数-签到卡
                          ,z6.svip_recharge_times                                                    -- 充值次数-SVIP
                          ,z6.normal_recharge_un                                                     -- 充值人数-普通充值
                          ,z6.signin_recharge_un                                                     -- 充值人数-签到卡
                          ,z6.svip_recharge_un                                                       -- 充值人数-SVIP
                          ,z6.recharge_un_subscription                                               -- 充值人数-订阅
                          ,z6.finish_time                                                            -- 订单完成用时
                          ,z6.create_order_num                                                       -- 创建订单数
                      FROM z1
                      FULL JOIN z6
                        ON z1.strategy_id = z6.strategy_id
                       AND z1.recharge_source = z6.recharge_source
                       AND z1.dt = z6.dt
                       AND z1.period_type = z6.period_type
                       AND z1.user_id = z6.user_id
                      FULL JOIN z3
                        ON z1.strategy_id = z3.strategy_id
                       AND z1.recharge_source = z3.recharge_source
                       AND z1.dt = z3.dt
                       AND z1.period_type = z3.period_type
                       AND z1.user_id = z3.user_id
                   ) z12
           ) z13
      LEFT JOIN z4
        ON z13.user_id = z4.user_id
      LEFT JOIN z5
        ON z13.user_id = z5.user_id
     WHERE dt is not null
)
SELECT date.* FROM date
;