insert into ads.ads_sensors_production_element_transform_di

-- ### 曝光用户 ###
with t2 as(
    SELECT
        dt
         ,app_core_ver
         ,os
         ,coalesce(reg_language,'其他')  as reg_language
         ,app_product_id
         ,recharge_type
         ,CASE WHEN event_strategy_id = '0' OR event_strategy_id = '1' OR  event_strategy_id IS NULL THEN '-1' ELSE event_strategy_id END AS event_strategy_id
         ,CASE WHEN element_id in (100708) then '半屏'
               WHEN element_id in (100024, 100025, 100365, 100126) then '商店页'
        end as position_type
         ,case
              when recharge_type = '0' then '非订阅'
              else '订阅' end as if_subscription
         ,bitmap_union(to_bitmap(
            replace(
                    replace(
                            replace(
                                    identity_login_id,'[',''
                            )
                        ,
                            ']'
                        ,
                            ''
                    )
                ,
                    '"'
                ,
                    ''
            )
                       ))  gear_exposure_uv
    FROM ads.ads_sensors_production_rechargeexposure_view
    WHERE recharge_type is not null
      AND element_id in(100024, 100025, 100365, 100126, 100708)
      AND dt = '${bf_1_dt}'
    GROUP BY  1,2,3,4,5,6,7,8
),

-- ### 创建订单用户 ###
     t3 as(
         SELECT
             dt
              ,app_core_ver
              ,os
              ,coalesce(reg_language,'其他')  as reg_language
              ,app_product_id
              ,recharge_type
              ,CASE WHEN event_strategy_id = '0' OR event_strategy_id = '1' OR  event_strategy_id IS NULL THEN '-1' ELSE event_strategy_id END AS event_strategy_id
              ,CASE WHEN element_id in (100708) then '半屏'
                    WHEN element_id in (100024, 100025, 100365, 100126) then '商店页'
             end  as position_type
              ,count(1) as order_pv
              ,bitmap_union(to_bitmap(
                 replace(
                         replace(
                                 replace(
                                         identity_login_id,'[',''
                                 )
                             ,
                                 ']'
                             ,
                                 ''
                         )
                     ,
                         '"'
                     ,
                         ''
                 )
                            )) AS order_uv
         FROM ads.ads_sensors_production_ordercreateaction_view
         WHERE recharge_type is not null
           AND element_id in(100024, 100025, 100365, 100126, 100708)
           AND dt = '${bf_1_dt}'
         GROUP BY  1,2,3,4,5,6,7,8
     ),

-- 支付成功
     t4 as(
         select
             dt
              ,app_core_ver
              , CASE WHEN `os` = 'IPhone' THEN 'iOS' ELSE `os` END AS os
              ,reg_language
              ,app_product_id
              ,recharge_type
              ,CASE WHEN event_strategy_id = '0' OR event_strategy_id = '1' OR  event_strategy_id IS NULL THEN '-1' ELSE event_strategy_id END AS event_strategy_id
              ,CASE WHEN  regexp(pay_source,'Ps_Half')  then '半屏'
                    WHEN regexp(pay_source,'Ps_Shop') then '商店页'
             end as position_type
              ,count(1) as payment_pv
              ,bitmap_union(to_bitmap(identity_login_id))  as payment_uv
              ,sum(cast(real_recharge as float))  as payment_amt
         from ads.ads_sensors_production_ordersuccess_view
         where recharge_type is not null
           AND dt = '${bf_1_dt}'
           and  (regexp(pay_source,'Ps_Shop')   or regexp(pay_source,'Ps_Half'))
         group by 1,2,3,4,5,6,7,8
     )

select
    t2.dt																		-- 日期
     ,ifnull(t2.app_core_ver,'未知')												-- core
     ,ifnull(t2.os,'未知')														-- 终端
     ,ifnull(t2.reg_language,'未知')												-- 注册语言
     ,ifnull(t2.app_product_id,'未知')											-- 产品ID
     ,t2.recharge_type															-- 充值类型
     ,ifnull(t2.event_strategy_id,'-1')											-- 策略ID
     ,t2.position_type															-- 位置
     ,t2.if_subscription 														-- 是否订阅
     ,t2.gear_exposure_uv														-- 档位曝光UV；转bitmap
     ,t3.order_uv																-- 创建订单UV；转bitmap
     ,t3.order_pv																-- 创建订单PV
     ,t4.payment_uv																-- 支付成功UV；转bitmap
     ,t4.payment_pv																-- 支付成功PV
     ,t4.payment_amt																-- 支付金额
from  t2
          left join t3
                    on  t2.dt =t3.dt and t2.app_core_ver=t3.app_core_ver and t2.os=t3.os and t2.reg_language=t3.reg_language
                        and t2.app_product_id=t3.app_product_id and t2.recharge_type=t3.recharge_type
                        and t2.event_strategy_id=t3.event_strategy_id and t2.position_type=t3.position_type
          left join t4
                    on  t2.dt =t4.dt and t2.app_core_ver=t4.app_core_ver and t2.os=t4.os and t2.reg_language=t4.reg_language
                        and t2.app_product_id=t4.app_product_id and t2.recharge_type=t4.recharge_type
                        and t2.event_strategy_id=t4.event_strategy_id and t2.position_type=t4.position_type
;