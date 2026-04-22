----------------------------------------------------------------
-- 程序功能： 海剧付费墙充值用户明细报表
-- 程序名： P_ads_bi_sv_paywall_recharge_user_detail_di
-- 目标表： ads.ads_bi_sv_paywall_recharge_user_detail_di
-- 开发人： qhr
-- 开发日期： 2026-03-30
----------------------------------------------------------------

insert into ads.ads_bi_sv_paywall_recharge_user_detail_di
-- CTE 1: hit_event (基础明细层)
-- 抽取核心用户的每日付费墙策略命中事件，并关联相应的国家、语言、终端等维度信息作为分析底座
with hit_event as (
    select evt.dt
         , evt.unnest_node_id   -- 炸裂后的节点id
         , evt.user_id
         , evt.node_id_path                                    as strategy_id       -- 完整节点id
         , evt.map_node_id                                     as map_strategy_id    -- 映射前的节点id FFQ-629-3175
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
     group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10
)
-- CTE 2: pay_succ (充值订单明细)
-- 获取半屏场景的充值成功订单记录，包含充值金额、渠道、档位特征(如VIP类别)、充值类型等业务字段
, pay_succ as (
    select a.dt                                        as dt
         , a.create_time                               as create_time
         , a.user_id                                   as user_id
         , d.corever2                                  as corever2
         , dic_mt.cd_val_desc                          as enum_name
         , lpad(a.recharge_amt, 3, '0')                as item_count
         , a.base_amount / 100                         as base_amount
         , a.recharge_src                              as recharge_source
         , coalesce(a.pay_wall_strategy_id
                   ,a.strategy_id
                   )                                   as strategy_id
         , a.subscribe_status                          as SubscribeStatus
         , a.recharge_type_cd                          as recharge_type_cd
         , a.recharge_type                             as shop_item_type
         , a.vip_type_cd                               as vip_type
         , a.recharge_channel                          as subpay_type
         , seconds_diff(c.FinishTime, a.create_time)   as finish_time
      from dwd.dwd_trade_pay_succ_recharge_order_hi                as a         -- 每小时5分执行
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
-- CTE 3: rec_expo (普通充值曝光PV)
-- 从底层埋点提取付费墙“半屏”模块的普通充值曝光次数
, rec_expo as (
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
       and element_id in('200900','210054') 
     group by 1, 2, 3, 4, 5, 6
)
-- CTE 4: ad_expo (广告曝光PV)
-- 提取埋点中带有主策略ID的“半屏”广告位专属曝光次数
, ad_expo as (
    select dt
         , '半屏'               as recharge_source
         , event_strategy_id   as strategy_id
         , login_id            as user_id
         , core
         , os
         , count(login_id)     as ad_exposure_pv
      from ads.ads_sensors_cd_video_adpositionexposure_view
     where dt >= '${bf_1_dt}'
       and dt <= '${dt}'
       and product_id = 6833
       and event_strategy_id is not null
       and element_id in('200900','210054') 
     group by 1, 2, 3, 4, 5, 6
)
-- CTE 5: ad_rev (广告收益)
-- 从聚合后的广告收入表里取出各个用户在该策略节点带来的整体广告流水(amt)
, ad_rev as (
    select dt
         , '半屏'                                   as recharge_source
         , cast(event_strategy_id as varchar(200)) as strategy_id
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
       and event_strategy_id is not null
       and event_strategy_id in('200900','210054') 
     group by 1, 2, 3, 4, 5, 6
)
-- CTE 6: order_creat (发起订单)
-- 提取用户在选定特征节点(element_id)发起创建订单动作的频次和充值VIP类别
, order_creat as (
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
       and element_id in('200900','210054') 
     group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10
)
-- CTE 7: expo_agg (曝光组装宽表)
-- 以 hit_event 的键分别关联 rec_expo(普通曝光) 和 ad_expo(广告曝光) 聚合并输出各用户的曝光PV与UV
, expo_agg as (
    select dt
         , unnest_node_id
         , user_id
         , strategy_id
         , map_strategy_id
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
      from (select rec_expo.dt
                 , hit_event.unnest_node_id
                 , hit_event.user_id
                 , ifnull(rec_expo.strategy_id, '续订(或策略id为空)')     as strategy_id
                 , hit_event.map_strategy_id
                 , hit_event.version_id
                 , hit_event.put_language
                 , hit_event.country_level
                 , ifnull(rec_expo.os, hit_event.mt)              as mt
                 , ifnull(rec_expo.core, hit_event.core)          as core
                 , rec_expo.recharge_source                       as recharge_source
                 , 1                                              as exposure_uv
                 , sum(rec_expo.exposure_pv)                      as exposure_pv
                 , 0                                              as ad_exposure_uv
                 , 0                                              as ad_exposure_pv
              from hit_event
              left join rec_expo
                on hit_event.user_id = rec_expo.user_id
               and hit_event.dt = rec_expo.dt
               and hit_event.map_strategy_id = rec_expo.strategy_id
             group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11
            union all
            select ad_expo.dt                                         as dt
                 , hit_event.unnest_node_id                           as unnest_node_id
                 , hit_event.user_id                                   as user_id
                 , ifnull(ad_expo.strategy_id, '续订(或策略id为空)')    as strategy_id
                 , hit_event.map_strategy_id
                 , hit_event.version_id                                as version_id
                 , hit_event.put_language                              as put_language
                 , hit_event.country_level                             as country_level
                 , ifnull(ad_expo.os, hit_event.mt)                    as mt
                 , ifnull(ad_expo.core, hit_event.core)                as core
                 , ad_expo.recharge_source                             as recharge_source
                 , 0                                                   as exposure_uv
                 , 0                                                   as exposure_pv
                 , 1                                                   as ad_exposure_uv
                 , sum(ad_expo.ad_exposure_pv)                         as ad_exposure_pv
              from hit_event
              left join ad_expo
                on hit_event.user_id = ad_expo.user_id
               and hit_event.dt = ad_expo.dt
               and hit_event.map_strategy_id = ad_expo.strategy_id
             group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11
           )                                                      as expo_union
     group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11
)
-- CTE 8: pay_agg (支付交易宽表)
-- 基于 hit_event 关联 pay_succ，聚合统计策略节点下高度详尽的各维度付费指标（各VIP档位金额细分、三方支付等）
, pay_agg as (
    select pay_succ.dt
         , hit_event.unnest_node_id
         , hit_event.user_id
         , hit_event.strategy_id
         , hit_event.map_strategy_id
         , hit_event.version_id
         , hit_event.put_language
         , hit_event.country_level
         , ifnull(pay_succ.enum_name, hit_event.mt)                                    as mt
         , ifnull(pay_succ.corever2, hit_event.core)                                   as core
         , pay_succ.recharge_source                                                    as recharge_source
         , pay_succ.shop_item_type
         , pay_succ.vip_type
         , case when ifnull(pay_succ.subpay_type, '-99') in ('GooglePlay', 'AppStore', 'AppGallery', 'MiGlobal') then pay_succ.subpay_type
                else ifnull(pay_succ.subpay_type, '三方支付')
            end                                                                        as subpay_type
         , pay_succ.item_count
         , 1                                                                           as recharge_un
         , count(pay_succ.user_id)                                                     as recharge_times
         , sum(pay_succ.base_amount)                                                   as recharge_amount
         , sum(case when pay_succ.recharge_type_cd = '0' then pay_succ.base_amount end)      as normal_recharge_amount
         , sum(case when pay_succ.recharge_type_cd = '840' then pay_succ.base_amount end)    as signin_recharge_amount
         , sum(case when pay_succ.recharge_type_cd = '810' then pay_succ.base_amount end)    as svip_recharge_amount
         , sum(case when pay_succ.recharge_type_cd = '860' then pay_succ.base_amount end)    as nsvip_recharge_amount
         , sum(case when ifnull(pay_succ.subpay_type, '-99') not in ('GooglePlay', 'AppStore', 'AppGallery', 'MiGlobal')
                    then pay_succ.base_amount
                    else 0
                end)                                                             as third_recharge_amount
         , count(case when pay_succ.recharge_type_cd = '0'   then pay_succ.user_id end)      as normal_recharge_times
         , count(case when pay_succ.recharge_type_cd = '840' then pay_succ.user_id end)      as signin_recharge_times
         , count(case when pay_succ.recharge_type_cd = '810' then pay_succ.user_id end)      as svip_recharge_times
         , count(case when pay_succ.recharge_type_cd = '860' then pay_succ.user_id end)      as nsvip_recharge_times
         , sum(case when pay_succ.recharge_type_cd = '0'   then 1 end)                 as normal_recharge_un
         , sum(case when pay_succ.recharge_type_cd = '840' then 1 end)                 as signin_recharge_un
         , sum(case when pay_succ.recharge_type_cd = '810' then 1 end)                 as svip_recharge_un
         , sum(case when pay_succ.recharge_type_cd = '860' then 1 end)                 as nsvip_recharge_un
         , sum(case when pay_succ.recharge_type_cd <> '0'  then 1 end)                 as recharge_un_subscription
         , avg(pay_succ.finish_time)                                                   as finish_time
      from hit_event
      join pay_succ
        on hit_event.user_id = pay_succ.user_id
       and hit_event.dt = pay_succ.dt
       and hit_event.map_strategy_id = pay_succ.strategy_id
     group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15
)
-- CTE 9: ad_rev_agg (收益组装宽表)
-- 将 hit_event 与 ad_rev 关联，求出单用户维度的累积广告流水总和
, ad_rev_agg as (
    select ad_rev.dt
         , hit_event.unnest_node_id
         , hit_event.user_id
         , hit_event.strategy_id
         , hit_event.map_strategy_id
         , hit_event.version_id
         , hit_event.put_language
         , hit_event.country_level
         , ifnull(ad_rev.enum_name, hit_event.mt)            as mt
         , ifnull(ad_rev.core, hit_event.core)               as core
         , ad_rev.recharge_source
         , sum(ad_rev.amt)                                   as ad_amt
      from hit_event
      join ad_rev
        on hit_event.user_id = ad_rev.user_id
       and hit_event.dt = ad_rev.dt
       and hit_event.map_strategy_id = ad_rev.strategy_id
     group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11
)
-- CTE 10: preload_ecpm (单用户高价值预加载分析)
-- 使用开窗查询出用户时间线上最近的一条激励视频预加载 eCPM 均值
, preload_ecpm as (
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
-- CTE 11: recharge_mode (充值偏好额度推算)
-- 经过双重查询与开窗，计算出用户发生频率最高的充值档位作为该用户的“充值众数/常购金额”
, recharge_mode as (
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
-- CTE 12: order_creat_agg (创单统计宽表)
-- 结合 hit_event 和 order_creat 获得在策略节点下的用户的订单创建点击量
, order_creat_agg as (
    select order_creat.dt
         , hit_event.unnest_node_id
         , hit_event.user_id
         , hit_event.strategy_id
         , hit_event.map_strategy_id
         , hit_event.version_id
         , hit_event.put_language
         , hit_event.country_level
         , ifnull(order_creat.mt, hit_event.mt)        as mt
         , ifnull(order_creat.core, hit_event.core)    as core
         , order_creat.recharge_source            as recharge_source
         , order_creat.shop_item_type
         , order_creat.item_count
         , order_creat.subpay_type
         , count(1)                      as create_order_num
      from hit_event
      join order_creat
        on hit_event.user_id = order_creat.user_id
       and hit_event.dt = order_creat.dt
       and hit_event.map_strategy_id = order_creat.strategy_id
     group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14
)
-- CTE 13: trade_agg (交易漏斗合流)
-- Full Join 完美对齐所有发起创单的人(order_creat_agg)和实际完成付费的人(pay_agg)
, trade_agg as (
    select coalesce(ord_agg.dt, p_agg.dt)                                as dt
         , coalesce(ord_agg.unnest_node_id, p_agg.unnest_node_id)    as unnest_node_id
         , coalesce(ord_agg.user_id, p_agg.user_id)                      as user_id
         , coalesce(ord_agg.strategy_id, p_agg.strategy_id)              as strategy_id
         , coalesce(ord_agg.map_strategy_id, p_agg.map_strategy_id)      as map_strategy_id
         , coalesce(ord_agg.version_id, p_agg.version_id)                as version_id
         , coalesce(ord_agg.recharge_source, p_agg.recharge_source)      as recharge_source
         , coalesce(ord_agg.put_language, p_agg.put_language)            as remarks
         , coalesce(ord_agg.country_level, p_agg.country_level)          as country_level
         , coalesce(ord_agg.mt, p_agg.mt)                                as mt
         , coalesce(ord_agg.core, p_agg.core)                            as core
         , p_agg.shop_item_type
         , p_agg.vip_type
         , p_agg.subpay_type
         , p_agg.item_count
         , p_agg.recharge_un
         , p_agg.recharge_times
         , p_agg.recharge_amount
         , p_agg.normal_recharge_amount
         , p_agg.signin_recharge_amount
         , p_agg.svip_recharge_amount
         , p_agg.nsvip_recharge_amount
         , p_agg.normal_recharge_times
         , p_agg.signin_recharge_times
         , p_agg.svip_recharge_times
         , p_agg.nsvip_recharge_times
         , p_agg.normal_recharge_un
         , p_agg.signin_recharge_un
         , p_agg.svip_recharge_un
         , p_agg.nsvip_recharge_un
         , p_agg.recharge_un_subscription
         , p_agg.finish_time
         , ord_agg.create_order_num
         , p_agg.third_recharge_amount
      from order_creat_agg                                               as ord_agg
      full join pay_agg                                                  as p_agg
        on ord_agg.dt = p_agg.dt
       and ord_agg.unnest_node_id = p_agg.unnest_node_id
       and ord_agg.user_id = p_agg.user_id
       and ord_agg.map_strategy_id = p_agg.map_strategy_id
       and ord_agg.recharge_source = p_agg.recharge_source
       and ord_agg.shop_item_type = p_agg.shop_item_type
       and ord_agg.item_count = p_agg.item_count
       and ord_agg.subpay_type = p_agg.subpay_type
)
-- ===================== 最终组装与输出层 =====================
-- 对所有中间加工层(expo_agg曝光, trade_agg买单, ad_rev_agg广告营收)全方位Full Join/Left join
-- 外挂上用户静态属性(preload_ecpm的eCPM, recharge_mode的偏好额)后，落入目标ADS明细宽表
select final_data.dt                                                             as dt                          -- 日期分区
     , md5(concat(ifnull(nullif(cast(final_data.unnest_node_id as varchar), ''), '-99')
                 ,ifnull(nullif(cast(final_data.user_id as varchar), ''), '-99')
                 ,ifnull(nullif(cast(final_data.map_strategy_id as varchar), ''), '-99')
                 )
          )                                                                      as md5_key                   -- md5唯一键
     , final_data.unnest_node_id                                                 as unnest_node_id            -- 策略节点ID
     , final_data.user_id                                                        as user_id                     -- 用户id
     , final_data.strategy_id                                                    as strategy_id                 -- 策略ID
     , final_data.map_strategy_id                                                as map_strategy_id        -- 策略映射ID
     , final_data.version_id                                                     as version_id                  -- 版本id
     , final_data.recharge_source                                                as recharge_source             -- 充值来源
     , 6833                                                                      as product_id                  -- 产品id
     , final_data.put_language                                                   as put_language                -- 投放语言
     , final_data.country_level                                                  as country_level               -- 国家等级
     , final_data.mt                                                             as mt                          -- 终端
     , final_data.core                                                           as core                        -- core
     , null                                                                      as strategy_name               -- 策略名称
     , null                                                                      as strategy_weight             -- 策略权重
     , null                                                                      as strategy_code               -- 策略代号
     , preload_ecpm.sv_last_preload_ecpm                                         as sv_last_preload_ecpm        -- 最近一次激励视频预加载eCPM拆包维度
     , recharge_mode.recharge_mode                                               as recharge_mode               -- 充值众数
     , final_data.exposure_uv                                                    as exposure_uv                 -- 曝光UV
     , final_data.exposure_pv                                                    as exposure_pv                 -- 曝光PV
     , final_data.ad_exposure_uv                                                 as ad_exposure_uv              -- 广告曝光UV
     , final_data.ad_exposure_pv                                                 as ad_exposure_pv              -- 广告曝光PV
     , final_data.ad_amt                                                         as ad_amt                      -- 广告收益
     , ifnull(final_data.shop_item_type, '0')                                    as shop_item_type              -- 档位类型
     , ifnull(final_data.vip_type, 0)                                            as vip_type                    -- vip类型
     , ifnull(final_data.subpay_type, '三方支付')                                 as subpay_type                 -- 充值类型
     , ifnull(final_data.item_count, '0')                                        as item_count                  -- 充值档位
     , ifnull(final_data.recharge_un, 0)                                         as recharge_un                 -- 充值人数
     , ifnull(final_data.recharge_times, 0)                                      as recharge_times              -- 充值次数
     , ifnull(final_data.recharge_amount, 0)                                     as recharge_amount             -- 充值金额
     , ifnull(final_data.normal_recharge_amount, 0)                              as normal_recharge_amount      -- 充值金额-普通充值
     , ifnull(final_data.signin_recharge_amount, 0)                              as signin_recharge_amount      -- 充值金额-签到卡
     , ifnull(final_data.svip_recharge_amount, 0)                                as svip_recharge_amount        -- 充值金额-SVIP
     , ifnull(final_data.nsvip_recharge_amount, 0)                               as nsvip_recharge_amount       -- 充值金额-NSVI
     , ifnull(final_data.third_recharge_amount, 0)                               as third_recharge_amount       -- 充值金额-三方支付
     , ifnull(final_data.normal_recharge_times, 0)                               as normal_recharge_times       -- 充值次数-普通充值
     , ifnull(final_data.signin_recharge_times, 0)                               as signin_recharge_times       -- 充值次数-签到卡
     , ifnull(final_data.svip_recharge_times, 0)                                 as svip_recharge_times         -- 充值次数-SVIP
     , ifnull(final_data.nsvip_recharge_times, 0)                                as nsvip_recharge_times        -- 充值次数-NSVI
     , ifnull(final_data.normal_recharge_un, 0)                                  as normal_recharge_un          -- 充值人数-普通充值
     , ifnull(final_data.signin_recharge_un, 0)                                  as signin_recharge_un          -- 充值人数-签到卡
     , ifnull(final_data.svip_recharge_un, 0)                                    as svip_recharge_un            -- 充值人数-SVIP
     , ifnull(final_data.nsvip_recharge_un, 0)                                   as nsvip_recharge_un           -- 充值人数-NSVI
     , ifnull(final_data.recharge_un_subscription, 0)                            as recharge_un_subscription    -- 充值人数-订阅
     , if(ifnull(final_data.recharge_amount, 0) > 0, 1, 0)                       as is_recharge                 -- 是否充值
     , final_data.finish_time                                                    as finish_time                 -- 订单完成用时(秒)
     , final_data.create_order_num                                               as create_order_num            -- 创建订单数
     , now()                                                                     as etl_ime                     -- 清洗时间
  from (select coalesce (expo_agg.dt, trade_agg.dt)                                     as dt
             , coalesce (expo_agg.unnest_node_id, trade_agg.unnest_node_id,'-99')       as unnest_node_id
             , coalesce (expo_agg.user_id, trade_agg.user_id,-99)                       as user_id
             , coalesce (expo_agg.strategy_id, trade_agg.strategy_id,'-99')             as strategy_id
             , coalesce (expo_agg.map_strategy_id, trade_agg.map_strategy_id,'-99')     as map_strategy_id
             , coalesce (expo_agg.version_id, trade_agg.version_id)                     as version_id
             , coalesce (expo_agg.recharge_source, trade_agg.recharge_source)           as recharge_source
             , coalesce (expo_agg.put_language, trade_agg.remarks)                      as put_language -- 之前查z6的remarks
             , coalesce (expo_agg.country_level, trade_agg.country_level)               as country_level
             , coalesce (expo_agg.mt, trade_agg.mt)                                     as mt
             , coalesce (expo_agg.core, trade_agg.core)                                 as core
             , coalesce (expo_agg.exposure_uv, 0)                                       as exposure_uv
             , coalesce (expo_agg.exposure_pv, 0)                                       as exposure_pv
             , coalesce (expo_agg.ad_exposure_uv, 0)                                    as ad_exposure_uv
             , coalesce (expo_agg.ad_exposure_pv, 0)                                    as ad_exposure_pv
             , coalesce (ad_rev_agg.ad_amt, 0)                                          as ad_amt
             , trade_agg.shop_item_type
             , trade_agg.vip_type
             , trade_agg.subpay_type
             , trade_agg.item_count
             , trade_agg.recharge_un
             , trade_agg.recharge_times
             , trade_agg.recharge_amount
             , trade_agg.normal_recharge_amount
             , trade_agg.signin_recharge_amount
             , trade_agg.svip_recharge_amount
             , trade_agg.nsvip_recharge_amount
             , trade_agg.normal_recharge_times
             , trade_agg.signin_recharge_times
             , trade_agg.svip_recharge_times
             , trade_agg.nsvip_recharge_times
             , trade_agg.normal_recharge_un
             , trade_agg.signin_recharge_un
             , trade_agg.svip_recharge_un
             , trade_agg.nsvip_recharge_un
             , trade_agg.recharge_un_subscription
             , trade_agg.finish_time
             , trade_agg.create_order_num
             , trade_agg.third_recharge_amount
          from expo_agg
          full join trade_agg
            on expo_agg.dt=trade_agg.dt
           and expo_agg.unnest_node_id = trade_agg.unnest_node_id  -- FIXED: 原来是不存在的 a6，已将其修正为对应的别名 trade_agg
           and expo_agg.map_strategy_id = trade_agg.map_strategy_id
           and expo_agg.user_id=trade_agg.user_id
          full join ad_rev_agg
            on expo_agg.dt = ad_rev_agg.dt
           and expo_agg.unnest_node_id = ad_rev_agg.unnest_node_id
           and expo_agg.map_strategy_id = ad_rev_agg.map_strategy_id
           and expo_agg.user_id = ad_rev_agg.user_id
       )                                      as final_data
  left join preload_ecpm
    on final_data.user_id = preload_ecpm.user_id
  left join recharge_mode
    on final_data.user_id = recharge_mode.user_id
 where final_data.dt is not null
;

commit;
