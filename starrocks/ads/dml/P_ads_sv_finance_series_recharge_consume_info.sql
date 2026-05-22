----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : 审计测试-总
-- workflow_version : 36
-- create_user      : chenmo
-- task_name        : 海剧上月数据二次导入
-- task_version     : 1
-- update_time      : 2026-02-16 11:41:25
-- sql_path         : \starrocks\审计测试-总\海剧上月数据二次导入
----------------------------------------------------------------
-- 前置SQL语句
delete from ads.ads_sv_finance_series_recharge_consume_info where dt >= date_format(date_sub('${dt}', interval 1 month), '%Y-%m-01');

-- SQL语句
insert into ads.ads_sv_finance_series_recharge_consume_info
select
    a.dt,
    a.product_id,
    a.user_id,
    a.series_id,
    a.order_id,
    a.coo_order_id,
    a.shop_item_id,
    a.report_type,
    a.amount,
    a.remain_amount,
    a.remain_amount_all,
    a.cost,
    ifnull(b.test_flag, 0) as test_flag,
    a.order_time,
    ext3,
    a.duration_time,
    now() as etl_time
from (
    select
        dt,
        product_id,
        user_id,
        null as series_id,
        order_id,
        coo_order_id,
        shop_item_id,
        report_type,
        amount,
        remain_amount,
        remain_amount as remain_amount_all,
        cost,
        coo_notify_time as order_time,
        ext3,
        duration_time,
        corp,
        del_col,
        leave_col,
        case
            when del_col='leave' then 'leave'
            when del_col='del1' and leave_col='leave1' then 'leave'
            when del_col='del1b' and leave_col='leave1b' then 'leave'
            when del_col='del3' and leave_col='leave3' then 'leave'
	    else 'del' end del_col1
    from (
        select
            date(a.coo_notify_time) as dt,
            6833 as product_id,
            a.user_id,
            a.order_serial_id as order_id,
            a.coo_order_id,
            a.shop_item_id,
            1 as report_type,
            ifnull(b.RealGet, 0) as amount,
            ifnull(b.CurMoney, 0) as remain_amount,
            ifnull(a.amount, 0)/100 as cost,
            a.coo_notify_time,
            a.ext3,
            datediff(a.ext3, a.coo_notify_time) as duration_time,
            c.corp,
            -- -------- 新增剔除逻辑 -----
            case
                when  pay_name ='AppStore' and a.core =1 and coo_notify_time>='2021-06-27' and coo_notify_time<'2024-07-01' then 'del1'
                when  pay_name ='AppStore' and a.core =1 and coo_notify_time>='2024-07-01'  then 'del1b'
                when  pay_name ='AppStore' and a.core =2 and coo_notify_time>='2021-06-27' and coo_notify_time<'2022-03-27' then 'del2'
                when  pay_name ='AppStore' and a.core =3  and a.order_id =d.order_number then 'del3b'
                when  pay_name ='AppStore' and a.core =3 and coo_notify_time>='2021-06-27' and coo_notify_time<'2022-03-27' then 'del3'
                when  pay_name in('GooglePlay',';oglePlay') and a.core =1 and coo_notify_time>='2021-06-01' and coo_notify_time<'2022-07-01'  then 'del4'
                when  pay_name in('GooglePlay',';oglePlay')  and a.core in (2,3) and coo_notify_time>='2021-06-01' and coo_notify_time<'2022-06-01' then 'del5a'
                when  pay_name in('GooglePlay',';oglePlay') and a.core in (2,3) and coo_notify_time>='2024-10-01' and coo_notify_time<'2025-02-01'   then 'del5b'
                when  pay_name in('GooglePlay',';oglePlay')  and a.core= 4 and coo_notify_time>='2021-06-01' and coo_notify_time<'2022-07-01'  then 'del6'
                when  pay_name ='PayPal'  and coo_notify_time>='2021-06-01' and coo_notify_time<'2022-02-01'   then 'del7a'
                when  pay_name ='PayPal' and a.order_id = d.order_number then 'del7b'
                when  pay_name ='AppGallery' then 'del8' else 'leave'
            end del_col,
            case
                when  pay_name ='AppStore' and a.core =1 and coo_notify_time>='2021-06-27' and coo_notify_time<'2024-07-01'
                    and a.product_id = 3511 and os_type =1 then 'leave1'
                when  pay_name ='AppStore' and a.core =1 and coo_notify_time>='2024-07-01' and a.product_id = 3511 and os_type in(1,7)  then 'leave1b'
                when  pay_name ='AppStore' and a.core =3 and coo_notify_time>='2021-06-27' and coo_notify_time<'2022-03-27'
                    and a.product_id in (3511,3311,8858,8888,7757) and os_type =1 then 'leave3'
            end leave_col
        from dwd.dwd_srsv_trade_hk_sync_payorder_di_view a
        left join (
            select
                *,
                row_number() over (partition by reforderid order by ifnull(RealGet, 0) desc) as rn
            from ods.ods_tidb_short_video_log_getmoneylog
        ) b
        on a.order_serial_id = b.reforderid and b.rn = 1
        left join
            dim.dim_srsv_paychannel_view c
        on a.pay_chanel_id = c.id
        left join dim.dim_sr_recharge_sdk_exclude d
        on a.order_id = d.order_number
        where d.ym is null and a.product_id = 6833
            and date(a.coo_notify_time) >= date_format(date_sub('${dt}', interval 1 month), '%Y-%m-01')
            and date(a.coo_notify_time) <= last_day(date_sub('${dt}', interval 1 month))
    ) a
    union all
    select
        date(a.CreateTime) as dt,
        6833 as product_id,
        a.UserId as user_id,
        BookId as series_id,
        Id as order_id,
        '-' as coo_order_id,
        null as shop_item_id,
        2 as report_type,
        a.Amount as amount,
        a.RemainAmount as remain_amount,
        a.RemainAmount as remain_amount_all,
        null as cost,
        a.CreateTime,
        null as ext3,
        null asduration_time,
        'MOBOREADER' as corp,
        'leave' as asdel_col,
        'leave' as leave_col,
        'leave' as del_col1
    from ods.ods_tidb_short_video_log_usermoneylog a
    where date(a.CreateTime) >= date_format(date_sub('${dt}', interval 1 month), '%Y-%m-01')
        and date(a.CreateTime) <= last_day(date_sub('${dt}', interval 1 month))
) a
left join (
    select
        user_id,
        max(test_flag) as test_flag
    from dwd.dwd_trade_short_video_payorder
    group by user_id
) b on a.user_id = b.user_id
where del_col1='leave' and corp ='MOBOREADER'
-- 剔除重复订单id
and order_id not in(select order_id from ads.ads_sv_finance_series_recharge_consume_info_delete);

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : 审计测试-总
-- workflow_version : 36
-- create_user      : chenmo
-- task_name        : 海剧上月数据初次导入
-- task_version     : 1
-- update_time      : 2026-02-16 11:41:26
-- sql_path         : \starrocks\审计测试-总\海剧上月数据初次导入
----------------------------------------------------------------
-- 前置SQL语句
delete from ads.ads_sv_finance_series_recharge_consume_info where dt >= date_format(date_sub('${dt}', interval 1 month), '%Y-%m-01');

