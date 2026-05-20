-------------------------------------------------
-- 应用报表：海剧-用户维度报表/海剧三方支付漏斗链路报表
-------------------------------------------------

-- 策略代号
with dim_strategy as (
    select Id                                            as id
         , Name                                          as name
         , max(StrategyCode)                             as strategy_code
         , max(null)                                     as sort
         , max(case when action_type = 3 then sort end ) as sort_popup
         , max(case when action_type = 9 then sort end ) as sort_return
      from ods.ods_tidb_short_video_center_activity                    as t1
      left join ads.ads_tidb_short_video_center_activity_position_view as t2
        on t1.Id = t2.center_activity_id
     group by 1, 2

     union all

    select id
         , name
         , strategy_code
         , sort
         , null          as sort_popup
         , null          as sort_return
      from ads.ads_sv_goods_strategy_view
)
-- 创建订单
, z1 as (
    select dt
         , case when dim_strategy.strategy_code regexp '^HC' then '活动'
                when dim_strategy.strategy_code regexp '^BH' then '活动'
                when dim_strategy.strategy_code regexp '^SF' then '活动'
                when dim_strategy.strategy_code regexp '^HX' then '活动'
                when dim_strategy.strategy_code regexp '^B' then '半屏'
                when dim_strategy.strategy_code regexp '^S' then '商店页'
                when dim_strategy.strategy_code regexp '^F' then '充值返回推弹窗'
                when recharge_source = 'H5' then '活动'
                else recharge_source
            end                                                     as recharge_source
         , strategy_id
         , count(distinct case when if_third = 0 then user_id end ) as `原生下单UV`
         , count(distinct case when if_third = 1 then user_id end ) as `三方下单UV`
      from ads.ads_sv_third_party_payment_funnel_create_order as a
      left join dim_strategy
        on a.strategy_id =  dim_strategy.id
     where dt between '${开始时间}' and '${结束时间}'
           ${if(len(周期类型) == 0,"","and period_type in ('" + 周期类型 + "')")}
           ${if(len(用户类型) == 0,"","and user_type in ('" + 用户类型 + "')")}
           ${if(len(投放语言) == 0,"","and language2 in ('" + 投放语言 + "')")}
           ${if(len(CORE) == 0,"","and core in ('" + CORE + "')")}
           ${if(len(终端) == 0,"","and mt in ('" + 终端 + "')")}
           ${if(len(支付渠道) == 0,"","and zfqd in ('" + 支付渠道 + "')")}
           ${if(len(档位类型) == 0,"","and shop_item_type in ('" + 档位类型 + "')")}
           ${if(len(充值来源) == 0,"","and recharge_source in ('" + 充值来源 + "')")}
           ${if(len(是否订阅) == 0,"","and case when shop_item_type in ('SVIP','签到卡') then '订阅' when shop_item_type='普通充值' then '非订阅' end in ('" + 是否订阅 + "')")}
     group by 1, 2, 3
)
-- 充值成功
, z2 as (
    select dt
         , case when dim_strategy.strategy_code regexp '^HC' then '活动'
                when dim_strategy.strategy_code regexp '^BH' then '活动'
                when dim_strategy.strategy_code regexp '^SF' then '活动'
                when dim_strategy.strategy_code regexp '^HX' then '活动'
                when dim_strategy.strategy_code regexp '^B' then '半屏'
                when dim_strategy.strategy_code regexp '^S' then '商店页'
                when dim_strategy.strategy_code regexp '^F' then '充值返回推弹窗'
                when recharge_source = 'H5' then '活动'
                else recharge_source
            end                                                                                       as recharge_source
         , strategy_id
         , count(distinct user_id)                                                                    as `充值人数`
         , count(distinct case when if_third = 0 then user_id end )                                   as `原生充值UV`
         , count(distinct case when if_third = 1 then user_id end )                                   as `三方充值UV`
         , count(distinct case when if_third = 0 and subscribe_status in ('0','1') then user_id end ) as `原生充值UV（剔除续订）`
         , count(distinct case when if_third = 1 and subscribe_status in ('0','1') then user_id end ) as `三方充值UV（剔除续订）`
         , count(case when if_third = 0 then user_id end )                                            as `原生充值PV`
         , count(case when if_third = 1 then user_id end )                                            as `三方充值PV`
         , sum(case when if_third = 0 then time_duration end)                                         as `原生支付时长`
         , sum(case when if_third = 1 then time_duration end)                                         as `三方支付时长`
         , sum(base_amount)                                                                           as `充值金额`
         , sum(case when if_third = 0 then base_amount end)                                           as `原生充值金额`
         , sum(case when if_third = 1 then base_amount end)                                           as `三方充值金额`
      from ads.ads_sv_third_party_payment_funnel_recharge as a
      left join dim_strategy
        on a.strategy_id =  dim_strategy.id
     where dt between '${开始时间}' and '${结束时间}'
           ${if(len(周期类型) == 0,"","and period_type in ('" + 周期类型 + "')")}
           ${if(len(用户类型) == 0,"","and user_type in ('" + 用户类型 + "')")}
           ${if(len(投放语言) == 0,"","and language2 in ('" + 投放语言 + "')")}
           ${if(len(CORE) == 0,"","and core in ('" + CORE + "')")}
           ${if(len(终端) == 0,"","and mt in ('" + 终端 + "')")}
           ${if(len(支付渠道) == 0,"","and zfqd in ('" + 支付渠道 + "')")}
           ${if(len(档位类型) == 0,"","and shop_item_type in ('" + 档位类型 + "')")}
           ${if(len(充值来源) == 0,"","and recharge_source in ('" + 充值来源 + "')")}
           ${if(len(是否订阅) == 0,"","and case         when shop_item_type in ('SVIP','签到卡') then '订阅' when shop_item_type='普通充值' then '非订阅' end in ('" + 是否订阅 + "')")}
     group by 1, 2, 3
)
-- 入三方包
, group_view as (
    select dt
         , account
      from (select dt
                 , group_id
                 , account
              from ads.ads_user_short_video_group_user_log_view
             where type = 1
               and dt >= date_add('${开始时间}',-1)
               and dt <= date_add('${结束时间}',1)
               and date(create_time) >= '${开始时间}'
               and date(create_time) <= '${结束时间}'
             group by 1, 2, 3

             union all

            select dt
                 , SubCrowdId as group_id
                 , UserId     as account
              from ads.crowd_log
             where Operation = 1
               and dt >= date_add('${开始时间}',-1)
               and dt <= date_add('${结束时间}',1)
               and date(CreateTime) >= '${开始时间}'
               and date(CreateTime) <= '${结束时间}'
             group by 1, 2, 3
           )                                 as a
      join ads.ads_third_payment_config_view as b
        on a.group_id = b.unnest_group_ids
     where status = 1
     group by 1, 2
)
-- 曝光
, x as (
    select replace("${支付渠道}", "'&'", "|") as zfqd
         , replace("${档位类型}", "','", "|") as shop_item_type
         , replace("${是否订阅}", "','", "|") as is_sub
)
, z3 as (
    select a.dt
         , case when dim_strategy.strategy_code regexp '^HC' then '活动'
                when dim_strategy.strategy_code regexp '^BH' then '活动'
                when dim_strategy.strategy_code regexp '^SF' then '活动'
                when dim_strategy.strategy_code regexp '^HX' then '活动'
                when dim_strategy.strategy_code regexp '^B' then '半屏'
                when dim_strategy.strategy_code regexp '^S' then '商店页'
                when dim_strategy.strategy_code regexp '^F' then '充值返回推弹窗'
                when recharge_source = 'H5' then '活动'
                else recharge_source
            end                                                         as recharge_source
         , strategy_id
         , count(distinct user_id)                                      as `曝光UV`
         , count(distinct account)                                      as `入包UV`
         , count(user_id)                                               as `曝光PV`
         , count(distinct case when zfqd like '%三方%' then user_id end ) as `三方曝光UV`
      from ads.ads_sv_third_party_payment_funnel_exposure as a
      left join group_view                                as b
        on a.user_id = b.account
       and a.dt = b.dt
      left join dim_strategy
        on a.strategy_id =  dim_strategy.id
     where a.dt between '${开始时间}' and '${结束时间}'
           ${if(len(周期类型) == 0,"","and period_type in ('" + 周期类型 + "')")}
           ${if(len(用户类型) == 0,"","and user_type in ('" + 用户类型 + "')")}
           ${if(len(投放语言) == 0,"","and language2 in ('" + 投放语言 + "')")}
           ${if(len(CORE) == 0,"","and core in ('" + CORE + "')")}
           ${if(len(终端) == 0,"","and mt in ('" + 终端 + "')")}
           ${if(len(支付渠道) == 0,"","and regexp(zfqd,(select zfqd from x) )")}
           ${if(len(档位类型) == 0,"","and regexp(shop_item_type,(select shop_item_type from x) )")}
           ${if(len(是否订阅) == 0,"","and regexp(is_sub,(select is_sub from x) )")}
           ${if(len(充值来源) == 0,"","and recharge_source in ('" + 充值来源 + "')")}
     group by 1, 2, 3
)
select z3.dt                          as `日期`
     , z3.recharge_source             as `充值来源`
     , z3.strategy_id
     , name
     , strategy_code
     , concat(strategy_code,'：',name) as `策略代号&名称`
     , `曝光UV`
     , `入包UV`
     , `曝光PV`
     , `三方曝光UV`
     , `原生下单UV`
     , `三方下单UV`
     , `充值人数`
     , `原生充值UV`
     , `三方充值UV`
     , `原生充值UV（剔除续订）`
     , `三方充值UV（剔除续订）`
     , `原生充值PV`
     , `三方充值PV`
     , `原生支付时长`
     , `三方支付时长`
     , `充值金额`
     , `原生充值金额`
     , `三方充值金额`
  from z3
  left join z1
    on z3.dt = z1.dt
   and z3.recharge_source = z1.recharge_source
   and z3.strategy_id = z1.strategy_id
  left join z2
    on z3.dt = z2.dt
   and z3.recharge_source = z2.recharge_source
   and z3.strategy_id = z2.strategy_id
  left join dim_strategy
    on z3.strategy_id =  dim_strategy.id
 where 1 = 1
       ${if(len(策略代号) == 0,"","and strategy_code in ('" + 策略代号 + "')")}
       ${if(len(策略名称) == 0,"","and name in ('" + 策略名称 + "')")}
;