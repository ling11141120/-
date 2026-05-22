----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dws_consume_user_consume_td_mid
-- workflow_version : 13
-- create_user      : yanxh
-- task_name        : dws_consume_user_consume_td_mid
-- task_version     : 6
-- update_time      : 2024-10-16 12:02:29
-- sql_path         : \starrocks\tbl_dws_consume_user_consume_td_mid\dws_consume_user_consume_td_mid
----------------------------------------------------------------
-- 前置SQL语句
delete from  dws.dws_consume_user_consume_td_mid where dt='${bf_1_dt}' and product_id in (3311,3322,3333,3366);

-- SQL语句
insert into dws.dws_consume_user_consume_td_mid
 select  '${bf_1_dt}' as dt,
      product_id ,
      user_id,
      types,
      sum(con_amount) as con_amount ,
      min(fst_time) as fst_time,
      max(lst_time) as lst_time,
      round(sum(consume_cnt)) as consume_cnt  ,
      bitmap_union(con_chapter_nums) as  con_chapter_nums,
      bitmap_union(csum_days_cnt) as csum_days_cnt,
      now() as etl_time
 from (
select
      product_id ,
      user_id,
      types,
      sum(con_chp_amount) as con_amount ,
      min(fst_time) fst_time,
      max(lst_time) lst_time,
      round(sum(con_book_cnt))  consume_cnt  ,
      bitmap_union(to_bitmap(CONCAT(book_id,chapter_id))) con_chapter_nums   ,
      bitmap_union(to_bitmap(date_format(dt,'%y%m%d'))) as csum_days_cnt   -- 消费天数
from dwm.dwm_consume_user_consume_mild_ed
where dt='${bf_1_dt}'
and product_id   in (3311,3322,3333,3366)
and pay_type <>1103
group by 1,2,3
  union all
select   Product_id ,User_Id ,types, con_amount,fst_time,lst_time ,consume_cnt, con_chapter_nums,csum_days_cnt
from dws.dws_consume_user_consume_td_mid where dt='${bf_2_dt}' and product_id    in (3311,3322,3333,3366)
  ) x  group by 1,2,3 ,4;

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dws_consume_user_consume_td_mid
-- workflow_version : 13
-- create_user      : yanxh
-- task_name        : dws_consume_user_consume_td_mid_2sp
-- task_version     : 5
-- update_time      : 2024-10-16 12:02:29
-- sql_path         : \starrocks\tbl_dws_consume_user_consume_td_mid\dws_consume_user_consume_td_mid_2sp
----------------------------------------------------------------
-- 前置SQL语句
delete from  dws.dws_consume_user_consume_td_mid where dt='${bf_1_dt}' and product_id not in (3311,3322,3333,3366);

-- SQL语句
-- 新增消费天数
 insert into dws.dws_consume_user_consume_td_mid
 select  '${bf_1_dt}' as dt,
      product_id ,
      user_id,
      types,
      sum(con_amount) as con_amount ,
      min(fst_time) as fst_time,
      max(lst_time) as lst_time,
      round(sum(consume_cnt)) as consume_cnt  ,
      bitmap_union(con_chapter_nums) as  con_chapter_nums,
      bitmap_union(csum_days_cnt) as csum_days_cnt,
      now() as etl_time
 from (
select
      product_id ,
      user_id,
      types,
      sum(con_chp_amount) as con_amount ,
      min(fst_time) fst_time,
      max(lst_time) lst_time,
      round(sum(con_book_cnt))  consume_cnt  ,
      bitmap_union(to_bitmap(CONCAT(book_id,chapter_id))) con_chapter_nums   ,
      bitmap_union(to_bitmap(date_format(dt,'%y%m%d'))) as csum_days_cnt   -- 消费天数
from dwm.dwm_consume_user_consume_mild_ed
where dt='${bf_1_dt}'
and product_id  not in (3311,3322,3333,3366)
and pay_type <>1103
group by 1,2,3
  union all
select   Product_id ,User_Id ,types, con_amount,fst_time,lst_time ,consume_cnt, con_chapter_nums,csum_days_cnt
from dws.dws_consume_user_consume_td_mid where dt='${bf_2_dt}' and product_id not   in (3311,3322,3333,3366)
  ) x  group by 1,2,3 ,4;
