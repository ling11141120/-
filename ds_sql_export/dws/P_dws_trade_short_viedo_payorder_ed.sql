----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dws_trade_short_viedo_payorder_ed
-- workflow_version : 16
-- create_user      : yanxh
-- task_name        : tbl_dws_trade_short_viedo_payorder_ed
-- task_version     : 16
-- update_time      : 2026-03-24 11:26:37
-- sql_path         : \starrocks\tbl_dws_trade_short_viedo_payorder_ed\tbl_dws_trade_short_viedo_payorder_ed
----------------------------------------------------------------
-- SQL语句
insert into dws.dws_trade_short_viedo_payorder_ed
with first_charge_info as (
    select
        product_id, user_id, First_charge_day, First_charge_money
    from (
        select
            product_id, user_id, dt as First_charge_day, amount as First_charge_money,
            row_number() over(partition by product_id, user_id order by id) as rn
        from dwd.dwd_trade_sharpenginepaycenter_payorder_view
        where dt >= '2023-07-05' and Order_Status = 1 and test_flag = 0 and product_id = 6833
    ) a where a.rn = 1
),
tt_payorder as (
    -- TT订阅订单
    select
        a.id, a.create_time, date(a.create_time) as dt, cast(b.price_title as decimal(10,2))*if(c.mt=4,0.85,0.7) as base_amount,
        6833 as product_id, a.account_id as user_id, b.price as amount
    from ods.ods_tidb_short_video_tt_vip_subscription_payorder a
    left join (
        select item_id, max(price_title) as price_title, max(Price) as price
        from dim.dim_short_video_goods_view
        where core = 16 and is_remove = 0
        group by item_id
    ) b on a.tier_id = b.item_id
    left join dim.dim_short_video_user_accountinfo c on c.user_id = a.account_id
    left join ods.ods_tidb_short_video_tt_vip_subscribe d
    on a.subscription_record_id = d.id
    left join (
        -- 子查询：获取退款订单的trade_order_id
        select get_json_string(content, '$.trade_order_id') as trade_order_id
        from ods.ods_tidb_short_video_tt_vip_subscribe_event_log
        where event_type IN (9, 10)  -- 撤销、退款
        group by 1
    ) e on a.trade_order_id = e.trade_order_id
    where a.trade_order_status = 2 and ifnull(d.is_sandbox, 0) = 0 and e.trade_order_id is null
    union all
    -- TT换币充值订单
    select
        a.id, a.create_time, date(a.create_time) as dt, a.token_amount*(1-0.00966958)/100 as base_amount,
        6833 as product_id, a.account_id as user_id, a.token_amount/100 as amount
    from ods.ods_tidb_short_video_tt_payorder a
    where a.trade_order_status = 2
),
tt_first_charge_info as (
    select
        product_id, user_id, First_charge_day, First_charge_money
    from (
        select
            product_id, user_id, dt as First_charge_day, amount as First_charge_money,
            row_number() over(partition by product_id, user_id order by create_time, id) as rn
        from tt_payorder a
    ) a
    where rn = 1
)
select
    a.dt, a.product_id, a.user_id,
    md5(concat_ws('_',ifnull(a.dt, -99),ifnull(a.product_id, -99),ifnull(a.user_id, -99),
                  ifnull(b.corever, -99),ifnull(b.Current_Language, -99),ifnull(b.Current_Language2, -99),
                  ifnull(b.mt, -99),ifnull(b.reg_country, -99),ifnull(b.create_time, -99),ifnull(a.Sub_pay_Type, -99),
                  ifnull(c.First_charge_day, -99),ifnull(c.First_charge_money, -99),
                  ifnull(a.sub_pay_type, -99))) as md5_key,
    b.corever,b.Current_Language,b.Current_Language2,b.mt,b.reg_country,
    b.create_time as reg_time,a.Sub_pay_Type,
    c.First_charge_day,
    c.First_charge_money,
    datediff(a.dt, c.First_charge_day) as re_days,
    datediff(a.dt, date(b.create_time)) as reg_days,
    sum(a.base_amount) as charge_money,
    count(a.user_id) as charge_count,
    sum(a.amount) charge_itemcount,
    now() as etl_time
from dwd.dwd_trade_sharpenginepaycenter_payorder_view a
left join dim.dim_short_video_user_accountinfo b
on a.product_id = b.product_id and a.user_id = b.user_id
left join first_charge_info c
on a.product_id = c.product_id and a.user_id = c.user_id
where a.dt >= date_sub('${bf_1_dt}', interval 3 day) and a.product_id = 6833 and a.Order_Status = 1 and a.test_flag = 0
group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14
union all
select
    a.dt, a.product_id, a.user_id,
    md5(concat_ws('_',ifnull(a.dt, -99),ifnull(a.product_id, -99),ifnull(a.user_id, -99),
                  ifnull(b.corever, -99),ifnull(b.Current_Language, -99),ifnull(b.Current_Language2, -99),
                  ifnull(b.mt, -99),ifnull(b.reg_country, -99),ifnull(b.create_time, -99),ifnull(null, -99),
                  ifnull(c.First_charge_day, -99),ifnull(c.First_charge_money, -99),
                  ifnull(null, -99))) as md5_key,
    b.corever,b.Current_Language,b.Current_Language2,b.mt,b.reg_country,
    b.create_time as reg_time, null as Sub_pay_Type,
    c.First_charge_day,
    c.First_charge_money,
    datediff(a.dt, c.First_charge_day) as re_days,
    datediff(a.dt, date(b.create_time)) as reg_days,
    round(sum(a.base_amount), 4) as charge_money,
    count(a.user_id) as charge_count,
    sum(a.amount) charge_itemcount,
    now() as etl_time
from tt_payorder a
left join dim.dim_short_video_user_accountinfo b
on a.product_id = b.product_id and a.user_id = b.user_id
left join tt_first_charge_info c
on a.product_id = c.product_id and a.user_id = c.user_id
where a.dt >= date_sub('${bf_1_dt}', interval 3 day)
group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14;

-- 后置SQL语句
delete from dws.dws_trade_short_viedo_payorder_ed where dt>=date_sub('${bf_1_dt}',interval 3 day) and etl_time<date_sub(current_timestamp(),interval 2 hour );
