----------------------------------------------------------------
-- 程序功能：海剧-TT小程序充值明细
-- 程序名：P_dwd_sv_tt_payorder_info
-- 目标表：dwd.dwd_sv_tt_payorder_info
-- 负责人：xjc
-- 开发日期：2026-05-26
----------------------------------------------------------------

insert into dwd.dwd_sv_tt_payorder_info
with refund_order as (
    -- 获取退款、沙盒订单的trade_order_id
    select
          trade_order_id
        , max(if(event_type in(9, 10), 1, 0))                       as is_refund
        , max(is_sandbox)                                           as is_sandbox
        , max(if(pay_type = 'ACA', 1, 0))                           as is_aca
    from dwd.dwd_sv_tt_vip_subscribe_event_log_view
    where create_time >= date_trunc('month', date_sub('${dt}', interval 5 month))  -- 退款沙盒订单处理周期
      and create_time < date_add(date_trunc('month', '${dt}'), interval 1 month)
      and trade_order_id is not null
    group by 1
)
, goods as (
    select
          item_id
        , mt
        , vip_type
        , shop_item_id
        , cast(price_title as decimal(10, 2))                       as recharge_amt
        , cast(price_title as decimal(10, 2)) * if(mt = 4, 0.85, 0.7) as net_amt
        , if(vip_type in(1, 4), 1, effective_time)                  as effective_time
    from dim.dim_short_video_goods_view                            as a1
    join dim.dim_sv_tiktok_minis_core_cfg_view                    as a2    -- 20260611新增，限制core值
      on a1.core = a2.core
    where is_remove = 0
)
-- tt订阅订单
select
      date(a.create_time)                                           as dt
    , 6833                                                          as product_id
    , date(date_add(a.create_time, interval e.generate_series month)) as settle_dt
    , a.trade_order_id
    , a.account_id                                                  as user_id
    , c.corever2                                                    as core
    , c.mt2                                                         as mt
    , c.reg_country
    , d.vip_type
    , d.shop_item_id
    , null                                                          as series_id
    , d.recharge_amt
    , d.recharge_amt / d.effective_time                             as monthly_recharge_amt
    , if(b.is_aca = 1 and d.mt = 1, d.recharge_amt * 0.85, d.net_amt) as net_amt     -- 20260611新增，pay_type='ACA' and mt=1按照0.85算
    , if(b.is_aca = 1 and d.mt = 1, d.recharge_amt * 0.85, d.net_amt) / d.effective_time as monthly_net_amt
    , ifnull(b.is_refund, 0)                                        as is_refund
    , ifnull(b.is_sandbox, 0)                                       as is_sandbox
    , a.create_time
    , date_add(a.create_time, interval e.generate_series month)      as settle_time
    , now()                                                         as etl_time
from dwd.dwd_sv_tt_vip_subscription_payorder_view a  -- 海剧tt订阅订单
left join refund_order b
       on a.trade_order_id = b.trade_order_id  -- 退款、沙盒订单
left join dim.dim_short_video_user_accountinfo c
       on a.account_id = c.user_id  -- 用户信息
left join goods d
       on a.tier_id = d.item_id
      and c.mt2 = d.mt  -- 商品信息
cross join generate_series(0, d.effective_time - 1) e  -- 结算金额按月拆分
where a.create_time >= date_trunc('month', date_sub('${dt}', interval 5 month))
  and a.create_time < date_add(date_trunc('month', '${dt}'), interval 1 month)
  and a.trade_order_status = 2  -- 支付成功

-- tt换币订单
union all

select
      date(a.create_time)                                           as dt
    , 6833                                                          as product_id
    , date(a.create_time)                                           as dt
    , a.trade_order_id
    , a.account_id                                                  as user_id
    , c.corever2                                                    as core
    , c.mt2                                                         as mt
    , c.reg_country
    , 0                                                             as vip_type
    , 0                                                             as shop_item_id
    , a.series_id
    , a.token_amount / 100                                          as recharge_amt
    , a.token_amount / 100                                          as monthly_recharge_amt
    , cast(a.token_amount as decimal(10, 2)) * (1 - 0.00966958) / 100 as net_amt
    , cast(a.token_amount as decimal(10, 2)) * (1 - 0.00966958) / 100 as monthly_net_amt
    , ifnull(b.is_refund, 0)                                        as is_refund
    , ifnull(b.is_sandbox, 0)                                       as is_sandbox
    , a.create_time
    , a.create_time                                                 as settle_time
    , now()                                                         as etl_time
from dwd.dwd_sv_tt_payorder_view a  -- 海剧tt换币订单
left join refund_order b
       on a.trade_order_id = b.trade_order_id
left join dim.dim_short_video_user_accountinfo c
       on a.account_id = c.user_id
where a.create_time >= date_trunc('month', date_sub('${dt}', interval 5 month))
  and a.create_time < date_add(date_trunc('month', '${dt}'), interval 1 month)
  and a.trade_order_status = 2
;
