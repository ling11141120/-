----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : ads_sr_finance_book_recharge_consume_info_jsconsume
-- workflow_version : 13
-- create_user      : chenmo
-- task_name        : ads_sr_finance_book_recharge_consume_info_jsconsume
-- task_version     : 8
-- update_time      : 2025-03-29 20:43:09
-- sql_path         : \starrocks\ads_sr_finance_book_recharge_consume_info_jsconsume\ads_sr_finance_book_recharge_consume_info_jsconsume
----------------------------------------------------------------
-- SQL语句
insert into ads.ads_sr_finance_book_recharge_consume_info_jsconsume
select
    dt,
    one_id,
    product_id,
    user_id,
    book_id,
    order_time,
    amount,
    remain_amount,
    report_type,
    amount_sum,
    etl_time
from (
    select dt,
       one_id,
       product_id,
       user_id,
       book_id,
       order_time,
       amount,
       remain_amount,
       report_type,
       sum(amount) over (partition by product_id, user_id order by order_time, one_id) as amount_sum,
       now() as etl_time
    from (
        select
            dt,
            0 as one_id,
            product_id,
            user_id,
            null as book_id,
            amount,
            remain_amount,
            order_time,
            1 as report_type
        from ads.ads_sr_finance_book_recharge_consume_info
        where amount != 0 and report_type = 1
        union all
        select
            dt,
            one_id,
            product_id,
            user_id,
            book_id,
            amount,
            remain_amount,
            order_time,
            2 as report_type
        from ads.ads_sr_finance_book_recharge_consume_info_jsconsume a
    ) a
) a where report_type = 2;

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : ads_sr_finance_book_recharge_consume_info_jsconsume
-- workflow_version : 13
-- create_user      : chenmo
-- task_name        : records_to_delete
-- task_version     : 10
-- update_time      : 2025-03-29 20:43:09
-- sql_path         : \starrocks\ads_sr_finance_book_recharge_consume_info_jsconsume\records_to_delete
----------------------------------------------------------------
-- SQL语句
with records_to_delete as (
    select
        a.product_id,
        a.user_id,
        a.amount_sum,
        a.one_id,
        sum(if(if(a.one_id = b.one_id, b.amount_sum, a.amount) >= b.diff and a.one_id != b.one_id, 999999999, if(a.one_id = b.one_id, b.amount_sum, a.amount))) over (partition by a.product_id, a.user_id order by a.order_time, a.one_id) as amount_sum1,
        b.amount_sum as b_amount_sum,
        b.diff
    from ads.ads_sr_finance_book_recharge_consume_info_jsconsume a
    join (
        select
            product_id,
            user_id,
            one_id,
            amount,
            amount_sum,
            amount-amount_sum as diff,
            row_number() over (partition by product_id, user_id order by order_time, one_id) as rn
        from ads.ads_sr_finance_book_recharge_consume_info_jsconsume
        where amount_sum < 0
    ) b on b.rn = 1 and a.product_id = b.product_id and a.user_id = b.user_id and a.one_id >= b.one_id
)
delete from ads.ads_sr_finance_book_recharge_consume_info_jsconsume
where (one_id, product_id, user_id) in (
    select one_id, product_id, user_id
    from records_to_delete
    where amount_sum = amount_sum1
);

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : ads_sr_finance_book_recharge_consume_info_month
-- workflow_version : 12
-- create_user      : chenmo
-- task_name        : ads_sr_finance_book_recharge_consume_info_jsconsume
-- task_version     : 12
-- update_time      : 2026-01-07 15:58:52
-- sql_path         : \starrocks\ads_sr_finance_book_recharge_consume_info_month\ads_sr_finance_book_recharge_consume_info_jsconsume
----------------------------------------------------------------
-- SQL语句
-- 每日执行
insert into ads.ads_sr_finance_book_recharge_consume_info_jsconsume
select
    dt,
    one_id,
    product_id,
    user_id,
    book_id,
    order_time,
    amount,
    remain_amount,
    report_type,
    sum(if(dt < '2025-12-01', amount_sum, amount)) over (partition by product_id, user_id order by order_time, one_id) as amount_sum,
    now() as etl_time
