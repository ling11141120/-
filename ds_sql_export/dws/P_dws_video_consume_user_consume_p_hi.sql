----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dws_video_consume_user_consume_p_hi
-- workflow_version : 3
-- create_user      : xixg
-- task_name        : dws_video_consume_user_consume_p_hi
-- task_version     : 3
-- update_time      : 2024-10-16 15:48:17
-- sql_path         : \starrocks\tbl_dws_video_consume_user_consume_p_hi\dws_video_consume_user_consume_p_hi
----------------------------------------------------------------
-- SQL语句
insert into dws.dws_video_consume_user_consume_p_hi
select DATE_FORMAT (a.create_time, '%Y-%m-%d %H'),
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
left join dim.dim_short_video_user_accountinfo b
on a.account_id=b.user_id
where a.dt>='${bf_3_dt}' and a.dt<='${dt}'
group by 1,2,3,4,5,6,7,8,9,10,11,12;
