----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_book_read_consume_inte3
-- workflow_version : 22
-- create_user      : linq
-- task_name        : dws_read_90_first_all_read_mid2
-- task_version     : 14
-- update_time      : 2026-01-09 19:20:43
-- sql_path         : \starrocks\tbl_ads_book_read_consume_inte3\dws_read_90_first_all_read_mid2
----------------------------------------------------------------
-- 前置SQL语句
delete from dws.dws_read_90_first_all_read_mid2 where dt >='${bf_1_dt}' and dt<='${dt}';

-- SQL语句
insert into dws.dws_read_90_first_all_read_mid2
with fst_r as(
    select a.dt, a.user_id,a.site_id, a.book_id,b.fst_create_time
    from dws.dws_read_90_first_all_read_mid1 a
    inner join(
        select dt,user_id,
           (case when product_id in(3311,3322,3333,3366,3371,3388,3399,3501,3511) and book_id % 1000 = 322 then 322
                 when product_id in(3311,3322,3333,3366,3371,3388,3399,3501,3511) and book_id % 1000 = 375 then 375
                 when product_id in(3311,3322,3333,3366,3371,3388,3399,3501,3511) and book_id % 1000 = 409 then 409
                 when product_id in(3311,3322,3333,3366,3371,3388,3399,3501,3511) and book_id % 1000 = 410 then 410
                 when product_id in(3311,3322,3333,3366,3371,3388,3399,3501,3511) and book_id % 1000 = 418 then 418
                 when product_id in(3311,3322,3333,3366,3371,3388,3399,3501,3511) and book_id % 1000 = 419 then 419
                 when product_id in(3311,3322,3333,3366,3371,3388,3399,3501,3511) and book_id % 1000 = 414 then 414
                 when product_id in(3311,3322,3333,3366,3371,3388,3399,3501,3511) and book_id % 1000 = 433 then 433
                 when product_id in(3311,3322,3333,3366,3371,3388,3399,3501,3511) and book_id % 1000 = 435 then 435
                 when product_id in(3311,3322,3333,3366,3371,3388,3399,3501,3511) and book_id % 1000 = 436 then 436
                 when product_id in(3311,3322,3333,3366,3371,3388,3399,3501,3511) and book_id % 1000 = 445 then 445
                 when product_id in(3311,3322,3333,3366,3371,3388,3399,3501,3511) and book_id % 1000 = 412 then 412
                 when product_id in(3311,3322,3333,3366,3371,3388,3399,3501,3511) and book_id % 1000 = 413 then 413
                 when product_id in(3311,3322,3333,3366,3371,3388,3399,3501,3511) and book_id % 1000 = 415 then 415
                 when product_id in(3311,3322,3333,3366,3371,3388,3399,3501,3511) and book_id % 1000 = 447 then 447
                 when product_id in(3311,3322,3333,3366,3371,3388,3399,3501,3511) and book_id % 1000 = 448 then 448

                 when product_id in(3311,3322,3333,3366,3371,3388,3399,3501,3511) and book_id % 1000 = 491 then 491
                 when product_id in(3311,3322,3333,3366,3371,3388,3399,3501,3511) and book_id % 1000 = 492 then 492
                 when product_id in(3311,3322,3333,3366,3371,3388,3399,3501,3511) and book_id % 1000 = 497 then 497
                 when product_id in(3311,3322,3333,3366,3371,3388,3399,3501,3511) and book_id % 1000 = 1 then 1
                 when product_id in (8858) then 885 when product_id in (7757) then 775
                 else 	333 end ) as siteid,
           book_id,min(create_time) as fst_create_time
        from dwd.dwd_read_user_chapter_view where dt>='${bf_1_dt}' and dt<='${dt}'
        group by 1,2,3,4
        )b on a.dt=b.dt and a.site_id=b.siteid and a.user_id=b.user_id and a.book_id=b.book_id
    where a.dt>='${bf_1_dt}' and a.dt<='${dt}'
)
select dt,site_id,book_id,user_id,max(is_source) as is_source,now() as etl_time
from(
    select fst_r.dt, fst_r.user_id, fst_r.site_id, fst_r.book_id, fst_r.fst_create_time,if(c.Install_Date is not null,1,0) is_source
    from fst_r
    left join (
        select dt,
               User_Id,
               Install_Date,
               Book_Id
        from dwd.dwd_user_install_info_ed_view
        where dt>='${bf_2_dt}' and dt<date_add('${dt}',interval 1 day )
          and Product_Id not in(6833,6883) and Book_Id>0 and User_Id>0 and IsDelete=0
        )c on fst_r.user_id=c.User_Id and fst_r.book_id=c.Book_Id
                  and minutes_diff(c.Install_Date,fst_r.fst_create_time) between -1 and 10
)t1
group by 1,2,3,4;
