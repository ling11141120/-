----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dws_consume_user_consume_mid
-- workflow_version : 1
-- create_user      : xixg
-- task_name        : dws_consume_user_consume_mid
-- task_version     : 1
-- update_time      : 2025-04-01 11:30:14
-- sql_path         : \starrocks\tbl_dws_consume_user_consume_mid\dws_consume_user_consume_mid
----------------------------------------------------------------
-- SQL语句
insert into dws.dws_consume_user_consume_mid
select  '${bf_1_dt}' as dt,a.user_id,
        a.book_id,
        a.product_id,
        sum(ifnull(a.con_chapter_num,0)) con_chapter_num,
        sum(ifnull(a.csum_total_amount,0))  as  csum_total_amount ,
        now() as etl_time
from(
        select  a.user_id,
                a.book_id,
                a.product_id,
                sum(ifnull(a.con_chapter_nums,0)) con_chapter_num,
                sum(ifnull(a.amount,0))  as  csum_total_amount
         from dws.dws_consume_user_consume_ed  a
        inner join dws.dws_user_login_l30d_temp b
              on a.product_id=b.product_id
              and a.user_id =b.user_id
              and  b.dt= '${bf_1_dt}'
        where a.dt>=  '${bf_1_dt}'
              and a.dt<'${dt}'
              and a.types=5
        group by 1,2,3
        union all
        select user_id ,
               book_id,
               product_id ,
               con_chapter_num,
               csum_total_amount
        from dws.dws_consume_user_consume_mid
        where dt>= '${bf_2_dt}' and dt<'${bf_1_dt}'
    ) a
group by 1,2,3 ,4;