-- SQL语句
insert into ads.ads_sv_finance_series_recharge_consume_info
select
    a.dt,
    a.product_id,
    a.user_id,
    a.series_id,
    a.order_id,
    a.coo_order_id,
    a.shop_item_id,
    a.report_type,
    a.amount,
    a.remain_amount,
    a.remain_amount_all,
    a.cost,
    ifnull(b.test_flag, 0) as test_flag,
    a.order_time,
    ext3,
    a.duration_time,
    now() as etl_time
from (
    select
        dt,
        product_id,
        user_id,
        null as series_id,
        order_id,
        coo_order_id,
        shop_item_id,
        report_type,
        amount,
        remain_amount,
        remain_amount as remain_amount_all,
        cost,
        coo_notify_time as order_time,
        ext3,
        duration_time,
        corp,
        del_col,
        leave_col,
        case
            when del_col='leave' then 'leave'
            when del_col='del1' and leave_col='leave1' then 'leave'
            when del_col='del1b' and leave_col='leave1b' then 'leave'
            when del_col='del3' and leave_col='leave3' then 'leave'
	    else 'del' end del_col1
    from (
        select
            date(a.coo_notify_time) as dt,
            6833 as product_id,
            a.user_id,
            a.order_serial_id as order_id,
            a.coo_order_id,
            a.shop_item_id,
            1 as report_type,
            ifnull(b.RealGet, 0) as amount,
            ifnull(b.CurMoney, 0) as remain_amount,
            ifnull(a.amount, 0)/100 as cost,
            a.coo_notify_time,
            a.ext3,
            datediff(a.ext3, a.coo_notify_time) as duration_time,
            c.corp,
            -- -------- 新增剔除逻辑 -----
            case
                when  pay_name ='AppStore' and a.core =1 and coo_notify_time>='2021-06-27' and coo_notify_time<'2024-07-01' then 'del1'
                when  pay_name ='AppStore' and a.core =1 and coo_notify_time>='2024-07-01'  then 'del1b'
                when  pay_name ='AppStore' and a.core =2 and coo_notify_time>='2021-06-27' and coo_notify_time<'2022-03-27' then 'del2'
                when  pay_name ='AppStore' and a.core =3  and a.order_id =d.order_number then 'del3b'
                when  pay_name ='AppStore' and a.core =3 and coo_notify_time>='2021-06-27' and coo_notify_time<'2022-03-27' then 'del3'
                when  pay_name in('GooglePlay',';oglePlay') and a.core =1 and coo_notify_time>='2021-06-01' and coo_notify_time<'2022-07-01'  then 'del4'
                when  pay_name in('GooglePlay',';oglePlay')  and a.core in (2,3) and coo_notify_time>='2021-06-01' and coo_notify_time<'2022-06-01' then 'del5a'
                when  pay_name in('GooglePlay',';oglePlay') and a.core in (2,3) and coo_notify_time>='2024-10-01' and coo_notify_time<'2025-02-01'   then 'del5b'
                when  pay_name in('GooglePlay',';oglePlay')  and a.core= 4 and coo_notify_time>='2021-06-01' and coo_notify_time<'2022-07-01'  then 'del6'
                when  pay_name ='PayPal'  and coo_notify_time>='2021-06-01' and coo_notify_time<'2022-02-01'   then 'del7a'
                when  pay_name ='PayPal' and a.order_id = d.order_number then 'del7b'
                when  pay_name ='AppGallery' then 'del8' else 'leave'
            end del_col,
            case
                when  pay_name ='AppStore' and a.core =1 and coo_notify_time>='2021-06-27' and coo_notify_time<'2024-07-01'
                    and a.product_id = 3511 and os_type =1 then 'leave1'
                when  pay_name ='AppStore' and a.core =1 and coo_notify_time>='2024-07-01' and a.product_id = 3511 and os_type in(1,7)  then 'leave1b'
                when  pay_name ='AppStore' and a.core =3 and coo_notify_time>='2021-06-27' and coo_notify_time<'2022-03-27'
                    and a.product_id in (3511,3311,8858,8888,7757) and os_type =1 then 'leave3'
            end leave_col
        from dwd.dwd_srsv_trade_hk_sync_payorder_di_view a
        left join (
            select
                *,
                row_number() over (partition by reforderid order by ifnull(RealGet, 0) desc) as rn
            from ods.ods_tidb_short_video_log_getmoneylog
        ) b
        on a.order_serial_id = b.reforderid and b.rn = 1
        left join
            dim.dim_srsv_paychannel_view c
        on a.pay_chanel_id = c.id
        left join dim.dim_sr_recharge_sdk_exclude d
        on a.order_id = d.order_number
        where d.ym is null and a.product_id = 6833
            and date(a.coo_notify_time) >= date_format(date_sub('${dt}', interval 1 month), '%Y-%m-01')
            and date(a.coo_notify_time) <= last_day(date_sub('${dt}', interval 1 month))
    ) a
    union all
    select
        date(a.CreateTime) as dt,
        6833 as product_id,
        a.UserId as user_id,
        BookId as series_id,
        Id as order_id,
        '-' as coo_order_id,
        null as shop_item_id,
        2 as report_type,
        a.Amount as amount,
        a.RemainAmount as remain_amount,
        a.RemainAmount as remain_amount_all,
        null as cost,
        a.CreateTime,
        null as ext3,
        null asduration_time,
        'MOBOREADER' as corp,
        'leave' as asdel_col,
        'leave' as leave_col,
        'leave' as del_col1
    from ods.ods_tidb_short_video_log_usermoneylog a
    where date(a.CreateTime) >= date_format(date_sub('${dt}', interval 1 month), '%Y-%m-01')
        and date(a.CreateTime) <= last_day(date_sub('${dt}', interval 1 month))
) a
left join (
    select
        user_id,
        max(test_flag) as test_flag
    from dwd.dwd_trade_short_video_payorder
    group by user_id
) b on a.user_id = b.user_id
where del_col1='leave' and corp ='MOBOREADER';

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : 审计测试-总
-- workflow_version : 36
-- create_user      : chenmo
-- task_name        : 海剧循环删除逻辑导出
-- task_version     : 2
-- update_time      : 2026-02-16 11:47:07
-- sql_path         : \starrocks\审计测试-总\海剧循环删除逻辑导出
----------------------------------------------------------------
-- SQL语句
insert into ads.ads_sv_finance_series_recharge_consume_info
with test_user as (
    select
        distinct user_id
    from dwd.dwd_trade_short_video_payorder
    where test_flag = 1
)
select
    dt,
    product_id,
    user_id,
    series_id,
    order_id,
    coo_order_id,
    shop_item_id,
    report_type,
    amount,
    remain_amount,
    remain_amount_all,
    cost,
    test_flag,
    order_time,
    expiration_time,
    duration_time,
    now() as etl_time
