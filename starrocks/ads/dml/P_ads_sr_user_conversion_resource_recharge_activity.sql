----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_sr_user_conversion_resource_recharge_activity
-- workflow_version : 2
-- create_user      : chenmo
-- task_name        : ads_sr_user_conversion_resource_recharge_activity
-- task_version     : 2
-- update_time      : 2025-01-22 10:53:08
-- sql_path         : \starrocks\tbl_ads_sr_user_conversion_resource_recharge_activity\ads_sr_user_conversion_resource_recharge_activity
----------------------------------------------------------------
-- SQL语句
insert into ads.ads_sr_user_conversion_resource_recharge_activity
select dt
       ,md5(concat(ifnull(app_product_id, -99), ifnull(os, -99), ifnull(app_core_ver, -99),
        ifnull(position_name, -99), ifnull(strategy_id, -99), ifnull(user_id, -99))) as md5_key
       ,app_product_id as product_id
       ,os
       ,app_core_ver as core
       ,position_name
       ,strategy_id
       ,user_id
       ,sum(if(event='曝光',event_num,0)) as exposure_num
       ,sum(if(event='点击',event_num,0)) as click_num
       ,sum(if(event='充值成功',event_num,0)) as success_num
       ,sum(if(event='充值成功',real_recharge,0)) as recharge_amount
       ,now() as etl_time
from (
SELECT  dt
       ,'曝光' AS event
       ,app_product_id
       ,os
       ,app_core_ver
       , CASE
            WHEN element_id = '100363' THEN '开屏'
            WHEN element_id = '100390' THEN '弹窗'
            WHEN element_id = '100391' THEN '悬浮窗'
            WHEN element_id = '100359' AND page_id = '10001' THEN '书城banner'
            WHEN element_id = '100359' AND page_id = '100774' THEN '福利中心banner'
            WHEN element_id = '100351' THEN '底部弹框'
            WHEN element_id = '100352' THEN '章末推送'
            WHEN element_id = '100400' THEN '返回推'
            WHEN element_id = '100671' THEN 'TAB'
            WHEN element_id = '100355' THEN '电池栏推荐'
            WHEN element_id = '100708' AND element_type = '14' THEN '半屏banner'
            WHEN element_id = '100698' THEN '私信'
            WHEN element_id = '100723' THEN '活动中心'
            ELSE null end  as `position_name`
      ,activity_id as strategy_id
      ,login_id  as user_id
      ,COUNT(1)  as event_num   -- 曝光次数
      ,0 as real_recharge
FROM ads.ads_sensors_production_operationpositionexposure_view
WHERE dt = '${bf_1_dt}'
AND element_id in(100363, 100390, 100391, 100359, 100351, 100352, 100400, 100723, 100671, 100355, 100708, 100698)
AND element_type IN (7, 9, 10, 11, 13, 14, 19)
GROUP BY  1, 2, 3, 4, 5, 6, 7, 8
having  position_name is not null
-- ----------------- 充值活动  * 点击  -------------------
union all
SELECT  dt
       ,'点击'                                                       AS event
       ,app_product_id
       ,os
       ,app_core_ver
       ,CASE WHEN element_id = '100363' THEN '开屏'
             WHEN element_id = '100390' THEN '弹窗'
             WHEN element_id = '100391' THEN '悬浮窗'
             WHEN element_id = '100359' AND page_id = '10001' THEN '书城banner'
             WHEN element_id = '100359' AND page_id = '100774' THEN '福利中心banner'
             WHEN element_id = '100351' THEN '底部弹框'
             WHEN element_id = '100352' THEN '章末推送'
             WHEN element_id = '100400' THEN '返回推'
             WHEN element_id = '100671' THEN 'TAB'
             WHEN element_id = '100355' THEN '电池栏推荐'
             WHEN element_id = '100708' AND element_type = '14' THEN '半屏banner'
             WHEN element_id = '100698' THEN '私信'
             WHEN element_id = '100723' THEN '活动中心'  ELSE null END AS `position_name`
       ,activity_id                                                AS strategy_id
       ,login_id  as user_id
       ,COUNT(1)        AS event_num  -- 点击次数
       ,0 as real_recharge
FROM ads.ads_sensors_production_operationpositionclick_view
WHERE dt = '${bf_1_dt}'
AND element_id in(100363, 100390, 100391, 100359, 100351, 100352, 100400, 100723, 100671, 100355, 100708, 100698)
AND element_type IN (7, 9, 10, 11, 13, 14, 19)
GROUP BY  1, 2, 3, 4, 5, 6, 7, 8
having position_name is not null
-- ----------------- 充值活动  * 成功  -------------------
union all
SELECT  dt
       ,'充值成功'   AS event
       ,app_product_id
       ,CASE WHEN os = 'IPhone' THEN 'iOS'
             else os END AS os
       ,app_core_ver
       ,CASE
             WHEN split(send_id, '_')[2] = 'popup' THEN '弹窗'
             WHEN split(send_id, '_')[2] = 'flashscreen' THEN '开屏'
             WHEN split(send_id, '_')[2] = 'netmonitor' THEN '悬浮窗'
             WHEN split(send_id, '_')[2] = 'halfscreen-banner' THEN '半屏banner'
             WHEN split(send_id, '_')[2] = 'rewards-banner' THEN '福利中心banner'
             WHEN split(send_id, '_')[2] = 'banner' THEN '书城banner'
             WHEN split(send_id, '_')[2] = 'reading' THEN '底部弹框'
             WHEN split(send_id, '_')[2] = 'chapterpush' THEN '章末推送'
             WHEN split(send_id, '_')[2] = 'returnrecommend' or split(activity_link, '_')[1]  ='returnrecommend' THEN '返回推' -------------------
             WHEN split(send_id, '_')[2] = 'centertab' THEN 'TAB'
             WHEN split(send_id, '_')[2] = 'batterybar' THEN '电池栏推荐'
             WHEN split(send_id, '_')[2] = 'news' THEN '私信'
             WHEN split(send_id, '_')[2] = 'actcenter' THEN '活动中心'
             else null END as position_name
       ,coalesce( split(send_id,'_')[4] ,split(activity_link,'_')[4],activity_id) as strategy_id
       ,identity_login_id as user_id
       ,COUNT(1) as event_num --  as `充值次数`
       ,sum(real_recharge) as real_recharge  -- as `充值金额`
    FROM ads.ads_sensors_production_ordersuccess_view
--     FROM ods_log.ods_sensors_cd_video_production_ordersuccess
    WHERE dt = '${bf_1_dt}'
        AND send_id is not null
        AND (regexp(send_id,'flashscreen|popup|netmonitor|halfscreen-banner|banner|rewards-banner|reading|chapterpush|returnrecommend|centertab|batterybar|news|actcenter')
             or regexp(pay_link,'returnrecommend'))
group by  1, 2, 3, 4, 5, 6, 7, 8
having  position_name is not null
) t0
group by 1, 3, 4, 5, 6, 7, 8;
