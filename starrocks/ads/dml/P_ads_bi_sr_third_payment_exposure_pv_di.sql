----------------------------------------------------------------
-- 程序功能： 海阅三方支付漏斗报表——曝光数据
-- 程序名： P_ads_bi_sr_third_payment_exposure_pv_di
-- 目标表： ads.ads_bi_sr_third_payment_exposure_pv_di
-- 负责人： roger
-- 开发日期： 2025-12-10
----------------------------------------------------------------

insert into ads.ads_bi_sr_third_payment_exposure_pv_di
select a.dt
     , ifnull(a.element_id, -99)             as element_id
     , ifnull(a.event_strategy_id, -99)      as event_strategy_id
     , a.core
     , a.mt
     , a.user_id
     , ifnull(a.programme_id, -99)           as programme_id
     , ifnull(a.recharge_type, -99)          as recharge_type
     , group_concat(distinct a.zffs_id_list) as zffs_id_list
     , group_concat(distinct case when unnest = 0 and mt = 1 then 'AppStore'
                                  when unnest = 0 and mt = 4 then 'GooglePlay'
                                  else b.payment
                             end
                   )                         as payment
     , group_concat(distinct case when unnest = 0 and mt = 1 then 'AppStore'
                                  when unnest = 0 and mt = 4 then 'GooglePlay'
                                  else b.payment_way
                              end
                   )                         as payment_way
     , count(distinct left (event_tm, 19))   as exposure_pv  -- 曝光PV
     , count(1)                              as exposure_pv2 -- 曝光PV
     , now()                                 as etl_time
  from (select cast(concat('[', t0.zffs_id_list, ']') as ARRAY<int>) as zffs_id_list_array
             , t0.dt
             , t0.element_id                                         as element_id
             , case when t0.element_id = '100708' and t0.element_type in (0, -1) then t0.event_strategy_id
                    when t0.element_id in (100024, 100025, 100126, 100365) then t0.event_strategy_id
                    when t0.element_id = '100400' and split(t0.pay_link, '_')[1] = 'returnrecommend'
                        then split(t0.pay_link, '_')[4]
                    when t0.element_id = '100390' and split(t0.pay_link, '_')[1] = 'popup' then split(t0.pay_link, '_')[4]
                    when t0.event_strategy_id > 0 then t0.event_strategy_id
                    else t0.activity_id
                end                                                  as event_strategy_id -- 策略ID
             , ifnull(t0.app_core_ver, -99)                          as core
             -- 在core=15的情况下要能区分ios和安卓
             , case when t0.mt is not null then t0.mt
                    when lower(t0.os) = 'ios' then 1
                    when lower(t0.os) = 'android' then 4
                    else if(t0.app_core_ver = 15 and t1.mt is not null, t1.mt, -99)
               end                                                   as mt
             , coalesce(t0.identity_user_id, t0.login_id)            as user_id
             , t0.programme_id
             , t0.recharge_type
             , t0.event_tm
             , t0.zffs_id_list
          from ads.ads_sensors_production_rechargeexposure_view as t0
          left join (select distinct id as user_id
                           , mt
                       from dim.dim_user_account_info_view
                    )                                           as t1
            on coalesce(t0.identity_user_id, t0.login_id) = t1.user_id
         where t0.dt >= '${bf_1_dt}'
           and t0.dt <= '${dt}'
           and t0.project_id = 5
           and t0.element_id not in ('100647', '100651', '100107')
       )                                                        as a
  left join unnest(zffs_id_list_array)                          as unnest
    on true
  left join ads.ads_tag_center_third_payment_rate_view b
    on unnest = b.id
 where cast(a.user_id as int) > 0
 group by 1, 2, 3, 4, 5, 6, 7, 8
;