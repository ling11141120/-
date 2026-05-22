----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_sv_consumption_series_ranking
-- workflow_version : 4
-- create_user      : chenmo
-- task_name        : ads_sv_consumption_series_ranking
-- task_version     : 2
-- update_time      : 2024-12-14 16:12:15
-- sql_path         : \starrocks\tbl_ads_sv_consumption_series_ranking\ads_sv_consumption_series_ranking
----------------------------------------------------------------
-- 前置SQL语句
delete from ads.ads_sv_consumption_series_ranking where dt = '${bf_1_dt}';

-- SQL语句
insert into ads.ads_sv_consumption_series_ranking
select
    '${bf_1_dt}' as dt,
    1 as days,
    series_id,
    row_number() over (order by sum(consume_value) desc, series_id) as rn,
    sum(consume_value) as consume_value,
now() as etl_time
from dwd.dwd_sv_consume_user_consume_bill_pdi
where dt <= '${bf_1_dt}' and  series_id is not null
group by series_id;

-- SQL语句
insert into ads.ads_sv_consumption_series_ranking
select
    '${bf_1_dt}' as dt,
    2 as days,
    series_id,
    row_number() over (order by sum(consume_value) desc, series_id) as rn,
    sum(consume_value) as consume_value,
now() as etl_time
from dwd.dwd_sv_consume_user_consume_bill_pdi
where dt = '${bf_1_dt}' and series_id is not null
group by series_id;

-- SQL语句
insert into ads.ads_sv_consumption_series_ranking
select
    '${bf_1_dt}' as dt,
    3 as days,
    series_id,
    row_number() over (order by sum(consume_value) desc, series_id) as rn,
    sum(consume_value) as consume_value,
now() as etl_time
from dwd.dwd_sv_consume_user_consume_bill_pdi
where dt >= date_sub('${bf_1_dt}', interval 2 day) and dt <= '${bf_1_dt}' and series_id is not null
group by series_id;

-- SQL语句
insert into ads.ads_sv_consumption_series_ranking
select
    '${bf_1_dt}' as dt,
    4 as days,
    series_id,
    row_number() over (order by sum(consume_value) desc, series_id) as rn,
    sum(consume_value) as consume_value,
now() as etl_time
from dwd.dwd_sv_consume_user_consume_bill_pdi
where dt >= date_sub('${bf_1_dt}', interval 6 day) and dt <= '${bf_1_dt}' and series_id is not null
group by series_id;

-- SQL语句
insert into ads.ads_sv_consumption_series_ranking
select
    '${bf_1_dt}' as dt,
    5 as days,
    series_id,
    row_number() over (order by sum(consume_value) desc, series_id) as rn,
    sum(consume_value) as consume_value,
now() as etl_time
from dwd.dwd_sv_consume_user_consume_bill_pdi
where dt >= date_sub('${bf_1_dt}', interval 14 day) and dt <= '${bf_1_dt}' and series_id is not null
group by series_id;

-- SQL语句
insert into ads.ads_sv_consumption_series_ranking
select
    '${bf_1_dt}' as dt,
    6 as days,
    series_id,
    row_number() over (order by sum(consume_value) desc, series_id) as rn,
    sum(consume_value) as consume_value,
now() as etl_time
from dwd.dwd_sv_consume_user_consume_bill_pdi
where dt >= date_sub('${bf_1_dt}', interval 29 day) and dt <= '${bf_1_dt}' and series_id is not null
group by series_id;
