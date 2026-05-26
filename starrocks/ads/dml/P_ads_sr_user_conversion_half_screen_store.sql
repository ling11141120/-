----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_sr_user_conversion_half_screen_store
-- workflow_version : 7
-- create_user      : chenmo
-- task_name        : ads_sr_user_conversion_half_screen_store
-- task_version     : 6
-- update_time      : 2025-02-08 14:26:56
-- sql_path         : \starrocks\tbl_ads_sr_user_conversion_half_screen_store\ads_sr_user_conversion_half_screen_store
----------------------------------------------------------------
-- SQL语句
insert into ads.ads_sr_user_conversion_half_screen_store
select
    t1.dt,
    md5(concat(ifnull(t1.app_product_id, -99), ifnull(t1.os, -99), ifnull(t1.app_core_ver, -99),
    ifnull(t1.user_id, -99), ifnull(t1.position, -99), ifnull(t1.recharge_type, -99), ifnull(t1.strategy_id, -99))) as md5_key,
    --  t1.event as ,
    t1.app_product_id as product_id,
    t1.os,
    t1.app_core_ver as core,
    t1.user_id,
    t1.position as position_name,
    t1.recharge_type,
    t1.strategy_id,
    sum(if(event = '曝光',event_num,0)) as exposure_num,
    sum(if(event = '点击',event_num,0)) as click_num,
    sum(if(event = '充值成功',event_num,0)) as success_num,
    sum(if(event = '充值成功',amount,0)) as recharge_amount,
    now() as etl_time
from (
    -- 曝光
    SELECT dt -- 日期
           ,'曝光'                                                                  AS event
           ,app_product_id
           ,os
           ,app_core_ver
           ,coalesce(identity_user_id,login_id)                                   AS user_id -- 用户
           ,CASE WHEN element_id IN (100708) THEN '半屏'
                 WHEN element_id IN (100024,100025,100126,100365) THEN '商店页' END AS position -- 位置
           ,CASE WHEN recharge_type = '0' THEN '普通充值'  ELSE '订阅' END         AS recharge_type -- 充值类型
           ,event_strategy_id                                                     AS strategy_id -- 策略ID
           ,COUNT(1)                                                              AS event_num -- 曝光次数
           ,0 as `amount`
    FROM ads.ads_sensors_production_rechargeexposure_view
    WHERE dt = '${bf_1_dt}'
    AND element_id in(100024, 100025, 100126, 100365, 100708)
    AND (element_type NOT IN (14, 15) or element_type is null) -- null 的部分要保留
    AND recharge_type is not null
    GROUP BY  1,2,3,4,5,6,7,8,9
    union all
    -- 点击
    SELECT dt -- 日期
           ,'点击'                                                                  AS event
           ,app_product_id
           ,os
           ,app_core_ver
           ,coalesce(identity_user_id,login_id)                                   AS user_id -- 用户
           ,CASE WHEN element_id IN (100708) THEN '半屏'
                 WHEN element_id IN (100024,100025,100126,100365) THEN '商店页' END AS position -- 位置
           ,CASE WHEN recharge_type = '0' THEN '普通充值'  ELSE '订阅' END         AS recharge_type -- 充值类型
           ,event_strategy_id                                                     AS strategy_id -- 策略ID
           ,COUNT(1)                                                              AS event_num -- 点击次数
           ,0 as `amount`
    FROM ads.ads_sensors_production_ordercreateaction_view
    WHERE dt = '${bf_1_dt}'
    AND element_id in(100024, 100025, 100126, 100365, 100708)
    AND (element_type NOT IN (14, 15) or element_type is null) -- null 的部分要保留
    AND recharge_type is not null
    GROUP BY  1,2,3,4,5,6,7,8,9
    union all
    -- 成功
    select dt -- 日期
        ,'充值成功' AS event
        ,app_product_id
        ,if(os = 'IPhone','iOS',os) as os
        ,app_core_ver
        ,identity_login_id                                 AS user_id -- 用户
        ,CASE WHEN regexp(pay_source,'Ps_Half') THEN '半屏'
              WHEN regexp(pay_source,'Ps_Shop') THEN '商店页' END AS position -- 位置
        ,CASE WHEN recharge_type = '0' THEN '普通充值'  ELSE '订阅' END              AS recharge_type -- 充值类型
        ,if(event_strategy_id > 0,event_strategy_id,split(split(pay_source, '|')[3],'_')[3] )    AS strategy_id -- 策略ID
        ,COUNT(1)                                                              AS event_num -- 充值次数
        ,sum(real_recharge) as `amount`
    FROM ads.ads_sensors_production_ordersuccess_view
    WHERE dt = '${bf_1_dt}'
    AND regexp(pay_source,'Ps_Half|Ps_Shop')
    and pay_source not like 'Ps_HalfLimitFreeCard%'
    AND recharge_type is not null
    GROUP BY  1,2,3,4,5,6,7,8,9
) t1 group by 1,3,4,5,6,7,8,9;