from (
    select
        dt,
        product_id,
        user_id,
        series_id,
        order_id,
        coo_order_id,
        shop_item_id,
        report_type,
        amount,
        sum(if(dt < date_format(date_sub('${dt}', interval 1 month), '%Y-%m-01'), remain_amount, amount)) over (partition by a.product_id, a.user_id order by a.order_time, a.order_id desc, a.amount desc) as remain_amount,
        remain_amount_all,
        cost,
        test_flag,
        order_time,
        expiration_time,
        duration_time
    from (
        select
            a.dt,
            a.product_id,
            a.user_id,
            a.series_id,
            a.order_id,
            a.coo_order_id,
            a.shop_item_id,
            a.report_type,
            a.amount,
            a.remain_amount,
            a.remain_amount_all,
            a.cost,
            if(b.user_id is not null, 1, 0) as test_flag,
            a.order_time,
            a.expiration_time,
            a.duration_time
        from ads.ads_sv_finance_series_recharge_consume_info a
        left join test_user b
        on a.user_id = b.user_id
        where report_type = 1 and dt >= date_format(date_sub('${dt}', interval 1 month), '%Y-%m-01')
        union all
        select
            a.dt,
            a.product_id,
            a.user_id,
            a.series_id,
            '-' as order_id,
            '-' as coo_order_id,
            null as shop_itme_id,
            a.report_type,
            a.amount,
            a.amount_sum,
            a.remain_amount,
            null as cost,
            if(b.user_id is not null, 1, 0) as test_flag,
            a.order_time,
            null as expiration_time,
            null as duration_time
        from ads.ads_sv_finance_series_recharge_consume_info_jsconsume a
        left join test_user b
        on a.user_id = b.user_id
        where (report_type = 2 and dt >= date_format(date_sub('${dt}', interval 1 month), '%Y-%m-01')) or dt < date_format(date_sub('${dt}', interval 1 month), '%Y-%m-01')
    ) a
) a where dt >= date_format(date_sub('${dt}', interval 1 month), '%Y-%m-01');

