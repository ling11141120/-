----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_sv_user_element_exposure_info
-- workflow_version : 12
-- create_user      : chenmo
-- task_name        : ads_sv_user_element_exposure_payorder_info
-- task_version     : 12
-- update_time      : 2025-10-28 14:17:34
-- sql_path         : \starrocks\tbl_ads_sv_user_element_exposure_info\ads_sv_user_element_exposure_payorder_info
----------------------------------------------------------------
-- SQL语句
insert into ads.ads_sv_user_element_exposure_payorder_info
select dt,
       product_id,
       user_id,
       order_id,
       subpay_type,
       next_subpay_type,
       corever,
       mt,
       subscribe_status,
       send_id,
       reg_country,
       user_type,
       current_language2,
       sfzf_strategy_id,
       zffs_list,
       next_zffs_list,
       create_time,
       now() as etl_time
from (
    select
        a.dt,
        a.product_id,
        a.user_id,
        a.order_id,
        a.subpay_type,
        a.next_subpay_type, -- 上次支付方式
        b.corever,
        a.mt,
        a.subscribe_status,
        a.send_id,
        b.reg_country,
        case when c.reg_days = 0 then 'D0'
           when c.reg_days >= 1 and reg_days <= 3 then 'D1-D3'
           when c.reg_days >= 4 then 'D3+'
        end as user_type,
        b.current_language2,
        d.sfzf_strategy_id,
        d.zffs_list,
        d.event_tm,
        rank() over (partition by a.dt, a.user_id, a.order_id order by d.event_tm desc) as d_rn,
        e.zffs_list as next_zffs_list,
        e.event_tm as next_event_tm,
        row_number() over (partition by a.dt, a.user_id, a.order_id order by e.event_tm) as e_rn,
        a.create_time
    from (
        select
            dt,
            product_id,
            user_id,
            order_id,
            subpay_type,
            next_subpay_type,
            mt,
            subscribe_status,
            send_id,
            create_time
        from (
            select
                dt,
                product_id,
                user_id,
                order_id,
                subpay_type,
                lead(subpay_type) over (partition by product_id, user_id order by create_time) as next_subpay_type,
    --             corever,
                mt,
                get_json_int(cooorder_extinfo, '$.SubscribeStatus') as subscribe_status,
                get_json_string(custom_data, '$.sendId') as send_id,
                create_time
            from dwd.dwd_trade_short_video_payorder
            where product_id = 6833 and status = 0 and test_flag = 0
        ) a where dt = '${bf_1_dt}'
    ) a
    left join dim.dim_short_video_user_accountinfo b
    on a.product_id = b.product_id and a.user_id = b.user_id
    left join (
        select
            dt,
            product_id,
            user_id,
            reg_days
        from dws.dws_user_short_video_wide_active_period_ed
        where dt = '${bf_1_dt}' and period_type = 'ctt'
    ) c on a.dt = c.dt and a.product_id = c.product_id and a.user_id = c.user_id
    left join (
        select
            dt,
            product_id,
            id,
            user_id,
            sfzf_strategy_id,
            event_tm,
            group_concat(zffs order by zffs_rank) as zffs_list
        from ads.ads_sv_user_element_exposure_info
        where dt >= '${bf_4_dt}' and dt <= '${dt}' and zffs_rank <= 3
        group by dt, product_id, id, user_id, sfzf_strategy_id, event_tm
    ) d on a.dt = d.dt and a.product_id = d.product_id and a.user_id = d.user_id and a.create_time >= d.event_tm
    left join (
        select
            dt,
            product_id,
            id,
            user_id,
            sfzf_strategy_id,
            event_tm,
            group_concat(zffs order by zffs_rank) as zffs_list
        from ads.ads_sv_user_element_exposure_info
        where dt >= '${bf_4_dt}' and dt <= '${dt}' and zffs_rank <= 3
        group by dt, product_id, id, user_id, sfzf_strategy_id, event_tm
    ) e on a.dt = e.dt and a.product_id = e.product_id and a.user_id = e.user_id and a.create_time < e.event_tm
) a where d_rn = 1 and e_rn = 1;
