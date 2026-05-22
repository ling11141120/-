----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dws_consume_book_chapter_ed
-- workflow_version : 2
-- create_user      : linq
-- task_name        : dws_consume_book_chapter_ed
-- task_version     : 2
-- update_time      : 2023-11-17 13:36:58
-- sql_path         : \starrocks\tbl_dws_consume_book_chapter_ed\dws_consume_book_chapter_ed
----------------------------------------------------------------
-- SQL语句
delete from  dws.dws_consume_book_chapter_ed where dt>='${bf_1_dt}' ;

-- SQL语句
insert into dws.dws_consume_book_chapter_ed
select dt,site_id,book_id,Chapter_id,product_id,types,
       if(CoreVer = '' or CoreVer is null or CoreVer = 0, 1, CoreVer)                        as CoreVer,
       if(MT = '' or MT is null, -99, MT)                                                    as MT,
       if(Ver = '' or Ver is null, -99, Ver)                                                 as Ver,
       if(Current_Language = '' or Current_Language is null, -99, Current_Language)          as CurrentLanguage,
       if(Current_Language2 = '' or Current_Language2 is null, -99, Current_Language2)       as CurrentLanguage2,
       if(reg_date = '' or reg_date is null, '1970-01-01', reg_date)                         as reg_date,
       if(reg_days is null, -99, reg_days)                                                   as reg_days,
       if(reg_country = '' or reg_country is null, -99, reg_country)                         as reg_country,
       if(AppVer = '' or AppVer is null, -99, AppVer)                                        as AppVer,
       if(Sex = '' or Sex is null, -99, Sex)                                                 as Sex,
       current_timestamp()                                                                   as etl_time,
       bitmap_union(to_bitmap(user_id))                                                      as user_id,
       sum(con_chp_amount)                                                                   as amound
from dwm.dwm_consume_user_consume_mild_ed
where dt >= '${bf_1_dt}' and dt<='${dt}' and pay_type<>1103 and book_id > 0 and chapter_id > 0 and product_id not in (7777, 8888, 0)
group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15,16;
