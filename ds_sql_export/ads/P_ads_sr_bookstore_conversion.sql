----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_sr_bookstore_conversion
-- workflow_version : 3
-- create_user      : chenmo
-- task_name        : ads_sr_bookstore_conversion
-- task_version     : 2
-- update_time      : 2025-01-26 14:18:38
-- sql_path         : \starrocks\tbl_ads_sr_bookstore_conversion\ads_sr_bookstore_conversion
----------------------------------------------------------------
-- SQL语句
insert into ads.ads_sr_bookstore_conversion
SELECT  dt
        ,md5(concat(ifnull(app_product_id, -99), ifnull(os, -99), ifnull(app_core_ver, -99),
        ifnull(list_id, -99), ifnull(module_channel_id, -99), ifnull(programme_id, -99), ifnull(book_id, -99), ifnull(login_id, -99))) as md5_key
    --    ,'曝光' AS event
       ,app_product_id
       ,os
       ,app_core_ver
       ,list_id -- 榜单
       ,module_channel_id -- 频道
       ,programme_id -- 方案
       ,book_id
       ,login_id
       ,sum(if(event = '曝光',event_num,0)) AS exposure_num -- `曝光次数`
       ,sum(if(event = '点击',event_num,0)) AS click_num -- `点击次数`
       ,sum(if(event = '阅读',read_chapter_num,0)) AS read_chapter_num --  `阅读章节数`
       ,sum(if(event = '阅读' and read_chapter_num >= 2,1,0)) is_read_active --  `有效阅读次数`
       ,sum(if(event = '解锁',event_num,0)) AS unlock_num --  `解锁次数`
       ,sum(if(event = '解锁',coin_consume,0)) AS unlock_coin_consume-- `解锁阅币消耗`
       ,sum(if(event = '解锁',gift_consume,0)) AS recharge_gift_consume -- `解锁礼券消耗`
       ,sum(if(event = '充值',event_num,0)) AS recharge_num -- `充值次数`
       ,sum(if(event = '充值',real_recharge,0)) AS recharge_amount -- `充值金额`
       ,now() AS etl_time