-- 后置SQL语句
with min_del as (
    select
        min(etl_time) as min_etl_time
    from ads.ads_sv_finance_series_recharge_consume_info
    where dt >= date_format(date_sub('${dt}', interval 1 month), '%Y-%m-01')
        and dt <= last_day(date_sub('${dt}', interval 1 month))
)
delete from ads.ads_sv_finance_series_recharge_consume_info where etl_time = (select min_etl_time from min_del);

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : 审计测试-总
-- workflow_version : 36
-- create_user      : chenmo
-- task_name        : 海剧补充消耗主键id
-- task_version     : 2
-- update_time      : 2026-02-16 11:41:25
-- sql_path         : \starrocks\审计测试-总\海剧补充消耗主键id
----------------------------------------------------------------
-- SQL语句
insert into ads.ads_sv_finance_series_recharge_consume_info
select
    a.dt,
    a.product_id,
    a.user_id,
    a.series_id,
    if(a.order_id = '-', b.Id, a.order_id) as order_id,
    a.coo_order_id,
    a.shop_item_id,
    a.report_type,
    a.amount,
    a.remain_amount,
    a.remain_amount_all,
    a.cost,
    a.test_flag,
    a.order_time,
    a.expiration_time,
    a.duration_time,
    now() as etl_time
from (
    select
        *,
        row_number() over (partition by user_id, series_id, amount, remain_amount_all, order_time) as rn
    from ads.ads_sv_finance_series_recharge_consume_info
    where dt >= date_format(date_sub('${dt}', interval 1 month), '%Y-%m-01')
        and dt <= last_day(date_sub('${dt}', interval 1 month))
) a
left join (
    select
        Id,
        UserId,
        BookId,
        Amount,
        RemainAmount,
        CreateTime,
        row_number() over (partition by UserId, BookId, Amount, RemainAmount, CreateTime) as rn
    from ods.ods_tidb_short_video_log_usermoneylog
    where date(CreateTime) >= date_format(date_sub('${dt}', interval 1 month), '%Y-%m-01')
        and date(CreateTime) <= last_day(date_sub('${dt}', interval 1 month))
) b
on a.user_id = b.UserId and a.series_id = b.BookId
and if(a.series_id = 0 and b.Amount < 0, b.Amount, abs(a.amount)) = b.Amount and a.remain_amount_all = b.RemainAmount and a.order_time = b.CreateTime and a.rn = b.rn;

