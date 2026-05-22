----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dws_consume_user_amt_mid
-- workflow_version : 6
-- create_user      : yanxh
-- task_name        : dws_consume_user_amt_mid
-- task_version     : 4
-- update_time      : 2025-01-27 11:25:16
-- sql_path         : \starrocks\tbl_dws_consume_user_amt_mid\dws_consume_user_amt_mid
----------------------------------------------------------------
-- SQL语句
insert into dws.dws_consume_user_amt_mid
select  '${bf_1_dt}' as dt, a.product_id, a.user_id,a.book_id,
sum(a.sum_amount_01) as sum_amount_01 ,
sum(a.con_chap_01) as con_chap_01,
sum(a.sum_amount_07) as sum_amount_07,
sum(a.con_chap_07) as con_chap_07,
sum(a.sum_amount_15) as sum_amount_15,
sum(a.con_chap_15) as con_chap_15,
sum(a.sum_amount) as sum_amount,
sum(a.con_chap) as con_chap,
now() as etl_time
from
(
select product_id,user_id,book_id,0 as sum_amount_01,0  as con_chap_01,0  as sum_amount_07,0  as con_chap_07,0  as sum_amount_15,0 as con_chap_15,sum_amount,con_chap  from dws.dws_consume_user_amt_mid where dt='${bf_2_dt}'
union all
  select                 a.product_id,
                         a.user_id,
                         a.book_id,
                         sum(case  when dt>=DATE_SUB('${dt}',interval 1 day) and dt<'${dt}'  then amount end) as sum_amount_01,
                         sum(case  when dt>=DATE_SUB('${dt}',interval 1 day) and dt<'${dt}'  then con_chapter_nums end) as con_chap_01,
                         sum(case  when dt>=DATE_SUB('${dt}',interval 7 day) and dt<'${dt}'  then amount end) as sum_amount_07,
                         sum(case  when dt>=DATE_SUB('${dt}',interval 7 day) and dt<'${dt}'  then con_chapter_nums end) as con_chap_07,
                         sum(case  when dt>=DATE_SUB('${dt}',interval 15 day) and dt<'${dt}'  then amount end) as sum_amount_15,
                         sum(case  when dt>=DATE_SUB('${dt}',interval 15 day) and dt<'${dt}'  then con_chapter_nums end) as con_chap_15,
						 sum(case  when dt>=DATE_SUB('${dt}',interval 1 day) and dt<'${dt}'  then amount end) as sum_amount,
						 sum(case  when dt>=DATE_SUB('${dt}',interval 1 day) and dt<'${dt}'  then con_chapter_nums end) as con_chap

  from dws.dws_consume_user_consume_ed a
     inner join
    (select  book_id from dim.dim_shuangwen_book_read_consume_info  where product_id  not in (8858)  ) b
    on a.book_id = b.book_id
   where a.dt >=DATE_SUB('${dt}',interval 15 day) and a.dt<'${dt}'
     and a.reg_date >= '2021-01-01'
     and a.types in (1, 2)
     and a.book_id <> 0
     group by 1, 2, 3
  ) a   group by 1, 2, 3 ,4 ;
