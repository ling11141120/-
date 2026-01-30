----------------------------------------------------------------
-- 程序功能： 交易域-支付成功充值订单
-- 程序名： P_ads_bi_sv_recharge_user_detail_di
-- 目标表： ads.ads_bi_sv_recharge_user_detail_di
-- 开发人： qhr
-- 开发日期： 2026-01-23
----------------------------------------------------------------

insert into ads.ads_bi_sv_recharge_user_detail_di
-- 活跃表
with t123 as(
    select svact.dt
         , svact.user_id
         , svact.period_type
         , svact.user_type
         , dic_lang.cd_val_desc                              as remarks
         , case when svact.country_level = '1' then 'T1'
                when svact.country_level = '2' then 'T2'
                else '其他'
            end                                              as country_level
         , dic_mt.cd_val_desc                                as enum_name
         , coalesce(svact.corever, -99)                      as corever
      from dws.dws_user_short_video_wide_active_period_ed    as svact
      left join dim.dim_pub_code_mapping_dict                as dic_lang
        on svact.current_language2 = dic_lang.cd_val
       and dic_lang.app_plat = 'pub'
       and dic_lang.cd_col = 'lang_cd'
      left join dim.dim_pub_code_mapping_dict                as dic_mt
        on svact.mt = dic_mt.cd_val
       and dic_mt.app_plat = 'pub'
       and dic_mt.cd_col = 'mt'
     where svact.dt >= '${bf_1_dt}'
       and svact.dt <= '${dt}'
       and svact.product_id = 6833
     group by 1, 2, 3, 4, 5, 6, 7, 8
)
-- 订单表数据
, t2 as (
    select a.dt                                        as dt
         , a.create_time                               as create_time
         , a.user_id                                   as user_id
         , d.corever2                                  as corever2
         , dic_mt.cd_val_desc                          as enum_name
         , lpad(a.recharge_amt, 3, '0')                as item_count
         , a.base_amount/100                           as base_amount
         , a.recharge_src                              as recharge_source
         , a.strategy_id                               as strategy_id
         , a.subscribe_status                          as SubscribeStatus
         , a.recharge_type_cd                          as recharge_type_cd
         , a.recharge_type                             as shop_item_type
         , ifnull(  b.vip_type
                  , case when datediff(a.card_expire_time, a.create_time) >= 25  and datediff(a.card_expire_time, a.create_time) <= 35   then 1 -- 月卡
                         when datediff(a.card_expire_time, a.create_time) >= 80  and datediff(a.card_expire_time, a.create_time) <= 100  then 2 -- 季卡
                         when datediff(a.card_expire_time, a.create_time) >= 350 and datediff(a.card_expire_time, a.create_time) <= 380  then 3 -- 年卡
                         when datediff(a.card_expire_time, a.create_time) >= 1   and datediff(a.card_expire_time, a.create_time) <= 9    then 4 -- 周卡
                     end
                 )                                     as vip_type
         , a.recharge_channel                          as subpay_type
         , seconds_diff(c.FinishTime,a.create_time)    as finish_time
    from dwd.dwd_trade_pay_succ_recharge_order_hi                    as a
    left join (select item_id
                    , shop_item_id
                    , vip_type
                 from dim.dim_short_video_goods_view
                where shop_item_id in (840,810,860)
                  and is_remove = 0
                group by 1, 2, 3
              )                                                      as b
      on a.item_id = b.item_id
     and a.recharge_type_cd = b.shop_item_id
    left join dim.dim_pub_code_mapping_dict                          as dic_mt
      on a.mt = dic_mt.cd_val
     and dic_mt.app_plat = 'pub'
     and dic_mt.cd_col = 'mt'
    left join ods.ods_tidb_sr_sharpengine_pay_hk_sync_payorder_di    as c
      on a.order_id = c.OrderSerialId
    left join dim.dim_short_video_user_accountinfo                   as d
      on a.user_id = d.user_id
   where a.dt>='${bf_1_dt}'
     and a.dt<='${dt}'
     and a.product_id = 6833
)
-- 充值档位曝光事件
, t3 as(
    select dt
         , case when element_id='200900' or page_id='200900' then '半屏'
                when page_id ='201300' then '商店页'
                when page_id ='203300' then 'H5'
                when page_id ='205000' then '会员中心页'
                when page_id ='200800' and element_id is null then '解锁页VIP'
                when element_id='202100' and element_type in('0','1') then '普通弹窗'
                when element_id='202100' and element_type in('3') then '充值返回推弹窗'
                when element_id='202100' and element_type in('12') then '充值弹层'
                else '其他'
            end                 as recharge_source
         , event_strategy_id    as strategy_id
         , login_id             as user_id
         , core
         , os
         , count(login_id)      as exposure_pv
      from ads.ads_sensors_cd_video_rechargeexposure_view
     where dt >= '${bf_1_dt}'
       and dt <= '${dt}'
       and product_id = 6833
     group by 1, 2, 3, 4, 5, 6
)
-- 广告曝光事件
, t3a as(
    select dt
         , case when element_id = '200900' or page_id = '200900' then '半屏'
                when page_id = '201300' then '商店页'
                when page_id = '203300' then 'H5'
                when element_id = '202100' and element_type in ('0', '1') then '普通弹窗'
                when element_id = '202100' and element_type in ('3') then '充值返回推弹窗'
                else '其他'
           end              as recharge_source
         , main_strategy_id as strategy_id
         , login_id         as user_id
         , core
         , os
         , count(login_id)  as ad_exposure_pv
      from ads.ads_sensors_cd_video_adpositionexposure_view
     where dt >= '${bf_1_dt}'
       and dt <= '${dt}'
       and product_id = 6833
       and main_strategy_id is not null
     group by 1, 2, 3, 4, 5, 6
)
-- 广告收益数据
, t3b as(
    select dt
         , '半屏'                 as recharge_source
         , main_strategy_id      as strategy_id
         , user_id
         , core
         , dic_mt.cd_val_desc    as enum_name
         , sum(amt)              as amt
      from dws.dws_advertisement_user_position_amt_ed    as a
      left join dim.dim_pub_code_mapping_dict            as dic_mt
        on a.mt = dic_mt.cd_val
       and dic_mt.app_plat = 'pub'
       and dic_mt.cd_col = 'mt'
     where dt >= '${bf_1_dt}'
       and dt <= '${dt}'
       and product_id = 6833
       and main_strategy_id is not null
     group by 1, 2, 3, 4, 5, 6
)
-- 创建订单事件
, t4 as (
    select case when element_id = '200900' or page_id = '200900' then '半屏'
                when page_id = '201300' then '商店页'
                when page_id = '203300' then 'H5'
                when page_id = '205000' then '会员中心页'
                when page_id = '200800' and element_id is null then '解锁页VIP'
                when element_id = '202100' and element_type in ('0', '1') then '普通弹窗'
                when element_id = '202100' and element_type in ('3') then '充值返回推弹窗'
                when element_id = '202100' and element_type in ('12') then '充值弹层'
                else '其他'
            end               as recharge_source
         , case when cast(real_recharge as float) < 10 then concat('00', real_recharge)
                when cast(real_recharge as float) < 100 then concat('0', real_recharge)
                else real_recharge
            end               as item_count
         , event_strategy_id as strategy_id
         , case when czlx = 'vip' then 'SVIP'
                when czlx = '签到卡充值' then '签到卡'
                else '普通充值'
           end                as shop_item_type
         , login_id           as user_id
         , core
         , os                 as mt
         , dt
         , zffs               as subpay_type
         , send_id
      from ads.ads_sensors_cd_video_ordercreateaction_view
     where dt >= '${bf_1_dt}'
       and dt <= '${dt}'
       and app_id = 683001001
     group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10
)
-- 活跃关联曝光
, z1 as (
    select dt
         , period_type
         , user_id
         , user_type
         , remarks
         , country_level
         , mt
         , corever
         , recharge_source
         , strategy_id
         , max(exposure_uv)    as exposure_uv
         , max(exposure_pv)    as exposure_pv
         , max(ad_exposure_uv) as ad_exposure_uv
         , max(ad_exposure_pv) as ad_exposure_pv
      from (select t3.dt
                 , t123.period_type
                 , t123.user_id
                 , t123.user_type
                 , t123.remarks
                 , t123.country_level
                 , ifnull(t3.os, t123.enum_name) as mt
                 , ifnull(t3.core, t123.corever) as corever
                 , case when t3.strategy_id is null then '续订(或策略id为空)'
                        when t3.strategy_id in ( 21907679071567884,21412617518317655,21412110712176725,21411962535805011
                                                ,59996164203217021,90064658960220161,72785256107606176
                                               ) then '商店页'
                        else t3.recharge_source
                    end                           as recharge_source
                 , case when t3.strategy_id is null then '续订(或策略id为空)'
                        else t3.strategy_id
                    end                           as strategy_id
                 , 1                              as exposure_uv
                 , sum(t3.exposure_pv)            as exposure_pv
                 , 0                              as ad_exposure_uv
                 , 0                              as ad_exposure_pv
              from t123
              left join t3
                on t123.user_id = t3.user_id
               and t123.dt = t3.dt
             group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10
             union all
            select t3a.dt                            as dt
                 , t123.period_type                  as period_type
                 , t123.user_id                      as user_id
                 , t123.user_type                    as user_type
                 , t123.remarks                      as remarks
                 , t123.country_level                as country_level
                 , ifnull(t3a.os, t123.enum_name)    as mt
                 , ifnull(t3a.core, t123.corever)    as corever
                 , case when t3a.strategy_id is null then '续订(或策略id为空)'
                        when t3a.strategy_id in ( 21907679071567884,21412617518317655,21412110712176725,21411962535805011
                                                 ,59996164203217021,90064658960220161,72785256107606176
                                                ) then '商店页'
                        else t3a.recharge_source
                    end                               as recharge_source
                 , case when t3a.strategy_id is null then '续订(或策略id为空)'
                        else t3a.strategy_id
                   end                                as strategy_id
                 , 0                                  as exposure_uv
                 , 0                                  as exposure_pv
                 , 1                                  as ad_exposure_uv
                 , sum(t3a.ad_exposure_pv)            as ad_exposure_pv
              from t123
              join t3a
                on t123.user_id = t3a.user_id
               and t123.dt = t3a.dt
             group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10
           ) z1a
     group by 1,2,3,4,5,6,7,8,9,10
)
-- 活跃关联充值
, z2 as(
    select t2.dt
         , t123.period_type
         , t123.user_id
         , t123.user_type
         , t123.remarks
         , t123.country_level
         , ifnull(t2.enum_name, t123.enum_name)                                as mt
         , ifnull(t2.corever2, t123.corever)                                   as corever
         , case when t2.strategy_id is null then '续订(或策略id为空)'
                when t2.SubscribeStatus = 2 and ifnull(t2.recharge_type_cd,'-99') in ('810', '840') then '续订(或策略id为空)'
                when t2.strategy_id in (21907679071567884, 21412617518317655, 21412110712176725, 21411962535805011,
                                        59996164203217021, 90064658960220161, 72785256107606176
                                       ) then '商店页'
                when t2.strategy_id in (119945781576073372, 119945781576073373, 119945781576073374, 119945781576073375,
                                        119945781576073376, 119945781576073377, 119945781576073378, 119945781576073379,
                                        119945781576073380, 119945781576073381, 119945781576073382, 119945781576073383,
                                        119741098431744170, 119741098431744171
                                       ) then 'H5'
                else recharge_source
            end                                                                as recharge_source
         , case when t2.strategy_id is null then '续订(或策略id为空)'
                else t2.strategy_id
           end                                                                 as strategy_id
         , t2.shop_item_type
         , t2.vip_type
         , case when ifnull(t2.subpay_type, '-99') in ('GooglePlay', 'AppStore', 'AppGallery', 'MiGlobal') then t2.subpay_type
                else ifnull(t2.subpay_type, '三方支付')
            end                                                                as subpay_type
         , item_count
         , 1                                                                   as recharge_un
         , count(t2.user_id)                                                   as recharge_times
         , sum(t2.base_amount)                                                 as recharge_amount
         , sum(case when t2.recharge_type_cd = '0' then base_amount end)       as normal_recharge_amount
         , sum(case when t2.recharge_type_cd = '840' then base_amount end)     as signin_recharge_amount
         , sum(case when t2.recharge_type_cd = '810' then base_amount end)     as svip_recharge_amount
         , sum(case when t2.recharge_type_cd = '860' then base_amount end)     as nsvip_recharge_amount
         , sum(case when ifnull(t2.subpay_type, '-99') not in ('GooglePlay', 'AppStore', 'AppGallery', 'MiGlobal') then base_amount
                    else 0
                end
              )                                                                as third_recharge_amount
         , count(case when t2.recharge_type_cd = '0' then t2.user_id end)      as normal_recharge_times
         , count(case when t2.recharge_type_cd = '840' then t2.user_id end)    as signin_recharge_times
         , count(case when t2.recharge_type_cd = '810' then t2.user_id end)    as svip_recharge_times
         , count(case when t2.recharge_type_cd = '860' then t2.user_id end)    as nsvip_recharge_times
         , sum(case when t2.recharge_type_cd = '0' then 1 end)                 as normal_recharge_un
         , sum(case when t2.recharge_type_cd = '840' then 1 end)               as signin_recharge_un
         , sum(case when t2.recharge_type_cd = '810' then 1 end)               as svip_recharge_un
         , sum(case when t2.recharge_type_cd = '860' then 1 end)               as nsvip_recharge_un
         , sum(case when t2.recharge_type_cd <> '0' then 1 end)                as recharge_un_subscription
         , avg(finish_time)                                                    as finish_time
      from t123
      join t2
        on t123.user_id = t2.user_id
       and t123.dt = t2.dt
     group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14
)
-- 活跃关联广告收益
, z3 as(
    select t3b.dt
         , t123.period_type
         , t123.user_id
         , t123.user_type
         , t123.remarks
         , t123.country_level
         , ifnull(t3b.enum_name, t123.enum_name)    as mt
         , ifnull(t3b.core, t123.corever)           as corever
         , recharge_source
         , strategy_id
         , sum(amt)                                 as ad_amt
      from t123
      join t3b
        on t123.user_id = t3b.user_id
       and t123.dt = t3b.dt
     group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10
)
, z4 as (
    select account_id          as user_id
         , value_micros * 1000 as sv_last_preload_ecpm
      from (select account_id
                 , value_micros
                 , create_time
                 , row_number() over (partition by account_id order by ID desc) as rn
              from dwd.dwd_sv_advertise_ad_preload_revenue_di_view
            ) t
     where rn = 1
)
, z5 as (
    select user_id
         , recharge_amount as recharge_mode
      from (select user_id
                 , item_count                                                       as recharge_amount
                 , Frequency
                 , row_number() over (partition by user_id order by Frequency desc) as rn
              from (select user_id
                         , item_count
                         , count(1) as Frequency
                      from dwd.dwd_trade_short_video_payorder
                     group by 1, 2
                   ) t1
           ) t2
     where rn = 1
)
-- 活跃关联创建订单
, z6 as(
    select coalesce(z1.dt, z2.dt)                           as dt
         , coalesce(z1.period_type, z2.period_type)         as period_type
         , coalesce(z1.strategy_id, z2.strategy_id)         as strategy_id
         , coalesce(z1.recharge_source, z2.recharge_source) as recharge_source
         , coalesce(z1.user_id, z2.user_id)                 as user_id
         , coalesce(z1.user_type, z2.user_type)             as user_type
         , coalesce(z1.remarks, z2.remarks)                 as remarks
         , coalesce(z1.country_level, z2.country_level)     as country_level
         , coalesce(z1.mt, z2.mt)                           as mt
         , coalesce(z1.corever, z2.corever)                 as corever
         , z2.shop_item_type
         , z2.vip_type
         , z2.subpay_type
         , z2.item_count
         , z2.recharge_un
         , z2.recharge_times
         , z2.recharge_amount
         , z2.normal_recharge_amount
         , z2.signin_recharge_amount
         , z2.svip_recharge_amount
         , z2.nsvip_recharge_amount
         , z2.normal_recharge_times
         , z2.signin_recharge_times
         , z2.svip_recharge_times
         , z2.nsvip_recharge_times
         , z2.normal_recharge_un
         , z2.signin_recharge_un
         , z2.svip_recharge_un
         , z2.nsvip_recharge_un
         , z2.recharge_un_subscription
         , z2.finish_time
         , z1.create_order_num
         , z2.third_recharge_amount
      from (select t4.dt
                 , t123.period_type
                 , t123.user_id
                 , t123.user_type
                 , t123.remarks
                 , t123.country_level
                 , ifnull(t4.mt, t123.enum_name) as mt
                 , ifnull(t4.core, t123.corever) as corever
                 , case when t4.strategy_id is null then '续订(或策略id为空)'
                        when t4.strategy_id in(21907679071567884, 21412617518317655, 21412110712176725, 21411962535805011,
                                               59996164203217021, 90064658960220161, 72785256107606176
                                              ) then '商店页'
                        else t4.recharge_source
                    end                          as recharge_source
                 , case when t4.strategy_id is null then '续订(或策略id为空)'
                        else t4.strategy_id
                   end                           as strategy_id
                 , t4.shop_item_type
                 , t4.item_count
                 , t4.subpay_type
                 , count(1)                      as create_order_num
              from t123
              join t4
                on t123.user_id = t4.user_id
               and t123.dt = t4.dt
             group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13
           ) as z1
      full join z2
        on z1.strategy_id = z2.strategy_id
       and z1.recharge_source = z2.recharge_source
       and z1.dt = z2.dt
       and z1.period_type = z2.period_type
       and z1.user_id = z2.user_id
       and z1.shop_item_type = z2.shop_item_type
       and z1.item_count = z2.item_count
       and z1.subpay_type = z2.subpay_type
)
select dt
     , period_type
     , strategy_id
     , recharge_source
     , z13.user_id
     , row_1
     , 6833                                   as product_id
     , user_type
     , remarks                                as put_language
     , country_level
     , mt
     , corever
     , null                                   as strategy_name
     , null                                   as strategy_weight
     , null                                   as strategy_code
     , z4.sv_last_preload_ecpm
     , z5.recharge_mode
     , if (row_1=1, exposure_uv, 0)           as exposure_uv
     , if (row_1=1, exposure_pv, 0)           as exposure_pv
     , if (row_1=1, ad_exposure_uv, 0)        as ad_exposure_uv
     , if (row_1=1, ad_exposure_pv, 0)        as ad_exposure_pv
     , if (row_1=1, ad_amt, 0)                as ad_amt
     , ifnull(shop_item_type, 0)              as shop_item_type
     , ifnull(vip_type, 0)                    as vip_type
     , ifnull(subpay_type, '三方支付')         as subpay_type
     , ifnull(item_count, 0)                  as item_count
     , ifnull(recharge_un, 0)                 as recharge_un
     , ifnull(recharge_times, 0)              as recharge_times
     , ifnull(recharge_amount, 0)             as recharge_amount
     , ifnull(normal_recharge_amount, 0)      as normal_recharge_amount
     , ifnull(signin_recharge_amount, 0)      as signin_recharge_amount
     , ifnull(svip_recharge_amount, 0)        as svip_recharge_amount
     , ifnull(nsvip_recharge_amount, 0)       as nsvip_recharge_amount
     , ifnull(normal_recharge_times, 0)       as normal_recharge_times
     , ifnull(signin_recharge_times, 0)       as signin_recharge_times
     , ifnull(svip_recharge_times, 0)         as svip_recharge_times
     , ifnull(nsvip_recharge_times, 0)        as nsvip_recharge_times
     , ifnull(normal_recharge_un, 0)          as normal_recharge_un
     , ifnull(signin_recharge_un, 0)          as signin_recharge_un
     , ifnull(svip_recharge_un, 0)            as svip_recharge_un
     , ifnull(nsvip_recharge_un, 0)           as nsvip_recharge_un
     , ifnull(recharge_un_subscription, 0)    as recharge_un_subscription
     , if (recharge_amount>0, 1, 0)           as is_recharge
     , finish_time
     , create_order_num
     , now()                                  as etl_time
     , ifnull(third_recharge_amount, 0)       as third_recharge_amount
  from (select z12.*
             , row_number () over (partition by dt, recharge_source, strategy_id, period_type, user_id
                                       order by shop_item_type, vip_type
                                  ) as row_1
          from (select coalesce (z1.dt, z6.dt)                              as dt
                     , coalesce (z1.period_type, z6.period_type)            as period_type
                     , coalesce (z1.strategy_id, z6.strategy_id)            as strategy_id
                     , coalesce (z1.recharge_source, z6.recharge_source)    as recharge_source
                     , coalesce (z1.user_id, z6.user_id)                    as user_id
                     , coalesce (z1.user_type, z6.user_type)                as user_type
                     , coalesce (z1.remarks, z6.remarks)                    as remarks
                     , coalesce (z1.country_level, z6.country_level)        as country_level
                     , coalesce (z1.mt, z6.mt)                              as mt
                     , coalesce (z1.corever, z6.corever)                    as corever
                     , coalesce (z1.exposure_uv, 0)                         as exposure_uv
                     , coalesce (z1.exposure_pv, 0)                         as exposure_pv
                     , coalesce (z1.ad_exposure_uv, 0)                      as ad_exposure_uv
                     , coalesce (z1.ad_exposure_pv, 0)                      as ad_exposure_pv
                     , coalesce (z3.ad_amt, 0)                              as ad_amt
                     , z6.shop_item_type
                     , z6.vip_type
                     , z6.subpay_type
                     , z6.item_count
                     , z6.recharge_un
                     , z6.recharge_times
                     , z6.recharge_amount
                     , z6.normal_recharge_amount
                     , z6.signin_recharge_amount
                     , z6.svip_recharge_amount
                     , z6.nsvip_recharge_amount
                     , z6.normal_recharge_times
                     , z6.signin_recharge_times
                     , z6.svip_recharge_times
                     , z6.nsvip_recharge_times
                     , z6.normal_recharge_un
                     , z6.signin_recharge_un
                     , z6.svip_recharge_un
                     , z6.nsvip_recharge_un
                     , z6.recharge_un_subscription
                     , z6.finish_time
                     , z6.create_order_num
                     , z6.third_recharge_amount
                  from z1
                  full join z6
                    on z1.strategy_id=z6.strategy_id
                   and z1.recharge_source=z6.recharge_source
                   and z1.dt=z6.dt
                   and z1.period_type=z6.period_type
                   and z1.user_id=z6.user_id
                  full join z3
                    on z1.strategy_id=z3.strategy_id
                   and z1.recharge_source=z3.recharge_source
                   and z1.dt=z3.dt
                   and z1.period_type=z3.period_type
                   and z1.user_id=z3.user_id
               ) as z12
       ) as z13
  left join z4
    on z13.user_id=z4.user_id
  left join z5
    on z13.user_id=z5.user_id
 where dt is not null
;

commit;