from ads.ads_sr_finance_book_recharge_consume_info_jsconsume;

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : ads_sr_finance_book_recharge_consume_info_month
-- workflow_version : 12
-- create_user      : chenmo
-- task_name        : records_to_delete
-- task_version     : 12
-- update_time      : 2026-01-07 15:58:52
-- sql_path         : \starrocks\ads_sr_finance_book_recharge_consume_info_month\records_to_delete
----------------------------------------------------------------
-- SQL语句
with records_to_delete as (
    select
        a.product_id,
        a.user_id,
        a.amount_sum,
        a.one_id,
        sum(if(if(a.one_id = b.one_id, b.amount_sum, a.amount) >= b.diff and a.one_id != b.one_id, 999999999, if(a.one_id = b.one_id, b.amount_sum, a.amount))) over (partition by a.product_id, a.user_id order by a.order_time, a.one_id) as amount_sum1,
        b.amount_sum as b_amount_sum,
        b.diff
    from ads.ads_sr_finance_book_recharge_consume_info_jsconsume a
    join (
        select
            product_id,
            user_id,
            one_id,
            amount,
            amount_sum,
            amount-amount_sum as diff,
            row_number() over (partition by product_id, user_id order by order_time, one_id) as rn
        from ads.ads_sr_finance_book_recharge_consume_info_jsconsume
        where amount_sum < 0
    ) b on b.rn = 1 and a.product_id = b.product_id and a.user_id = b.user_id and a.one_id >= b.one_id
    where a.report_type = 2
)
delete from ads.ads_sr_finance_book_recharge_consume_info_jsconsume
where (one_id, product_id, user_id) in (
    select one_id, product_id, user_id
    from records_to_delete
    where amount_sum = amount_sum1
);

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : 审计测试-总
-- workflow_version : 36
-- create_user      : chenmo
-- task_name        : 海阅循环删除逻辑初次导入
-- task_version     : 1
-- update_time      : 2026-02-16 11:41:25
-- sql_path         : \starrocks\审计测试-总\海阅循环删除逻辑初次导入
----------------------------------------------------------------
-- SQL语句
insert overwrite ads.ads_sr_finance_book_recharge_consume_info_jsconsume
select
    dt,
    row_number() over (order by product_id, user_id, order_time, amount) as one_id,
    product_id,
    user_id,
    book_id,
    order_time,
    amount,
    remain_amount,
    report_type,
    sum(if(dt < date_format(date_sub('${dt}', interval 1 month), '%Y-%m-01'), amount_sum, amount)) over (partition by product_id, user_id order by order_time) as amount_sum,
now() as etl_time
from (
    select
        dt,
        product_id,
        user_id,
        null as book_id,
        amount,
        remain_amount,
        order_time,
        1 as report_type,
        0 as amount_sum
    from ads.ads_sr_finance_book_recharge_consume_info
    where amount != 0 and report_type = 1
        and dt >= date_format(date_sub('${dt}', interval 1 month), '%Y-%m-01')
        and dt <= last_day(date_sub('${dt}', interval 1 month))
    union all
    select
        dt,
        ProductId as product_id,
        UserId as user_id,
        BookId as book_id,
        concat('-', Amount) as amount,
        RemainAmount as remain_amount,
        CreateTime,
        2 as report_type,
        0 as amount_sum
    from ods_log.ods_book_log_usermoneylog
    where dt >= date_format(date_sub('${dt}', interval 1 month), '%Y-%m-01')
        and dt <= last_day(date_sub('${dt}', interval 1 month))
    union all
    select
        a.dt,
        a.product_id,
        a.user_id,
        a.book_id,
        a.amount,
        a.remain_amount_all,
        a.order_time,
        a.report_type,
        a.remain_amount
    from (
        select
            *,
            row_number() over (partition by product_id, user_id order by order_time desc, remain_amount) as rn
        from ads.ads_sr_finance_book_recharge_consume_info
        where dt < date_format(date_sub('${dt}', interval 1 month), '%Y-%m-01')
    ) a where rn = 1
) a;

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : 审计测试-总_改
-- workflow_version : 11
-- create_user      : xiejc
-- task_name        : 海阅循环删除逻辑初次导入
-- task_version     : 1
-- update_time      : 2026-03-31 14:40:14
-- sql_path         : \starrocks\审计测试-总_改\海阅循环删除逻辑初次导入
----------------------------------------------------------------
-- SQL语句
insert overwrite ads.ads_sr_finance_book_recharge_consume_info_jsconsume
select
    dt,
    row_number() over (order by product_id, user_id, order_time, amount) as one_id,
    product_id,
    user_id,
    book_id,
    order_time,
    amount,
    remain_amount,
    report_type,
    sum(if(dt < date_format(date_sub('${dt}', interval 1 month), '%Y-%m-01'), amount_sum, amount)) over (partition by product_id, user_id order by order_time) as amount_sum,
