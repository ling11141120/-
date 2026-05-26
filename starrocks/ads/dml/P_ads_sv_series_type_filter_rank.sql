----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_sv_series_type_filter_rank
-- workflow_version : 5
-- create_user      : chenmo
-- task_name        : ads_sv_series_type_filter_rank
-- task_version     : 4
-- update_time      : 2025-07-16 14:31:02
-- sql_path         : \starrocks\tbl_ads_sv_series_type_filter_rank\ads_sv_series_type_filter_rank
----------------------------------------------------------------
-- SQL语句
insert into ads.ads_sv_series_type_filter_rank
select
    '${bf_1_dt}' as dt,
    id,
    name,
    sum(consume_value) as consume_value,
    now() as etl_time
from (
    select
        c.id,
        c.name,
        a.series_id,
        a.consume_value/count(1) over (partition by a.series_id) as consume_value
    from (
        select
            series_id,
            sum(consume_value) as consume_value
        from dwd.dwd_sv_consume_user_consume_bill_pdi
        where dt >= date_sub('${bf_1_dt}', interval 30 day) and dt <= '${bf_1_dt}'
        and consume_type = 0 and epis_id != 0 and series_id is not null
        group by series_id
    ) a
    join dim.dim_short_video_series_ref_type_view b
    on a.series_id = b.series_id
    join dim.dim_short_video_series_type_view c
    on b.series_type_id = c.id
) a
group by 1, 2, 3;
