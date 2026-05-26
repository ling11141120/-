----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_sv_new_series_ranking
-- workflow_version : 5
-- create_user      : chenmo
-- task_name        : ads_sv_new_series_ranking
-- task_version     : 3
-- update_time      : 2024-12-14 16:12:47
-- sql_path         : \starrocks\tbl_ads_sv_new_series_ranking\ads_sv_new_series_ranking
----------------------------------------------------------------
-- 前置SQL语句
delete from ads.ads_sv_new_series_ranking where dt = '${bf_1_dt}';

-- SQL语句
insert into ads.ads_sv_new_series_ranking
select
    '${bf_1_dt}' as dt,
    1 as days,
    a.series_id,
    b.publish_edat,
    row_number() over (order by b.publish_edat desc, a.series_id) as rn,
    sum(a.consume_value) as consume_value,
now() as etl_time
from dwd.dwd_sv_consume_user_consume_bill_pdi a
left join dim.dim_short_video_series_view b
on a.series_id = b.series_id
where dt <= '${bf_1_dt}' and a.series_id is not null and b.publish_status = 1 and b.last_epis != 0
group by a.series_id, b.publish_edat;

-- SQL语句
insert into ads.ads_sv_new_series_ranking
select
    '${bf_1_dt}' as dt,
    2 as days,
    a.series_id,
    b.publish_edat,
    row_number() over (order by b.publish_edat desc, a.series_id) as rn,
    sum(a.consume_value) as consume_value,
now() as etl_time
from dwd.dwd_sv_consume_user_consume_bill_pdi a
left join dim.dim_short_video_series_view b
on a.series_id = b.series_id
where dt = '${bf_1_dt}' and a.series_id is not null and b.publish_status = 1 and b.last_epis != 0
group by a.series_id, b.publish_edat;

-- SQL语句
insert into ads.ads_sv_new_series_ranking
select
    '${bf_1_dt}' as dt,
    3 as days,
    a.series_id,
    b.publish_edat,
    row_number() over (order by b.publish_edat desc, a.series_id) as rn,
    sum(a.consume_value) as consume_value,
now() as etl_time
from dwd.dwd_sv_consume_user_consume_bill_pdi a
left join dim.dim_short_video_series_view b
on a.series_id = b.series_id
where dt >= date_sub('${bf_1_dt}', interval 2 day) and dt <= '${bf_1_dt}' and a.series_id is not null and b.publish_status = 1 and b.last_epis != 0
group by a.series_id, b.publish_edat;

-- SQL语句
insert into ads.ads_sv_new_series_ranking
select
    '${bf_1_dt}' as dt,
    4 as days,
    a.series_id,
    b.publish_edat,
    row_number() over (order by b.publish_edat desc, a.series_id) as rn,
    sum(a.consume_value) as consume_value,
now() as etl_time
from dwd.dwd_sv_consume_user_consume_bill_pdi a
left join dim.dim_short_video_series_view b
on a.series_id = b.series_id
where dt >= date_sub('${bf_1_dt}', interval 6 day) and dt <= '${bf_1_dt}' and a.series_id is not null and b.publish_status = 1 and b.last_epis != 0
group by a.series_id, b.publish_edat;

-- SQL语句
insert into ads.ads_sv_new_series_ranking
select
    '${bf_1_dt}' as dt,
    5 as days,
    a.series_id,
    b.publish_edat,
    row_number() over (order by b.publish_edat desc, a.series_id) as rn,
    sum(a.consume_value) as consume_value,
now() as etl_time
from dwd.dwd_sv_consume_user_consume_bill_pdi a
left join dim.dim_short_video_series_view b
on a.series_id = b.series_id
where dt >= date_sub('${bf_1_dt}', interval 14 day) and dt <= '${bf_1_dt}' and a.series_id is not null and b.publish_status = 1 and b.last_epis != 0
group by a.series_id, b.publish_edat;

-- SQL语句
insert into ads.ads_sv_new_series_ranking
select
    '${bf_1_dt}' as dt,
    6 as days,
    a.series_id,
    b.publish_edat,
    row_number() over (order by b.publish_edat desc, a.series_id) as rn,
    sum(a.consume_value) as consume_value,
now() as etl_time
from dwd.dwd_sv_consume_user_consume_bill_pdi a
left join dim.dim_short_video_series_view b
on a.series_id = b.series_id
where dt >= date_sub('${bf_1_dt}', interval 29 day) and dt <= '${bf_1_dt}' and a.series_id is not null and b.publish_status = 1 and b.last_epis != 0
group by a.series_id, b.publish_edat;
