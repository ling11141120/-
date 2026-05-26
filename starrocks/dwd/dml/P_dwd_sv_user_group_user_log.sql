----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dwd_sv_user_group_user_log
-- workflow_version : 5
-- create_user      : chenmo
-- task_name        : dwd_sv_user_group_user_log
-- task_version     : 5
-- update_time      : 2025-01-13 18:18:06
-- sql_path         : \starrocks\tbl_dwd_sv_user_group_user_log\dwd_sv_user_group_user_log
----------------------------------------------------------------
-- SQL语句
insert into dwd.dwd_sv_user_group_user_log
with group_user_log as (
    select
        group_id,
        account,
        create_time,
        type,
        lag(type, 1, 2) over (PARTITION BY group_id, account ORDER BY create_time, type) as lag_type
    from (
        select
            group_id,
            account,
            create_time,
            type
        from dwd.dwd_user_short_video_group_user_log_view
        where dt = '${bf_1_dt}'
        union all
        select
            group_id,
            user_id,
            start_time,
            1
        from dwd.dwd_sv_user_group_user_log
        where end_time = '2099-12-31'
    ) t1
),
b as (
    select
        group_id,
        account,
        create_time,
        type,
        ROW_NUMBER() OVER (PARTITION BY group_id, account, type ORDER BY create_time) as rn
    from group_user_log
    where type != lag_type
)
select
    l1.group_id,
    l1.account as user_id,
    l1.create_time as start_time,
    ifnull(l2.create_time, '2099-12-31') as end_time,
    now() as etl_tm
from (
    select * from b where type = 1
) l1
left join (
    select * from b where type = 2
) l2
on l1.group_id = l2.group_id and l1.account = l2.account and l1.rn = l2.rn;
