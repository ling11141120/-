----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dws_consume_short_video_consume_ed
-- workflow_version : 12
-- create_user      : linq
-- task_name        : dws_consume_short_video_consume_ed
-- task_version     : 10
-- update_time      : 2024-11-29 14:04:41
-- sql_path         : \starrocks\tbl_dws_consume_short_video_consume_ed\dws_consume_short_video_consume_ed
----------------------------------------------------------------
-- 前置SQL语句
delete from dws.dws_consume_short_video_consume_ed where dt>='${bf_3_dt}' and dt<='${dt}';

-- SQL语句
insert into dws.dws_consume_short_video_consume_ed
select a.dt,
       6833 as product_id,
       a.consume_type as types,
       a.account_id as user_id,
       ifnull(a.epis_id,-99) as epis_id,
       b.corever,
       b.Current_Language,
       b.Current_Language2,
       b.mt,
       b.reg_country,
       b.create_time as reg_time,
       b.sex,
       sum(consume_value) consume_amt,
       count(distinct a.id)  consume_cnt,
       now() as etl_time
from dwd.dwd_sv_consume_user_consume_bill_pdi a
left join dim.dim_short_video_user_accountinfo b on a.account_id=b.user_id
where a.dt>='${bf_3_dt}' and a.dt<='${dt}'
group by 1,2,3,4,5,6,7,8,9,10,11,12;
