----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_sr_user_element_exposure_info
-- workflow_version : 11
-- create_user      : chenmo
-- task_name        : ads_sr_user_element_exposure_payorder_info
-- task_version     : 9
-- update_time      : 2025-04-01 17:43:57
-- sql_path         : \starrocks\tbl_ads_sr_user_element_exposure_info\ads_sr_user_element_exposure_payorder_info
----------------------------------------------------------------
-- SQL语句
insert into ads.ads_sr_user_element_exposure_payorder_info
select dt,
       product_id,
       user_id,
       order_id,
       subpay_type,
       next_subpay_type,
       corever,
       mt,
       subscribe_status,
       package_id,
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
        a.package_id,
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
            package_id,
            create_time
        from (
            select
                dt,
                ProductId as product_id,
                UserId as user_id,
                OrderId as order_id,
                SubPayType as subpay_type,
                lead(SubPayType) over (partition by ProductId, UserId order by CreateTime) as next_subpay_type,
    --             corever,
                mt,
                get_json_int(CooOrderExtInfo, '$.SubscribeStatus') as subscribe_status,
                PackageId as package_id,
                CreateTime as create_time
            from dwd.dwd_trade_user_payorder
            where ProductId != 6833 and ShopItem = 0 and TestFlag = 0
        ) a where dt = '${bf_1_dt}'
    ) a
    left join dim.dim_user_account_info_view b
    on a.product_id = b.product_id and a.user_id = b.id
    left join (
        select
            dt,
            product_id,
            user_id,
            reg_days
        from dws.dws_user_wide_active_period_ed
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
        from ads.ads_sr_user_element_exposure_info
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
        from ads.ads_sr_user_element_exposure_info
        where dt >= '${bf_4_dt}' and dt <= '${dt}' and zffs_rank <= 3
        group by dt, product_id, id, user_id, sfzf_strategy_id, event_tm
    ) e on a.dt = e.dt and a.product_id = e.product_id and a.user_id = e.user_id and a.create_time < e.event_tm
) a where d_rn = 1 and e_rn = 1;
