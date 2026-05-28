----------------------------------------------------------------
-- 程序功能： 交易域用户充值档位、结构表
-- 程序名： P_ads_bi_sv_trade_user_recharge_gear
-- 目标表： ads.ads_bi_sv_trade_user_recharge_gear
-- 负责人： xjc
-- 开发日期：2026-05-25
----------------------------------------------------------------

delete from ads.ads_bi_sv_trade_user_recharge_gear where dt = '${bf_1_dt}';

-- SQL语句
insert into ads.ads_bi_sv_trade_user_recharge_gear
with base as ( -- 1.获取订单明细信息--
    select dt
         ,product_id
         ,user_id
         ,shop_item
         ,item_count
         ,base_amount
         ,pay_config_id
         ,mt
         ,cooorder_extinfo
    from dwd.dwd_trade_short_video_payorder
    where dt <= '${bf_1_dt}'
      and test_flag = 0
      and status = 0
)
   , payorder as (
    select a.dt
         ,a.product_id
         ,a.user_id
         ,b.current_language2                                                                                       as reg_language
         ,b.source_chl                                                                                              as source_chl
         ,b.reg_country                                                                                             as reg_country
         ,ifnull(d.level, 2)                                                                                        as country_level
         ,b.mt
         ,b.corever
         ,a.shop_item
         ,a.item_count                                                                                              as recharge_gear
         ,if(a.dt = c.fst_recharege_dt, 1, 0)                                                                       as is_first_recharge
         ,case
              when (a.mt = 1 and get_json_int(a.cooorder_extinfo, '$.totalBillingPeriods') >= 2)
                  or ((a.mt <> 1 or a.mt is null) and get_json_int(a.cooorder_extinfo, '$.InitialCommittedPaymentsCount') >= 2)
                  then case
                           when e.installment_count = 3 then 2
                           when e.installment_count = 12 then 3
                           else e.vip_type
                  end
              else e.vip_type
        end                                                                                                       as vip_type
         ,count(a.user_id)                                                                                          as charge_cnt
         ,sum(item_count)                                                                                           as before_charge
         ,sum(a.base_amount / 100)                                                                                  as after_charge
         ,case when a.mt = 1 and get_json_int(a.cooorder_extinfo, '$.totalBillingPeriods') >= 2 then '分期支付'
               when (a.mt <> 1 or a.mt is null) and get_json_int(a.cooorder_extinfo, '$.InitialCommittedPaymentsCount') >= 2 then '分期支付'
               else '非分期支付'
        end                                                                                                      as subscribe_mode
    from base                                      as a    -- 2.关联账户表，获取用户基础信息-------------------
             left join dim.dim_short_video_user_accountinfo as b
                       on a.product_id = b.product_id
                           and a.user_id = b.user_id
        -- 3.获取首次充值时间
             left join (
        select product_id
             ,user_id
             ,min(dt)    as fst_recharege_dt
        from base
        group by 1, 2
    )                                     as c
                       on a.product_id = c.product_id
                           and a.user_id = c.user_id
        -- 4.获取国家等级字段
             left join (
        select product_id
             ,short_name
             ,level
        from dim.dim_countrylevel
        where product_id = 6833
    )                                     as d
                       on b.product_id = d.product_id
                           and b.reg_country = d.short_name
        -- 5.获取vip充值的类型 '1 月卡 2 季卡 3 年卡 4 周卡'
             left join (
        select pay_config_id
             ,is_on_off
             ,vip_type
             ,installment_count
        from dim.dim_sv_recharge_item_info_view
        where pay_config_id is not null
            qualify row_number() over(partition by pay_config_id order by is_on_off desc) = 1
        order by 1
    )                                     as e
                       on a.pay_config_id = e.pay_config_id
    where a.dt = '${bf_1_dt}'
    group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 17
)
select a.dt
     ,b.period_type
     ,a.product_id
     ,a.user_id
     ,a.reg_language
     ,a.source_chl
     ,a.reg_country
     ,a.country_level
     ,a.mt
     ,a.corever
     ,b.user_type
     ,a.shop_item
     ,a.recharge_gear
     ,a.is_first_recharge
     ,a.vip_type
     ,a.charge_cnt
     ,a.before_charge
     ,a.after_charge
     ,now()             as etl_tm
     ,a.subscribe_mode
from payorder                                   as a
         left join (
    select product_id
         ,user_id
         ,period_type
         ,user_type
    from dws.dws_user_short_video_wide_active_period_ed
    where dt = '${bf_1_dt}'
)                                    as b
                   on a.product_id = b.product_id
                       and a.user_id = b.user_id
;
