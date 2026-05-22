----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dim_short_read_user_accountinfo_daily
-- workflow_version : 7
-- create_user      : chenmo
-- task_name        : dim_short_read_user_accountinfo_daily
-- task_version     : 2
-- update_time      : 2025-02-19 15:02:59
-- sql_path         : \starrocks\tbl_dim_short_read_user_accountinfo_daily\dim_short_read_user_accountinfo_daily
----------------------------------------------------------------
-- SQL语句
insert into dim.dim_short_read_user_accountinfo_daily
select
    '${dt}' as dt,
    productid,
    Id,
    PushSwitch,
    now() as update_time
from ods.ods_tidb_readernovel_tidb_xx_userotherinfo;
