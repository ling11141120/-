insert into ads.ads_bi_sr_recharge_user_detail_di
with z1 as (
    select t1.dt
         , t1.user_id
         , period_type
         , user_type
         , dic_lang.remarks
         , case when country_level = 1 then 'T1'
                when country_level = 2 then 'T2'
                else '其他'
           end                                   as country_level
         , dic_mt.enum_name
         , coalesce(t1.corever, '其他')           as corever
      from dws.dws_user_wide_active_period_ed    as t1
      left join dim.dim_dic                      as dic_lang
        on t1.current_language2 = dic_lang.enum_id
       and dic_lang.table_name = 'dim_producttype'
       and dic_lang.dic_column = 'language_id'
      left join dim.dim_dic                      as dic_mt
        on t1.mt = dic_mt.enum_id
       and dic_mt.table_name = 'dim_user_accountinfo_df'
       and dic_mt.dic_column = 'mt'
      left join dim.dim_country_dic              as b
        on t1.reg_country = b.code
     where t1.dt >= '${bf_1_dt}'
       and t1.dt <= '${dt}'
     group by 1, 2, 3, 4, 5, 6, 7, 8
)
, z2 as(
    select t1.dt
          ,create_time
          ,product_id
          ,user_id
          ,case when item_count < 10 then concat('00', cast(item_count as varchar))
                when item_count < 100 then concat('0', cast(item_count as varchar))
                else cast(item_count as varchar)
            end                                                       as item_count
          ,base_amount / 100                                          as base_amount
          ,real_money
          ,shop_item
          ,package_id
          ,SensorsData
          ,case when regexp (package_id,'Ps_CombinAct|Ps_LadderTask_CombinAct|Ps_ChallengeTask_CombinAct|Ps_SpecialSignAct_CombinAct|Ps_LimitFreeCard|CombinAct') then '活动'
                when regexp(package_id,'Ps_HalfLimitFreeCard') then '其他'
                when regexp(package_id,'Ps_Half') then '半屏'
                when regexp(package_id,'Ps_SendCoupon|Ps_ReturnFail|Ps_GiftRewardPop|Ps_MulityChapterVip') then '半屏' -- 半屏挽留
                when regexp(package_id,'Ps_Shop_half|Ps_Shop') then '商店'
                when regexp(package_id,'Ps_ReturnRecommend') then '返回推弹窗'
                when regexp(package_id,'Ps_PopInfo') then '弹窗' -- TAG弹窗
                when regexp(package_id,'Ps_Bonus') then '商店'
                when package_id = -99 then '空来源'  else '其他'
            end                                                       as recharge_source
          ,case when regexp(package_id,'Ps_SkipChapter') then '跳章解锁'
                when regexp(package_id,'Ps_H5Shop') then 'H5商城'
                when regexp(package_id,'Ps_ReturnFail') then '失败挽留'
                when regexp(package_id,'Ps_ThirdPay') then '三方支付'
                when regexp(package_id,'Ps_Batch') then '批量解锁'
                when regexp(package_id,'Ps_H5EDMLimitedOffer') then 'EDM'
                else '其他'
            end                                                       as recharge_source2 -- 部分功能使用了配置的商品策略
          ,case when regexp(package_id,'Ps_ReturnRecommend') then coalesce(split(split(package_id,'|')[2],'_')[4] ,split(get_json_string(SensorsData,'$.pay_link'),'_')[4] ) -- 返回推解析活动策略ID
                when regexp(package_id,'Ps_PopInfo') then coalesce(split(split(package_id,'|')[2],'_')[4] ,split(get_json_string(SensorsData,'$.pay_link'),'_')[4] ) -- 弹窗解析活动策略ID
                else get_json_int(SensorsData,'$.activity_id')
            end                                                       as activity_id -- 解析神策活动策略（主要是活动充值）
          ,split(get_json_string(SensorsData,'$.pay_link'),'_')[4]    as dddd
          ,case when regexp(package_id,'Ps_Batch') then -1 -- 批量的取package解析
                else get_json_int(SensorsData,'$.event_strategy_id')
            end                                                       as strategy_id -- 原始策略ID
          ,split(split(package_id,'|')[3],'_')[1]                     as strategy_id2 -- 解析package_id策略ID
          ,case when shop_item = 0 then '普通充值'
                when shop_item = 810 then 'SVIP'
                when shop_item in ( 830,840) then '福利包'
                when shop_item = 840 then '新福利包'
                when shop_item = 850 then 'VIP'
                when shop_item = 800 then '旧订阅卡'
                else '其他'
            end                                                       as shop_item_type
          ,get_json_string(cooorder_extinfo,'$.SubscribeStatus')      as SubscribeStatus
          ,case get_json_string(SensorsData,'$.subscription_period')
                when 1 then '周卡'
                when 2 then '月卡'
                when 3 then '季卡'
                when 4 then '年卡'
                when 5 then '天卡'
            end                                                       as item_type
        ,substring_index(substring_index(substring_index(substring_index(substring_index(substring_index(substring_index( substring_index(substring_index(substring_index(
                         substring_index(substring_index(substring_index( substring_index(substring_index(substring_index(substring_index(substring_index(substring_index(
                         substring_index(substring_index(substring_index(substring_index(substring_index(substring_index(extinfo,'|',-1),'readerfr.',-1),'minireaderfr.',-1),
                         'cdycnovelfr.',-1),'tcreader.',-1),'minireaderft.',-1),'minireaderen.',-1),'ereader.',-1),'readerpt.',-1),'novelpt.',-1) ,'spainreader.',-1),'noveltw.',-1),
                         'novelen.',-1),'readerru.',-1),'minireaderes.',-1),'minireaderth.',-1),'readerid.',-1),'thai.',-1),'noveles.',-1),'novelru.',-1),'reader4.',-1),'novelth.',-1)
                         ,'novelid.',-1),'readerja.',-1),'novelja.',-1
                        )                                             as item_id
        ,case subpay_type 
              when 'AppStore' then 'IOS'
              when 'GooglePlay' then '安卓'
              else '三方支付'
          end                                                       as subpay_type
        ,ifnull(corever,-99)                                        as core
        ,ifnull(mt,-99)                                             as mt
        ,seconds_diff(t2.FinishTime,t1.create_time)                 as finish_time
      from ads.ads_trade_user_payorder_view t1
      left join (select OrderSerialId
                       ,FinishTime
                   from ods.ods_tidb_sr_sharpengine_pay_hk_sync_payorder_di
                  where ProductId != 6833
                ) t2
        on t1.order_id= t2.OrderSerialId
     where test_flag = 0
       and t1.dt>='${bf_1_dt}'
       and t1.dt<='${dt}'
)
, z3 as (
    select z2.dt
          ,create_time
          ,z2.user_id
          ,z2.product_id
          ,item_count
          ,base_amount
          ,real_money
          ,shop_item
          ,case when item_type='天卡' and t3.subscription_days is not null then t3.subscription_days
                when item_type is null and shop_item in (800,810,830,840,850) and t2.vip_type is not null then t2.vip_type
                when item_type is null and shop_item in (800,810,830,840,850) and t2.vip_type is null then '周卡'
                else item_type
            end as item_type
          ,case when recharge_source = '半屏' and strategy_id = -1 and strategy_id2 in (2, 930084) then '商店'             -- 一般-1的情况都是商店的策略 + 强转商店
                when strategy_id = 2 then '商店' -- 一般2的情况都是商店的策略
                else recharge_source
            end as recharge_source
          ,recharge_source2
          ,activity_id
          ,strategy_id
          ,strategy_id2
          ,shop_item_type
          ,SubscribeStatus
          ,case when recharge_source = '半屏' and strategy_id > 0 then strategy_id
                when recharge_source = '半屏' and (strategy_id = -1 or strategy_id is null or strategy_id = -99) and strategy_id2 > 0 then strategy_id2
                when recharge_source = '商店' and strategy_id > 0 then strategy_id
                when recharge_source = '商店' and (strategy_id = -1 or strategy_id is null or strategy_id = -99) and strategy_id2 > 0 then strategy_id2
                when recharge_source = '活动' then activity_id
                when recharge_source = '返回推弹窗' and activity_id > 0 then activity_id
                when recharge_source = '弹窗' and activity_id > 0 then activity_id
                when recharge_source = '弹窗' and activity_id = 8684412 then 8713442
                when recharge_source = '弹窗' and activity_id = 8684413 then 8713445
                when recharge_source = '其他' and activity_id > 0 then activity_id
                when recharge_source = '其他' and strategy_id > 0 then strategy_id
                when recharge_source = '其他' and strategy_id2 > 0 then strategy_id2
                when recharge_source = '空来源' and activity_id > 0 then activity_id
                when recharge_source = '空来源' then coalesce (strategy_id, strategy_id2)
                else -99
            end as event_strategy_id
          ,case when recharge_source = '商店' then 1
                when recharge_source = '半屏' and strategy_id = -1 and strategy_id2 in (2, 930084) then 1
                when strategy_id = 2 then 1
                when recharge_source = '半屏' then 2
                else 3
            end as recharge_scene_type
          ,package_id
          ,SensorsData
          ,subpay_type
          ,z2.core
          ,z2.mt
          ,finish_time
     from z2
     left join (select item_id
                      ,case when if (max(validity)=107, 107, min(validity))=1 then '月卡'
                            when if (max(validity)=107, 107, min(validity))=3 then '季卡'
                            when if (max(validity)=107, 107, min(validity))=12 then '年卡'
                            when if (max(validity)=107, 107, min(validity))=107 then '周卡'
                            else '非会员卡'
                        end as vip_type
                  from dim.dim_trade_pay_item_info_view
                 where merchandise_type in (800, 810, 830, 840, 850)
                   and status =1 
                   and is_delete=0
                   and product_id <> 3399 -- 商品库表存在日语存在测试数据，单独清洗
                 group by 1
               ) t2
       on z2.item_id = t2.item_id
     left join (select dt
                      ,app_product_id as product_id
                      ,identity_login_id as user_id
                      ,recharge_type
                      ,recharge_amount as recharge_amount
                      ,concat(max(SUBSTRING_INDEX(subscription_days,'.',1)),'天卡') as subscription_days
                  from ads.ads_sensors_production_ordersuccess_view
                 where dt>='${bf_1_dt}' 
                   and dt<='${dt}'
                   and recharge_type>0
                 group by 1,2,3,4,5
               ) t3 
       on z2.dt = t3.dt
      and z2.product_id = t3.product_id
      and z2.user_id = t3.user_id
      and t3.recharge_type = z2.shop_item
      and t3.recharge_amount = z2.real_money
)
, z4 as (
    select z3.dt
          ,z3.create_time
          ,z3.user_id
          ,z3.item_count
          ,z3.base_amount
          ,z3.shop_item
          ,z3.item_type
          ,z3.recharge_source
          ,z3.recharge_source2                                                                -- 归因跳章解锁/失败挽留等
          ,subscribeStatus
          ,case when subscribeStatus = 2 and shop_item_type <> '普通充值' then '续订(或策略id为空)'
                when recharge_source = '半屏' and t1.tactics_name is null and t3.tactics_name is not null then '商店'
                when recharge_source = '半屏' and t1.pattern_type = 2 then '活动'                   -- 半屏使用活动专区归为活动
                when recharge_source = '半屏' and strategy_id2 = 2 and strategy_id <> 7 then '商店' -- 半屏引用商店策略（2)
                when recharge_source2 = '失败挽留' and coalesce(t1.tactics_name,t2.tactics_name,t3.tactics_name,t4.tactics_name) is null then '其他'    -- 半屏, 取不到策略
                when recharge_source = '空来源' and recharge_source2 <> '其他' then recharge_source2
                when recharge_source = '空来源' and t3.tactics_name is not null then '商店'
                when recharge_source = '空来源' and t4.tactics_name is not null then '半屏'
                when recharge_source = '空来源' and coalesce(t1.tactics_name,t2.tactics_name,t3.tactics_name,t4.tactics_name,recharge_source2) = '其他' then '续订(或策略id为空)'
                else recharge_source 
            end as recharge_source3                                        -- 处理半屏引用商店策略
          ,z3.activity_id
          ,z3.strategy_id
          ,z3.strategy_id2
          ,z3.shop_item_type
          ,z3.event_strategy_id
          ,t1.tactics_name as tactics_name1
          ,t2.tactics_name as tactics_name2
          ,t3.tactics_name as tactics_name3
          ,t4.tactics_name as tactics_name4
          ,case when subscribeStatus = 2 and shop_item_type <> '普通充值' then '续订'
                when recharge_source = '空来源' and coalesce(t1.tactics_name,t2.tactics_name,t3.tactics_name,t4.tactics_name,recharge_source2) = '其他' then '策略ID为空'
                else coalesce(t1.tactics_name,t2.tactics_name,t3.tactics_name,t4.tactics_name,recharge_source2)
            end as tactics_name_
          ,if(t1.pattern_type = 2, '活动专区', '其他') as 半屏档位模式
          ,package_id
          ,sensorsData
          ,z3.subpay_type
          ,z3.core
          ,z3.mt
          ,z3.finish_time
      from z3
      left join dim.tag_center_merchandise_tactics_view t1 -- 半屏/商店取策略
        on z3.recharge_scene_type = t1.scene_type 
       and z3.event_strategy_id = t1.tactics_id 
       and concat(t1.scene_type, '-', t1.tactics_id) not in ('2-360003', '2-330011', '2-330010', '2-330012', '2-480053')
      left join dim.dim_tag_center_activity_view t2 -- 活动策略
        on z3.activity_id = t2.tactics_id
      left join dim.tag_center_merchandise_tactics_view t3 -- 其他位置取了商店的策略
        on z3.recharge_scene_type in (2, 3) -- 3
       and t3.scene_type = 1 
       and z3.event_strategy_id = t3.tactics_id
      left join dim.tag_center_merchandise_tactics_view t4 -- 补异常半屏数据
        on z3.recharge_scene_type in (2, 3) -- 3
       and t4.scene_type = 2 
       and z3.event_strategy_id = t4.tactics_id
      ), z4_1 as
      (
select dt
   , coalesce (recharge_source3
   , '其他') as recharge_source3            -- 充值来源 -- 过滤活跃未充值用户
   , event_strategy_id as event_strategy_id -- 策略ID
   , tactics_name_ as strategy_name         -- 策略名称
   , shop_item_type as shop_item_type       -- 档位类型
   , item_count as item_count --充值档位
   , item_type
   , subpay_type
   , core
   , mt
   , user_id as user_id
--
   , create_time
   , sum(base_amount) as base_amount
   , count (1) as recharge_order_num
   , avg(finish_time) as finish_time
   , max(package_id) package_id
   , max(SensorsData) as SensorsData
from z4
group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11
    )
   ,
