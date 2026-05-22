----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dws_read_user_chapters_mid
-- workflow_version : 13
-- create_user      : yanxh
-- task_name        : dws_read_user_chapters_mid_1
-- task_version     : 10
-- update_time      : 2025-06-21 15:37:20
-- sql_path         : \starrocks\tbl_dws_read_user_chapters_mid\dws_read_user_chapters_mid_1
----------------------------------------------------------------
-- SQL语句
insert into   dws.dws_read_user_chapters_mid
WITH tmp_book AS (
    select book_id
    from  dim.dim_shuangwen_book_read_consume_info
    where product_id  not in (8858)
),
tmp_a AS (
    --昨天以及近15天的数据------------------
select        a.product_id,
              a.user_id ,
              a.book_id,
              sum(case  when a.dt>=DATE_SUB('${dt}',interval 1 day) and a.dt<'${dt}'  then a.read_chapter_num end) as con_read_chap_01,
              sum(case  when a.dt>=DATE_SUB('${dt}',interval 7 day) and a.dt<'${dt}'  then a.read_chapter_num end) as con_read_chap_07,
              sum(case  when a.dt>=DATE_SUB('${dt}',interval 15 day) and a.dt<'${dt}'  then a.read_chapter_num end) as con_read_chap_15,
              sum(case  when a.dt>=DATE_SUB('${dt}',interval 1 day) and a.dt<'${dt}'  then a.read_chapter_num end) as con_read_chap
 from dws.dws_read_user_readbook_ed a
inner join tmp_book b
   on a.book_id =b.book_id
WHERE  a.dt>=DATE_SUB('${dt}',interval 15 day) and a.dt<'${dt}'
  and product_id in (3366)
  and  a.reg_date >='2021-01-01'
group by 1,2,3
)
select
    '${bf_1_dt}' as dt,
    product_id,
    user_id,
    book_id,
    sum(a.con_read_chap_01) con_read_chap_01,
    sum(a.con_read_chap_07) con_read_chap_07,
    sum(a.con_read_chap_15) con_read_chap_15,
    sum(a.con_read_chap) con_read_chap ,
    now() as etl_time
from (    -- ---------------------------

-- 前天的数据--------------------
     select
            product_id,
            user_id,
            book_id,
            0 as con_read_chap_01,
            0 as con_read_chap_07,
            0 as con_read_chap_15,
            con_read_chap
     from  dws.dws_read_user_chapters_mid
     where dt='${bf_2_dt}'
      and product_id in (3366)
     union all
         --昨天以及近15天的数据------------------
     select
           a.product_id,
           a.user_id ,
           a.book_id,
           con_read_chap_01,
           con_read_chap_07,
           con_read_chap_15,
           con_read_chap
         from tmp_a a
     ) a
group by 1,2,3,4;

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dws_read_user_chapters_mid
-- workflow_version : 13
-- create_user      : yanxh
-- task_name        : dws_read_user_chapters_mid_2
-- task_version     : 9
-- update_time      : 2025-06-21 15:37:20
-- sql_path         : \starrocks\tbl_dws_read_user_chapters_mid\dws_read_user_chapters_mid_2
----------------------------------------------------------------
-- SQL语句
insert into   dws.dws_read_user_chapters_mid
WITH tmp_book AS (
    select book_id
    from  dim.dim_shuangwen_book_read_consume_info
    where product_id  not in (8858)
),
     tmp_a AS (
         --昨天以及近15天的数据------------------
         select        a.product_id,
                       a.user_id ,
                       a.book_id,
                       sum(case  when a.dt>=DATE_SUB('${dt}',interval 1 day) and a.dt<'${dt}'  then a.read_chapter_num end) as con_read_chap_01,
                       sum(case  when a.dt>=DATE_SUB('${dt}',interval 7 day) and a.dt<'${dt}'  then a.read_chapter_num end) as con_read_chap_07,
                       sum(case  when a.dt>=DATE_SUB('${dt}',interval 15 day) and a.dt<'${dt}'  then a.read_chapter_num end) as con_read_chap_15,
                       sum(case  when a.dt>=DATE_SUB('${dt}',interval 1 day) and a.dt<'${dt}'  then a.read_chapter_num end) as con_read_chap
         from dws.dws_read_user_readbook_ed a
                  inner join tmp_book b
                             on a.book_id =b.book_id
         WHERE  a.dt>=DATE_SUB('${dt}',interval 15 day) and a.dt<'${dt}'
           and product_id not in (3366)
           and  a.reg_date >='2021-01-01'
         group by 1,2,3
     )
select
    '${bf_1_dt}' as dt,
    product_id,
    user_id,
    book_id,
    sum(a.con_read_chap_01) con_read_chap_01,
    sum(a.con_read_chap_07) con_read_chap_07,
    sum(a.con_read_chap_15) con_read_chap_15,
    sum(a.con_read_chap) con_read_chap ,
    now() as etl_time
from (    -- ---------------------------

-- 前天的数据--------------------
         select
             product_id,
             user_id,
             book_id,
             0 as con_read_chap_01,
             0 as con_read_chap_07,
             0 as con_read_chap_15,
             con_read_chap
         from  dws.dws_read_user_chapters_mid
         where dt='${bf_2_dt}'
           and product_id not in (3366)
         union all
         --昨天以及近15天的数据------------------
         select
             a.product_id,
             a.user_id ,
             a.book_id,
             con_read_chap_01,
             con_read_chap_07,
             con_read_chap_15,
             con_read_chap
         from tmp_a a
     ) a
group by 1,2,3,4;
