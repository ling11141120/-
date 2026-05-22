----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dws_read_user_read_roll_a
-- workflow_version : 27
-- create_user      : linq
-- task_name        : dws_read_user_read_roll_a_en
-- task_version     : 2
-- update_time      : 2023-10-24 15:26:43
-- sql_path         : \starrocks\tbl_dws_read_user_read_roll_a\dws_read_user_read_roll_a_en
----------------------------------------------------------------
-- SQL语句
insert into dws.dws_read_user_read_roll_a
with read_info as (
    select dt,
           user_id,
           product_id,
           bitmap_union(total_read_bookids) as total_read_bookids,
           bitmap_union(total_read_chp_ids) as total_read_chp_ids,
           sum(total_read_days)             as total_read_days
    from (
             select dt, user_id, product_id, total_read_bookids, total_read_chp_ids, total_read_days
             from (
                  select '${bf_1_dt}' as dt,user_id,product_id,total_read_bookids,total_read_chp_ids,total_read_days
                  from dws.dws_read_user_read_roll_a
                  where dt='${bf_2_dt}' and product_id=3366
                 )read_roll
             union all
             select '${bf_1_dt}' as dt, user_id, product_id, total_read_bookids, total_read_chp_ids, total_read_days
             from dws.dws_read_user_read_book_ed_tmp
             where product_id=3366
         )read_info_a
    group by 1,2,3
)
select '${bf_1_dt}' as dt,
       read_info.User_Id,
       read_info.product_id,
       total_read_bookids,
       total_read_chp_ids,
       total_read_days,
       new_bookid_chapid,
       new_chp_book_cnt,
       now() as etl_time
from read_info
left join (
    select product_id, user_id, new_bookid_chapid, new_chp_book_cnt
    from dws.dws_read_user_read_newchapter_tmp
    where product_id=3366
) nc on read_info.Product_id=nc.product_id and read_info.User_Id=nc.user_id;

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dws_read_user_read_roll_a
-- workflow_version : 27
-- create_user      : linq
-- task_name        : dws_read_user_read_roll_a_other
-- task_version     : 2
-- update_time      : 2023-10-24 15:26:43
-- sql_path         : \starrocks\tbl_dws_read_user_read_roll_a\dws_read_user_read_roll_a_other
----------------------------------------------------------------
-- SQL语句
insert into dws.dws_read_user_read_roll_a
with read_info as (
    select dt,
           user_id,
           product_id,
           bitmap_union(total_read_bookids) as total_read_bookids,
           bitmap_union(total_read_chp_ids) as total_read_chp_ids,
           sum(total_read_days)             as total_read_days
    from (
             select dt, user_id, product_id, total_read_bookids, total_read_chp_ids, total_read_days
             from (
                  select '${bf_1_dt}' as dt,user_id,product_id,total_read_bookids,total_read_chp_ids,total_read_days
                  from dws.dws_read_user_read_roll_a
                  where dt='${bf_2_dt}' and product_id not in(3366,3388,3322)
                 )read_roll
             union all
             select '${bf_1_dt}' as dt, user_id, product_id, total_read_bookids, total_read_chp_ids, total_read_days
             from dws.dws_read_user_read_book_ed_tmp
             where product_id not in(3366,3388,3322)
         )read_info_a
    group by 1,2,3
)
select '${bf_1_dt}' as dt,
       read_info.User_Id,
       read_info.product_id,
       total_read_bookids,
       total_read_chp_ids,
       total_read_days,
       new_bookid_chapid,
       new_chp_book_cnt,
       now() as etl_time
from read_info
left join (
    select product_id, user_id, new_bookid_chapid, new_chp_book_cnt
    from dws.dws_read_user_read_newchapter_tmp
    where product_id not in(3366,3388,3322)
) nc on read_info.Product_id=nc.product_id and read_info.User_Id=nc.user_id;

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dws_read_user_read_roll_a
-- workflow_version : 27
-- create_user      : linq
-- task_name        : dws_read_user_read_roll_a_pt
-- task_version     : 2
-- update_time      : 2023-10-24 15:26:43
-- sql_path         : \starrocks\tbl_dws_read_user_read_roll_a\dws_read_user_read_roll_a_pt
----------------------------------------------------------------
-- SQL语句
insert into dws.dws_read_user_read_roll_a
with read_info as (
    select dt,
           user_id,
           product_id,
           bitmap_union(total_read_bookids) as total_read_bookids,
           bitmap_union(total_read_chp_ids) as total_read_chp_ids,
           sum(total_read_days)             as total_read_days
    from (
             select dt, user_id, product_id, total_read_bookids, total_read_chp_ids, total_read_days
             from (
                  select '${bf_1_dt}' as dt,user_id,product_id,total_read_bookids,total_read_chp_ids,total_read_days
                  from dws.dws_read_user_read_roll_a
                  where dt='${bf_2_dt}' and product_id=3322
                 )read_roll
             union all
             select '${bf_1_dt}' as dt, user_id, product_id, total_read_bookids, total_read_chp_ids, total_read_days
             from dws.dws_read_user_read_book_ed_tmp
             where product_id=3322
         )read_info_a
    group by 1,2,3
)
select '${bf_1_dt}' as dt,
       read_info.User_Id,
       read_info.product_id,
       total_read_bookids,
       total_read_chp_ids,
       total_read_days,
       new_bookid_chapid,
       new_chp_book_cnt,
       now() as etl_time
from read_info
left join (
    select product_id, user_id, new_bookid_chapid, new_chp_book_cnt
    from dws.dws_read_user_read_newchapter_tmp
    where product_id=3322
) nc on read_info.Product_id=nc.product_id and read_info.User_Id=nc.user_id;

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dws_read_user_read_roll_a
-- workflow_version : 27
-- create_user      : linq
-- task_name        : dws_read_user_read_roll_a_sp
-- task_version     : 3
-- update_time      : 2023-10-26 17:30:14
-- sql_path         : \starrocks\tbl_dws_read_user_read_roll_a\dws_read_user_read_roll_a_sp
----------------------------------------------------------------
-- SQL语句
insert into dws.dws_read_user_read_roll_a
with read_info as (
    select dt,
           user_id,
           product_id,
           bitmap_union(total_read_bookids) as total_read_bookids,
           bitmap_union(total_read_chp_ids) as total_read_chp_ids,
           sum(total_read_days)             as total_read_days
    from (
             select dt, user_id, product_id, total_read_bookids, total_read_chp_ids, total_read_days
             from (
                  select '${bf_1_dt}' as dt,user_id,product_id,total_read_bookids,total_read_chp_ids,total_read_days
                  from dws.dws_read_user_read_roll_a
                  where dt='${bf_2_dt}' and product_id=3388
                 )read_roll
             union all
             select '${bf_1_dt}' as dt, user_id, product_id, total_read_bookids, total_read_chp_ids, total_read_days
             from dws.dws_read_user_read_book_ed_tmp
             where product_id=3388
         )read_info_a
    group by 1,2,3
)
select '${bf_1_dt}' as dt,
       read_info.User_Id,
       read_info.product_id,
       total_read_bookids,
       total_read_chp_ids,
       total_read_days,
       new_bookid_chapid,
       new_chp_book_cnt,
       now() as etl_time
from read_info
left join (
    select product_id, user_id, new_bookid_chapid, new_chp_book_cnt
    from dws.dws_read_user_read_newchapter_tmp
    where product_id=3388
) nc on read_info.Product_id=nc.product_id and read_info.User_Id=nc.user_id;
