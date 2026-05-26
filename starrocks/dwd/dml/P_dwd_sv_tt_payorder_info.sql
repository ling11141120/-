----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dwd_sv_tt_payorder_info
-- workflow_version : 5
-- create_user      : chenmo
-- task_name        : dwd_sv_tt_payorder_info
-- task_version     : 2
-- update_time      : 2026-01-26 16:05:48
-- sql_path         : \starrocks\tbl_dwd_sv_tt_payorder_info\dwd_sv_tt_payorder_info
----------------------------------------------------------------
-- SQL语句
insert into dwd.dwd_sv_tt_payorder_info
with refund_order as (
    -- 获取退款、沙盒订单的trade_order_id
    select
        get_json_string(content, '$.trade_order_id') as trade_order_id,
        max(if(event_type in(9, 10), 1, 0)) as is_refund,
        max(if(get_json_string(content, '$.is_sandbox'), 1, 0)) as is_sandbox
    from ods.ods_tidb_short_video_tt_vip_subscribe_event_log
    where create_time >= date_sub('${bf_1_dt}', interval 7 day)  -- 退款沙盒订单处理周期
        and get_json_string(content, '$.trade_order_id') is not null
    group by 1
),
goods as (
    select
        item_id, mt, vip_type, shop_item_id,
        cast(price_title as decimal(10, 2)) as recharge_amt,
        cast(price_title as decimal(10, 2)) * if(mt = 4, 0.85, 0.7) as net_amt,
        if(vip_type in(1, 4), 1, effective_time) as effective_time
    from dim.dim_short_video_goods_view
    where core = 16 and is_remove = 0
)
-- tt订阅订单
select
    date(a.create_time) as dt,
    6833 as product_id,
    date(date_add(a.create_time, interval e.generate_series month)) as settle_dt,
    a.trade_order_id,
    a.account_id as user_id,
    c.corever2 as core,
    c.mt2 as mt,
    c.reg_country,
    d.vip_type,
    d.shop_item_id,
    null as series_id,
    d.recharge_amt,
    d.recharge_amt / d.effective_time as monthly_recharge_amt,
    d.net_amt,
    d.net_amt / d.effective_time as monthly_net_amt,
    ifnull(b.is_refund, 0) as is_refund,
    ifnull(b.is_sandbox, 0) as is_sandbox,
    a.create_time,
    date_add(a.create_time, interval e.generate_series month) as settle_time,
    now() as etl_time
from ods.ods_tidb_short_video_tt_vip_subscription_payorder a  -- 海剧tt订阅订单
left join refund_order b on a.trade_order_id = b.trade_order_id  -- 退款、沙盒订单
left join dim.dim_short_video_user_accountinfo c on a.account_id = c.user_id  -- 用户信息
left join goods d on a.tier_id = d.item_id and c.mt2 = d.mt  -- 商品信息
cross join generate_series(0, d.effective_time - 1) e  -- 结算金额按月拆分
where a.create_time >= date_sub('${bf_1_dt}', interval 7 day) and a.trade_order_status = 2  -- 支付成功
-- tt换币订单
union all
select
    date(a.create_time) as dt,
    6833 as product_id,
    date(a.create_time) as dt,
    a.trade_order_id,
    a.account_id as user_id,
    c.corever2 as core,
    c.mt2 as mt,
    c.reg_country,
    0 as vip_type,
    0 as shop_item_id,
    a.series_id,
    a.token_amount / 100 as recharge_amt,
    a.token_amount / 100 as monthly_recharge_amt,
	cast(a.token_amount as decimal(10, 2)) * (1 - 0.00966958) / 100 as net_amt,
	cast(a.token_amount as decimal(10, 2)) * (1 - 0.00966958) / 100 as monthly_net_amt,
    ifnull(b.is_refund, 0) as is_refund,
    ifnull(b.is_sandbox, 0) as is_sandbox,
    a.create_time,
    a.create_time as settle_time,
    now() as etl_time
from ods.ods_tidb_short_video_tt_payorder a  -- 海剧tt换币订单
left join refund_order b on a.trade_order_id = b.trade_order_id
left join dim.dim_short_video_user_accountinfo c on a.account_id = c.user_id
where a.create_time >= date_sub('${bf_1_dt}', interval 7 day) and a.trade_order_status = 2;

-- SQL语句
-- 支付成功;
