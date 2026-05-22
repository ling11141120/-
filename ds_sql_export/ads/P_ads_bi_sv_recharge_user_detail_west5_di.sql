----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_bi_sv_recharge_user_detail_west5_di
-- workflow_version : 4
-- create_user      : xixg
-- task_name        : ads_bi_sv_recharge_user_detail_west5_di
-- task_version     : 4
-- update_time      : 2025-07-18 17:20:10
-- sql_path         : \starrocks\tbl_ads_bi_sv_recharge_user_detail_west5_di\ads_bi_sv_recharge_user_detail_west5_di
----------------------------------------------------------------
-- SQL语句
insert into  ads.`ads_bi_sv_recharge_user_detail_west5_di`
-- 活跃表
with t123 as(
    -- dt,user_id,period_type
    select
        t1.dt,
        t1.user_id,
        period_type,
        user_type,
        dic_lang.remarks,
        case
            when country_level =1 then 'T1'
            when country_level =2 then 'T2'
            else '其他'
            end as country_level,
        dic_mt.enum_name,
        COALESCE(t1.corever,'其他') as corever
    from dws.dws_user_short_video_wide_active_period_west5_ed t1
             left join dim.dim_dic dic_lang  -- 注册/投放语言
                       on t1.current_language2 = dic_lang.enum_id
                           and dic_lang.table_name = 'dim_producttype'
                           and dic_lang.dic_column = 'language_id'
             left join dim.dim_dic  dic_mt  -- mt
                       on t1.mt = dic_mt.enum_id
                           and dic_mt.table_name = 'dim_user_accountinfo_df'
                           and dic_mt.dic_column = 'mt'
             left join dim.dim_country_dic b
                       on t1.reg_country=b.code
    where dt = '${bf_1_dt}'
      and product_id=6833
    group by 1,2,3,4,5,6,7,8
),

-- 订单表数据
t2 as(
 select
     '${bf_1_dt}' AS dt,a.create_time,a.user_id,a.corever2,dic_mt.enum_name,
     case
         when a.item_count<10 then concat('00',cast(a.item_count as varchar))
         when a.item_count<100 then concat('0',cast(a.item_count as varchar))
         else cast(a.item_count as varchar) end item_count,
     a.base_amount/100 base_amount,a.shop_item,a.package_id,
     case
         when SPLIT(get_json_string(a.custom_data, '$.sendId'), '_')[1]='201300' then '商店页'
         when SPLIT(get_json_string(a.custom_data, '$.sendId'), '_')[1]='200900' then '半屏'
         when SPLIT(get_json_string(a.custom_data, '$.sendId'), '_')[1]='203300' then 'H5'
         when SPLIT(get_json_string(a.custom_data, '$.sendId'), '_')[1] is null then '半屏'
         when SPLIT(get_json_string(a.custom_data, '$.sendId'), '_')[1]='202100'
             and SPLIT(get_json_string(a.custom_data, '$.sendId'), '_')[2] in ('0','1') then '普通弹窗'
         when SPLIT(get_json_string(a.custom_data, '$.sendId'), '_')[1]='202100'
             and SPLIT(get_json_string(a.custom_data, '$.sendId'), '_')[2] in ('3') then '充值返回推弹窗'
         else '其他' end recharge_source,
     get_json_string(a.custom_data, '$.activityId')  activity_id,
     get_json_string(a.custom_data, '$.strategyId') strategy_id,
     get_json_string(a.cooorder_extinfo, '$.SubscribeStatus') SubscribeStatus,
     case when a.shop_item=0 then '普通充值'
          when a.shop_item=810 then 'SVIP'
          when a.shop_item=840 then '签到卡'
          else '其他' end shop_item_type,
     ifnull(b.vip_type, case
                            when datediff(a.vip_expire_time, a.create_time) >= 25 and datediff(a.vip_expire_time, a.create_time) <= 35 then 1 -- 月卡
                            when datediff(a.vip_expire_time, a.create_time) >= 80 and datediff(a.vip_expire_time, a.create_time) <= 100 then 2 -- 季卡
                            when datediff(a.vip_expire_time, a.create_time) >= 350 and datediff(a.vip_expire_time, a.create_time) <= 380 then 3 -- 年卡
                            when datediff(a.vip_expire_time, a.create_time) >= 1 and datediff(a.vip_expire_time, a.create_time) <= 9 then 4 -- 周卡
         end) as vip_type,
     a.subpay_type,
     seconds_diff(c.FinishTime,a.create_time) as finish_time
 from ads.ads_short_video_payorder_view a    --  dwd_trade_short_video_payorder
left join (
             select
                 item_id, shop_item_id, vip_type
             from dim.dim_short_video_goods_view
             where shop_item_id in(840,810)
               and is_remove=0
             group by 1, 2, 3
         ) b
    on SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(ExtInfo,'|',-1),'com.changdu.mobovideo.',-1),'com.changdu.moboshort.',-1),'com.changjian.moboshortcj.',-1),'third.',-1) = b.item_id
           and a.shop_item = b.shop_item_id
