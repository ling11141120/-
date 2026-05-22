----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dws_read_user_read_book_chapter_info_ed
-- workflow_version : 10
-- create_user      : yanxh
-- task_name        : dws_read_user_read_book_chapter_info_ed
-- task_version     : 10
-- update_time      : 2025-06-03 15:50:41
-- sql_path         : \starrocks\tbl_dws_read_user_read_book_chapter_info_ed\dws_read_user_read_book_chapter_info_ed
----------------------------------------------------------------
-- SQL语句
INSERT into dws.dws_read_user_read_book_chapter_info_ed
WITH tmp1 AS (
    select book_id,
           book_name,
           chapter_id,
           serial_number
    from  dim.dim_book_chapter_info
    where site_id not in (0,48,90,446)
    group by 1,2,3,4

)
select
    a.dt ,
    a.product_id ,
    a.user_id,
    (case 	when  	 a.book_id % 1000 = 322 then 322
             when 	 a.book_id % 1000 = 375 then 375
             when  	 a.book_id % 1000 = 409 then 409
             when 	 a.book_id % 1000 = 410 then 410
             when 	 a.book_id % 1000 = 418 then 418
             when 	 a.book_id % 1000 = 419 then 419
             when 	 a.book_id % 1000 = 414 then 414
             when 	 a.book_id % 1000 = 433 then 433
             when 	 a.book_id % 1000 = 435 then 435
             when 	 a.book_id % 1000 = 436 then 436
             when 	 a.book_id % 1000 = 445 then 445
             when 	 a.book_id % 1000 = 412 then 412
             when 	 a.book_id % 1000 = 413 then 413
             when 	 a.book_id % 1000 = 415 then 415
             when 	 a.book_id % 1000 = 447 then 447
             when 	 a.book_id % 1000 = 448 then 448
             when 	 a.book_id % 1000 = 491 then 491
             when 	 a.book_id % 1000 = 492 then 492
             when 	 a.book_id % 1000 = 1 then 1
             when 	a.product_id in (8858) then 885 when a.product_id in (7757) then 775
             else 	333 end ) as site_id,
    a.book_id,
    a.chapter_id ,
    c.serial_number,
    c.book_name,
    b.mt,
    b.corever,
    b.current_language current_language,
    b.current_language2 current_language2,
    count(1) as read_counts,
    now() as etl_time
from dwd.dwd_read_user_chapter_view a
         left join dim.dim_user_account_info_view b
                   on a.product_id =b.product_id  and a.user_id =b.id
         left join tmp1 c
                   on a.book_id=c.book_id and a.chapter_id=c.chapter_id
where   a.dt = '${bf_1_dt}'
  and a.book_id >0
  and a.chapter_id !='null'
  and a.product_id not in (7777,8888,0)
group by 1 ,2,3,4,5,6,7,8,9,10,11,12;
