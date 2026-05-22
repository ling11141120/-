----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_sv_popular_series_ranking
-- workflow_version : 6
-- create_user      : chenmo
-- task_name        : ads_sv_popular_series_ranking
-- task_version     : 3
-- update_time      : 2024-12-14 16:12:32
-- sql_path         : \starrocks\tbl_ads_sv_popular_series_ranking\ads_sv_popular_series_ranking
----------------------------------------------------------------
-- 前置SQL语句
delete from ads.ads_sv_popular_series_ranking where dt = '${bf_1_dt}';

-- SQL语句
insert into ads.ads_sv_popular_series_ranking
select
    '${bf_1_dt}' as dt,
    1 as days,
    series_id,
    row_number() over (order by count(distinct account_id) desc, series_id) as rn,
    count(distinct account_id) as uv,
    now() as etl_time
from dwd.dwd_video_short_video_epis_history
where dt <= '${bf_1_dt}' and watch_stamp != 0
group by series_id;

-- SQL语句
insert into ads.ads_sv_popular_series_ranking
select
    '${bf_1_dt}' as dt,
    2 as days,
    series_id,
    row_number() over (order by count(distinct account_id) desc, series_id) as rn,
    count(distinct account_id) as uv,
    now() as etl_time
from dwd.dwd_video_short_video_epis_history
where dt = '${bf_1_dt}' and watch_stamp != 0
group by series_id;

-- SQL语句
insert into ads.ads_sv_popular_series_ranking
select
    '${bf_1_dt}' as dt,
    3 as days,
    series_id,
    row_number() over (order by count(distinct account_id) desc, series_id) as rn,
    count(distinct account_id) as uv,
    now() as etl_time
from dwd.dwd_video_short_video_epis_history
where dt >= date_sub('${bf_1_dt}', interval 2 day) and dt <= '${bf_1_dt}' and watch_stamp != 0
group by series_id;

-- SQL语句
insert into ads.ads_sv_popular_series_ranking
select
    '${bf_1_dt}' as dt,
    4 as days,
    series_id,
    row_number() over (order by count(distinct account_id) desc, series_id) as rn,
    count(distinct account_id) as uv,
    now() as etl_time
from dwd.dwd_video_short_video_epis_history
where dt >= date_sub('${bf_1_dt}', interval 6 day) and dt <= '${bf_1_dt}' and watch_stamp != 0
group by series_id;

-- SQL语句
insert into ads.ads_sv_popular_series_ranking
select
    '${bf_1_dt}' as dt,
    5 as days,
    series_id,
    row_number() over (order by count(distinct account_id) desc, series_id) as rn,
    count(distinct account_id) as uv,
    now() as etl_time
from dwd.dwd_video_short_video_epis_history
where dt >= date_sub('${bf_1_dt}', interval 14 day) and dt <= '${bf_1_dt}' and watch_stamp != 0
group by series_id;

-- SQL语句
insert into ads.ads_sv_popular_series_ranking
select
    '${bf_1_dt}' as dt,
    6 as days,
    series_id,
    row_number() over (order by count(distinct account_id) desc, series_id) as rn,
    count(distinct account_id) as uv,
    now() as etl_time
from dwd.dwd_video_short_video_epis_history
where dt >= date_sub('${bf_1_dt}', interval 29 day) and dt <= '${bf_1_dt}' and watch_stamp != 0
group by series_id;
