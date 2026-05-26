----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_srsv_finance_user_pay_ymd
-- workflow_version : 5
-- create_user      : chenmo
-- task_name        : ads_srsv_finance_user_pay_d
-- task_version     : 3
-- update_time      : 2025-04-14 15:19:20
-- sql_path         : \starrocks\tbl_ads_srsv_finance_user_pay_ymd\ads_srsv_finance_user_pay_d
----------------------------------------------------------------
-- SQL语句
insert into ads.ads_srsv_finance_user_pay_d
with z1 as (
    select
        dt,
        'MoboReader（阅读）' as types,
        count(distinct id) as con_user
    from dim.dim_user_account_info_view
    where dt <= '${bf_1_dt}'
    group by 1,2
    union all
    select
        dt,
        'MoboReels（短剧）' as types,
        count(distinct user_id) as con_user
    from dim.dim_short_video_user_accountinfo
    where dt <= '${bf_1_dt}'
    group by 1,2
),
z2 as (
    select
        a1.dt,
        'MoboReader（阅读）' as types,
        count(a1.user_id) as user_cnt,
        count(a2.user_id) as user_cnt_1d,
        count(a3.user_id) as user_cnt_7d
    from (
        select
            dt, user_id
        from (
            select
                dt, user_id
            from ads.ads_report_trade_hkpayorder_detail_view
            where dt = '${bf_1_dt}'
            and test_flag = 0
            and order_status = 1
            and product_id in (3311, 3322, 3333, 3355, 3366, 3371, 3377, 3388, 3399, 3501, 3511, 7777, 8888)
            union all
            select
                dt,
                user_id
            from dwd.dwd_consume_user_consume
            where dt = '${bf_1_dt}'
            and types = 1
        ) a
        group by dt, user_id
    ) a1
    left join (
        -- 次留
        select
            dt, user_id
        from (
            select
                dt, user_id
            from ads.ads_report_trade_hkpayorder_detail_view
            where dt = '${bf_2_dt}'
            and test_flag = 0
            and order_status = 1
            and product_id in (3311, 3322, 3333, 3355, 3366, 3371, 3377, 3388, 3399, 3501, 3511, 7777, 8888)
            union all
            select
                dt,
                user_id
            from dwd.dwd_consume_user_consume
            where dt = '${bf_2_dt}'
            and types = 1
        ) a
        group by dt, user_id
    ) a2 on a1.user_id = a2.user_id
    left join (
        -- 7留
        select
            dt, user_id
        from (
            select
                dt, user_id
            from ads.ads_report_trade_hkpayorder_detail_view
            where dt = '${bf_7_dt}'
            and test_flag = 0
            and order_status = 1
            and product_id in (3311, 3322, 3333, 3355, 3366, 3371, 3377, 3388, 3399, 3501, 3511, 7777, 8888)
            union all
            select
                dt,
                user_id
            from dwd.dwd_consume_user_consume
            where dt = '${bf_7_dt}'
            and types = 1
        ) a
        group by dt, user_id
    ) a3 on a1.user_id = a3.user_id
    group by 1, 2
    union all
    select
        a1.dt,
        'MoboReels（短剧）' as types,
        count(a1.user_id) as user_cnt,
        count(a2.user_id) as user_cnt_1d,
        count(a3.user_id) as user_cnt_7d
    from (
        select
            dt, user_id
        from (
            select
                dt, user_id
            from ads.ads_report_trade_hkpayorder_detail_view
            where dt = '${bf_1_dt}'
            and test_flag = 0
            and order_status = 1
            and product_id in (6833)
            union all
            select
                dt,
                account_id
            from dwd.dwd_consume_short_video_consume_view
            where dt = '${bf_1_dt}'
            and consume_type = 0
        ) a
        group by dt, user_id
    ) a1
    left join (
        -- 次留
        select
            dt, user_id
        from (
            select
                dt, user_id
            from ads.ads_report_trade_hkpayorder_detail_view
            where dt = '${bf_2_dt}'
            and test_flag = 0
            and order_status = 1
            and product_id in (6833)
            union all
            select
                dt,
                account_id
            from dwd.dwd_consume_short_video_consume_view
            where dt = '${bf_2_dt}'
            and consume_type = 0
        ) a
        group by dt, user_id
    ) a2 on a1.user_id = a2.user_id
    left join (
        -- 7留
        select
            dt, user_id
        from (
            select
                dt, user_id
            from ads.ads_report_trade_hkpayorder_detail_view
            where dt = '${bf_7_dt}'
            and test_flag = 0
            and order_status = 1
            and product_id in (6833)
            union all
            select
                dt,
                account_id
            from dwd.dwd_consume_short_video_consume_view
            where dt = '${bf_7_dt}'
            and consume_type = 0
        ) a
        group by dt, user_id
    ) a3 on a1.user_id = a3.user_id
    group by 1, 2
)
select
    z1.dt,
    z1.types project_id,
    z2.user_cnt mau,
    z2.user_cnt_1d,
    z2.user_cnt_7d,
    z1.con_user user_num,
    sum(z1.con_user) over(partition by z1.types order by z1.dt) user_total,
    now() etl_time
from z1
left join z2
on z1.dt = z2.dt and z1.types = z2.types
order by dt desc
limit 2;
