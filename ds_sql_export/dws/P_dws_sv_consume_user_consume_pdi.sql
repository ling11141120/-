----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dws_sv_consume_user_consume_pdi
-- workflow_version : 3
-- create_user      : linq
-- task_name        : dws_sv_consume_user_consume_pdi
-- task_version     : 3
-- update_time      : 2024-10-16 15:26:04
-- sql_path         : \starrocks\tbl_dws_sv_consume_user_consume_pdi\dws_sv_consume_user_consume_pdi
----------------------------------------------------------------
-- 前置SQL语句
delete from dws.dws_sv_consume_user_consume_pdi where dt>='${bf_3_dt}' and dt<='${dt}';

-- SQL语句
insert into dws.dws_sv_consume_user_consume_pdi
select a.dt,
       6833 as product_id,
       a.consume_type as types,
       a.consume_type2 as consume_type2,
       a.account_id as user_id,
       ifnull(a.epis_id,-99) as epis_id,
       b.corever,
       b.Current_Language,
       b.Current_Language2,
       b.mt,
       b.reg_country,
       b.create_time as reg_time,
       datediff(a.dt,b.create_time) as reg_days,
       b.sex,
       b.chl,
       b.chl2,
       b.ad_series_id,
       sum(consume_value) consume_amt,
       count(distinct a.id)  consume_cnt,
       min(a.create_time) as fst_consume_tm,
       max(a.create_time) as lst_consume_tm,
       now() as etl_time
from dwd.dwd_sv_consume_user_consume_bill_pdi a
left join dim.dim_short_video_user_accountinfo b on a.account_id=b.user_id
where a.dt>='${bf_3_dt}' and a.dt<='${dt}'
group by 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17;