left join dim.dim_dic  dic_mt  -- mt
        on a.mt = dic_mt.enum_id
            and dic_mt.table_name = 'dim_user_accountinfo_df'
            and dic_mt.dic_column = 'mt'
left join ods.ods_tidb_sr_sharpengine_pay_hk_sync_payorder_di c on a.order_id = c.OrderSerialId
 where a.test_flag=0
   and a.dt>='${bf_1_dt}' and a.dt<='${dt}'
   and DATE(date_sub(a.create_time,INTERVAL 13 HOUR)) = '${bf_1_dt}'

)
        ,
-- 充值档位曝光事件
t3 as(
 select
    '${bf_1_dt}' as dt,
     case
         when element_id='200900' or page_id='200900' then '半屏'
         when page_id ='201300' then '商店页'
         when page_id ='203300' then 'H5'
         when element_id='202100' and element_type in('0','1') then '普通弹窗'
         when element_id='202100' and element_type in('3') then '充值返回推弹窗'
         else '其他' end recharge_source,
     -- case
     -- when cast(real_recharge as float)<10 then concat('00',real_recharge )
     -- when  cast(real_recharge as float)<100 then concat('0',real_recharge)
     -- else real_recharge end item_count,
     event_strategy_id strategy_id,
     -- case
     -- when czlx='vip' then 'SVIP'
     -- when czlx='签到卡充值' then '签到卡'
     -- else '普通充值'  end shop_item_type,
     login_id user_id,core,os,
     count(login_id) as exposure_pv
 from ads.ads_sensors_cd_video_rechargeexposure_view
 where  dt>='${bf_1_dt}' and dt<='${dt}'
   and DATE(date_add(event_tm,INTERVAL -13 HOUR)) = '${bf_1_dt}'
   and  product_id = '6833'
 group by 1,2,3,4,5,6
),

-- 广告曝光事件
t3a as(
 select
    '${bf_1_dt}' AS dt,
     case
         when element_id='200900' or page_id='200900' then '半屏'
         when page_id ='201300' then '商店页'
         when page_id ='203300' then 'H5'
         when element_id='202100' and element_type in('0','1') then '普通弹窗'
         when element_id='202100' and element_type in('3') then '充值返回推弹窗'
         else '其他' end recharge_source,
     main_strategy_id strategy_id,
     login_id user_id,core,os,
     count(login_id) as ad_exposure_pv
 from ads.ads_sensors_cd_video_adpositionexposure_view
 where  dt>='2025-03-26' ---改功能03.26上线
   and dt>='${bf_1_dt}' and dt<='${dt}'
   and  DATE(date_add(event_tm,INTERVAL -13 HOUR)) = '${bf_1_dt}'
   and  product_id = '6833'
   and main_strategy_id  is not null
 group by 1,2,3,4,5,6
),

-- 广告收益数据
t3b as(
 select
     dt,
     '半屏' recharge_source,
     main_strategy_id strategy_id,
     user_id,core,dic_mt.enum_name,
     sum(amt) amt
 from
     dws.dws_advertisement_user_position_amt_west5_ed a
         left join dim.dim_dic  dic_mt  -- mt
                   on a.mt = dic_mt.enum_id
                       and dic_mt.table_name = 'dim_user_accountinfo_df'
                       and dic_mt.dic_column = 'mt'
 where dt = '${bf_1_dt}'
   and product_id=6833
   and main_strategy_id is not null
 group by 1,2,3,4,5,6
),
-- 创建订单事件
t4 as (
 select
     case
         when element_id='200900' or page_id='200900' then '半屏'
         when page_id ='201300' then '商店页'
         when page_id ='203300' then 'H5'
         when element_id='202100' and element_type in('0','1') then '普通弹窗'
         when element_id='202100' and element_type in('3') then '充值返回推弹窗'
         else '其他' end recharge_source,
     case
         when cast(real_recharge as float)<10 then concat('00',real_recharge )
         when  cast(real_recharge as float)<100 then concat('0',real_recharge)
         else real_recharge end item_count,
     event_strategy_id strategy_id,
     case
         when czlx='vip' then 'SVIP'
         when czlx='签到卡充值' then '签到卡'
         else '普通充值'  end shop_item_type,
     login_id user_id,
     core,
     os as mt,
     -- event_tm,
    '${bf_1_dt}' AS dt,
     zffs as subpay_type,
     send_id
 from ads.ads_sensors_cd_video_ordercreateaction_view
 where  dt>='${bf_1_dt}' and dt<='${dt}'
      and  DATE(date_add(event_tm,INTERVAL -13 HOUR)) = '${bf_1_dt}'
      and   app_id = 683001001
 group by 1,2,3,4,5,6,7,8,9,10
),

