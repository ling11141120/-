-------------------------------------------------
-- 应用报表：阅读-用户维度报表/海阅三方支付漏斗链路报表
-------------------------------------------------

with z_p as (
    select replace("${支付渠道类型}", "','", "|") as pay_ment_type
         , replace("${支付渠道}", "','", "|") as pay_ment
         , replace("${子支付渠道}", "','", "|") as pay_ment_way
)
-- 入三方包
, group_view as (
    select dt
         , account
      from (select dt
                 , SubCrowdId as group_id
                 , UserId     as account
              from ads.ads_sr_beidou_group_crowd_log
             where Operation = 1
               and dt >= date_add('${开始时间}',-1)
               and dt <= date_add('${结束时间}',1)
               and date(CreateTime) >= '${开始时间}'
               and date(CreateTime) <= '${结束时间}'
             group by 1, 2, 3
           )                                        as a
      join ads.ads_center_third_payment_global_view as b
        on a.group_id = b.unnest_jgroupid
     where status = 1
     group by 1, 2
)
, z0 as (
    select t1.dt
         , t1.user_id as user_id0
      from dws.dws_user_wide_active_period_ed as t1
      left join dim.dim_dic                   as dic_lang
        on t1.current_language2 = dic_lang.enum_id
       and dic_lang.table_name = 'dim_producttype'
       and dic_lang.dic_column = 'language_id'
      left join dim.dim_dic                   as dic_mt
        on t1.mt = dic_mt.enum_id
       and dic_mt.table_name = 'dim_user_accountinfo_df'
       and dic_mt.dic_column = 'mt'
      left join dim.dim_country_dic          as b
        on t1.reg_country = b.code
     where dt >= '${开始时间}'
       and dt <= '${结束时间}'
       ${if(len(周期类型) == 0,"","and period_type in ('" + 周期类型 + "')")}
       ${if(len(用户类型) == 0,"","and user_type in ('" + 用户类型 + "')")}
       ${if(len(注册国家) == 0,"","and coalesce(b.country,reg_country) in ('" + 注册国家 + "')")}
       ${if(len(投放语言) == 0,"","and dic_lang.remarks in ('" + 投放语言 + "')")}
       ${if(len(国家等级) == 0,"","and case when country_level =1 then 'T1' when country_level =2 then 'T2' else '其他' end in ('" + 国家等级 + "')")}
       ${if(len(终端) == 0,"","and dic_mt.enum_name in ('" + 终端 + "')")}
       ${if(len(CORE) == 0,"","and COALESCE(t1.corever,'其他') in ('" + CORE + "')")}
     group by 1, 2
)
, z1 as (
    select '充值成功'                                              as action
         , t1.dt
         , t1.user_id
         , '0'                                                    as account
         , case when item_count < 10 then concat('00',cast(item_count as varchar))
                when item_count < 100 then concat('0',cast(item_count as varchar))
                else cast(item_count AS varchar)
            end                                                   as item_count
         , t1.base_amount/100                                     as base_amount
         , case when t1.shop_item = 0 then '普通充值'
                when t1.shop_item = 810 then 'SVIP'
                when t1.shop_item IN ( 830, 840) then '福利包' --
                when t1.shop_item = 840 then '新福利包'
                when t1.shop_item = 850 then 'VIP'
                when t1.shop_item = 800 then '旧订阅卡'
                else '其他'
            end                                                   as shop_item_type
         , case when get_json_string(cooorder_extinfo, '$.SubscribeStatus') = 2 then '续订'
                when regexp(t1.package_id, 'Ps_CombinAct|Ps_LadderTask_CombinAct|Ps_ChallengeTask_CombinAct|Ps_SpecialSignAct_CombinAct|Ps_LimitFreeCard|CombinAct') then 'H5活动'
                when regexp(t1.package_id, 'Ps_HalfLimitFreeCard|Ps_MulityChapterVip') then '半屏'
                when regexp(t1.package_id, 'Ps_Half') then '半屏'
                when regexp(t1.package_id, 'Ps_SendCoupon_half') then '半屏' -- 半屏挽留
                when regexp(t1.package_id, 'Ps_SendCoupon') then '商店页' -- 半屏挽留
                when regexp(t1.package_id, 'Ps_ReturnFail|Ps_ReturnFail_half') then '半屏' -- 半屏挽留
                when regexp(t1.package_id, 'Ps_Shop_half|Ps_Shop') then '商店页'
                when regexp(t1.package_id, 'Ps_ReturnRecommend') then '阅读器返回推'
                when regexp(t1.package_id, 'Ps_PopInfo') then '弹窗' -- TAG弹窗
                when regexp(t1.package_id, 'Ps_Bonus') then '商店页'
                when t1.package_id = -99 then '空来源'
                else '其他'
            end                                                   as recharge_source
         , case when regexp(t1.package_id, 'Ps_CombinAct|Ps_LadderTask_CombinAct|Ps_ChallengeTask_CombinAct|Ps_SpecialSignAct_CombinAct|Ps_LimitFreeCard|CombinAct') then get_json_int(sensors_data, '$.activity_id')
                when regexp(t1.package_id, 'Ps_HalfLimitFreeCard|Ps_MulityChapterVip') then get_json_int(sensors_data, '$.event_strategy_id')
                when regexp(t1.package_id, 'Ps_Half') then get_json_int(sensors_data, '$.event_strategy_id')
                when regexp(t1.package_id, 'Ps_SendCoupon|Ps_SendCoupon_half') then get_json_int(sensors_data, '$.event_strategy_id')
                when regexp(t1.package_id, 'Ps_ReturnFail|Ps_ReturnFail_half') then get_json_int(sensors_data, '$.event_strategy_id')
                when regexp(t1.package_id, 'Ps_Shop_half|Ps_Shop') then get_json_int(sensors_data, '$.event_strategy_id')
                when regexp(t1.package_id, 'Ps_ReturnRecommend') then coalesce(split(split(t1.package_id,'|')[2], '_')[4] , split(get_json_string(sensors_data, '$.pay_link'), '_')[4] ) -- 返回推解析活动策略ID
                when regexp(t1.package_id, 'Ps_PopInfo') then get_json_int(sensors_data, '$.activity_id')
                when regexp(t1.package_id, 'Ps_Bonus') then get_json_int(sensors_data, '$.event_strategy_id')
                else if(get_json_int(sensors_data,'$.event_strategy_id') > 1, get_json_int(sensors_data, '$.event_strategy_id'), get_json_int(sensors_data, '$.activity_id') )
            end                                                   as event_strategy_id
         , get_json_string(cooorder_extinfo, '$.SubscribeStatus') as SubscribeStatus
         , case when subpay_type IN ('AppStore', 'GooglePlay', 'AppGallery', 'Miglobal') then 0
                else 1
            end                                                   as is_third
         , case when subpay_type IN ('AppStore', 'GooglePlay', 'AppGallery', 'Miglobal') then 'subpay_type'
                else '三方'
            end                                                   as pay_name_type
         , order_hk.pay_name                                      as pay_name
         , replace( order_hk.pay_ment_way, ' ', '')               as pay_ment_way
         , order_hk.finish_time-order_hk.create_time              as time_duration
         , t1.package_id
         , sensors_data                                           as sensors_data
         , 1                                                      as pv
      from ads.ads_trade_user_payorder_view                 as t1
      left join ads.ads_report_trade_hkpayorder_detail_view as order_hk
        on order_hk. dt >= '${开始时间}'
       and order_hk.dt <= '${结束时间}'
       and t1.order_id = order_hk.order_serial_id
     where t1.dt >= '${开始时间}'
       and t1.dt <= '${结束时间}'
       ${if(len(终端) == 0,"","and case when t1.mt=1 then 'iOS' when t1.mt=4 then 'Android' else '其他' end in ('" + 终端 + "')")}
       ${if(len(CORE) == 0,"","and COALESCE(t1.corever,'其他') in ('" + CORE + "')")}

     union all

    select '曝光'              as action
         , t1.dt
         , user_id
         , account
         , '0'               as item_count
         , 0                 as base_amount
         , case when recharge_type = 0 then '普通充值'
                when recharge_type = 810 then 'SVIP'
                when recharge_type IN ( 830, 840) then '福利包' --
                when recharge_type = 840 then '新福利包'
                when recharge_type = 850 then 'VIP'
                when recharge_type = 800 then '旧订阅卡'
                else '其他'
            end              as shop_item_type
         , case when element_id = '100390' then '弹窗'
                when element_id = '100352' then '章末推送'
                when element_id = '100400' then '阅读器返回推'
                when element_id = '100284' then 'H5活动'
                when element_id in ('100708', '100337') then '半屏'
                when element_id IN ( 100024, 100025, 100026, 100121, 100120 ) then '商店页'
                else '其他'
            end              as recharge_source
         , event_strategy_id as event_strategy_id
         , 0                 as SubscribeStatus
         , case when payment = 'GooglePlay' then '0'
                when payment = 'AppStore' then '0'
                when regexp(payment, 'GooglePlay') and regexp(payment, ',') then '1'
                when regexp(payment, 'AppStore') and regexp(payment, ',') then '1'
                when payment is null then '0'
                else '1'
            end              as is_third
         , case when payment = 'GooglePlay' then 'GooglePlay'
                when payment = 'AppStore' then 'AppStore'
                when regexp(payment, 'GooglePlay') and regexp(payment, ',') then 'GooglePlay,三方'
                when regexp(payment, 'AppStore') and regexp(payment, ',') then 'AppStore,三方'
                else '三方'
            end              as pay_name_type
         , payment           as pay_name
         , payment_way       as pay_ment_way
         , 0                 as time_duration
         , '99'              as package_id
         , '99'              as sensorsData
         , exposure_pv       as pv
      from ads.ads_bi_sr_third_payment_exposure_pv_di as t1
      left join group_view                            as t2
        on t1.user_id = t2.account
       and t1.dt = t2.dt
     where t1.dt >= '${开始时间}'
       and t1.dt <= '${结束时间}'
       ${if(len(CORE) == 0,"","and COALESCE(t1.core,'其他') in ('" + CORE + "')")}
       ${if(len(终端) == 0,"","and case when mt = 1 then 'iOS' when mt = 4 then 'Android' else '其他' end in ('" + 终端 + "')")}

     union all

    select '创建订单'                                                                as action
         , dt
         , coalesce(login_id,identity_user_id)                                      as user_id
         , '0'                                                                      as account
         , '0'                                                                      as item_count
         , 0                                                                        as base_amount
         , case when recharge_type = 0 then '普通充值'
                when recharge_type = 810 then 'SVIP'
                when recharge_type IN ( 830, 840) then '福利包' --
                when recharge_type = 840 then '新福利包'
                when recharge_type = 850 then 'VIP'
                when recharge_type = 800 then '旧订阅卡'
                else '其他'
            end                                                                     as shop_item_type
         , case when element_id = '100390' then '弹窗'
                when element_id = '100352' then '章末推送'
                when element_id = '100400' then '阅读器返回推'
                when element_id = '100284' then 'H5活动'
                when element_id IN ('100708', '100337') then '半屏'
                when element_id IN ( 100024, 100025, 100026, 100121, 100120 ) then '商店页'
                else '其他'
            end                                                                     as recharge_source
         , case when element_id IN ('100390', '100352', '100400', '100284') then activity_id
                else event_strategy_id
            end                                                                     as event_strategy_id
         , 0                                                                        as SubscribeStatus
         , if(zffs in ('苹果支付','谷歌支付','GooglePlay','AppStore','Google Play') , 0, 1) as is_third
         , case when zffs in ('苹果支付', 'AppStore') then 'AppStore'
                when zffs in ('谷歌支付', 'GooglePlay', 'Google Play') then 'GooglePlay'
                else '三方'
            end                                                                     as pay_name_type
         , coalesce(t_zffs.payment,zffs)                                            as pay_name
         , coalesce(replace(t_zffs.payment_way,' ',''), zffs)                       as pay_ment_way
         , 0                                                                        as time_duration
         , ''                                                                       as package_id
         , ''                                                                       as sensors_data
         , count(1)                                                                 as pv
      from ods_log.ods_sensors_cd_video_production_ordercreateaction as t1
      left join ads.ads_tag_center_third_payment_rate_view           as t_zffs
        on t1.zffs_id = t_zffs.id
      left join dim.dim_user_all_info                                as tu
        on t1.identity_user_id = tu.user_id
     where t1.dt >= '${开始时间}'
       and t1.dt <= '${结束时间}'
       and project_id = 5
       and element_id NOT IN ('100647', '100651', '100107')
       ${if(len(CORE) == 0,"","and COALESCE(t1.app_core_ver,'其他') in ('" + CORE + "')")}
       ${if(len(终端) == 0,"","and case when os in ('iOS','Android') then os when tu.mt = 1 then 'iOS' when tu.mt = 4 then 'Android' else '其他' end in ('" + 终端 + "')")}
     group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14
)
, e_info as (
    select case when max_by(scene_type, coalesce(plan_code,'-')) = 1 then '商店页'
                when max_by(scene_type, coalesce(plan_code,'-')) = 2 then '半屏'
                when max_by(scene_type, coalesce(plan_code,'-')) = 3 then '即冲即消'
            end                         as location
         , tactics_id
         , max(coalesce(plan_code,'-')) as strategy_code
         , max(tactics_name)            as strategy_name
      from dim.tag_center_merchandise_tactics_view
     group by tactics_id

     union all

    select '资源位'                 as location
         , tactics_id
         , coalesce(plan_code,'-') as strategy_code
         , tactics_name            as strategy_name
      from dim.dim_tag_center_activity_view
)
select z0.dt                                                                                 as `日期`
     , case when SubscribeStatus = 2 then '续订(或策略id为空)'
            when event_strategy_id is null then '续订(或策略id为空)'
            when event_strategy_id < 1 then '续订(或策略id为空)'
            else recharge_source
        end                                                                                  as `充值来源`
     , case when SubscribeStatus = 2 then '续订'
            when event_strategy_id is null then '策略id为空'
            when event_strategy_id < 1 then '策略id为空'
            else event_strategy_id
        end                                                                                  as `策略ID`
     , max(concat(strategy_code,'：',strategy_name))                                          as `策略代号&名称`
     , max(strategy_code)                                                                    as `策略代号`
     , max(strategy_name)                                                                    as `名称`
     , count(distinct if(action = '曝光',user_id,null))                                       as `曝光UV`
     , sum(if(action = '曝光',pv,0))                                                          as `曝光PV`
     , count(distinct if(action = '曝光' and is_third,user_id,null))                          as `三方曝光UV`
     , count(distinct if(action = '曝光',account,null))                                       as `入包UV`
     , count(distinct if(action = '创建订单' and is_third = 0,user_id,null))                   as `原生下单UV`
     , count(distinct if(action = '创建订单' and is_third = 1,user_id,null))                   as `三方下单UV`
     , count(distinct if(action = '充值成功' and is_third = 0,user_id,null))                   as `原生充值UV`
     , count(distinct if(action = '充值成功' and is_third = 1,user_id,null))                   as `三方充值UV`
     , sum(if(action = '充值成功' and is_third = 0,pv,0))                                      as `原生充值PV`
     , sum(if(action = '充值成功' and is_third = 1,pv,0))                                      as `三方充值PV`
     , sum(if(action = '充值成功' and is_third = 0 and time_duration <= 1800,time_duration,0)) as `原生支付时长`
     , sum(if(action = '充值成功' and is_third = 0 and time_duration <= 1800,pv,0))            as `原生支付时长次数`
     , sum(if(action = '充值成功' and is_third = 1 and time_duration <= 1800,time_duration,0)) as `三方支付时长`
     , sum(if(action = '充值成功' and is_third = 0 and time_duration <= 1800,pv,0))            as `三方支付时长次数`
     , sum(if(action = '充值成功' and is_third = 0,base_amount,0))                             as `原生充值金额`
     , sum(if(action = '充值成功' and is_third = 1,base_amount,0))                             as `三方充值金额`
     , max(user_id)
  from z0
  left join z1
    on z0.dt = z1.dt
   and z0.user_id0 = z1.user_id
  left join e_info
    on event_strategy_id = tactics_id
    ${if(hitgroup == '否' ," "," inner join (select user_id as user_id_gp
                                                  , date(min(create_time)) as s_date
                                                  , date(max(end_time)) as e_date
                                               from ads.ads_market_realtime_group_log_view
                                              where 1=1
                                                and op_type = 0
                                                and dt >= date_add('" + 开始时间 + "',-30)
                                                and dt  < date_add('" + 结束时间 + "',30)
                                                and group_id in ('" +  人群包ID + "')
                                              group by 1
                                              union all
                                             select UserId as user_id
                                                  , date(min(CreateTime )) as s_date
                                                  ,     date(max(EndTime)) as e_date
                                               from ads.ads_sr_beidou_group_crowd_log
                                              where ProjectId = 1
                                                and Operation = 1
                                                and dt >= date_add('" + 开始时间 + "',-30)
                                                and dt  < date_add('" + 结束时间 + "',30)
                                                and SubCrowdId in ('" +  人群包ID + "')
                                              group by 1
                                           ) t4
    on z0.user_id0 = t4.user_id_gp
   and z0.dt >= s_date
   and z0.dt <= e_date ")}
 where 1 = 1
       ${if(len(策略代号) == 0,"","and strategy_code in ('" + 策略代号 + "')")}
       ${if(len(策略名称) == 0,"","and strategy_name in ('" + 策略名称 + "')")}
       ${if(len(档位类型) == 0,"", "and shop_item_type in ('" + 档位类型 + "')")}
       ${if(len(支付渠道类型) == 0,"","and regexp(pay_name_type, (select pay_ment_type from z_p) )")}
       ${if(len(支付渠道) == 0,"","and regexp(pay_name, (select pay_ment from z_p) )")}
       ${if(len(子支付渠道) == 0,"","and regexp(pay_ment_way, (select pay_ment_way from z_p) )")}
 group by 1, 2, 3
;
