----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : ads_sv_user_device2_fill
-- workflow_version : 4
-- create_user      : chenmo
-- task_name        : ads_sv_user_device2_fill
-- task_version     : 3
-- update_time      : 2025-09-10 18:03:07
-- sql_path         : \starrocks\ads_sv_user_device2_fill\ads_sv_user_device2_fill
----------------------------------------------------------------
-- SQL语句
insert into ads.ads_sv_user_device2_fill
select
    dt,
    AccountId,
    now() as etl_time
from (
    select
        a.dt,
        a.Id,
        a.CreateTime,
        a.AppId,
        a.BatchId,
        a.AccountId,
        a.DeviceId,
        a.Token,
        b.device2,
        max(b.device2) over (partition by a.AccountId) as max_device2
    from ods.ods_tidb_unifypush_log_log_pushlog_sv a
    left join dim.dim_short_video_account_device_info b
    on a.AccountId = b.user_id and a.Token = b.device_token
    where a.dt = '${bf_1_dt}' and a.AccountId is not null
) a
where max_device2 is null
group by dt, AccountId;
