----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dim_book_author
-- workflow_version : 5
-- create_user      : linq
-- task_name        : dim_book_author
-- task_version     : 5
-- update_time      : 2023-11-18 14:15:32
-- sql_path         : \starrocks\tbl_dim_book_author\dim_book_author
----------------------------------------------------------------
-- 前置SQL语句
delete from  dim.dim_book_author where 1=1;

-- SQL语句
insert into dim.dim_book_author
select book.productid as product_id,bookid * 1000 + SiteId as book_id, BookName as book_name, AuthorId as author_id, PenName as author_name, CategoryId as new_cid ,now() as etl_time
from (
         select productid, bookid, SiteId, BookName, AuthorId, CategoryId from ods.ods_edit_book
         where productid = 3366 or(productid = 3388 and siteId=375) or(productid = 3322 and siteId=409) or(productid = 3311 and siteid=410)
         union all
         select 3371 as productid, bookid, SiteId, BookName, AuthorId, CategoryId from ods.ods_edit_book where productid = 3388 and SiteId=418
         union all
         select 3501 as productid, bookid, SiteId, BookName, AuthorId, CategoryId from ods.ods_edit_book where productid = 3311 and SiteId=414
         union all
         select 3511 as productid, bookid, SiteId, BookName, AuthorId, CategoryId from ods.ods_edit_book where productid = 3311 and SiteId=433
     ) book
         left join (
         select productid, AccountId, PenName from ods.ods_edit_author where productid in (3366,3388,3322,3311) union all
         select 3371 as productid, AccountId, PenName from ods.ods_edit_author where productid = 3388 union all
         select 3501 as productid, AccountId, PenName from ods.ods_edit_author where productid = 3311 union all
         select 3511 as productid, AccountId, PenName from ods.ods_edit_author where productid = 3311
) author on book.productid = author.productid and book.authorid = author.AccountId;
