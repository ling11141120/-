----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dws_user_read_book_info_p_a
-- workflow_version : 2
-- create_user      : yanxh
-- task_name        : dws_user_read_book_info_p_a
-- task_version     : 2
-- update_time      : 2024-10-16 11:32:02
-- sql_path         : \starrocks\tbl_dws_user_read_book_info_p_a\dws_user_read_book_info_p_a
----------------------------------------------------------------
-- SQL语句
-- ----------------- 定时调度脚本，将最新的数据写进当天的日期分区里-----------------------------------
insert into dws.`dws_user_read_book_info_p_a`
select '${dt}' as dt,
       product_id,user_id,
       max(case when rank_1=1 then fst_bookid end) as fst_bookid, -- 首次阅读书籍
       max(case when rank_2=1 then lst_bookid end) as  lst_bookid,   -- 最近一次阅读书籍
       max(case when rank_1=1 then fst_tm end) as fst_tm, -- 首次阅读时间
       max(case when rank_2=1 then lst_tm end) as lst_tm, -- 最近一次阅读时间
       now() as etl_tm
from (
select product_id,user_id,
     fst_bookid,lst_bookid,fst_tm,lst_tm,
     row_number() over(partition by  Product_Id,user_id order by fst_tm ) as rank_1,
     row_number() over(partition by  Product_Id,user_id order by lst_tm  desc ) as rank_2

from (
-- 已经落表的历史数据----
select
product_id,user_id,fst_bookid,lst_bookid,fst_tm,lst_tm
from  dws.`dws_user_read_book_info_p_a`
 where dt='${bf_1_dt}'
union all
--  昨天至当前的数据-----
select
       Product_Id,user_id,
       max(case when rank_1=1 then book_id end) as fst_bookid, -- 首次阅读书籍
       max(case when rank_2=1 then book_id end) as  lst_bookid,   -- 最近一次阅读书籍
       max(case when rank_1=1 then create_time end) as fst_tm, -- 首次阅读时间
       max(case when rank_2=1 then create_time end) as lst_tm -- 最近一次阅读时间
from (
select  Product_Id,user_id,book_id,create_time,
        row_number() over(partition by  Product_Id,user_id order by create_time ) as rank_1,
        row_number() over(partition by  Product_Id,user_id  order by create_time desc) as rank_2
from dwd.dwd_read_user_chapter_view
where dt >='${bf_1_dt}' and  dt<='${dt}'
and product_id not in (7777,8888) and book_id >0 and user_id >0
) a
group by 1,2
) v
) n group by 1,2 ,3;
