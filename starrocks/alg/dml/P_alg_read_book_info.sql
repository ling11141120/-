----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_alg_read_book_info
-- workflow_version : 18
-- create_user      : yanxh
-- task_name        : alg_read_book_info
-- task_version     : 9
-- update_time      : 2024-10-16 15:25:50
-- sql_path         : \starrocks\tbl_alg_read_book_info\alg_read_book_info
----------------------------------------------------------------
-- 前置SQL语句
delete from alg.alg_read_book_info where dt = '${bf_1_dt}';

-- SQL语句
insert into alg.alg_read_book_info
select
'${bf_1_dt}' as dt,
 book_id
,count(DISTINCT user_id) as con_user_read
,0 as con_aduser_read
,0 as con_notaduser_read

,count(DISTINCT case when con_read_chap>0 and con_read_chap<=15 then  user_id end) as con_user_read_a
,count(DISTINCT case when con_read_chap>15 and con_read_chap<=50 then  user_id end) as con_user_read_b
,count(DISTINCT case when con_read_chap>50  then  user_id end) as con_user_read_c

,0 as con_aduser_read_a
,0 as con_aduser_read_b
,0 as con_aduser_read_c

,0 as con_notaduser_read_a
,0 as con_notaduser_read_b
,0 as con_notaduser_read_c

,0 as con_aduser_read_01
,count(DISTINCT case when con_read_chap_01>0 then user_id end) as con_notaduser_read_01

,0 as con_aduser_read_07
,count(DISTINCT case when con_read_chap_07>0 then user_id end) as con_notaduser_read_07

,0 as con_aduser_read_15
,count(DISTINCT case when  con_read_chap_15>0 then user_id end) as con_notaduser_read_15

,sum(con_read_chap_01) as con_read_chap_01
,sum(con_read_chap_07) as con_read_chap_07
,sum(con_read_chap_15) as con_read_chap_15
,sum(con_read_chap) as con_read_chap

,0 as con_adread_chap_01
,0 as con_adread_chap_07
,0 as con_adread_chap_15
,0 as con_adread_chap

,0 as con_notadread_chap_01
,0 as con_notadread_chap_07
,0 as con_notadread_chap_15
,0 as con_notadread_chap
,now() as etl_time
from
    dws.dws_read_user_chapters_mid  x
    where dt='${bf_1_dt}'
    group by 1 ,2
;
