----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dws_video_user_unlock_series_last3_td
-- workflow_version : 5
-- create_user      : chenmo
-- task_name        : dws_video_user_unlock_series_last3_td
-- task_version     : 4
-- update_time      : 2025-01-21 11:40:59
-- sql_path         : \starrocks\tbl_dws_video_user_unlock_series_last3_td\dws_video_user_unlock_series_last3_td
----------------------------------------------------------------
-- 前置SQL语句
delete from dws.`dws_video_user_unlock_series_last3_td` where dt = '${dt}';

-- SQL语句
insert into dws.`dws_video_user_unlock_series_last3_td`
with a as (
    select
        series_id,
        user_id,
        sum(unlock_value) as unlock_value,
        max(remaining_epis) as remaining_epis,
        max(create_time) as create_time
    from (
        select
            series_id,
            account_id as user_id,
            1 as unlock_value,
            0 as remaining_epis,
            create_time
        from dwd.dwd_short_video_series_unlock_view
        where date(create_time)='${dt}'
        and epis_id != 0
        union all
        select
            series_id,
            user_id,
            unlock_value,
            remaining_epis,
            create_time
        from dws.dws_video_user_unlock_series_last3_td
        where dt = '${bf_1_dt}'
    ) t
    group by series_id, user_id
)
select
    '${dt}' as dt,
    6833 as product_id,
    user_id,
    last_rn,
    series_id,
    unlock_value,
    remaining_epis,
    create_time,
    now() as etl_time
from (
    select
        a.user_id,
        a.series_id,
        a.unlock_value,
        a.create_time,
        least(b.last_epis-ifnull(c.epis_num, 0), a.remaining_epis) as remaining_epis,
        c.epis_num,
        row_number() over (partition by a.user_id order by a.unlock_value desc, a.create_time desc, a.series_id) as last_rn
    from a
    left join dim.dim_short_video_series_view b on a.series_id = b.series_id
    left join (
        select
            accountid,
            seriesid,
            max(episnum) as epis_num
        from ods.ods_tidb_short_video_log_ext_epis_history_part2
        group by accountid, seriesid
    ) c on a.user_id = c.accountid and a.series_id = c.seriesid
    where b.series_id is not null
) t;
