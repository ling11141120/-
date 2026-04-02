----------------------------------------------------------------
-- 程序功能： 海剧付费墙充值用户明细报表
-- 程序名： P_ads_bi_sv_paywall_recharge_user_detail_di
-- 目标表： ads.ads_bi_sv_paywall_recharge_user_detail_di
-- 开发人： qhr
-- 开发日期： 2026-03-30
----------------------------------------------------------------

insert into ads.ads_bi_sv_paywall_recharge_user_detail_di
with t123 as (
    select evt.dt
         , evt.strategy_node_id
         , evt.user_id
         , evt.node_id                                         as strategy_id
         , evt.version_id
         , dic_lang.cd_val_desc                                as put_language
         , case when cl.level = 1 then 'T1'
                when ifnull(cl.level, 2) = 2 then 'T2'
                else '其他'
           end                                                 as country_level
         , dic_mt.cd_val_desc                                  as mt
         , case when coalesce(uifo.corever, 0) = 0 then 1
                else uifo.corever
            end                                                as core
      from dwd.dwd_traffic_sv_paywall_strategy_hit_event_di    as evt
      left join dim.dim_short_video_user_accountinfo           as uifo
        on evt.dt = uifo.dt
       and evt.user_id = uifo.user_id
       and uifo.product_id = 6833
      left join dim.dim_countrylevel                           as cl
        on uifo.product_id = cl.product_id
       and uifo.reg_country = cl.short_name
      left join dim.dim_pub_code_mapping_dict                  as dic_lang
        on uifo.current_language2 = dic_lang.cd_val
       and dic_lang.app_plat = 'pub'
       and dic_lang.cd_col = 'lang_cd'
      left join dim.dim_pub_code_mapping_dict                  as dic_mt
        on uifo.mt = dic_mt.cd_val
       and dic_mt.app_plat = 'pub'
       and dic_mt.cd_col = 'mt'
     where evt.dt >= '${bf_1_dt}'
       and evt.dt <= '${dt}'
     group by 1, 2, 3, 4, 5, 6, 7, 8, 9
)
, t2 as (
    select a.dt                                        as dt
         , a.create_time                               as create_time
         , a.user_id                                   as user_id
         , d.corever2                                  as corever2
         , dic_mt.cd_val_desc                          as enum_name
         , lpad(a.recharge_amt, 3, '0')                as item_count
         , a.base_amount / 100                         as base_amount
         , a.recharge_src                              as recharge_source
         , a.strategy_id                               as strategy_id
         , a.subscribe_status                          as SubscribeStatus
         , a.recharge_type_cd                          as recharge_type_cd
         , a.recharge_type                             as shop_item_type
         , a.vip_type_cd                               as vip_type
         , a.recharge_channel                          as subpay_type
         , seconds_diff(c.FinishTime, a.create_time)   as finish_time
      from dwd.dwd_trade_pay_succ_recharge_order_hi                as a
      left join dim.dim_pub_code_mapping_dict                      as dic_mt
        on a.mt = dic_mt.cd_val
       and dic_mt.app_plat = 'pub'
       and dic_mt.cd_col = 'mt'
      left join ods.ods_tidb_sr_sharpengine_pay_hk_sync_payorder_di as c
        on a.order_id = c.OrderSerialId
       and c.CreateTime >= date_sub('${bf_1_dt}', interval 30 day)
       and c.CreateTime <= '${dt}'
      left join dim.dim_short_video_user_accountinfo               as d
        on a.user_id = d.user_id
     where a.dt >= '${bf_1_dt}'
       and a.dt <= '${dt}'
       and a.product_id = 6833
       and a.recharge_src = '半屏'
)
, t3 as (
    select dt
         , '半屏'                as recharge_source
         , event_strategy_id    as strategy_id
         , login_id             as user_id
         , core
         , os
         , count(login_id)      as exposure_pv
      from ads.ads_sensors_cd_video_rechargeexposure_view
     where dt >= '${bf_1_dt}'
       and dt <= '${dt}'
       and product_id = 6833
       and (element_id = '200900' or page_id = '200900')
     group by 1, 2, 3, 4, 5, 6
)
, t3a as (
    select dt
         , '半屏'               as recharge_source
         , main_strategy_id    as strategy_id
         , login_id            as user_id
         , core
         , os
         , count(login_id)     as ad_exposure_pv
      from ads.ads_sensors_cd_video_adpositionexposure_view
     where dt >= '${bf_1_dt}'
       and dt <= '${dt}'
       and product_id = 6833
       and main_strategy_id is not null
       and (element_id = '200900' or page_id = '200900')
     group by 1, 2, 3, 4, 5, 6
)
, t3b as (
    select dt
         , '半屏'                                  as recharge_source
         , cast(main_strategy_id as varchar(200)) as strategy_id
         , user_id
         , core
         , dic_mt.cd_val_desc                     as enum_name
         , sum(amt)                               as amt
      from dws.dws_advertisement_user_position_amt_ed as a
      left join dim.dim_pub_code_mapping_dict        as dic_mt
        on a.mt = dic_mt.cd_val
       and dic_mt.app_plat = 'pub'
       and dic_mt.cd_col = 'mt'
     where dt >= '${bf_1_dt}'
       and dt <= '${dt}'
       and product_id = 6833
       and main_strategy_id is not null
     group by 1, 2, 3, 4, 5, 6
)
, t4 as (
    select '半屏'                                      as recharge_source
         , case when cast(real_recharge as float) < 10 then concat('00', real_recharge)
                when cast(real_recharge as float) < 100 then concat('0', real_recharge)
                else real_recharge
            end                                       as item_count
         , cast(event_strategy_id as varchar(200))    as strategy_id
         , case when czlx = 'vip' then 'SVIP'
                when czlx = '签到卡充值' then '签到卡'
                else '普通充值'
            end                                       as shop_item_type
         , login_id                                   as user_id
         , core
         , os                                         as mt
         , dt
         , zffs                                       as subpay_type
         , send_id
      from ads.ads_sensors_cd_video_ordercreateaction_view
     where dt >= '${bf_1_dt}'
       and dt <= '${dt}'
       and app_id = 683001001
       and (element_id = '200900' or page_id = '200900')
     group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10
)
, z1 as (
    select dt
         , strategy_node_id
         , user_id
         , strategy_id
         , version_id
         , put_language
         , country_level
         , mt
         , core
         , recharge_source
         , max(exposure_uv)                                       as exposure_uv
         , max(exposure_pv)                                       as exposure_pv
         , max(ad_exposure_uv)                                    as ad_exposure_uv
         , max(ad_exposure_pv)                                    as ad_exposure_pv
      from (select t3.dt
                 , t123.strategy_node_id
                 , t123.user_id
                 , ifnull(t3.strategy_id, '续订(或策略id为空)')     as strategy_id
                 , t123.version_id
                 , t123.put_language
                 , t123.country_level
                 , ifnull(t3.os, t123.mt)                         as mt
                 , ifnull(t3.core, t123.core)                     as core
                 , t3.recharge_source                             as recharge_source
                 , 1                                              as exposure_uv
                 , sum(t3.exposure_pv)                            as exposure_pv
                 , 0                                              as ad_exposure_uv
                 , 0                                              as ad_exposure_pv
              from t123
              left join t3
                on t123.user_id = t3.user_id
               and t123.dt = t3.dt
               and t123.strategy_id = t3.strategy_id
             group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10
            union all
            select t3a.dt                                         as dt
                 , t123.strategy_node_id                          as strategy_node_id
                 , t123.user_id                                   as user_id
                 , ifnull(t3a.strategy_id, '续订(或策略id为空)')    as strategy_id
                 , t123.version_id                                as version_id
                 , t123.put_language                              as put_language
                 , t123.country_level                             as country_level
                 , ifnull(t3a.os, t123.mt)                        as mt
                 , ifnull(t3a.core, t123.core)                    as core
                 , t3a.recharge_source                            as recharge_source
                 , 0                                              as exposure_uv
                 , 0                                              as exposure_pv
                 , 1                                              as ad_exposure_uv
                 , sum(t3a.ad_exposure_pv)                        as ad_exposure_pv
              from t123
              left join t3a
                on t123.user_id = t3a.user_id
               and t123.dt = t3a.dt
               and t123.strategy_id = t3a.strategy_id
             group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10
           )                                                      as z1a
     group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10
)
, z2 as (
    select t2.dt
         , t123.strategy_node_id
         , t123.user_id
         , t123.strategy_id
         , t123.version_id
         , t123.put_language
         , t123.country_level
         , ifnull(t2.enum_name, t123.mt)                                         as mt
         , ifnull(t2.corever2, t123.core)                                        as core
         , t2.recharge_source                                                    as recharge_source
         , t2.shop_item_type
         , t2.vip_type
         , case when ifnull(t2.subpay_type, '-99') in ('GooglePlay', 'AppStore', 'AppGallery', 'MiGlobal') then t2.subpay_type
                else ifnull(t2.subpay_type, '三方支付')
            end                                                                  as subpay_type
         , t2.item_count
         , 1                                                                     as recharge_un
         , count(t2.user_id)                                                     as recharge_times
         , sum(t2.base_amount)                                                   as recharge_amount
         , sum(case when t2.recharge_type_cd = '0' then t2.base_amount end)      as normal_recharge_amount
         , sum(case when t2.recharge_type_cd = '840' then t2.base_amount end)    as signin_recharge_amount
         , sum(case when t2.recharge_type_cd = '810' then t2.base_amount end)    as svip_recharge_amount
         , sum(case when t2.recharge_type_cd = '860' then t2.base_amount end)    as nsvip_recharge_amount
         , sum(case when ifnull(t2.subpay_type, '-99') not in ('GooglePlay', 'AppStore', 'AppGallery', 'MiGlobal')
                    then t2.base_amount
                    else 0
                end)                                                             as third_recharge_amount
         , count(case when t2.recharge_type_cd = '0'   then t2.user_id end)      as normal_recharge_times
         , count(case when t2.recharge_type_cd = '840' then t2.user_id end)      as signin_recharge_times
         , count(case when t2.recharge_type_cd = '810' then t2.user_id end)      as svip_recharge_times
         , count(case when t2.recharge_type_cd = '860' then t2.user_id end)      as nsvip_recharge_times
         , sum(case when t2.recharge_type_cd = '0'   then 1 end)                 as normal_recharge_un
         , sum(case when t2.recharge_type_cd = '840' then 1 end)                 as signin_recharge_un
         , sum(case when t2.recharge_type_cd = '810' then 1 end)                 as svip_recharge_un
         , sum(case when t2.recharge_type_cd = '860' then 1 end)                 as nsvip_recharge_un
         , sum(case when t2.recharge_type_cd <> '0'  then 1 end)                 as recharge_un_subscription
         , avg(t2.finish_time)                                                   as finish_time
      from t123
      join t2
        on t123.user_id = t2.user_id
       and t123.dt = t2.dt
       and t123.strategy_id = t2.strategy_id
     group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14
)
, z3 as (
    select t3b.dt
         , t123.strategy_node_id
         , t123.user_id
         , t123.strategy_id
         , t123.version_id
         , t123.put_language
         , t123.country_level
         , ifnull(t3b.enum_name, t123.mt)            as mt
         , ifnull(t3b.core, t123.core)               as core
         , t3b.recharge_source
         , sum(t3b.amt)                              as ad_amt
      from t123
      join t3b
        on t123.user_id = t3b.user_id
       and t123.dt = t3b.dt
       and t123.strategy_id = t3b.strategy_id
     group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10
)
, z4 as (
    select account_id          as user_id
         , value_micros * 1000 as sv_last_preload_ecpm
      from (select account_id
                 , value_micros
                 , create_time
                 , row_number() over (partition by account_id order by id desc) as rn
              from dwd.dwd_sv_advertise_ad_preload_revenue_di_view
           ) t
     where rn = 1
)
, z5 as (
    select user_id
         , recharge_amount                                                          as recharge_mode
      from (select user_id
                 , item_count                                                       as recharge_amount
                 , Frequency
                 , row_number() over (partition by user_id order by Frequency desc) as rn
              from (select user_id
                         , item_count
                         , count(1)                                                 as Frequency
                      from dwd.dwd_trade_short_video_payorder
                     group by 1, 2
                )                                                                   as t1
        )                                                                           as t2
     where rn = 1
)
, z6_1 as (
    select t4.dt
         , t123.strategy_node_id
         , t123.user_id
         , t123.strategy_id
         , t123.version_id
         , t123.put_language
         , t123.country_level
         , ifnull(t4.mt, t123.mt)        as mt
         , ifnull(t4.core, t123.core)    as core
         , t4.recharge_source            as recharge_source
         , t4.shop_item_type
         , t4.item_count
         , t4.subpay_type
         , count(1)                      as create_order_num
      from t123
      join t4
        on t123.user_id = t4.user_id
       and t123.dt = t4.dt
       and t123.strategy_id = t4.strategy_id
     group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13
)
, z6 as (
    select coalesce(z1.dt, z2.dt)                                as dt
         , coalesce(z1.strategy_node_id, z2.strategy_node_id)    as strategy_node_id
         , coalesce(z1.user_id, z2.user_id)                      as user_id
         , coalesce(z1.strategy_id, z2.strategy_id)              as strategy_id
         , coalesce(z1.recharge_source, z2.recharge_source)      as recharge_source
         , coalesce(z1.put_language, z2.put_language)            as remarks
         , coalesce(z1.country_level, z2.country_level)          as country_level
         , coalesce(z1.mt, z2.mt)                                as mt
         , coalesce(z1.core, z2.core)                            as core
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
      from z6_1                                                  as z1
      full join z2
        on z1.dt = z2.dt
       and z1.strategy_node_id = z2.strategy_node_id
       and z1.user_id = z2.user_id
       and z1.strategy_id = z2.strategy_id
       and z1.recharge_source = z2.recharge_source
       and z1.shop_item_type = z2.shop_item_type
       and z1.item_count = z2.item_count
       and z1.subpay_type = z2.subpay_type
)
select fd.dt                                                             as dt                          -- 日期分区
     , fd.strategy_node_id                                               as strategy_node_id            -- 策略节点ID
     , fd.user_id                                                        as user_id                     -- 用户id
     , if(fd.strategy_id = fd.strategy_node_id, fd.strategy_id, null)    as strategy_id                 -- 策略ID
     , fd.version_id                                                     as version_id                  -- 版本id
     , fd.recharge_source                                                as recharge_source             -- 充值来源
     , 6833                                                              as product_id                  -- 产品id
     , fd.put_language                                                   as put_language                -- 投放语言
     , fd.country_level                                                  as country_level               -- 国家等级
     , fd.mt                                                             as mt                          -- 终端
     , fd.core                                                           as core                        -- core
     , null                                                              as strategy_name               -- 策略名称
     , null                                                              as strategy_weight             -- 策略权重
     , null                                                              as strategy_code               -- 策略代号
     , z4.sv_last_preload_ecpm                                           as sv_last_preload_ecpm        -- 最近一次激励视频预加载eCPM拆包维度
     , z5.recharge_mode                                                  as recharge_mode               -- 充值众数
     , fd.exposure_uv                                                    as exposure_uv                 -- 曝光UV
     , fd.exposure_pv                                                    as exposure_pv                 -- 曝光PV
     , fd.ad_exposure_uv                                                 as ad_exposure_uv              -- 广告曝光UV
     , fd.ad_exposure_pv                                                 as ad_exposure_pv              -- 广告曝光PV
     , fd.ad_amt                                                         as ad_amt                      -- 广告收益
     , ifnull(fd.shop_item_type, '0')                                    as shop_item_type              -- 档位类型
     , ifnull(fd.vip_type, 0)                                            as vip_type                    -- vip类型
     , ifnull(fd.subpay_type, '三方支付')                                 as subpay_type                 -- 充值类型
     , ifnull(fd.item_count, '0')                                        as item_count                  -- 充值档位
     , ifnull(fd.recharge_un, 0)                                         as recharge_un                 -- 充值人数
     , ifnull(fd.recharge_times, 0)                                      as recharge_times              -- 充值次数
     , ifnull(fd.recharge_amount, 0)                                     as recharge_amount             -- 充值金额
     , ifnull(fd.normal_recharge_amount, 0)                              as normal_recharge_amount      -- 充值金额-普通充值
     , ifnull(fd.signin_recharge_amount, 0)                              as signin_recharge_amount      -- 充值金额-签到卡
     , ifnull(fd.svip_recharge_amount, 0)                                as svip_recharge_amount        -- 充值金额-SVIP
     , ifnull(fd.nsvip_recharge_amount, 0)                               as nsvip_recharge_amount       -- 充值金额-NSVI
     , ifnull(fd.third_recharge_amount, 0)                               as third_recharge_amount       -- 充值金额-三方支付
     , ifnull(fd.normal_recharge_times, 0)                               as normal_recharge_times       -- 充值次数-普通充值
     , ifnull(fd.signin_recharge_times, 0)                               as signin_recharge_times       -- 充值次数-签到卡
     , ifnull(fd.svip_recharge_times, 0)                                 as svip_recharge_times         -- 充值次数-SVIP
     , ifnull(fd.nsvip_recharge_times, 0)                                as nsvip_recharge_times        -- 充值次数-NSVI
     , ifnull(fd.normal_recharge_un, 0)                                  as normal_recharge_un          -- 充值人数-普通充值
     , ifnull(fd.signin_recharge_un, 0)                                  as signin_recharge_un          -- 充值人数-签到卡
     , ifnull(fd.svip_recharge_un, 0)                                    as svip_recharge_un            -- 充值人数-SVIP
     , ifnull(fd.nsvip_recharge_un, 0)                                   as nsvip_recharge_un           -- 充值人数-NSVI
     , ifnull(fd.recharge_un_subscription, 0)                            as recharge_un_subscription    -- 充值人数-订阅
     , if(ifnull(fd.recharge_amount, 0) > 0, 1, 0)                       as is_recharge                 -- 是否充值
     , fd.finish_time                                                    as finish_time                 -- 订单完成用时(秒)
     , fd.create_order_num                                               as create_order_num            -- 创建订单数
     , now()                                                             as etl_ime                     -- 清洗时间
  from (select coalesce (z1.dt, z6.dt)                                   as dt
             , coalesce (z1.strategy_node_id, z6.strategy_node_id)       as strategy_node_id
             , coalesce (z1.user_id, z6.user_id)                         as user_id
             , coalesce (z1.strategy_id, z6.strategy_id)                 as strategy_id
             , coalesce (z1.recharge_source, z6.recharge_source)         as recharge_source
             , coalesce (z1.put_language, z6.put_language)               as remarks
             , coalesce (z1.country_level, z6.country_level)             as country_level
             , coalesce (z1.mt, z6.mt)                                   as mt
             , coalesce (z1.core, z6.core)                               as corever
             , coalesce (z1.exposure_uv, 0)                              as exposure_uv
             , coalesce (z1.exposure_pv, 0)                              as exposure_pv
             , coalesce (z1.ad_exposure_uv, 0)                           as ad_exposure_uv
             , coalesce (z1.ad_exposure_pv, 0)                           as ad_exposure_pv
             , coalesce (z3.ad_amt, 0)                                   as ad_amt
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
            on z1.dt=z6.dt
           and z1.strategy_node_id = a6.strategy_node_id
           and z1.user_id=z6.user_id
          full join z3
            on z1.dt = z3.dt
           and z1.strategy_node_id = z3.strategy_node_id
           and z1.user_id = z3.user_id
       )                                      as fd
  left join z4
    on fd.user_id = z4.user_id
  left join z5
    on fd.user_id = z5.user_id
 where fd.dt is not null
   and fd.rn = 1
;

commit;