-- 后置SQL语句
with min_del as (
    select
        min(etl_time) as min_etl_time
    from ads.ads_sv_finance_series_recharge_consume_info
    where dt >= date_format(date_sub('${dt}', interval 1 month), '%Y-%m-01')
        and dt <= last_day(date_sub('${dt}', interval 1 month))
)
delete from ads.ads_sv_finance_series_recharge_consume_info where etl_time = (select min_etl_time from min_del);

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : 审计测试-总_改
-- workflow_version : 11
-- create_user      : xiejc
-- task_name        : 海剧上月数据二次导入
-- task_version     : 3
-- update_time      : 2026-04-01 16:24:12
-- sql_path         : \starrocks\审计测试-总_改\海剧上月数据二次导入
----------------------------------------------------------------
-- 前置SQL语句
delete from ads.ads_sv_finance_series_recharge_consume_info where dt >= '$[add_months(yyyy-MM, -1)]-01';

-- SQL语句
insert into ads.ads_sv_finance_series_recharge_consume_info
select
    a.dt,
    a.product_id,
    a.user_id,
    a.series_id,
    a.order_id,
    a.coo_order_id,
    a.shop_item_id,
    a.report_type,
    a.amount,
    a.remain_amount,
    a.remain_amount_all,
    a.cost,
    ifnull(b.test_flag, 0) as test_flag,
    a.order_time,
    ext3,
    a.duration_time,
    now() as etl_time
from (
    select
        dt,
        product_id,
        user_id,
        null as series_id,
        order_id,
        coo_order_id,
        shop_item_id,
        report_type,
        amount,
        remain_amount,
        remain_amount as remain_amount_all,
        cost,
        coo_notify_time as order_time,
        ext3,
        duration_time,
        corp,
        del_col,
        leave_col,
        case
            when del_col='leave' then 'leave'
            when del_col='del1' and leave_col='leave1' then 'leave'
            when del_col='del1b' and leave_col='leave1b' then 'leave'
            when del_col='del3' and leave_col='leave3' then 'leave'
	    else 'del' end del_col1
    from (
        select
            date(a.coo_notify_time) as dt,
            6833 as product_id,
            a.user_id,
            a.order_serial_id as order_id,
            a.coo_order_id,
            a.shop_item_id,
            1 as report_type,
            ifnull(b.RealGet, 0) as amount,
            ifnull(b.CurMoney, 0) as remain_amount,
            ifnull(a.amount, 0)/100 as cost,
            a.coo_notify_time,
            a.ext3,
            datediff(a.ext3, a.coo_notify_time) as duration_time,
            c.corp,
            -- -------- 新增剔除逻辑 -----
            case
                when  pay_name ='AppStore' and a.core =1 and coo_notify_time>='2021-06-27' and coo_notify_time<'2024-07-01' then 'del1'
                when  pay_name ='AppStore' and a.core =1 and coo_notify_time>='2024-07-01'  then 'del1b'
                when  pay_name ='AppStore' and a.core =2 and coo_notify_time>='2021-06-27' and coo_notify_time<'2022-03-27' then 'del2'
                when  pay_name ='AppStore' and a.core =3  and a.order_id =d.order_number then 'del3b'
                when  pay_name ='AppStore' and a.core =3 and coo_notify_time>='2021-06-27' and coo_notify_time<'2022-03-27' then 'del3'
                when  pay_name in('GooglePlay',';oglePlay') and a.core =1 and coo_notify_time>='2021-06-01' and coo_notify_time<'2022-07-01'  then 'del4'
                when  pay_name in('GooglePlay',';oglePlay')  and a.core in (2,3) and coo_notify_time>='2021-06-01' and coo_notify_time<'2022-06-01' then 'del5a'
                when  pay_name in('GooglePlay',';oglePlay') and a.core in (2,3) and coo_notify_time>='2024-10-01' and coo_notify_time<'2025-02-01'   then 'del5b'
                when  pay_name in('GooglePlay',';oglePlay')  and a.core= 4 and coo_notify_time>='2021-06-01' and coo_notify_time<'2022-07-01'  then 'del6'
                when  pay_name ='PayPal'  and coo_notify_time>='2021-06-01' and coo_notify_time<'2022-02-01'   then 'del7a'
                when  pay_name ='PayPal' and a.order_id = d.order_number then 'del7b'
                when  pay_name ='AppGallery' then 'del8' else 'leave'
            end del_col,
            case
                when  pay_name ='AppStore' and a.core =1 and coo_notify_time>='2021-06-27' and coo_notify_time<'2024-07-01'
                    and a.product_id = 3511 and os_type =1 then 'leave1'
                when  pay_name ='AppStore' and a.core =1 and coo_notify_time>='2024-07-01' and a.product_id = 3511 and os_type in(1,7)  then 'leave1b'
                when  pay_name ='AppStore' and a.core =3 and coo_notify_time>='2021-06-27' and coo_notify_time<'2022-03-27'
                    and a.product_id in (3511,3311,8858,8888,7757) and os_type =1 then 'leave3'
            end leave_col
        from dwd.dwd_srsv_trade_hk_sync_payorder_di_view a
        left join (
            select
                *,
                row_number() over (partition by reforderid order by ifnull(RealGet, 0) desc) as rn
            from ods.ods_tidb_short_video_log_getmoneylog
        ) b
        on a.order_serial_id = b.reforderid and b.rn = 1
        left join
            dim.dim_srsv_paychannel_view c
        on a.pay_chanel_id = c.id
        left join dim.dim_sr_recharge_sdk_exclude d
        on a.order_id = d.order_number
        where d.ym is null and a.product_id = 6833
            and date(a.coo_notify_time) >= date_format(date_sub('${dt}', interval 1 month), '%Y-%m-01')
            and date(a.coo_notify_time) <= last_day(date_sub('${dt}', interval 1 month))
    ) a
    union all
    select
        date(a.CreateTime) as dt,
        6833 as product_id,
        a.UserId as user_id,
        BookId as series_id,
        Id as order_id,
        '-' as coo_order_id,
        null as shop_item_id,
        2 as report_type,
        a.Amount as amount,
        a.RemainAmount as remain_amount,
        a.RemainAmount as remain_amount_all,
        null as cost,
        a.CreateTime,
        null as ext3,
        null asduration_time,
        'MOBOREADER' as corp,
        'leave' as asdel_col,
        'leave' as leave_col,
        'leave' as del_col1
    from ods.ods_tidb_short_video_log_usermoneylog a
    where date(a.CreateTime) >= date_format(date_sub('${dt}', interval 1 month), '%Y-%m-01')
        and date(a.CreateTime) <= last_day(date_sub('${dt}', interval 1 month))
) a
left join (
    select
        user_id,
        max(test_flag) as test_flag
    from dwd.dwd_trade_short_video_payorder
    group by user_id
) b on a.user_id = b.user_id
where del_col1='leave' and corp ='MOBOREADER'
-- 剔除重复订单id
and order_id not in(select order_id from ads.ads_sv_finance_series_recharge_consume_info_delete);

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : 审计测试-总_改
-- workflow_version : 11
-- create_user      : xiejc
-- task_name        : 海剧上月数据初次导入
-- task_version     : 3
-- update_time      : 2026-04-01 16:24:12
-- sql_path         : \starrocks\审计测试-总_改\海剧上月数据初次导入
----------------------------------------------------------------
-- 前置SQL语句
delete from ads.ads_sv_finance_series_recharge_consume_info where dt >='$[add_months(yyyy-MM, -1)]-01';

