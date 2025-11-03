----------------------------------------------------------------
-- 程序功能： 海剧三方支付漏斗报表-充值成功
-- 程序名： P_ads_sv_third_party_payment_funnel_recharge
-- 目标表： ads.ads_sv_third_party_payment_funnel_recharge
-- 负责人： wx
-- 开发日期：2025-10-20
-- 版本号：v0.3.1
----------------------------------------------------------------
insert into ads.ads_sv_third_party_payment_funnel_recharge
-- 活跃表
with active as(
    select t1.dt
          ,t1.user_id
          ,t1.period_type
          ,t1.user_type
          ,t1.corever
          ,dic_mt.enum_name    as mt
          ,dic_lang.remarks    as language2
      from dws.dws_user_short_video_wide_active_period_ed    as t1
      left join dim.dim_dic                                  as dic_lang  -- 注册/投放语言
        on t1.current_language2 = dic_lang.enum_id
       and dic_lang.table_name = 'dim_producttype'
       and dic_lang.dic_column = 'language_id'
      left join dim.dim_dic                                  as dic_mt  -- mt
        on t1.mt = dic_mt.enum_id
       and dic_mt.table_name = 'dim_user_accountinfo_df'
       and dic_mt.dic_column = 'mt'
     where product_id = 6833
       and dt >= '${bf_1_dt}'
       and dt <= '${dt}'
     group by 1, 2, 3, 4, 5, 6, 7
),
-- 字典表
dim_strategy as (
    select Id                                              as id
          ,Name                                            as name
          ,max(StrategyCode)                               as strategy_code
          ,null                                            as sort
          ,max(case when action_type = 3 then sort end)    as sort_popup
          ,max(case when action_type =9 then sort end)     as sort_return
      from ods.ods_tidb_short_video_center_activity                     as a
      left join ads.ads_tidb_short_video_center_activity_position_view  as b
        on a.Id = b.center_activity_id
     group by 1,2
     union all
    select id
          ,name
          ,strategy_code
          ,sort
          ,null    as sort_popup
          ,null    as sort_return
    from ads.ads_sv_goods_strategy_view
),
-- 订单表数据
payorder as(select dt
                  ,user_id
                  ,case when mt=1 then 'iOS'
                        when mt=4 then 'Android'
                        else '其他'
                    end               as mt
                  ,corever2           as core
                  ,base_amount/100    as base_amount
                  ,order_id
                  ,t1.create_time
                  ,case when SPLIT(get_json_string(custom_data, '$.sendId'), '_')[1]='201300' then '商店页'
                        when SPLIT(get_json_string(custom_data, '$.sendId'), '_')[1]='200900' then '半屏'
                        when SPLIT(get_json_string(custom_data, '$.sendId'), '_')[1]='200800' and SPLIT(get_json_string(custom_data, '$.sendId'), '_')[2]='0' then '解锁页VIP'
                        when SPLIT(get_json_string(custom_data, '$.sendId'), '_')[1]='203300' then 'H5' 
                        when SPLIT(get_json_string(custom_data, '$.sendId'), '_')[1] is null
                             then (case when split(get_json_string(custom_data, '$.activityLink'), '_')[1]=202100 
                                         and split(get_json_string(custom_data, '$.activityLink'), '_')[2] in (0,1) then '普通弹窗'
                                        when split(get_json_string(custom_data, '$.activityLink'), '_')[1]=202100
                                         and split(get_json_string(custom_data, '$.activityLink'), '_')[2]=3 then '充值返回推弹窗'
                                        when split(get_json_string(custom_data, '$.activityLink'), '_')[1]=202100
                                         and split(get_json_string(custom_data, '$.activityLink'), '_')[2] in (12) then '充值弹层'
                                        when split(get_json_string(custom_data, '$.activityLink'), '_')[1]=200800
                                         and SPLIT(get_json_string(custom_data, '$.sendId'), '_')[2]='0' then '解锁页VIP'
                                        when split(get_json_string(custom_data, '$.activityLink'), '_')[1]=205000  then '会员中心页'
                                        when split(get_json_string(custom_data, '$.activityLink'), '_')[1]=203200 then '悬浮窗'
                                        when split(get_json_string(custom_data, '$.activityLink'), '_')[1]=204000 then 'TAB栏'
                                        when split(get_json_string(custom_data, '$.activityLink'), '_')[1]=204100 then 'banner'
                                        when split(get_json_string(custom_data, '$.activityLink'), '_')[1]=210010 then 'push'
                                        when split(get_json_string(custom_data, '$.activityLink'), '_')[1]=203600 then '开屏页'
                                        when split(get_json_string(custom_data, '$.activityLink'), '_')[1] is null then '其他'
                                        else split(get_json_string(custom_data, '$.activityLink'), '_')[1]
                                    end
                                  )
                        when SPLIT(get_json_string(custom_data, '$.sendId'), '_')[1]='202100'
                         and SPLIT(get_json_string(custom_data, '$.sendId'), '_')[2] in ('0','1') then '普通弹窗'
                        when SPLIT(get_json_string(custom_data, '$.sendId'), '_')[1]='202100'
                         and SPLIT(get_json_string(custom_data, '$.sendId'), '_')[2] in ('3') then '充值返回推弹窗'
                        when SPLIT(get_json_string(custom_data, '$.sendId'), '_')[1]='202100'
                         and SPLIT(get_json_string(custom_data, '$.sendId'), '_')[2] in ('12') then '充值弹层'
                        else '其他'
                    end                                                    as recharge_source
                  ,get_json_string(custom_data, '$.strategyId')            as strategy_id
                  ,get_json_string(cooorder_extinfo, '$.SubscribeStatus')  as SubscribeStatus
                  ,case when shop_item = 0 then '普通充值'
                        when shop_item = 810 then 'SVIP'
                        when shop_item = 840 then '签到卡'
                        else '其他'
                    end                                                    as shop_item_type
                  ,case when subpay_type = 'AppStore' then 'iOS'
                        when subpay_type = 'GooglePlay' then '安卓'
                        when subpay_type = 'AppGallery' then '华为'
                        when subpay_type = 'MiGlobal' then '小米'
                        else '三方'end as zfqd
                  ,if(subpay_type in ('AppStore','GooglePlay','AppGallery','MiGlobal'), 0, 1) as if_third
                  ,time_duration from (select *
                                         from ads.ads_short_video_payorder_view
                                        where test_flag=0
                                          and product_id=6833
                                          and test_flag = 0
                                          and dt >= '${bf_1_dt}'
                                          and dt <= '${dt}'
                                      )         as t1
                                 left join (select order_serial_id
                                                  ,finish_time - create_time    as time_duration
                                              from ads.ads_report_trade_hkpayorder_detail_view order_hk
                                             where product_id = 6833
                                               and dt >= '${bf_1_dt}'
                                               and dt <= '${dt}'
                                           )    as t2
                                  on t1.order_id = t2.order_serial_id
)
-- 活跃关联充值成功
select payorder.dt
      ,payorder.user_id
      ,period_type
      ,order_id
      ,user_type
      ,language2
      ,coalesce(payorder.core, active.corever)    as core
      ,coalesce(payorder.mt, active.mt)           as mt
      ,create_time
      ,case when strategy_id is null then '续订(或策略id为空)'
            when SubscribeStatus=2 and shop_item_type in ('SVIP','签到卡') then '续订(或策略id为空)'
            when strategy_id in (21907679071567884,21412617518317655,21412110712176725
                                 ,21411962535805011,59996164203217021,90064658960220161,72785256107606176) then '商店页'
            when strategy_id in(119945781576073372,119945781576073373,119945781576073374,119945781576073375
                                ,119945781576073376,119945781576073377,119945781576073378,119945781576073379
                                ,119945781576073380,119945781576073381,119945781576073382,119945781576073383
                                ,119741098431744170,119741098431744171) then 'H5'
            when strategy_code regexp '^HC' THEN 'H5'
            else recharge_source
        end                                                       as recharge_source
      ,if(strategy_id is null, '续订(或策略id为空)', strategy_id)  as strategy_id
      ,shop_item_type
      ,zfqd
      ,if_third
      ,SubscribeStatus
      ,time_duration
      ,base_amount
      ,now()                                                      as etl_time
  from active
  left join payorder
    on active.user_id = payorder.user_id
   and active.dt = payorder.dt
  left join dim_strategy c
  	on payorder.strategy_id = c.id
 where time_duration < 1800
   and payorder.user_id is not null
;