----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_sr_user_element_exposure_info
-- workflow_version : 11
-- create_user      : chenmo
-- task_name        : ads_sr_user_element_exposure_info
-- task_version     : 5
-- update_time      : 2025-04-08 16:23:10
-- sql_path         : \starrocks\tbl_ads_sr_user_element_exposure_info\ads_sr_user_element_exposure_info
----------------------------------------------------------------
-- SQL语句
insert into ads.ads_sr_user_element_exposure_info
select
    a.dt,
    a.app_product_id,
    a.id,
    a.zffs_rank,
    a.login_id,
    a.zffs,
    a.event_strategy_id,
    a.event_tm,
    b.current_language2,
    b.corever,
    case when c.reg_days = 0 then 'D0'
        when c.reg_days >= 1 and reg_days <= 3 then 'D1-D3'
        when c.reg_days >= 4 then 'D3+'
    end as user_type,
    b.mt,
    b.reg_country,
    now() as etl_time
from (
    select
        a.dt,
        a.app_product_id,
        a.id,
        a.login_id,
        a.zffs_array[generate_series] as zffs,
        a.event_strategy_id,
        generate_series as zffs_rank,
        a.event_tm
    from (
        select
            dt,
            app_product_id,
            id,
            login_id,
            ifnull(round(event_strategy_id, 0), '') as event_strategy_id,
            split(click_content, ',') as zffs_array,
            array_length(split(click_content, ',')) as zffs_length,
            event_tm
        from ads.ads_sensors_production_element_expose_view
        where dt = '${bf_1_dt}' and app_product_id != 6833 and element_id = 100608 and click_content is not null and login_id is not null
    ) a
    cross join generate_series(1, zffs_length)
) a
left join dim.dim_user_account_info_view b
on a.app_product_id = b.product_id and a.login_id = b.Id
left join (
    select
        dt,
        product_id,
        user_id,
        reg_days
    from dws.dws_user_wide_active_period_ed
    where dt = '${bf_1_dt}' and period_type = 'ctt'
) c on a.dt = c.dt and a.app_product_id = c.product_id and a.login_id = c.user_id;
