----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_sr_resource_book_promotion_conversion
-- workflow_version : 3
-- create_user      : chenmo
-- task_name        : ads_sr_resource_book_promotion_conversion
-- task_version     : 3
-- update_time      : 2025-01-26 14:07:56
-- sql_path         : \starrocks\tbl_ads_sr_resource_book_promotion_conversion\ads_sr_resource_book_promotion_conversion
----------------------------------------------------------------
-- SQL语句
insert into ads.ads_sr_resource_book_promotion_conversion
SELECT  dt -- , event
       ,md5(concat(ifnull(app_product_id, -99), ifnull(os, -99), ifnull(app_core_ver, -99),
        ifnull(position_name, -99), ifnull(strategy_id, -99), ifnull(user_id, -99))) as md5_key
           ,app_product_id as product_id
           ,os
           ,app_core_ver as core
           ,position_name
           ,strategy_id -- 加一层判断：该策略是否存在曝光/点击
           ,user_id
           ,SUM(if(event = '曝光',event_num,0))                                                                               AS exposure_num -- 曝光次数
           ,SUM(if(event = '点击',event_num,0))                                                                               AS click_num -- 点击次数
           ,SUM(if(event = '阅读',read_book_num,0))                                                                           AS read_book_num -- 阅读书籍数
           ,SUM(if(event = '阅读',read_book_num_active,0))                                                                    AS read_book_num_active -- 有效阅读书籍数
           ,SUM(if(event = '阅读',read_chapter_num,0))                                                                        AS read_chapter_num -- 累计阅读章节数(阅读次数)
           ,SUM(if(event = '解锁',event_num,0))                                                                               AS unlock_num -- 解锁次数
           ,SUM(if(event = '解锁',coin_consume,0))                                                                            AS coin_consume -- 阅币消耗
           ,SUM(if(event = '解锁',gift_consume,0))                                                                            AS gift_consume -- 礼券消耗
           ,SUM(if(event = '充值',event_num,0))                                                                               AS recharge_num -- 充值金额
           ,SUM(if(event = '充值',real_recharge,0))                                                                           AS real_recharge -- 充值金额
           ,COUNT( CASE WHEN SUM(if(event IN ( '曝光' ,'点击'),event_num,0)) > 0 THEN 1 END) OVER (PARTITION BY dt,strategy_id) AS activity_strategy -- 有效策略
           ,now() as etl_time
    FROM
    ( -- ----------------- 推书活动 * 曝光 -------------------
        SELECT  dt
               ,'曝光'                                            AS event
               ,app_product_id
               ,os
               ,app_core_ver
               ,CASE WHEN element_id = '100363' THEN '开屏'
                     WHEN element_id = '100390' THEN '弹窗'
                     WHEN element_id = '100391' THEN '悬浮窗'
                     WHEN element_id = '100359' AND page_id = '10001' THEN '书城banner'
                     WHEN element_id = '100351' THEN '底部弹框'
                     WHEN element_id = '100352' THEN '章末推送'
                     WHEN element_id = '100366' THEN '书架顶部'
                     WHEN element_id = '100671' THEN 'TAB'
                     WHEN element_id = '100355' THEN '电池栏推荐'
                     WHEN element_id = '100698' THEN '私信'
                     WHEN element_id = '100723' THEN '活动中心'
                     WHEN element_id = '100371' THEN '搜索热词' END AS position_name -- , element_id
               ,activity_id                                     AS strategy_id
               ,login_id                                        AS user_id
               ,COUNT(1)                                        AS event_num
               ,0                                               AS read_book_num -- 阅读书籍数
               ,0                                               AS read_book_num_active -- 有效阅读书籍数
               ,0                                               AS read_chapter_num -- 累计阅读章节数
               ,0                                               AS coin_consume -- 阅币消耗
               ,0                                               AS gift_consume -- 礼券消耗
               ,0                                               AS real_recharge -- 充值金额
        FROM ads.ads_sensors_production_operationpositionexposure_view
        WHERE dt = '${bf_1_dt}'
        AND element_id IN (100363, 100390, 100391, 100359, 100351, 100352, 100723, 100671, 100355, 100698, 100366, 100371)
        AND element_type IN (4, 7, 8, 22)
        GROUP BY  1,2,3,4,5,6,7,8
        UNION ALL
        SELECT  dt
               ,'曝光' event
               ,app_product_id
               ,os
               ,app_core_ver
               ,'书架推荐'      AS position_name
               ,activity_id AS strategy_id
               ,login_id    AS user_id
               ,COUNT(1)    AS event_num
               ,0           AS read_book_num -- 阅读书籍数
               ,0           AS read_book_num_active -- 有效阅读书籍数
               ,0           AS read_chapter_num -- 累计阅读章节数
               ,0           AS coin_consume -- 阅币消耗
               ,0           AS gift_consume -- 礼券消耗
               ,0           AS real_recharge -- 充值金额
        FROM ads.ads_sensors_production_itemexposure_view
        WHERE dt = '${bf_1_dt}'
        AND page_id = '10005'
        AND element_id = '100321'
        AND activity_id > 0
        GROUP BY  1,2,3,4,5,6,7,8
        UNION ALL
        -- ----------------- 推书活动 * 点击 -------------------
        SELECT  dt
               ,'点击'                                            AS event
               ,app_product_id
               ,os
               ,app_core_ver
               ,CASE WHEN element_id = '100363' THEN '开屏'
                     WHEN element_id = '100390' THEN '弹窗'
                     WHEN element_id = '100391' THEN '悬浮窗'
                     WHEN element_id = '100359' AND page_id = '10001' THEN '书城banner'
                     WHEN element_id = '100351' THEN '底部弹框'
                     WHEN element_id = '100352' THEN '章末推送'
                     WHEN element_id = '100366' THEN '书架顶部'
                     WHEN element_id = '100671' THEN 'TAB'
                     WHEN element_id = '100355' THEN '电池栏推荐'
                     WHEN element_id = '100698' THEN '私信'
                     WHEN element_id = '100723' THEN '活动中心' END AS position_name
               ,activity_id                                     AS strategy_id
               ,login_id                                        AS user_id
               ,COUNT(1)                                        AS event_num
               ,0                                               AS read_book_num -- 阅读书籍数
               ,0                                               AS read_book_num_active -- 有效阅读书籍数
               ,0                                               AS read_chapter_num -- 累计阅读章节数
               ,0                                               AS coin_consume -- 阅币消耗
               ,0                                               AS gift_consume -- 礼券消耗
               ,0                                               AS real_recharge -- 充值金额
        FROM ads.ads_sensors_production_operationpositionclick_view
        WHERE dt = '${bf_1_dt}'
        AND element_id in(100363, 100390, 100391, 100359, 100351, 100352, 100723, 100671, 100355, 100698, 100366, 100371)
        AND element_type IN (4, 7, 8, 22)
        GROUP BY  1,2,3,4,5,6,7,8
        UNION ALL
        SELECT  dt
               ,'点击' event
               ,app_product_id
               ,os
               ,app_core_ver
               ,'书架推荐'      AS position_name
               ,activity_id AS strategy_id
               ,login_id    AS user_id
               ,COUNT(1)    AS event_num
               ,0           AS read_book_num -- 阅读书籍数
               ,0           AS read_book_num_active -- 有效阅读书籍数
               ,0           AS read_chapter_num -- 累计阅读章节数
               ,0           AS coin_consume -- 阅币消耗
               ,0           AS gift_consume -- 礼券消耗
               ,0           AS real_recharge -- 充值金额
        FROM ads.ads_sensors_production_itemclick_view
        WHERE dt = '${bf_1_dt}'
        AND page_id = '10005'
        AND element_id = '100321'
        AND activity_id > 0
        GROUP BY  1,2,3,4,5,6,7,8
        UNION ALL
        SELECT  dt
               ,'点击' event
               ,app_product_id
               ,os
               ,app_core_ver
               ,'串书'                    AS position_name
               ,split(send_id,'_')[4]   AS strategy_id
               ,login_id                AS user_id
               ,COUNT(distinct book_id) AS event_num
               ,0                       AS read_book_num -- 阅读书籍数
               ,0                       AS read_book_num_active -- 有效阅读书籍数
               ,0                       AS read_chapter_num -- 累计阅读章节数
               ,0                       AS coin_consume -- 阅币消耗
               ,0                       AS gift_consume -- 礼券消耗
               ,0                       AS real_recharge -- 充值金额
        FROM ads.ads_sensors_production_startreadingchapter_view
        WHERE dt = '${bf_1_dt}' -- AND activity_link LIKE '%nextbook%'
        AND split(send_id, '_')[2] = 'nextbook'
        GROUP BY  1,2,3,4,5,6,7,8
        -- ----------------- 推书活动 * 点击 -------------------
        -- 单次活动阅读书籍数，有效阅读书籍书（但本书阅读超过3章），累计阅读章节数
        UNION ALL
        SELECT  dt
               ,'阅读' event
               ,app_product_id
               ,os
               ,app_core_ver
               ,position_name
               ,strategy_id
               ,uid
               ,0                                                      AS event_num
               ,COUNT(distinct book_id)                                AS read_book_num -- 阅读书籍数
               ,COUNT(if(one_book_read_chapter_num >= 3,book_id,null)) AS read_book_num_active -- 有效阅读书籍数
               ,SUM(one_book_read_chapter_num)                         AS read_chapter_num -- 累计阅读章节数(阅读次数)
               ,0                                                      AS coin_consume -- 阅币消耗
               ,0                                                      AS gift_consume -- 礼券消耗
               ,0                                                      AS real_recharge -- 充值金额
        FROM
        (
            SELECT  dt
                   ,'阅读' event
                   ,app_product_id
                   ,os
                   ,app_core_ver
                   ,position_name
                   ,strategy_id
                   ,uid
                   ,book_id -- COUNT(distinct book_id) AS read_book_num -- 阅读书籍数
                   ,COUNT(distinct chapter_id)         AS one_book_read_chapter_num -- 阅读章节数
            FROM
            (
                SELECT  dt
                       ,'阅读' event
                       ,app_product_id
                       ,os
                       ,app_core_ver
                       ,CASE WHEN coalesce(split(send_id,'_')[2],split(activity_link,'_')[1] ) = 'flashscreen' THEN '开屏'
                             WHEN coalesce(split(send_id,'_')[2],split(activity_link,'_')[1] ) = 'popup' THEN '弹窗'
                             WHEN coalesce(split(send_id,'_')[2],split(activity_link,'_')[1] ) = 'netmonitor' THEN '悬浮窗'
                             WHEN coalesce(split(send_id,'_')[2],split(activity_link,'_')[1] ) = 'banner' THEN '书城BANNER'
                             WHEN coalesce(split(send_id,'_')[2],split(activity_link,'_')[1] ) = 'reading' THEN '底部弹框'
                             WHEN coalesce(split(send_id,'_')[2],split(activity_link,'_')[1] ) = 'chapterpush' THEN '章末推送'
                             WHEN coalesce(split(send_id,'_')[2],split(activity_link,'_')[1] ) = 'topbookshelf' THEN '书架顶部'
                             WHEN coalesce(split(send_id,'_')[2],split(activity_link,'_')[1] ) = 'centertab' THEN 'TAB'
                             WHEN coalesce(split(send_id,'_')[2],split(activity_link,'_')[1] ) = 'batterybar' THEN '电池栏推荐'
                             WHEN coalesce(split(send_id,'_')[2],split(activity_link,'_')[1] ) = 'news' THEN '私信'
                             WHEN coalesce(split(send_id,'_')[2],split(activity_link,'_')[1] ) = 'actcenter' THEN '活动中心'
                             WHEN coalesce(split(send_id,'_')[2],split(activity_link,'_')[1] ) = 'trends-book' THEN '搜索热词'
                             WHEN coalesce(split(send_id,'_')[2],split(activity_link,'_')[1] ) = 'bookshelf-add' THEN '书架推荐'
                             WHEN coalesce(split(send_id,'_')[2],split(activity_link,'_')[1] ) = 'bookshelf-add0' THEN '书架推荐'
                             WHEN coalesce(split(send_id,'_')[2],split(activity_link,'_')[1] ) = 'nextbook' THEN '串书'  ELSE '其他' END AS position_name
                       ,coalesce(split(send_id,'_')[4],split(activity_link,'_')[4])                                                  AS strategy_id
                       ,login_id                                                                                                     AS uid
                       ,book_id
                       ,chapter_id
                       ,send_id
                       ,activity_link
                FROM ads.ads_sensors_production_startreadingchapter_view
                WHERE dt = '${bf_1_dt}' --
                UNION ALL
                SELECT dt
                , '阅读' event
                , app_product_id
                , CASE WHEN split(app_channel, '_')[3] = 'ios' THEN 'iOS'
                WHEN split(app_channel, '_')[3] = 'android' THEN 'Android' ELSE split(app_channel, '_')[3] END AS os -- 需要先补字段
                , app_core_ver
                , CASE WHEN coalesce(split(send_id, '_')[2], split(activity_link, '_')[1] ) = 'flashscreen' THEN '开屏'
                WHEN coalesce(split(send_id, '_')[2], split(activity_link, '_')[1] ) = 'popup' THEN '弹窗'
                WHEN coalesce(split(send_id, '_')[2], split(activity_link, '_')[1] ) = 'netmonitor' THEN '悬浮窗'
                WHEN coalesce(split(send_id, '_')[2], split(activity_link, '_')[1] ) = 'banner' THEN '书城BANNER'
                WHEN coalesce(split(send_id, '_')[2], split(activity_link, '_')[1] ) = 'reading' THEN '底部弹框'
                WHEN coalesce(split(send_id, '_')[2], split(activity_link, '_')[1] ) = 'chapterpush' THEN '章末推送'
                WHEN coalesce(split(send_id, '_')[2], split(activity_link, '_')[1] ) = 'topbookshelf' THEN '书架顶部'
                WHEN coalesce(split(send_id, '_')[2], split(activity_link, '_')[1] ) = 'centertab' THEN 'TAB'
                WHEN coalesce(split(send_id, '_')[2], split(activity_link, '_')[1] ) = 'batterybar' THEN '电池栏推荐'
                WHEN coalesce(split(send_id, '_')[2], split(activity_link, '_')[1] ) = 'news' THEN '私信'
                WHEN coalesce(split(send_id, '_')[2], split(activity_link, '_')[1] ) = 'actcenter' THEN '活动中心'
                WHEN coalesce(split(send_id, '_')[2], split(activity_link, '_')[1] ) = 'trends-book' THEN '搜索热词'
                WHEN coalesce(split(send_id, '_')[2], split(activity_link, '_')[1] ) = 'bookshelf-add' THEN '书架推荐'
                WHEN coalesce(split(send_id, '_')[2], split(activity_link, '_')[1] ) = 'bookshelf-add0' THEN '书架推荐'
                WHEN coalesce(split(send_id, '_')[2], split(activity_link, '_')[1] ) = 'nextbook' THEN '串书' ELSE '其他' END AS position_name
                , coalesce(split(send_id, '_')[4], split(activity_link, '_')[4]) AS strategy_id
                , login_id AS uid
                , book_id
                , chapter_id
                , send_id
                , activity_link -- 需要先补字段
                FROM ads.ads_sensors_production_endreadingchapter_view
                WHERE dt = '${bf_1_dt}'
            ) z0
            WHERE position_name <> '其他'
            GROUP BY  1,2,3,4,5,6,7,8,9
        )z1
        GROUP BY  1,2,3,4,5,6,7,8
        UNION ALL
        -- ----------------- 推书活动 * 解锁 -------------------
        SELECT  dt
               ,'解锁' event
               ,app_product_id
               ,CASE WHEN os = '1' THEN 'iOS'
                     WHEN os = '4' THEN 'Android'  ELSE '其他' END                                                             AS os
               ,app_core_ver
               ,CASE WHEN coalesce(split(send_id,'_')[2],split(activity_link,'_')[1] ) = 'flashscreen' THEN '开屏'
                     WHEN coalesce(split(send_id,'_')[2],split(activity_link,'_')[1] ) = 'popup' THEN '弹窗'
                     WHEN coalesce(split(send_id,'_')[2],split(activity_link,'_')[1] ) = 'netmonitor' THEN '悬浮窗'
                     WHEN coalesce(split(send_id,'_')[2],split(activity_link,'_')[1] ) = 'banner' THEN '书城BANNER'
                     WHEN coalesce(split(send_id,'_')[2],split(activity_link,'_')[1] ) = 'reading' THEN '底部弹框'
                     WHEN coalesce(split(send_id,'_')[2],split(activity_link,'_')[1] ) = 'chapterpush' THEN '章末推送'
                     WHEN coalesce(split(send_id,'_')[2],split(activity_link,'_')[1] ) = 'topbookshelf' THEN '书架顶部'
                     WHEN coalesce(split(send_id,'_')[2],split(activity_link,'_')[1] ) = 'centertab' THEN 'TAB'
                     WHEN coalesce(split(send_id,'_')[2],split(activity_link,'_')[1] ) = 'batterybar' THEN '电池栏推荐'
                     WHEN coalesce(split(send_id,'_')[2],split(activity_link,'_')[1] ) = 'news' THEN '私信'
                     WHEN coalesce(split(send_id,'_')[2],split(activity_link,'_')[1] ) = 'actcenter' THEN '活动中心'
                     WHEN coalesce(split(send_id,'_')[2],split(activity_link,'_')[1] ) = 'trends-book' THEN '搜索热词'
                     WHEN coalesce(split(send_id,'_')[2],split(activity_link,'_')[1] ) = 'bookshelf-add' THEN '书架推荐'
                     WHEN coalesce(split(send_id,'_')[2],split(activity_link,'_')[1] ) = 'bookshelf-add0' THEN '书架推荐'
                     WHEN coalesce(split(send_id,'_')[2],split(activity_link,'_')[1] ) = 'nextbook' THEN '串书'  ELSE '其他' END AS position_name
               ,coalesce(split(send_id,'_')[4],split(activity_link,'_')[4])                                                  AS strategy_id
               ,identity_login_id                                                                                            AS uid -- , max(split(activity_link, '_')[1])
               ,COUNT(1)                                                                                                     AS event_num -- 解锁次数
               ,0                                                                                                            AS read_book_num -- 阅读书籍数
               ,0                                                                                                            AS read_book_num_active -- 有效阅读书籍数
               ,0                                                                                                            AS read_chapter_num -- 累计阅读章节数
               ,SUM(if(coin_consume > 0,coin_consume,0))                                                                     AS `coin_consume` -- 阅币消耗
               ,SUM(if(gift_consume > 0,gift_consume,0))                                                                     AS `gift_consume` -- 礼券消耗
               ,0                                                                                                            AS real_recharge -- 充值金额
        FROM ads.ads_sensors_production_unlockchapter_view
        WHERE dt = '${bf_1_dt}'
        GROUP BY  1,2,3,4,5,6,7,8
        HAVING position_name <> '其他' -- ----------------- 推书活动 * 查询 充值 -------------------
        UNION ALL
        SELECT  dt
               ,'充值' event
               ,app_product_id
               ,os                 AS os
               ,app_core_ver
               ,position_name      AS position_name
               ,strategy_id        AS strategy_id
               ,uid                AS uid
               ,COUNT(1)           AS event_num -- 充值次数`
               ,0                  AS read_book_num -- 阅读书籍数
               ,0                  AS read_book_num_active -- 有效阅读书籍数
               ,0                  AS read_chapter_num -- 累计阅读章节数
               ,0                  AS coin_consume -- 阅币消耗
               ,0                  AS gift_consume -- 礼券消耗
               ,SUM(real_recharge) AS real_recharge -- as `充值金额`
        FROM
        (
            SELECT  t1.dt
                   ,'充值' event
                   ,app_product_id
                   ,CASE WHEN os = 'IPhone' THEN 'iOS'  ELSE os END                                                               AS os
                   ,app_core_ver
                   ,CASE WHEN coalesce(split(activity_link,'_')[1],split(send_id,'_')[2] ) = 'flashscreen' THEN '开屏'
                         WHEN coalesce(split(activity_link,'_')[1] ,split(send_id,'_')[2] ) = 'popup' THEN '弹窗'
                         WHEN coalesce(split(activity_link,'_')[1] ,split(send_id,'_')[2] ) = 'netmonitor' THEN '悬浮窗'
                         WHEN coalesce(split(activity_link,'_')[1] ,split(send_id,'_')[2] ) = 'banner' THEN '书城BANNER'
                         WHEN coalesce(split(activity_link,'_')[1] ,split(send_id,'_')[2] ) = 'reading' THEN '底部弹框'
                         WHEN coalesce(split(activity_link,'_')[1] ,split(send_id,'_')[2] ) = 'chapterpush' THEN '章末推送'
                         WHEN coalesce(split(activity_link,'_')[1] ,split(send_id,'_')[2] ) = 'topbookshelf' THEN '书架顶部'
                         WHEN coalesce(split(activity_link,'_')[1] ,split(send_id,'_')[2] ) = 'centertab' THEN 'TAB'
                         WHEN coalesce(split(activity_link,'_')[1] ,split(send_id,'_')[2] ) = 'batterybar' THEN '电池栏推荐'
                         WHEN coalesce(split(activity_link,'_')[1] ,split(send_id,'_')[2] ) = 'news' THEN '私信'
                         WHEN coalesce(split(activity_link,'_')[1] ,split(send_id,'_')[2] ) = 'actcenter' THEN '活动中心'
                         WHEN coalesce(split(activity_link,'_')[1] ,split(send_id,'_')[2] ) = 'trends-book' THEN '搜索热词'
                         WHEN coalesce(split(activity_link,'_')[1] ,split(send_id,'_')[2] ) = 'bookshelf-add' THEN '书架推荐'
                         WHEN coalesce(split(activity_link,'_')[1] ,split(send_id,'_')[2] ) = 'bookshelf-add0' THEN '书架推荐'
                         WHEN coalesce(split(activity_link,'_')[1] ,split(send_id,'_')[2] ) = 'nextbook' THEN '串书'  ELSE '其他' END AS position_name
                   ,coalesce(split(send_id,'_')[4],split(activity_link,'_')[4])                                                   AS strategy_id
                   ,t1.identity_login_id                                                                                          AS uid
                   ,real_recharge -- , is_click
                   ,CASE WHEN split(activity_link,'_')[2] IN (4,8) AND split(split(pay_source,'|')[2],'_')[1] = split(activity_link,'_')[6] THEN 1
                         WHEN split(activity_link,'_')[2] IN (7,22) THEN is_click  ELSE 0 END                                     AS is_click
            FROM ads.ads_sensors_production_ordersuccess_view t1
            LEFT JOIN
            (
                SELECT  dt
                       ,identity_login_id
                       ,if(event_strategy_id > 1 ,event_strategy_id,activity_id) AS activity_id
                       ,book_id
                       ,1                                                        AS `is_click`
                FROM ads.ads_sensors_production_itemclick_view
                WHERE dt = '${bf_1_dt}'
                AND element_id = '100625'
                GROUP BY  1,2,3,4
            ) z0
            ON split(activity_link, '_')[2] IN ('7' , '22') AND split(activity_link, '_')[4] = z0.activity_id AND split(split(pay_source, '|')[2], '_')[1] = z0.book_id AND t1.identity_login_id = z0.identity_login_id
            WHERE t1.dt = '${bf_1_dt}'
            AND regexp(pay_source, 'half|Half')
            AND pay_source not LIKE 'Ps_HalfLimitFreeCard%%'
            AND split(activity_link, '_')[2] IN (4, 8, 7, 22)
        ) a0
        WHERE position_name <> '其他'
        AND is_click = 1
        GROUP BY  1,2,3,4,5,6,7,8
    ) z0
    WHERE position_name <> '其他'
    GROUP BY  1,2,3,4,5,6,7,8;