-- 创建订单事件
    t4 as (
select
    case when element_id = '100390' then '弹窗'
    when element_id = '100352' then '其他'
    when element_id = '100400' then '返回推弹窗'
    when element_id = '100284' then '活动'
    when element_id in ('100708'
   , '100337') then '半屏'
    when element_id in ( 100024
   , 100025
   , 100026
   , 100121
   , 100120 ) then '商店' else '其他' end as `recharge_source`
   , case
    when cast(real_recharge as float)
   <10 then concat('00'
   , real_recharge )
    when cast(real_recharge as float)
   <100 then concat('0'
   , real_recharge)
    else real_recharge end item_count
   , case when element_id in ('100390'
   , '100352'
   , '100400'
   , '100284') then activity_id else event_strategy_id end as event_strategy_id
   , case when recharge_type = 0 then '普通充值'
    when recharge_type = 810 then 'SVIP'
    when recharge_type in ( 830
   , 840) then '福利包' --
    when recharge_type = 840 then '新福利包'
    when recharge_type = 850 then 'VIP'
    when recharge_type = 800 then '旧订阅卡' else '其他' end shop_item_type
   , coalesce (login_id
   , cast(distinct_id as int)) user_id
   , ifnull(app_core_ver
   , -99) as core
   , ifnull(os
   , -99) as mt
   ,
-- event_tm,
    dt
   , zffs as subpay_type
   , count (1) as create_order_num
from ads.ads_sensors_production_ordercreateaction_view
where dt>='${bf_1_dt}'
 and dt<='${dt}'
 and element_id not in ('100647'
   , '100651'
   , '100107')
group by 1, 2, 3, 4, 5, 6, 7, 8, 9
    )
   , z5 as (
select
    coalesce (t4.dt
   , z4_1.dt) dt
   , coalesce (t4.recharge_source
   , z4_1.recharge_source3
   , '其他') as recharge_source3               -- 充值来源
   , coalesce (t4.event_strategy_id
   , z4_1.event_strategy_id) event_strategy_id -- 策略ID
   , z4_1.strategy_name                        -- -- 策略名称
   , coalesce (t4.shop_item_type
   , z4_1.shop_item_type) shop_item_type       -- 档位类型
   , coalesce (t4.item_count
   , z4_1.item_count) item_count --充值档位
   , z4_1.item_type
   , coalesce (t4.subpay_type
   , z4_1.subpay_type) subpay_type
   , coalesce (t4.core
   , z4_1.core) core
   , coalesce (t4.mt
   , z4_1.mt) mt
   , coalesce (t4.user_id
   , z4_1.user_id) user_id
   , z4_1.base_amount as base_amount
   , z4_1.recharge_order_num as recharge_order_num
   , z4_1.finish_time as finish_time
   , z4_1.package_id as package_id
   , z4_1.SensorsData as SensorsData
   , t4.create_order_num as create_order_num
from t4
    full join z4_1
  on t4.dt=z4_1.dt and t4.recharge_source = z4_1.recharge_source3 and t4.event_strategy_id and z4_1.event_strategy_id and t4.shop_item_type = z4_1.shop_item_type
      and t4.item_count = z4_1.item_count and t4.subpay_type = z4_1.subpay_type and t4.core = z4_1.core and t4.mt = z4_1.mt and t4.user_id = z4_1.user_id

      )
      ,
      z7 as
      (
select dt
   , case when element_id = '100708' and t1.pattern_type = 2 then '活动'
    when element_id = '100708' and t2.tactics_id
   > 2 and event_strategy_id not in (690001
   , 720001
   , 510001
   , 540001) then '活动'
    when element_id in ('100708'
   , '100338'
   , '100337'
   , '100707'
   , '100401') and t0.event_strategy_id in (2
   , 930084) then '商店'
    when element_id in (100284) then '活动'
    when element_id = '100708' and element_type in (0
   , -1) then '半屏'
    when element_id in ('100338'
   , '100337'
   , '100707') and t1.pattern_type = 2 then '活动'
    when element_id in ('100338'
   , '100337'
   , '100707') then '半屏'
    when element_id in (100024
   , 100025
   , 100126
   , 100365
   , 100120) then '商店'
    when element_id in (100031) then '商店'
    when element_id = '100400' and split(pay_link
   , '_')[1] = 'returnrecommend' then '返回推弹窗'
    when element_id = '100390' and split(pay_link
   , '_')[1] = 'popup' then '弹窗' else '其他' end as recharge_source3
   , case when element_id = '100708' and element_type in (0
   , -1) then event_strategy_id
    when element_id in (100024
   , 100025
   , 100126
   , 100365) then event_strategy_id
    when element_id = '100400' and split(pay_link
   , '_')[1] = 'returnrecommend' then split(pay_link
   , '_')[4]
    when element_id = '100390' and split(pay_link
   , '_')[1] = 'popup' and split(pay_link
   , '_')[4] = 8684412 then 8713442
    when element_id = '100390' and split(pay_link
   , '_')[1] = 'popup' and split(pay_link
   , '_')[4] = 8684413 then 8713445
    when element_id = '100390' and split(pay_link
   , '_')[1] = 'popup' then split(pay_link
   , '_')[4]
    when event_strategy_id
   > 0 then event_strategy_id else t0.activity_id end as event_strategy_id -- 策略ID
   , ifnull(app_core_ver
   , -99) as core
   , case lower(os) when 'ios' then 1 when 'android' then 4 else -99 end as mt
   , coalesce (identity_user_id
   , login_id) as user_id
   , count (distinct left (event_tm
   , 18)) as exposure_pv                                                   -- `曝光PV`
   , MAX(coalesce (t1.tactics_name
   , t2.tactics_name
   , t3.tactics_name)) as strategy_name                                    -- `策略名称`
   , max(element_id) as `exp_element_id`
from ads.ads_sensors_production_rechargeexposure_view t0
    left join dim.tag_center_merchandise_tactics_view t1 -- 半屏/商店取策略
  on t0.element_id in ('100708', '100338', '100337', '100707')
      and t1.scene_type = 2 and t0.event_strategy_id = t1.tactics_id
      and concat( t1.scene_type, '-', t1.tactics_id) not in ('2-360003', '2-330011', '2-330010', '2-330012', '2-480053', '2-30003', '2-2')
      left join dim.dim_tag_center_activity_view t2 -- 活动策略
      on (case when element_id = '100400' and split(pay_link, '_')[1] = 'returnrecommend' then split(pay_link, '_')[4]
      when element_id = '100390' and split(pay_link, '_')[1] = 'popup' and split(pay_link, '_')[4] = 8684412 then 8713442
      when element_id = '100390' and split(pay_link, '_')[1] = 'popup' and split(pay_link, '_')[4] = 8684413 then 8713445
      when element_id = '100390' and split(pay_link, '_')[1] = 'popup' then split(pay_link, '_')[4]
      when event_strategy_id > 0 then event_strategy_id else t0.activity_id end ) = t2.tactics_id
      and date (t2.begin_time) <> '0001-01-01'
      left join dim.tag_center_merchandise_tactics_view t3 -- 商店取策略
      on t3.scene_type = 1
      and t0.event_strategy_id = t3.tactics_id
where t0.dt>='${bf_1_dt}'
 and t0.dt<='${dt}'
 and project_id = 5
 and element_id not in ('100647'
   , '100651'
   , '100107')
group by 1, 2, 3, 4, 5, 6
    )
   , z8 as -- 广告收入
   (
select dt
   , user_id
   , strategy_id as event_strategy_id
   , core
   , mt
   , SUM(PV) as ad_PV
   , SUM(AMOUNT) as ad_amount
from
   (
    select dt
   , split(main_strategy_id
   , '_')[1] as strategy_id
   , login_id as user_id
   , ifnull(app_core_ver
   , -99) as core
   , case lower(os) when 'ios' then 1 when 'android' then 4 else -99 end as mt
   , 1 as `PV`
   , 0 as `AMOUNT`
    from ads.ads_sensors_production_ad_position_exposure_view
    where dt>='${bf_1_dt}' and dt<='${dt}'
    and main_strategy_id is not null
    and ad_position_id in (18
   , 62)
    union all
    select dt
   , split(main_strategy_id
   , '_')[1] as strategy_id
   , login_id
   , ifnull(app_core_ver
   , -99) as core
   , case lower(os) when 'ios' then 1 when 'android' then 4 else -99 end as mt
   , 1 as `PV`
   , 0 as `AMOUNT`
    from ads.ads_sensors_production_element_expose_view
    where dt>='${bf_1_dt}' and dt<='${dt}'
    and element_id = '100356'
    and ad_position_id = 18
    and main_strategy_id is not null
    union all
    select dt
   , split(main_strategy_id
   , '_')[1] as strategy_id
   , login_id
   , ifnull(app_core_ver
   , -99) as core
   , case lower(os) when 'ios' then 1 when 'android' then 4 else -99 end as mt
   , 0 as `PV`
   , case when os in ('4'
   , 'Android'
   , 'HarmonyOS') and ad_platform = 'AdMob' then ad_revenue/10000000000 else ad_revenue/10000 end as `AMOUNT`
    from ads.ads_sensors_production_ad_revenue_action_view
    where dt>='${bf_1_dt}' and dt<='${dt}'
    and main_strategy_id is not null
    and ad_position_id in (18
   , 62)
    union all
    select t1.dt
   , t1.strategy_id
   , t1.user_id
   , t1.core
   , t1.mt
   , t1.PV
   , t2.H5peramount as amount
    from (
    select t1.dt
   , split(main_strategy_id
   , '_')[1] as strategy_id
   , login_id as user_id
   , ifnull(app_core_ver
   , -99) as core
   , case lower(os) when 'ios' then 1 when 'android' then 4 else -99 end as mt
   , 0 as PV
--
   , H5peramount as amount
    from ads.ads_sensors_production_element_click_view t1
    where t1.dt>='${bf_1_dt}' and t1.dt<='${dt}'
    and element_id = '100356'
    and ad_position_id = 18
    and main_strategy_id is not null
    ) t1
    left join
   (
    select dt
   , ifnull(core
   , -99) as core
   , ifnull(mt
   , -99) as mt
   , SUM(amt)/SUM(cnt ) as H5peramount
    from dws.dws_advertisement_user_position_amt_ed
    where dt>='${bf_1_dt}' and dt<='${dt}'
    and positions = '59'
    group by 1
   , 2
   , 3
    ) t2
    on t1.dt = t2.dt and t1.core=t2.core and t1.mt=t2.mt
    ) zad
group by 1, 2, 3, 4, 5
    ), z9 as (
select *
   , row_number () over (partition by dt
   , user_id
   , recharge_source3
   , event_strategy_id
   , core
   , mt ) row_1
from
   (
    select ifnull(z5.dt
   , z7.dt) as dt                               -- `日期`
   , ifnull(z5.user_id
   , z7.user_id) as user_id
   , ifnull(z5.recharge_source3
   , z7.recharge_source3) as recharge_source3 --充值来源
   , ifnull(z5.event_strategy_id
   , z7.event_strategy_id) as event_strategy_id -- 策略ID
   , ifnull(ifnull(z5.strategy_name
   , z7.strategy_name)
   , '其他') as strategy_name                   -- 策略名称
   , ifnull(z7.exposure_pv
   , 0) as exposure_pv                          -- 曝光PV
   , z5.shop_item_type                          -- 档位类型
   , z5.item_count --充值档位
   , z5.item_type
   , z5.subpay_type
   , ifnull(z5.core
   , z7.core) as core
   , ifnull(z5.mt
   , z7.mt) as mt
   , if (z5.base_amount
   > 0
   , z5.user_id
   , null ) as recharge_user_id                 -- 充值user_id  -- 没充值的是空
   , z5.base_amount as base_amount --`充值金额`
   , z5.recharge_order_num                      -- 成功订单数
   , z5.finish_time                             -- 订单完成时间
   , z5.create_order_num                        -- 创建订单数
   , z8.ad_PV as ad_PV --`广告曝光PV`
   , z8.ad_amount as ad_amount --`广告收入`
   , package_id
   , SensorsData
   , exp_element_id
    from z5
    full join z7
    on z7.dt = z5.dt
    and z7.user_id = z5.user_id
    and z7.event_strategy_id = z5.event_strategy_id
    and z7.recharge_source3 = z5.recharge_source3
    and z5.core = z7.core
    and z5.mt = z7.mt
    left join z8
    on z7.dt = z8.dt
    and z7.user_id = z8.user_id
    and z7.event_strategy_id = z8.event_strategy_id
    and z7.recharge_source3 = '半屏'
    and z8.core = z7.core
    and z8.mt = z7.mt
    ) a0
    )
   , z10 as (
select dt              -- `日期`
   , user_id
   , recharge_source3 as recharge_source--`充值来源`
   , event_strategy_id -- `策略ID`
   , strategy_name --`策略名称`
   , row_1
   , if (row_1 = 1
   , exposure_pv
   , 0) as exposure_pv --`策略曝光PV`
   , if (row_1 = 1
   , ad_PV
   , 0) ad_exposure_pv -- `广告曝光PV`
   , shop_item_type    -- `档位类型`
   , item_count        -- `充值档位`
   , item_type
   , subpay_type
   , core
   , mt
   , recharge_user_id --`充值user_id`
   , base_amount       -- `充值金额`
   , recharge_order_num
   , finish_time
   , create_order_num
   , if (row_1 = 1
   , ad_amount
   , 0) ad_amount      -- `广告收入`
   , package_id
   , SensorsData
   , exp_element_id
from z9
    )
select z10.dt
     , z1.period_type
     , ifnull(z10.event_strategy_id, -99) as event_strategy_id
     , ifnull(z10.recharge_source, -99)   as recharge_source
     , z10.user_id
     , z10.mt
     , z10.core
     , z10.row_1
     , z10.shop_item_type
     , z10.item_count
     , item_type
     , z10.subpay_type -- 充值类型 = 支付方式
     , z10.strategy_name
     , z1.user_type
     , z1.remarks                         as put_language
     , z1.country_level
     , z10.exposure_pv
     , z10.ad_exposure_pv
     , z10.recharge_user_id
     , z10.base_amount                    as recharge_amount
     , z10.recharge_order_num
     , z10.create_order_num
     , z10.finish_time
     , z10.ad_amount
     , z10.package_id
     , z10.SensorsData
     , z10.exp_element_id
     , now()                              as etl_ime
  from z10
  inner join z1
  on z1.dt = z10.dt and z1.user_id = z10.user_id