-- SQL语句
insert into ads.ads_sv_finance_series_recharge_consume_info
select
    a.dt,
    a.product_id,
    a.user_id,
    a.series_id,
    a.order_id,
    a.coo_order_id,
    a.shop_item_id,
    a.report_type,
    a.amount,
    a.remain_amount,
    a.remain_amount_all,
    a.cost,
    ifnull(b.test_flag, 0) as test_flag,
    a.order_time,
    ext3,
    a.duration_time,
    now() as etl_time
from (
    select
        dt,
        product_id,
        user_id,
        null as series_id,
        order_id,
        coo_order_id,
        shop_item_id,
        report_type,
        amount,
        remain_amount,
        remain_amount as remain_amount_all,
        cost,
        coo_notify_time as order_time,
        ext3,
        duration_time,
        corp,
        del_col,
        leave_col,
        case
            when del_col='leave' then 'leave'
            when del_col='del1' and leave_col='leave1' then 'leave'
            when del_col='del1b' and leave_col='leave1b' then 'leave'
            when del_col='del3' and leave_col='leave3' then 'leave'
	    else 'del' end del_col1
    from (
        select
            date(a.coo_notify_time) as dt,
            6833 as product_id,
            a.user_id,
            a.order_serial_id as order_id,
            a.coo_order_id,
            a.shop_item_id,
            1 as report_type,
            ifnull(b.RealGet, 0) as amount,
            ifnull(b.CurMoney, 0) as remain_amount,
            ifnull(a.amount, 0)/100 as cost,
            a.coo_notify_time,
            a.ext3,
            datediff(a.ext3, a.coo_notify_time) as duration_time,
            c.corp,
            -- -------- 新增剔除逻辑 -----
            case
                when  pay_name ='AppStore' and a.core =1 and coo_notify_time>='2021-06-27' and coo_notify_time<'2024-07-01' then 'del1'
                when  pay_name ='AppStore' and a.core =1 and coo_notify_time>='2024-07-01'  then 'del1b'
                when  pay_name ='AppStore' and a.core =2 and coo_notify_time>='2021-06-27' and coo_notify_time<'2022-03-27' then 'del2'
                when  pay_name ='AppStore' and a.core =3  and a.order_id =d.order_number then 'del3b'
                when  pay_name ='AppStore' and a.core =3 and coo_notify_time>='2021-06-27' and coo_notify_time<'2022-03-27' then 'del3'
                when  pay_name in('GooglePlay',';oglePlay') and a.core =1 and coo_notify_time>='2021-06-01' and coo_notify_time<'2022-07-01'  then 'del4'
                when  pay_name in('GooglePlay',';oglePlay')  and a.core in (2,3) and coo_notify_time>='2021-06-01' and coo_notify_time<'2022-06-01' then 'del5a'
                when  pay_name in('GooglePlay',';oglePlay') and a.core in (2,3) and coo_notify_time>='2024-10-01' and coo_notify_time<'2025-02-01'   then 'del5b'
                when  pay_name in('GooglePlay',';oglePlay')  and a.core= 4 and coo_notify_time>='2021-06-01' and coo_notify_time<'2022-07-01'  then 'del6'
                when  pay_name ='PayPal'  and coo_notify_time>='2021-06-01' and coo_notify_time<'2022-02-01'   then 'del7a'
                when  pay_name ='PayPal' and a.order_id = d.order_number then 'del7b'
                when  pay_name ='AppGallery' then 'del8' else 'leave'
            end del_col,
            case
                when  pay_name ='AppStore' and a.core =1 and coo_notify_time>='2021-06-27' and coo_notify_time<'2024-07-01'
                    and a.product_id = 3511 and os_type =1 then 'leave1'
                when  pay_name ='AppStore' and a.core =1 and coo_notify_time>='2024-07-01' and a.product_id = 3511 and os_type in(1,7)  then 'leave1b'
                when  pay_name ='AppStore' and a.core =3 and coo_notify_time>='2021-06-27' and coo_notify_time<'2022-03-27'
                    and a.product_id in (3511,3311,8858,8888,7757) and os_type =1 then 'leave3'
            end leave_col
        from dwd.dwd_srsv_trade_hk_sync_payorder_di_view a
        left join (
            select
                *,
                row_number() over (partition by reforderid order by ifnull(RealGet, 0) desc) as rn
            from ods.ods_tidb_short_video_log_getmoneylog
        ) b
        on a.order_serial_id = b.reforderid and b.rn = 1
        left join
            dim.dim_srsv_paychannel_view c
        on a.pay_chanel_id = c.id
        left join dim.dim_sr_recharge_sdk_exclude d
        on a.order_id = d.order_number
        where d.ym is null and a.product_id = 6833
            and date(a.coo_notify_time) >= date_format(date_sub('${dt}', interval 1 month), '%Y-%m-01')
            and date(a.coo_notify_time) <= last_day(date_sub('${dt}', interval 1 month))
    ) a
    union all
    select
        date(a.CreateTime) as dt,
        6833 as product_id,
        a.UserId as user_id,
        BookId as series_id,
        Id as order_id,
        '-' as coo_order_id,
        null as shop_item_id,
        2 as report_type,
        a.Amount as amount,
        a.RemainAmount as remain_amount,
        a.RemainAmount as remain_amount_all,
        null as cost,
        a.CreateTime,
        null as ext3,
        null asduration_time,
        'MOBOREADER' as corp,
        'leave' as asdel_col,
        'leave' as leave_col,
        'leave' as del_col1
    from ods.ods_tidb_short_video_log_usermoneylog a
    where date(a.CreateTime) >= date_format(date_sub('${dt}', interval 1 month), '%Y-%m-01')
        and date(a.CreateTime) <= last_day(date_sub('${dt}', interval 1 month))
) a
left join (
    select
        user_id,
        max(test_flag) as test_flag
    from dwd.dwd_trade_short_video_payorder
    group by user_id
) b on a.user_id = b.user_id
where del_col1='leave' and corp ='MOBOREADER';

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : 审计测试-总_改
-- workflow_version : 11
-- create_user      : xiejc
-- task_name        : 海剧冗余数据删除
-- task_version     : 1
-- update_time      : 2026-03-31 15:54:20
-- sql_path         : \starrocks\审计测试-总_改\海剧冗余数据删除
----------------------------------------------------------------
-- SQL语句
delete from ads.ads_sv_finance_series_recharge_consume_info where etl_time = '${sv_min_etl_time}';

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : 审计测试-总_改
-- workflow_version : 11
-- create_user      : xiejc
-- task_name        : 海剧冗余数据删除
-- task_version     : 2
-- update_time      : 2026-04-01 16:46:10
-- sql_path         : \starrocks\审计测试-总_改\海剧冗余数据删除
----------------------------------------------------------------
-- SQL语句
delete from ads.ads_sv_finance_series_recharge_consume_info where etl_time = '${sv_min_etl_time_2}';

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : 审计测试-总_改
-- workflow_version : 11
-- create_user      : xiejc
-- task_name        : 海剧循环删除逻辑导出
-- task_version     : 2
-- update_time      : 2026-04-01 16:28:08
-- sql_path         : \starrocks\审计测试-总_改\海剧循环删除逻辑导出
----------------------------------------------------------------
-- SQL语句
insert into ads.ads_sv_finance_series_recharge_consume_info
with test_user as (
    select
        distinct user_id
    from dwd.dwd_trade_short_video_payorder
    where test_flag = 1
)
select
    dt,
    product_id,
    user_id,
    series_id,
    order_id,
    coo_order_id,
    shop_item_id,
    report_type,
    amount,
    remain_amount,
    remain_amount_all,
    cost,
    test_flag,
    order_time,
    expiration_time,
    duration_time,
    now() as etl_time
