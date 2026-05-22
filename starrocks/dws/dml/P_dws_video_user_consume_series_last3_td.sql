----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dws_video_user_consume_series_last3_td
-- workflow_version : 6
-- create_user      : chenmo
-- task_name        : dws_video_user_consume_series_last3_td
-- task_version     : 6
-- update_time      : 2025-01-17 17:15:02
-- sql_path         : \starrocks\tbl_dws_video_user_consume_series_last3_td\dws_video_user_consume_series_last3_td
----------------------------------------------------------------
-- 前置SQL语句
delete from dws.`dws_video_user_consume_series_last3_td` where dt = '${dt}';

-- SQL语句
insert into dws.`dws_video_user_consume_series_last3_td`
with a as (
    select
        series_id,
        user_id,
        sum(consume_value) as consume_value,
        max(remaining_epis) as remaining_epis,
        max(create_time) as create_time
    from (
        select
            b.series_id,
            a.account_id as user_id,
            a.consume_value,
            999 as remaining_epis,
            a.create_time
        from dwd.dwd_consume_short_video_consume_view a
        left join dim.dim_short_video_epis_view b on a.epis_id = b.epis_id
        where a.dt='${dt}'
        and a.epis_id != 0
        and b.series_id is not null
        union all
        select
            series_id,
            user_id,
            consume_value,
            remaining_epis,
            create_time
        from dws.dws_video_user_consume_series_last3_td
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
    consume_value,
    remaining_epis,
    create_time,
    now() as etl_time
from (
    select
        a.user_id,
        a.series_id,
        a.consume_value,
        a.create_time,
        least(b.last_epis-ifnull(c.epis_num, 0), a.remaining_epis) as remaining_epis,
        c.epis_num,
        row_number() over (partition by a.user_id order by a.consume_value desc, a.create_time desc, a.series_id) as last_rn
    from a
    left join dim.dim_short_video_series_view b on a.series_id = b.series_id
    left join (
        select
            accountid,
            seriesid,
            max(episnum) as epis_num
        from ods.ods_tidb_short_video_log_ext_epis_history_part2
        where dt>='${bf_1_dt}'
        group by accountid, seriesid
    ) c on a.user_id = c.accountid and a.series_id = c.seriesid
    where b.series_id is not null
) t;
