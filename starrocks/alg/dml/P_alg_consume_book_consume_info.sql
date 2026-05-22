----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_alg_consume_book_consume_info
-- workflow_version : 3
-- create_user      : yanxh
-- task_name        : alg_consume_book_consume_info
-- task_version     : 2
-- update_time      : 2023-10-27 14:10:43
-- sql_path         : \starrocks\tbl_alg_consume_book_consume_info\alg_consume_book_consume_info
----------------------------------------------------------------
-- SQL语句
insert overwrite alg.alg_consume_book_consume_info partition(p'${pname}')
select
   '${bf_1_dt}' as dt,
   book_id
  ,count(distinct user_id) as con_user_cons
  ,0 as con_aduser_cons
  ,0 as con_notaduser_cons

  ,count(DISTINCT case when con_chap>0 and con_chap<=15 then  user_id end) as con_user_cons_a
  ,count(DISTINCT case when con_chap>15 and con_chap<=50 then  user_id end) as con_user_cons_b
  ,count(DISTINCT case when con_chap>50  then  user_id end) as con_user_cons_c

  ,0 as con_aduser_cons_a
  ,0 as con_aduser_cons_b
  ,0 as con_aduser_cons_c

  ,0 as con_notaduser_cons_a
  ,0 as con_notaduser_cons_b
  ,0 as con_notaduser_cons_c

  ,0 as con_aduser_cons_01
  ,count(DISTINCT case when  con_chap_01>0 then user_id end) as con_notaduser_cons_01

  ,0 as con_aduser_cons_07
  ,count(DISTINCT case when  con_chap_07>0 then user_id end) as con_notaduser_cons_07

  ,0 as con_aduser_cons_15
  ,count(DISTINCT case when con_chap_15>0 then user_id end) as con_notaduser_cons_15

  ,sum(con_chap_01) as con_chap_cons_01
  ,sum(con_chap_07) as con_chap_cons_07
  ,sum(con_chap_15) as con_chap_cons_15
  ,sum(con_chap) as con_chap_cons

  ,0 as con_ad_chap_cons_01
  ,0 as con_ad_chap_cons_07
  ,0 as con_ad_chap_cons_15
  ,0 as con_ad_chap_cons

  ,0 as con_notad_chap_cons_01
  ,0 as con_notad_chap_cons_07
  ,0 as con_notad_chap_cons_15
  ,0 as con_notad_chap_cons

  ,sum(sum_amount_01) as sum_amount_01
  ,sum(sum_amount_07) as sum_amount_07
  ,sum(sum_amount_15) as sum_amount_15
  ,sum(sum_amount) as sum_amount

  ,0 as sum_amount_ad_01
  ,0 as sum_amount_ad_07
  ,0 as sum_amount_ad_15
  ,0 as sum_amount_ad

  ,0 as sum_amount_notad_01
  ,0 as sum_amount_notad_07
  ,0 as sum_amount_notad_15
  ,0 as sum_amount_notad,
  now() as etl_time
from dws.dws_consume_user_amt_mid
     where dt='${bf_1_dt}'
group by 1,2 ;