-- 活跃关联曝光
z1 as (
 select
     dt,period_type,user_id,user_type,remarks,country_level,mt,corever,recharge_source,strategy_id,
     max(exposure_uv) as exposure_uv,max(exposure_pv) as exposure_pv,max(ad_exposure_uv) as ad_exposure_uv,max(ad_exposure_pv) as ad_exposure_pv
 FROM
     (
         select
             t3.dt ,
             t123.period_type,
             t123.user_id,
             t123.user_type,
             t123.remarks,
             t123.country_level,
             ifnull(t3.os, t123.enum_name) as mt,
             ifnull(t3.core, t123.corever) as corever,
             case
                 when t3.strategy_id is null then '续订(或策略id为空)'
                 -- when SubscribeStatus=2 and shop_item_type in ('SVIP','签到卡') then '续订(或策略id为空)'
                 when t3.strategy_id in (
                                         21907679071567884,
                                         21412617518317655,
                                         21412110712176725,
                                         21411962535805011,
                                         59996164203217021,
                                         90064658960220161,
                                         72785256107606176) then '商店页'
                 else t3.recharge_source end recharge_source,
             case
                 when t3.strategy_id is null then '续订(或策略id为空)'
                 else t3.strategy_id end strategy_id,
             -- shop_item_type 档位类型,
             -- item_count 充值档位,
             1 as exposure_uv,
             sum(t3.exposure_pv) exposure_pv,
             0 as ad_exposure_uv,
             0 as ad_exposure_pv
         from t123
                  left join t3
                            on t123.user_id = t3.user_id and t123.dt = t3.dt
         group by 1,2,3,4,5,6,7,8,9,10

         union all

         select
             t3a.dt ,
             t123.period_type,
             t123.user_id,
             t123.user_type,
             t123.remarks,
             t123.country_level,
             ifnull(t3a.os, t123.enum_name) as mt,
             ifnull(t3a.core, t123.corever) as corever,
             case
                 when t3a.strategy_id is null then '续订(或策略id为空)'
                 -- when SubscribeStatus=2 and shop_item_type in ('SVIP','签到卡') then '续订(或策略id为空)'
                 when t3a.strategy_id in (
                                          21907679071567884,
                                          21412617518317655,
                                          21412110712176725,
                                          21411962535805011,
                                          59996164203217021,
                                          90064658960220161,
                                          72785256107606176) then '商店页'
                 else t3a.recharge_source end recharge_source,
             case
                 when t3a.strategy_id is null then '续订(或策略id为空)'
                 else t3a.strategy_id end strategy_id,
             -- shop_item_type 档位类型,
             -- item_count 充值档位,
             0 as exposure_uv,
             0 as  exposure_pv,
             1 as  ad_exposure_uv,
             sum(t3a.ad_exposure_pv) ad_exposure_pv
         from t123
                  inner join t3a
                             on t123.user_id = t3a.user_id and t123.dt = t3a.dt
         group by 1,2,3,4,5,6,7,8,9,10
     ) z1a
 where 1=1
 group by 1,2,3,4,5,6,7,8,9,10
 -- and recharge_source in ('半屏')
),