now() as etl_time
from (
    select
        dt,
        product_id,
        user_id,
        null as book_id,
        amount,
        remain_amount,
        order_time,
        1 as report_type,
        0 as amount_sum
    from ads.ads_sr_finance_book_recharge_consume_info
    where amount != 0 and report_type = 1
        and dt >= date_format(date_sub('${dt}', interval 1 month), '%Y-%m-01')
        and dt <= last_day(date_sub('${dt}', interval 1 month))
    union all
    select
        dt,
        ProductId as product_id,
        UserId as user_id,
        BookId as book_id,
        concat('-', Amount) as amount,
        RemainAmount as remain_amount,
        CreateTime,
        2 as report_type,
        0 as amount_sum
    from ods_log.ods_book_log_usermoneylog
    where dt >= date_format(date_sub('${dt}', interval 1 month), '%Y-%m-01')
        and dt <= last_day(date_sub('${dt}', interval 1 month))
    union all
    select
        a.dt,
        a.product_id,
        a.user_id,
        a.book_id,
        a.amount,
        a.remain_amount_all,
        a.order_time,
        a.report_type,
        a.remain_amount
    from (
        select
            *,
            row_number() over (partition by product_id, user_id order by order_time desc, remain_amount) as rn
        from ads.ads_sr_finance_book_recharge_consume_info
        where dt < date_format(date_sub('${dt}', interval 1 month), '%Y-%m-01')
    ) a where rn = 1
) a;

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : 审计测试-总_改_补数
-- workflow_version : 20
-- create_user      : xiejc
-- task_name        : 海阅循环删除逻辑初次导入
-- task_version     : 4
-- update_time      : 2026-05-07 18:10:26
-- sql_path         : \starrocks\审计测试-总_改_补数\海阅循环删除逻辑初次导入
----------------------------------------------------------------
-- SQL语句
insert overwrite ads.ads_sr_finance_book_recharge_consume_info_jsconsume
select
    dt,
    row_number() over (order by product_id, user_id, order_time, amount) as one_id,
    product_id,
    user_id,
    book_id,
    order_time,
    amount,
    remain_amount,
    report_type,
    sum(if(dt < date_format(date_sub('${dt}', interval 1 month), '%Y-%m-01'), amount_sum, amount)) over (partition by product_id, user_id order by order_time) as amount_sum,
now() as etl_time
from (
    select
        dt,
        product_id,
        user_id,
        null as book_id,
        amount,
        remain_amount,
        order_time,
        1 as report_type,
        0 as amount_sum
    from tmp.tmp_xjc_ads_sr_finance_book_recharge_consume_info
    where amount != 0 and report_type = 1
        and dt >= date_format(date_sub('${dt}', interval 1 month), '%Y-%m-01')
        and dt <= last_day(date_sub('${dt}', interval 1 month))
    union all
    select
        dt,
        ProductId as product_id,
        UserId as user_id,
        BookId as book_id,
        concat('-', Amount) as amount,
        RemainAmount as remain_amount,
        CreateTime,
        2 as report_type,
        0 as amount_sum
    from ods_log.ods_book_log_usermoneylog
    where dt >= date_format(date_sub('${dt}', interval 1 month), '%Y-%m-01')
        and dt <= last_day(date_sub('${dt}', interval 1 month))
    union all
    select
        a.dt,
        a.product_id,
        a.user_id,
        a.book_id,
        a.amount,
        a.remain_amount_all,
        a.order_time,
        a.report_type,
        a.remain_amount
    from (
        select
            *,
            row_number() over (partition by product_id, user_id order by order_time desc, remain_amount) as rn
        from tmp.tmp_xjc_ads_sr_finance_book_recharge_consume_info
        where dt < date_format(date_sub('${dt}', interval 1 month), '%Y-%m-01')
    ) a where rn = 1
) a;
