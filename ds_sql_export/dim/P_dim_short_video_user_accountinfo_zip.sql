----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dim_short_video_user_accountinfo_daily
-- workflow_version : 5
-- create_user      : chenmo
-- task_name        : dim_short_video_user_accountinfo_zip
-- task_version     : 1
-- update_time      : 2025-03-17 20:27:10
-- sql_path         : \starrocks\tbl_dim_short_video_user_accountinfo_daily\dim_short_video_user_accountinfo_zip
----------------------------------------------------------------
-- SQL语句
-- 拉链更新
insert into dim.dim_short_video_user_accountinfo_zip
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
        app_notify
    from dim.dim_short_video_user_accountinfo_zip
    where end_dt = '9999-12-31'
    union all
    select
        product_id,
        user_id,
        '${bf_1_dt}' as start_dt,
        '9999-12-31' as end_dt,
        mt,
        corever,
        app_ver,
        current_language,
        app_id,
        app_notify
    from dim.dim_short_video_user_accountinfo
    where row_update_time >= '${bf_1_dt}'
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
            min(start_dt) as start_dt,
            max(end_dt) as end_dt
        from user_info
        group by product_id, user_id, mt, corever, app_ver, current_language, app_id, app_notify
    ) ui
) ui;
