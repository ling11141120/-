----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : 审计测试-总
-- workflow_version : 36
-- create_user      : chenmo
-- task_name        : 海剧账龄汇总
-- task_version     : 1
-- update_time      : 2026-02-16 11:41:25
-- sql_path         : \starrocks\审计测试-总\海剧账龄汇总
----------------------------------------------------------------
-- 前置SQL语句
delete from ads.`ads_sv_finance_series_recharge_surplus_info` where aging_dt = last_day(date_sub('${dt}', interval 1 month));

-- SQL语句
insert into ads.`ads_sv_finance_series_recharge_surplus_info`
with recharge as (
    -- 用户充值明细
    select
        dt,
        product_id,
        user_id,
        order_id,
        coo_order_id,
        shop_item_id,
        amount,
        cost,
        test_flag,
        order_time,
        expiration_time,
        duration_time,
        sum(amount) over (partition by product_id, user_id order by order_time, coo_order_id) as charge_sum
    from ads.ads_sv_finance_series_recharge_consume_info
    where report_type = 1 and amount != 0 and dt <= last_day(date_sub('${dt}', interval 1 month))
),
consume as (
    -- 用户结余阅币
    select
        product_id,
        user_id,
        abs(sum(amount)) as consume_amt
    from ads.ads_sv_finance_series_recharge_consume_info
    where report_type = 2 and dt <= last_day(date_sub('${dt}', interval 1 month))
    group by product_id, user_id
)
select
    last_day(date_sub('${dt}', interval 1 month)) as aging_dt,
    a.dt,
    a.product_id,
    a.user_id,
    a.order_id,
    a.coo_order_id,
    a.shop_item_id,
    a.amount,
    if(a.charge_sum - ifnull(b.consume_amt, 0) - a.amount <= 0,
        a.charge_sum - ifnull(b.consume_amt, 0),
        a.amount
    ) as surplus,
    a.cost,
    a.test_flag,
    a.order_time,
    a.expiration_time,
    a.duration_time,
    now() as etl_time
from recharge a
left join consume b
on a.product_id = b.product_id and a.user_id = b.user_id
where a.charge_sum > ifnull(b.consume_amt, 0);

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : 审计测试-总_改
-- workflow_version : 11
-- create_user      : xiejc
-- task_name        : 海剧账龄汇总
-- task_version     : 2
-- update_time      : 2026-03-31 15:54:20
-- sql_path         : \starrocks\审计测试-总_改\海剧账龄汇总
----------------------------------------------------------------
-- 前置SQL语句
delete from ads.`ads_sv_finance_series_recharge_surplus_info` where aging_dt = '${last_day}';

-- SQL语句
insert into ads.`ads_sv_finance_series_recharge_surplus_info`
with recharge as (
    -- 用户充值明细
    select
        dt,
        product_id,
        user_id,
        order_id,
        coo_order_id,
        shop_item_id,
        amount,
        cost,
        test_flag,
        order_time,
        expiration_time,
        duration_time,
        sum(amount) over (partition by product_id, user_id order by order_time, coo_order_id) as charge_sum
    from ads.ads_sv_finance_series_recharge_consume_info
    where report_type = 1 and amount != 0 and dt <= last_day(date_sub('${dt}', interval 1 month))
),
consume as (
    -- 用户结余阅币
    select
        product_id,
        user_id,
        abs(sum(amount)) as consume_amt
    from ads.ads_sv_finance_series_recharge_consume_info
    where report_type = 2 and dt <= last_day(date_sub('${dt}', interval 1 month))
    group by product_id, user_id
)
select
    last_day(date_sub('${dt}', interval 1 month)) as aging_dt,
    a.dt,
    a.product_id,
    a.user_id,
    a.order_id,
    a.coo_order_id,
    a.shop_item_id,
    a.amount,
    if(a.charge_sum - ifnull(b.consume_amt, 0) - a.amount <= 0,
        a.charge_sum - ifnull(b.consume_amt, 0),
        a.amount
    ) as surplus,
    a.cost,
    a.test_flag,
    a.order_time,
    a.expiration_time,
    a.duration_time,
    now() as etl_time
from recharge a
left join consume b
on a.product_id = b.product_id and a.user_id = b.user_id
where a.charge_sum > ifnull(b.consume_amt, 0);

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : 审计测试-总_改_补数
-- workflow_version : 20
-- create_user      : xiejc
-- task_name        : 海剧账龄汇总
-- task_version     : 4
-- update_time      : 2026-05-07 18:01:08
-- sql_path         : \starrocks\审计测试-总_改_补数\海剧账龄汇总
----------------------------------------------------------------
-- 前置SQL语句
delete from ads.`ads_sv_finance_series_recharge_surplus_info` where aging_dt = '${last_day}';
