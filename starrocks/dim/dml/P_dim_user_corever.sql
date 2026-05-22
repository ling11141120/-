----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dim_user_corever
-- workflow_version : 4
-- create_user      : chenmo
-- task_name        : dim_user_corever
-- task_version     : 4
-- update_time      : 2024-12-28 17:45:16
-- sql_path         : \starrocks\tbl_dim_user_corever\dim_user_corever
----------------------------------------------------------------
-- SQL语句
insert into dim.dim_user_corever
select
    a.user_id,
    a.corever,
    a.create_time,
    a.update_time,
    now() as etl_time
from (
    select
        user_id,
        corever,
        create_time,
        now() as update_time
    from dim.dim_short_video_user_accountinfo
    where product_id = 6833
) a
left join (
    select
        user_id,
        core,
        create_time,
        update_time
    from (
        select
            user_id,
            core,
            create_time,
            update_time,
            row_number() over (partition by user_id order by update_time desc) as rn
        from dim.dim_user_corever
    ) t where rn = 1
) b on a.user_id = b.user_id
where a.corever != ifnull(b.core, -99);