FROM  (
-- ----------------- 书城 ** 曝光 -------------------
SELECT  dt
       ,'曝光'     AS event
       ,app_product_id
       ,os
       ,app_core_ver
       ,list_id -- 榜单
       ,module_channel_id -- 频道
       ,programme_id -- 方案
       ,book_id
       ,login_id
       ,COUNT(1) AS event_num
       ,0 read_chapter_num
       ,0        AS coin_consume
       ,0        AS gift_consume
       ,0        AS real_recharge
FROM ads.ads_sensors_production_itemexposure_view a1
WHERE dt = '${bf_1_dt}'
AND ((page_id = '10001' AND element_id = '100597') or element_id = '100613')
GROUP BY  1,2,3,4,5,6,7,8,9,10
-- ----------------- 书城 ** 点击 -------------------
UNION ALL
SELECT  dt
       ,'点击'     AS event
       ,app_product_id
       ,os
       ,app_core_ver
       ,list_id -- 榜单
       ,module_channel_id -- 频道
       ,programme_id -- 方案
       ,book_id
       ,login_id
       ,COUNT(1) AS event_num
       ,0        AS read_chapter_num
       ,0        AS coin_consume
       ,0        AS gift_consume
       ,0        AS real_recharge
FROM ads.ads_sensors_production_itemclick_view
WHERE dt = '${bf_1_dt}'
AND ((page_id = '10001' AND element_id = '100597') or element_id = '100613')
GROUP BY  1,2,3,4,5,6,7,8,9,10
UNION ALL
-- ----------------- 书城 ** 阅读 -------------------
SELECT  dt
       ,'阅读'                       AS event
       ,app_product_id
       ,os
       ,app_core_ver
       ,list_id -- 榜单
       ,module_channel_id -- 频道
       ,programme_id -- 方案
       ,book_id
       ,login_id
       ,0                          AS event_num
       ,COUNT(distinct chapter_id) AS read_chapter_num
       ,0                          AS coin_consume
       ,0                          AS gift_consume
       ,0                          AS real_recharge
FROM
(
    SELECT  dt
           ,app_product_id
           ,os
           ,app_core_ver
           ,book_id
           ,login_id
           ,chapter_id
           ,activity_link
           ,split(activity_link,'_')[2] AS programme_id
           ,split(activity_link,'_')[3] AS module_channel_id
           ,split(activity_link,'_')[4] AS list_id
    FROM ads.ads_sensors_production_startreadingchapter_view a1
    WHERE dt = '${bf_1_dt}'
    AND ((split(activity_link, '_')[1] = 'bookstore' AND split(activity_link, '_')[6] = book_id) or split(send_id, '_')[2] = 'bookstore' )
    UNION ALL
    SELECT  dt
           ,app_product_id
           ,os
           ,app_core_ver
           ,book_id
           ,login_id
           ,chapter_id
           ,activity_link
           ,split(activity_link,'_')[2] AS programme_id
           ,split(activity_link,'_')[3] AS module_channel_id
           ,split(activity_link,'_')[4] AS list_id
    FROM ads.ads_sensors_production_endreadingchapter_view a1
    WHERE dt = '${bf_1_dt}'
    AND ((split(activity_link, '_')[1] = 'bookstore' AND split(activity_link, '_')[6] = book_id) or split(send_id, '_')[2] = 'bookstore' )
) a0
GROUP BY  1,2,3,4,5,6,7,8,9,10
-- ----------------- 书城 ** 解锁 -------------------
UNION ALL
SELECT  dt
       ,'解锁'                                     AS event
       ,app_product_id
       ,CASE WHEN os = '1' THEN 'iOS'
             WHEN os = '4' THEN 'Android'  ELSE '其他' END      AS os
       ,app_core_ver
       ,split(activity_link,'_')[4]              AS list_id
       ,split(activity_link,'_')[3]              AS module_channel_id
       ,split(activity_link,'_')[2]              AS programme_id
       ,book_id
       ,identity_login_id
       ,COUNT(1)                                 AS event_num -- 解锁次数
       ,0                                        AS read_chapter_num
       ,SUM(if(coin_consume > 0,coin_consume,0)) AS `coin_consume` -- 阅币消耗
       ,SUM(if(gift_consume > 0,gift_consume,0)) AS `gift_consume` -- 礼券消耗
       ,0                                        AS real_recharge
FROM ads.ads_sensors_production_unlockchapter_view a1
WHERE dt = '${bf_1_dt}'
AND ((split(activity_link, '_')[1] = 'bookstore' AND split(activity_link, '_')[6] = book_id) or split(send_id, '_')[2] = 'bookstore' )
GROUP BY  1,2,3,4,5,6,7,8,9,10
-- ----------------- 书城 ** 充值 -------------------
UNION ALL
SELECT  dt
       ,'充值'                                                                             AS event
       ,app_product_id
       ,CASE WHEN os = 'IPhone' THEN 'iOS'  ELSE os END        AS os
       ,app_core_ver
       ,if(split(send_id,'_')[5] = 0,split(activity_link,'_')[4],split(send_id,'_')[5] ) AS list_id
       ,if(split(send_id,'_')[4] = 0,split(activity_link,'_')[3],split(send_id,'_')[4] ) AS module_channel_id
       ,if(split(send_id,'_')[3] = 0,split(activity_link,'_')[2],split(send_id,'_')[3] ) AS programme_id
       ,split(send_id,'_')[1]                                                            AS book_id
       ,identity_login_id
       ,COUNT(1)                                                                         AS event_num -- 充值成功次数
       ,0                                                                                AS read_chapter_num
       ,0                                                                                AS coin_consume
       ,0                                                                                AS gift_consume
       ,SUM(real_recharge)                                                               AS real_recharge
FROM ads.ads_sensors_production_ordersuccess_view a1
WHERE dt = '${bf_1_dt}'
AND regexp(pay_source, 'half|Half')
AND pay_source not LIKE 'Ps_HalfLimitFreeCard%%'
AND ( (split(activity_link, '_')[1] = 'bookstore' AND regexp(pay_source, split(activity_link, '_')[6] )) or split(send_id, '_')[2] = 'bookstore' )
GROUP BY  1,2,3,4,5,6,7,8,9,10 ) z1
GROUP BY  1,2,3,4,5,6,7,8,9,10;
