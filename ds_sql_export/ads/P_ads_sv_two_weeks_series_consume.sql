----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_sv_two_weeks_series_consume
-- workflow_version : 8
-- create_user      : chenmo
-- task_name        : ads_sv_two_weeks_series_consume
-- task_version     : 7
-- update_time      : 2024-12-23 10:03:11
-- sql_path         : \starrocks\tbl_ads_sv_two_weeks_series_consume\ads_sv_two_weeks_series_consume
----------------------------------------------------------------
-- 前置SQL语句
delete from ads.ads_sv_two_weeks_series_consume where dt = '${bf_1_dt}';

-- SQL语句
insert into ads.ads_sv_two_weeks_series_consume
select
    '${bf_1_dt}' as dt,
    a.series_id,
    c.language,
    d.corever,
    sum(a.consume_value) as price,
    row_number() over (partition by language,corever order by sum(a.consume_value) desc) as sort,
    now() as etl_time
from (
    select
        series_id,
        consume_value,
        account_id
    from dwd.dwd_sv_consume_user_consume_bill_pdi
    where date_sub(create_time, interval 13 hour) >= date_sub('${dt}', interval 14 day) and date_sub(create_time, interval 13 hour) < '${dt}'
    and series_id is not null
) a
left join dim.dim_short_video_series_view c on a.series_id = c.series_id
left join dim.dim_short_video_user_accountinfo d on a.account_id = d.user_id
where d.corever is not null
group by a.series_id, c.language, d.corever;
