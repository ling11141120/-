----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dim_short_read_user_accountinfo_daily
-- workflow_version : 7
-- create_user      : chenmo
-- task_name        : dim_short_read_user_accountinfo_zip
-- task_version     : 5
-- update_time      : 2025-04-15 14:36:02
-- sql_path         : \starrocks\tbl_dim_short_read_user_accountinfo_daily\dim_short_read_user_accountinfo_zip
----------------------------------------------------------------
-- SQL语句
-- 拉链更新
insert into dim.dim_short_read_user_accountinfo_zip
with user_info as (
    select
        product_id,
        user_id,
        start_dt,
        end_dt,
        mt,
        corever,
        app_ver,
        current_language,
        app_id,
        app_notify,
		dynamic_island_switch
    from dim.dim_short_read_user_accountinfo_zip
    where end_dt = '9999-12-31'
    union all
    select
        a.product_id,
        a.id,
        '${bf_1_dt}' as start_dt,
        '9999-12-31' as end_dt,
        a.mt,
        a.corever,
        a.appver,
        a.current_language,
        a.app_id,
        b.PushSwitch,
		b.DynamicIslandSwitch as dynamic_island_switch
    from dim.dim_user_account_info_view a
    left join ods.ods_tidb_readernovel_tidb_xx_userotherinfo b
    on a.product_id = b.productid and a.id = b.Id
    where a.row_update_timestamp >= '${bf_1_dt}' or b.row_update_time >= '${bf_1_dt}'
)
select
    product_id,
    user_id,
    start_dt,
    if(rn = 2, '${bf_2_dt}', '9999-12-31') as end_dt,
    mt,
    corever,
    app_ver,
    current_language,
    app_id,
    app_notify,
	dynamic_island_switch,
    now() as etl_time
from (
    select
        *,
        row_number() over (partition by product_id, user_id order by start_dt desc) as rn
    from (
        select
            product_id,
            user_id,
            mt,
            corever,
            app_ver,
            current_language,
            app_id,
            app_notify,
			dynamic_island_switch,
            min(start_dt) as start_dt,
            max(end_dt) as end_dt
        from user_info
        group by product_id, user_id, mt, corever, app_ver, current_language, app_id, app_notify,dynamic_island_switch
    ) ui
) ui;
