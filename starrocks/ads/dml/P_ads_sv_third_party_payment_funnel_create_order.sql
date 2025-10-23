----------------------------------------------------------------
-- 程序功能： 海剧三方支付漏斗报表-创建订单
-- 程序名： P_ads_sv_third_party_payment_funnel_create_order.sql
-- 目标表： ads.ads_sv_third_party_payment_funnel_create_order
-- 负责人： wx
-- 开发日期： 2025-10-23
-- 版本号： v0.0.1
----------------------------------------------------------------
insert into ads.ads_sv_third_party_payment_funnel_create_order
-- 活跃表
with active as(
    select t1.dt
          ,t1.user_id
          ,t1.period_type
          ,t1.user_type
          ,t1.corever
          ,dic_mt.enum_name as mt
          ,dic_lang.remarks as language2
    from dws.dws_user_short_video_wide_active_period_ed  as t1
    left join dim.dim_dic dic_lang  -- 注册/投放语言
      on t1.current_language2 = dic_lang.enum_id
     and dic_lang.table_name = 'dim_producttype'
     and dic_lang.dic_column = 'language_id'
    left join dim.dim_dic  dic_mt  -- mt
      on t1.mt = dic_mt.enum_id
     and dic_mt.table_name = 'dim_user_accountinfo_df'
     and dic_mt.dic_column = 'mt'
    where product_id = 6833 and dt >= '${bf_1_dt}' and dt <= '${dt}'
    group by 1, 2, 3, 4, 5, 6, 7
),
-- 创建订单事件
createorder as (
    select
        case when element_id='200900' or page_id='200900' then '半屏'
             when page_id ='201300' then '商店页'
             when page_id ='203300' then 'H5'
             when page_id ='205000' then '会员中心页'
             when page_id ='200800' and element_id is null then '解锁页VIP'
             when element_id='202100' and element_type in('0','1') then '普通弹窗'
             when element_id='202100' and element_type in('3') then '充值返回推弹窗'
             when element_id='202100' and element_type in('12') then '充值弹层'
             else '其他'
         end               as recharge_source
        ,event_strategy_id as strategy_id
        ,case when czlx like '%vip%' then 'SVIP'
              when czlx like '%签到卡%' then '签到卡'
              else '普通充值'
          end              as shop_item_type
        ,case when zffs in ('苹果支付','AppStore','IOS') then 'iOS'
              when zffs in ('谷歌支付','Android','GooglePlay') then '安卓'
              else '三方'
          end              as zfqd
        ,login_id          as user_id
        ,case when os='iOS' then 'iOS'
              when os='Android' then 'Android'
              else '其他'
          end as mt
        ,case when app_id = 683001001 then '1'
              when app_id = 683002001 then '2'
              when app_id = 683003001 then '3'
          end              as core
        ,dt
        ,if(zffs in ('AppStore', 'GooglePlay', 'Android', 'IOS', '苹果支付', '谷歌支付'), 0, 1) if_third
    from ads.ads_sensors_cd_video_ordercreateaction_view
    where dt >= '${bf_1_dt}' and dt <= '${dt}'
)
-- 活跃关联创建订单
select
     createorder.dt
    ,createorder.user_id
    ,period_type
    ,user_type
    ,language2
    ,coalesce(createorder.core, active.corever) as core
    ,coalesce(createorder.mt, active.mt) as mt
    ,case when strategy_id is null then '续订(或策略id为空)'
          when strategy_id in (21907679071567884, 21412617518317655, 21412110712176725, 21411962535805011, 59996164203217021, 90064658960220161, 72785256107606176) then '商店页'
          else recharge_source
      end as recharge_source
    ,if(strategy_id is null, '续订(或策略id为空)', strategy_id) as strategy_id
    ,shop_item_type
    ,zfqd
    ,if_third
    ,now() as etl_time
  from active
  left join createorder
    on active.user_id = createorder.user_id and active.dt = createorder.dt
 where createorder.user_id is not null
;