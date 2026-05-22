----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dws_read_book_chapter_ed
-- workflow_version : 8
-- create_user      : yanxh
-- task_name        : tbl_dws_read_book_chapter_ed
-- task_version     : 8
-- update_time      : 2024-10-16 11:42:01
-- sql_path         : \starrocks\tbl_dws_read_book_chapter_ed\tbl_dws_read_book_chapter_ed
----------------------------------------------------------------
-- SQL语句
insert into  dws.dws_read_book_chapter_ed
select
    a.dt ,  a.site_id,a.book_id,a.chapter_id,a.product_id,
    if(b.CoreVer ='' or b.CoreVer is null or b.CoreVer=0,1,b.CoreVer) CoreVer ,
    if(b.MT ='' or b.MT is null,-99,b.MT) MT ,
    if(b.Ver ='' or b.Ver is null,-99,b.Ver) Ver ,
    if(b.CurrentLanguage ='' or b.CurrentLanguage is null,-99,b.CurrentLanguage) CurrentLanguage,
    if(b.CurrentLanguage2 ='' or b.CurrentLanguage2 is null,-99,b.CurrentLanguage2) CurrentLanguage2,
    if(b.Create_Time ='' or b.Create_Time is null,'1970-01-01',b.Create_Time) reg_date,
    if(datediff(a.dt,date(b.Create_Time)) is null,-99, datediff(a.dt,date(b.Create_Time))) as reg_days,
    if(b.RegCountry ='' or b.RegCountry is null,-99,b.RegCountry) reg_country,
    if(b.AppVer ='' or b.AppVer is null,-99,b.AppVer) AppVer,
    if(b.Sex ='' or b.Sex is null,-99,b.Sex) Sex,
    bitmap_union(to_bitmap(a.user_id))  user_id,
    now() as etl_time
from
    (
        select 	a.dt,a.product_id ,
                  (case 	when  	a.product_id in(3311,3322,3333,3366,3371,3388,3399,3501,3511) and a.book_id % 1000 = 322 then 322
                           when 	a.product_id in(3311,3322,3333,3366,3371,3388,3399,3501,3511) and a.book_id % 1000 = 375 then 375
                           when  	a.product_id in(3311,3322,3333,3366,3371,3388,3399,3501,3511) and a.book_id % 1000 = 409 then 409
                           when 	a.product_id in(3311,3322,3333,3366,3371,3388,3399,3501,3511) and a.book_id % 1000 = 410 then 410
                           when 	a.product_id in(3311,3322,3333,3366,3371,3388,3399,3501,3511) and a.book_id % 1000 = 418 then 418
                           when 	a.product_id in(3311,3322,3333,3366,3371,3388,3399,3501,3511) and a.book_id % 1000 = 419 then 419
                           when 	a.product_id in(3311,3322,3333,3366,3371,3388,3399,3501,3511) and a.book_id % 1000 = 414 then 414
                           when 	a.product_id in(3311,3322,3333,3366,3371,3388,3399,3501,3511) and a.book_id % 1000 = 433 then 433
                           when 	a.product_id in(3311,3322,3333,3366,3371,3388,3399,3501,3511) and a.book_id % 1000 = 435 then 435
                           when 	a.product_id in(3311,3322,3333,3366,3371,3388,3399,3501,3511) and a.book_id % 1000 = 436 then 436
                           when 	a.product_id in(3311,3322,3333,3366,3371,3388,3399,3501,3511) and a.book_id % 1000 = 445 then 445
                           when 	a.product_id in(3311,3322,3333,3366,3371,3388,3399,3501,3511) and a.book_id % 1000 = 412 then 412
                           when 	a.product_id in(3311,3322,3333,3366,3371,3388,3399,3501,3511) and a.book_id % 1000 = 413 then 413
                           when 	a.product_id in(3311,3322,3333,3366,3371,3388,3399,3501,3511) and a.book_id % 1000 = 415 then 415
                           when 	a.product_id in(3311,3322,3333,3366,3371,3388,3399,3501,3511) and a.book_id % 1000 = 447 then 447
                           when 	a.product_id in(3311,3322,3333,3366,3371,3388,3399,3501,3511) and a.book_id % 1000 = 448 then 448
                           when 	a.product_id in(3311,3322,3333,3366,3371,3388,3399,3501,3511) and a.book_id % 1000 = 491 then 491 -- 英语app中的海外简体
                           when 	a.product_id in(3311,3322,3333,3366,3371,3388,3399,3501,3511) and a.book_id % 1000 = 492 then 492 -- 英语app中的海外繁体
                           when 	a.product_id in(3311,3322,3333,3366,3371,3388,3399,3501,3511) and a.book_id % 1000 = 1 then 1     -- 英语的图书，早期的书
                           when 	a.product_id in (8858) then 885 when a.product_id in (7757) then 775
                           else 	333 end ) as site_id,
                  a.book_id ,a.chapter_id  ,a.user_id
        from dwd.dwd_read_user_chapter_view a
        where a.dt>='${bf_1_dt}' and  a.dt<='${dt}' and a.book_id>0 and a.chapter_id >0 and a.product_id not in (7777,8888,0)
    ) a
        left JOIN
    (
        select if(b.CoreVer ='' or b.CoreVer is null or b.CoreVer=0,1,b.CoreVer) CoreVer ,
               if(b.MT ='' or b.MT is null,-99,b.MT) MT,
               if(b.Ver ='' or b.Ver is null,-99,b.Ver) Ver,
               if(b.Current_Language ='' or b.Current_Language is null,-99,b.Current_Language) CurrentLanguage,
               if(b.Current_Language2 ='' or b.Current_Language2 is null,-99,b.Current_Language2) CurrentLanguage2,
               b.Create_Time ,
               if(b.Reg_Country ='' or b.Reg_Country is null,-99,b.Reg_Country) RegCountry,
               if(b.AppVer ='' or b.AppVer is null,-99,b.AppVer) AppVer,
               if(b.Sex ='' or b.Sex is null,-99,b.Sex) Sex,
               b.id, b.product_id from dim.dim_user_account_info_view b
    ) b
    on a.Product_id=b.Product_id and a.user_id=b.id
group by 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15 ;