-- 活跃关联充值
z2 as(
 select
     *
 FROM
     (
         select
             t2.dt ,
             t123.period_type,
             t123.user_id,
             t123.user_type,
             t123.remarks,
             t123.country_level,
             ifnull(t2.enum_name, t123.enum_name) as mt,
             ifnull(t2.corever2, t123.corever) as corever,
             case
                 when strategy_id is null then '续订(或策略id为空)'
                 when SubscribeStatus=2 and shop_item_type in ('SVIP','签到卡') then '续订(或策略id为空)'
                 when strategy_id in (
                                      21907679071567884,
                                      21412617518317655,
                                      21412110712176725,
                                      21411962535805011,
                                      59996164203217021,
                                      90064658960220161,
                                      72785256107606176) then '商店页'
                 when strategy_id in(
                                     119945781576073372,
                                     119945781576073373,
                                     119945781576073374,
                                     119945781576073375,
                                     119945781576073376,
                                     119945781576073377,
                                     119945781576073378,
                                     119945781576073379,
                                     119945781576073380,
                                     119945781576073381,
                                     119945781576073382,
                                     119945781576073383,
                                     119741098431744170,
                                     119741098431744171
                     ) then 'H5'
                 else recharge_source end recharge_source,
             case
                 when strategy_id is null then '续订(或策略id为空)'
                 else strategy_id end strategy_id,
             shop_item_type , -- 档位类型
             vip_type,
             ifnull(subpay_type, '三方支付') as subpay_type,
             item_count , -- 充值档位
             1 as  recharge_un, --
             count(t2.user_id) recharge_times, -- 充值次数
             sum(base_amount) recharge_amount, -- 充值金额
             sum(case when shop_item_type='普通充值' then base_amount end) `normal_recharge_amount`,-- `充值金额-普通充值`,
             sum(case when shop_item_type='签到卡' then base_amount end) `signin_recharge_amount`,-- `充值金额-签到卡`,
             sum(case when shop_item_type='SVIP' then base_amount end) `svip_recharge_amount`,-- `充值金额-SVIP`,
             count(case when shop_item_type='普通充值' then t2.user_id end) `normal_recharge_times`,-- `充值次数-普通充值`,
             count(case when shop_item_type='签到卡' then t2.user_id end) `signin_recharge_times`,-- `充值次数-签到卡`,
             count(case when shop_item_type='SVIP' then t2.user_id end) `svip_recharge_times`,-- `充值次数-SVIP`,
             sum(case when shop_item_type='普通充值' then 1 end) `normal_recharge_un`,-- `充值人数-普通充值`,
             sum(distinct case when shop_item_type='签到卡' then 1 end) `signin_recharge_un`,-- `充值人数-签到卡`,
             sum(distinct case when shop_item_type='SVIP' then 1 end) `svip_recharge_un`, -- `充值人数-SVIP`,
             sum(distinct case when shop_item_type !='普通充值' then 1 end) `recharge_un_subscription`,-- `充值人数-订阅`
             avg(finish_time) as finish_time
         from t123
                  inner join t2 on t123.user_id = t2.user_id and t123.dt = t2.dt
         group by 1,2,3,4,5,6,7,8,9,10,11,12,13,14
     ) z2a
 where 1=1
 -- and 充值来源 in ('半屏')
),

-- 活跃关联广告收益
z3 as(
 select
     *
 FROM
     (
         select
             t3b.dt ,
             t123.period_type,
             t123.user_id,
             t123.user_type,
             t123.remarks,
             t123.country_level,
             ifnull(t3b.enum_name, t123.enum_name) as mt,
             ifnull(t3b.core, t123.corever) as corever,
             recharge_source  ,
             strategy_id  ,
             sum(amt) ad_amt
         from t123
                  inner join t3b
                             on t123.user_id = t3b.user_id and t123.dt = t3b.dt
         group by 1,2,3,4,5,6,7,8,9,10
     ) z3a
 where 1=1
 -- and 充值来源 in ('半屏')
)
        ,
z4 as (
 SELECT account_id as user_id, value_micros * 1000 AS sv_last_preload_ecpm
 FROM (
          SELECT
              account_id,
              value_micros,
              create_time,
              ROW_NUMBER() OVER (PARTITION BY account_id ORDER BY ID DESC) AS rn
          FROM dwd.dwd_sv_advertise_ad_preload_revenue_di_view -- ods_tidb_sv_short_video_log_ad_preload_revenue_di
      ) t
 WHERE rn = 1
)
,
z5 as (
 SELECT user_id ,recharge_amount as recharge_mode
 FROM (
          SELECT user_id,item_count  AS recharge_amount, Frequency,
                 ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY Frequency DESC) AS rn
          FROM (
                   SELECT user_id, item_count, COUNT(1) AS Frequency
                   FROM dwd.dwd_trade_short_video_payorder   -- dwd_trade_short_video_payorder
                   GROUP BY 1, 2
               ) t1
      ) t2
 WHERE rn = 1
)
        ,
