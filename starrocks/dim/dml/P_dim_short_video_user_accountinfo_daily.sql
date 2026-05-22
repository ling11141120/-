----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dim_short_video_user_accountinfo_daily
-- workflow_version : 5
-- create_user      : chenmo
-- task_name        : dim_short_video_user_accountinfo_daily
-- task_version     : 1
-- update_time      : 2025-02-21 09:49:53
-- sql_path         : \starrocks\tbl_dim_short_video_user_accountinfo_daily\dim_short_video_user_accountinfo_daily
----------------------------------------------------------------
-- SQL语句
insert into dim.dim_short_video_user_accountinfo_daily
select
    '${dt}' as dt,
    product_id,
    user_id,
    app_notify,
    now() as update_time
from dim.dim_short_video_user_accountinfo;
