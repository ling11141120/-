----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dws_read_user_readbook_ed
-- workflow_version : 17
-- create_user      : yanxh
-- task_name        : dws_read_user_readbook_ed
-- task_version     : 17
-- update_time      : 2026-01-09 14:54:28
-- sql_path         : \starrocks\tbl_dws_read_user_readbook_ed\dws_read_user_readbook_ed
----------------------------------------------------------------
-- 前置SQL语句
delete from dws.dws_read_user_readbook_ed where dt>='${bf_1_dt}' and dt<='${dt}';

-- SQL语句
insert into dws.dws_read_user_readbook_ed
select 	a.dt dt,a.Productid Productid,a.UserId UserId,a.BookId BookId,
          (case 	when  	a.productid in(3311,3322,3333,3366,3371,3388,3399,3501,3511) and a.BookId % 1000 = 322 then 322
                   when 	a.productid in(3311,3322,3333,3366,3371,3388,3399,3501,3511) and a.BookId % 1000 = 375 then 375
                   when  	a.productid in(3311,3322,3333,3366,3371,3388,3399,3501,3511) and a.BookId % 1000 = 409 then 409
                   when 	a.productid in(3311,3322,3333,3366,3371,3388,3399,3501,3511) and a.BookId % 1000 = 410 then 410
                   when 	a.productid in(3311,3322,3333,3366,3371,3388,3399,3501,3511) and a.BookId % 1000 = 418 then 418
                   when 	a.productid in(3311,3322,3333,3366,3371,3388,3399,3501,3511) and a.BookId % 1000 = 419 then 419
                   when 	a.productid in(3311,3322,3333,3366,3371,3388,3399,3501,3511) and a.BookId % 1000 = 414 then 414
                   when 	a.productid in(3311,3322,3333,3366,3371,3388,3399,3501,3511) and a.BookId % 1000 = 433 then 433
                   when 	a.productid in(3311,3322,3333,3366,3371,3388,3399,3501,3511) and a.BookId % 1000 = 435 then 435
                   when 	a.productid in(3311,3322,3333,3366,3371,3388,3399,3501,3511) and a.BookId % 1000 = 436 then 436
                   when 	a.productid in(3311,3322,3333,3366,3371,3388,3399,3501,3511) and a.BookId % 1000 = 445 then 445
                   when 	a.productid in(3311,3322,3333,3366,3371,3388,3399,3501,3511) and a.BookId % 1000 = 412 then 412
                   when 	a.productid in(3311,3322,3333,3366,3371,3388,3399,3501,3511) and a.BookId % 1000 = 413 then 413
                   when 	a.productid in(3311,3322,3333,3366,3371,3388,3399,3501,3511) and a.BookId % 1000 = 415 then 415
                   when 	a.productid in(3311,3322,3333,3366,3371,3388,3399,3501,3511) and a.BookId % 1000 = 447 then 447
                   when 	a.productid in(3311,3322,3333,3366,3371,3388,3399,3501,3511) and a.BookId % 1000 = 448 then 448
                   when 	a.productid in(3311,3322,3333,3366,3371,3388,3399,3501,3511) and a.BookId % 1000 = 491 then 491
                   when 	a.productid in(3311,3322,3333,3366,3371,3388,3399,3501,3511) and a.BookId % 1000 = 492 then 492
                   when 	a.productid in(3311,3322,3333,3366,3371,3388,3399,3501,3511) and a.BookId % 1000 = 497 then 497
                   when 	a.productid in(3311,3322,3333,3366,3371,3388,3399,3501,3511) and a.BookId % 1000 = 1 then 1  -- 英语的图书
                   when 	a.productid in (8858) then 885 when a.productid in (7757) then 775
                   else 	333 end ) as siteid,
          if(b.CoreVer=0 or b.corever is null ,1,b.corever) as CoreVer,b.MT ,b.Ver ,b.Current_Language CurrentLanguage,b.Current_Language2 CurrentLanguage2,
          b.Create_Time as reg_date,datediff(a.dt,date(b.Create_Time)) as reg_days,b.Reg_Country as RegCountry,b.AppVer ,
          b.Sex  ,b.App_Id as AppId,
          a.read_chapter_num,
          a.fst_tm,
          a.lst_tm,
          now() as etl_time
from (
select dt,Product_id as Productid,User_Id as UserId,Book_Id as BookId,AppId,count(distinct chapter_id) as read_chapter_num,min(create_time) as fst_tm,max(create_time) as lst_tm
from dwd.dwd_read_user_chapter_view where dt >= '${bf_1_dt}' and  dt<='${dt}'
group by 1,2,3,4 ,5
) a
  left join dim.dim_user_account_info_view b
                   on a.Productid = b.product_id and a.UserId = b.id;