-- 活跃关联创建订单
z6 as(
 select
     coalesce(z1.dt,z2.dt) dt,
     coalesce(z1.period_type,z2.period_type) period_type, -- 周期类型
     coalesce(z1.strategy_id,z2.strategy_id) strategy_id, -- 策略ID
     coalesce(z1.recharge_source,z2.recharge_source) recharge_source, -- 充值来源
     coalesce(z1.user_id,z2.user_id) user_id, -- 用户id
     coalesce(z1.user_type,z2.user_type) user_type, -- 用户类型
     coalesce(z1.remarks,z2.remarks) remarks, -- 投放语言
     coalesce(z1.country_level,z2.country_level) country_level, -- 国家等级
     coalesce(z1.mt,z2.mt) mt, -- 终端
     coalesce(z1.corever,z2.corever) corever, -- core
     z2.shop_item_type,  -- 档位类型
     z2.vip_type,
     z2.subpay_type,
     z2.item_count,  -- 充值档位
     z2.recharge_un,  -- 充值人数
     z2.recharge_times,  -- 充值次数
     z2.recharge_amount,  -- 充值金额
     z2.normal_recharge_amount,  -- 充值金额-普通充值
     z2.signin_recharge_amount,  -- 充值金额-签到卡
     z2.svip_recharge_amount,  -- 充值金额-SVIP
     z2.normal_recharge_times,  -- 充值次数-普通充值
     z2.signin_recharge_times,  -- 充值次数-签到卡
     z2.svip_recharge_times,  -- 充值次数-SVIP
     z2.normal_recharge_un,  -- 充值人数-普通充值
     z2.signin_recharge_un,  -- 充值人数-签到卡
     z2.svip_recharge_un,  -- 充值人数-SVIP
     z2.recharge_un_subscription,  -- 充值人数-订阅
     z2.finish_time,  -- 订单完成用时
     z1.create_order_num
 FROM
     (
         select
             t4.dt ,
             t123.period_type,
             t123.user_id,
             t123.user_type,
             t123.remarks,
             t123.country_level,
             ifnull(t4.mt, t123.enum_name) as mt,
             ifnull(t4.core, t123.corever) as corever,
             case
                 when t4.strategy_id is null then '续订(或策略id为空)'
                 -- when SubscribeStatus=2 and shop_item_type in ('SVIP','签到卡') then '续订(或策略id为空)'
                 when t4.strategy_id in (
                                         21907679071567884,
                                         21412617518317655,
                                         21412110712176725,
                                         21411962535805011,
                                         59996164203217021,
                                         90064658960220161,
                                         72785256107606176) then '商店页'
                 else t4.recharge_source end recharge_source,
             case
                 when t4.strategy_id is null then '续订(或策略id为空)'
                 else t4.strategy_id end strategy_id,
             shop_item_type, -- 档位类型
             item_count, -- 充值档位
             subpay_type,
             count(1) as create_order_num
         from t123
  inner join t4
             on t123.user_id = t4.user_id and t123.dt = t4.dt
         group by 1,2,3,4,5,6,7,8,9,10,11,12,13
     ) z1
         full join z2
                   on z1.strategy_id=z2.strategy_id and z1.recharge_source=z2.recharge_source and z1.dt=z2.dt and z1.period_type=z2.period_type and z1.user_id=z2.user_id
                       and z1.shop_item_type=z2.shop_item_type and z1.item_count=z2.item_count and z1.subpay_type=z2.subpay_type
 where 1=1
)
,
date as (
 select
     dt,
     period_type,
     strategy_id,
     recharge_source,
     z13.user_id,
     row_1,
     6833 as product_id,
     user_type,
     remarks as put_language,
     country_level,
     mt,
     corever,
     null as strategy_name,
     null as strategy_weight,
     null as strategy_code,
     z4.sv_last_preload_ecpm,
     z5.recharge_mode,
     if(row_1=1 ,exposure_uv,0)  exposure_uv,
     if(row_1=1 ,exposure_pv,0)  exposure_pv,
     if(row_1=1 ,ad_exposure_uv,0)  ad_exposure_uv,
     if(row_1=1 ,ad_exposure_pv,0)  ad_exposure_pv,
     if(row_1=1 ,ad_amt,0)  ad_amt,
     ifnull(shop_item_type,0) shop_item_type,
     ifnull(vip_type,0) vip_type,
     ifnull(subpay_type,'三方支付') subpay_type,
     ifnull(item_count,0) item_count,
     ifnull(recharge_un,0) recharge_un,
     ifnull(recharge_times,0) recharge_times,
     ifnull(recharge_amount,0) recharge_amount,
     ifnull(normal_recharge_amount,0) normal_recharge_amount,
     ifnull(signin_recharge_amount,0) `signin_recharge_amount`,
     ifnull(svip_recharge_amount,0) `svip_recharge_amount`,
     ifnull(`normal_recharge_times`,0) `normal_recharge_times`,
     ifnull(`signin_recharge_times`,0) `signin_recharge_times`,
     ifnull(`svip_recharge_times`,0) `svip_recharge_times`,
     ifnull(`normal_recharge_un`,0) `normal_recharge_un`,
     ifnull(`signin_recharge_un`,0) `signin_recharge_un`,
     ifnull(`svip_recharge_un`,0) `svip_recharge_un`,
     ifnull(`recharge_un_subscription`,0) `recharge_un_subscription`,
     if(recharge_amount>0,1,0) as is_recharge,
     finish_time,
     create_order_num,
     now() as etl_time
 from
     (
         select
             z12.*,
             row_number() over(partition by dt,recharge_source,strategy_id,period_type,user_id order by shop_item_type, vip_type ) row_1
         from
             (
                 select
                     coalesce(z1.dt,z6.dt) dt,
                     coalesce(z1.period_type,z6.period_type) period_type, -- 周期类型
                     coalesce(z1.strategy_id,z6.strategy_id) strategy_id, -- 策略ID
                     coalesce(z1.recharge_source,z6.recharge_source) recharge_source, -- 充值来源
                     coalesce(z1.user_id,z6.user_id) user_id, -- 用户id
                     coalesce(z1.user_type,z6.user_type) user_type, -- 用户类型
                     coalesce(z1.remarks,z6.remarks) remarks, -- 投放语言
                     coalesce(z1.country_level,z6.country_level) country_level, -- 国家等级
                     coalesce(z1.mt,z6.mt) mt, -- 终端
                     coalesce(z1.corever,z6.corever) corever, -- core
                     coalesce(z1.exposure_uv,0) exposure_uv, -- 曝光UV
                     coalesce(z1.exposure_pv,0) exposure_pv, -- 曝光PV
                     coalesce(z1.ad_exposure_uv,0) ad_exposure_uv, -- 广告曝光UV
                     coalesce(z1.ad_exposure_pv,0) ad_exposure_pv, -- 广告曝光PV
                     coalesce(z3.ad_amt,0) ad_amt,  -- 广告收益
                     z6.shop_item_type,  -- 档位类型
                     z6.vip_type,
                     z6.subpay_type,
                     z6.item_count,  -- 充值档位
                     z6.recharge_un,  -- 充值人数
                     z6.recharge_times,  -- 充值次数
                     z6.recharge_amount,  -- 充值金额
                     z6.normal_recharge_amount,  -- 充值金额-普通充值
                     z6.signin_recharge_amount,  -- 充值金额-签到卡
                     z6.svip_recharge_amount,  -- 充值金额-SVIP
                     z6.normal_recharge_times,  -- 充值次数-普通充值
                     z6.signin_recharge_times,  -- 充值次数-签到卡
                     z6.svip_recharge_times,  -- 充值次数-SVIP
                     z6.normal_recharge_un,  -- 充值人数-普通充值
                     z6.signin_recharge_un,  -- 充值人数-签到卡
                     z6.svip_recharge_un,  -- 充值人数-SVIP
                     z6.recharge_un_subscription,  -- 充值人数-订阅
                     z6.finish_time,  -- 订单完成用时
                     z6.create_order_num  -- 创建订单数
                 from z1
                          full join z6
                                    on z1.strategy_id=z6.strategy_id and z1.recharge_source=z6.recharge_source and z1.dt=z6.dt and z1.period_type=z6.period_type and z1.user_id=z6.user_id
                          full join z3
                                    on z1.strategy_id=z3.strategy_id and z1.recharge_source=z3.recharge_source and z1.dt=z3.dt and z1.period_type=z3.period_type and z1.user_id=z3.user_id
             ) z12
     ) z13
         left join z4 on z13.user_id=z4.user_id
         left join z5 on z13.user_id=z5.user_id
 where dt is not null
)
select date.* from date ;