from (
    select
        dt,
        product_id,
        user_id,
        series_id,
        order_id,
        coo_order_id,
        shop_item_id,
        report_type,
        amount,
        sum(if(dt < date_format(date_sub('${dt}', interval 1 month), '%Y-%m-01'), remain_amount, amount)) over (partition by a.product_id, a.user_id order by a.order_time, a.order_id desc, a.amount desc) as remain_amount,
        remain_amount_all,
        cost,
        test_flag,
        order_time,
        expiration_time,
        duration_time
    from (
        select
            a.dt,
            a.product_id,
            a.user_id,
            a.series_id,
            a.order_id,
            a.coo_order_id,
            a.shop_item_id,
            a.report_type,
            a.amount,
            a.remain_amount,
            a.remain_amount_all,
            a.cost,
            if(b.user_id is not null, 1, 0) as test_flag,
            a.order_time,
            a.expiration_time,
            a.duration_time
        from ads.ads_sv_finance_series_recharge_consume_info a
        left join test_user b
        on a.user_id = b.user_id
        where report_type = 1 and dt >= date_format(date_sub('${dt}', interval 1 month), '%Y-%m-01')
        union all
        select
            a.dt,
            a.product_id,
            a.user_id,
            a.series_id,
            '-' as order_id,
            '-' as coo_order_id,
            null as shop_itme_id,
            a.report_type,
            a.amount,
            a.amount_sum,
            a.remain_amount,
            null as cost,
            if(b.user_id is not null, 1, 0) as test_flag,
            a.order_time,
            null as expiration_time,
            null as duration_time
        from ads.ads_sv_finance_series_recharge_consume_info_jsconsume a
        left join test_user b
        on a.user_id = b.user_id
        where (report_type = 2 and dt >= date_format(date_sub('${dt}', interval 1 month), '%Y-%m-01')) or dt < date_format(date_sub('${dt}', interval 1 month), '%Y-%m-01')
    ) a
) a where dt >= date_format(date_sub('${dt}', interval 1 month), '%Y-%m-01');

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : 审计测试-总_改
-- workflow_version : 11
-- create_user      : xiejc
-- task_name        : 海剧补充消耗主键id
-- task_version     : 2
-- update_time      : 2026-04-01 16:28:08
-- sql_path         : \starrocks\审计测试-总_改\海剧补充消耗主键id
----------------------------------------------------------------
-- SQL语句
insert into ads.ads_sv_finance_series_recharge_consume_info
select
    a.dt,
    a.product_id,
    a.user_id,
    a.series_id,
    if(a.order_id = '-', b.Id, a.order_id) as order_id,
    a.coo_order_id,
    a.shop_item_id,
    a.report_type,
    a.amount,
    a.remain_amount,
    a.remain_amount_all,
    a.cost,
    a.test_flag,
    a.order_time,
    a.expiration_time,
    a.duration_time,
    now() as etl_time
from (
    select
        *,
        row_number() over (partition by user_id, series_id, amount, remain_amount_all, order_time) as rn
    from ads.ads_sv_finance_series_recharge_consume_info
    where dt >= date_format(date_sub('${dt}', interval 1 month), '%Y-%m-01')
        and dt <= last_day(date_sub('${dt}', interval 1 month))
) a
left join (
    select
        Id,
        UserId,
        BookId,
        Amount,
        RemainAmount,
        CreateTime,
        row_number() over (partition by UserId, BookId, Amount, RemainAmount, CreateTime) as rn
    from ods.ods_tidb_short_video_log_usermoneylog
    where date(CreateTime) >= date_format(date_sub('${dt}', interval 1 month), '%Y-%m-01')
        and date(CreateTime) <= last_day(date_sub('${dt}', interval 1 month))
) b
on a.user_id = b.UserId and a.series_id = b.BookId
and if(a.series_id = 0 and b.Amount < 0, b.Amount, abs(a.amount)) = b.Amount and a.remain_amount_all = b.RemainAmount and a.order_time = b.CreateTime and a.rn = b.rn;
