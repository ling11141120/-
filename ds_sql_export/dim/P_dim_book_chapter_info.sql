----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dim_book_chapter_info
-- workflow_version : 21
-- create_user      : yanxh
-- task_name        : dim_book_chapter_info_ar
-- task_version     : 2
-- update_time      : 2026-02-11 17:31:04
-- sql_path         : \starrocks\tbl_dim_book_chapter_info\dim_book_chapter_info_ar
----------------------------------------------------------------
-- SQL语句
-- 阿拉伯语、意大利语
insert into dim.dim_book_chapter_info
select a.book_id * 1000 + a.site_id       as book_id
     , a.site_id
     , a.serial_number
     , a.chapter_id
     , a.chapter_name
     , a.chapter_length
     , a.public_time
     , a.timer
     , b.bookname                         as book_name
     , b.newcid                           as new_cid
     , b.newcname                         as new_cname
     , b.Language                         as language_id
     , b.isfull                           as is_full
     , b.sexy2
     , case when b.FreeChapterNum = 0 then a.vip
            when b.FreeChapterNum > 0 and b.FreeChapterNum < a.serial_number then 1
            else 0
       end                                as Free_Chapter_Num
     , a.create_time
     , current_timestamp()                as etl_time
  from ods.ods_edit_shuangwen_chapter     as a
  left join ods.ods_book_novel_book_m     as b
    on (a.book_id * 1000 + a.site_id) = b.bookid
   and a.site_id = b.SiteID
   and b.productid = 3366
 where a.Productid = 3311
   and a.site_id in (415, 413)
   and a.status != -1
;

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dim_book_chapter_info
-- workflow_version : 21
-- create_user      : yanxh
-- task_name        : dim_book_chapter_info_de
-- task_version     : 2
-- update_time      : 2025-04-09 16:39:52
-- sql_path         : \starrocks\tbl_dim_book_chapter_info\dim_book_chapter_info_de
----------------------------------------------------------------
-- SQL语句
-- 德语书籍，20241021新增，陈星需求----
insert into dim.dim_book_chapter_info
select book_id,site_id,serial_number,chapter_id,chapter_name,chapter_length,public_time,timer,book_name,new_cid,
       new_cname,language_id,is_full,sexy2,Free_Chapter_Num ,create_time,etl_time
from (
         select (a.book_id*1000+a.site_id) as book_id ,a.site_id,a.serial_number,a.chapter_id,a.chapter_name,a.chapter_length,
                a.public_time, b.bookname as book_name,b.newcid as new_cid,b.newcname as new_cname,b.Language as language_id,
                b.isfull as is_full,b.sexy2 ,
                case when b.FreeChapterNum=0 then a.vip
                     when b.FreeChapterNum>0 and  b.FreeChapterNum<a.serial_number then 1 else 0 end  as Free_Chapter_Num ,
                CURRENT_TIMESTAMP() as  etl_time,a.timer,a.create_time
         from ods.ods_edit_shuangwen_chapter a
                  left join ods.ods_book_novel_book_m b on (a.book_id*1000+a.site_id)=b.bookid and a.site_id =b.SiteID  and b.productid =3311
         where  a.Productid =3311
           and a.site_id =412
           and a.status!=-1  ) a ;

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dim_book_chapter_info
-- workflow_version : 21
-- create_user      : yanxh
-- task_name        : dim_book_chapter_info_en
-- task_version     : 4
-- update_time      : 2025-11-20 14:24:24
-- sql_path         : \starrocks\tbl_dim_book_chapter_info\dim_book_chapter_info_en
----------------------------------------------------------------
-- SQL语句
insert into dim.dim_book_chapter_info
--  英语 韩语、菲律宾、越南语 书籍 ----
select book_id,site_id,serial_number,chapter_id,chapter_name,chapter_length,public_time,timer,book_name,new_cid,
       new_cname,language_id,is_full,sexy2,Free_Chapter_Num ,create_time,etl_time
from (
         select (a.book_id*1000+a.site_id) as book_id ,a.site_id,a.serial_number,a.chapter_id,a.chapter_name,a.chapter_length,
                a.public_time, b.bookname as book_name,b.newcid as new_cid,b.newcname as new_cname,b.Language as language_id,
                b.isfull as is_full,b.sexy2 ,
                case when b.FreeChapterNum=0 then a.vip
                     when b.FreeChapterNum>0 and  b.FreeChapterNum<a.serial_number then 1 else 0 end  as Free_Chapter_Num ,
                CURRENT_TIMESTAMP() as  etl_time,a.timer,a.create_time
         from ods.ods_edit_shuangwen_chapter a
                  left join ods.ods_book_novel_book_m b on (a.book_id*1000+a.site_id)=b.bookid and a.site_id =b.SiteID  and b.productid =3366
         where  a.Productid =3366
           and a.site_id  in (322,436,445,435,497)
           and (a.status!=-1 or a.book_id in (61541,58462,58465,60227,60607,58458,58464,58459,61153,61538))   ----兼容部分书籍删除的章节id（2024-09-13）
     ) a
;

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dim_book_chapter_info
-- workflow_version : 21
-- create_user      : yanxh
-- task_name        : dim_book_chapter_info_fr
-- task_version     : 2
-- update_time      : 2025-04-09 16:39:52
-- sql_path         : \starrocks\tbl_dim_book_chapter_info\dim_book_chapter_info_fr
----------------------------------------------------------------
-- SQL语句
insert into dim.dim_book_chapter_info
-- 法语书籍----
select book_id,site_id,serial_number,chapter_id,chapter_name,chapter_length,public_time,timer,book_name,new_cid,
       new_cname,language_id,is_full,sexy2,Free_Chapter_Num ,create_time,etl_time
from (
         select (a.book_id*1000+a.site_id) as book_id ,a.site_id,a.serial_number,a.chapter_id,a.chapter_name,a.chapter_length,
                a.public_time, b.bookname as book_name,b.newcid as new_cid,b.newcname as new_cname,b.Language as language_id,
                b.isfull as is_full,b.sexy2 ,
                case when b.FreeChapterNum=0 then a.vip
                     when b.FreeChapterNum>0 and  b.FreeChapterNum<a.serial_number then 1 else 0 end  as Free_Chapter_Num ,
                CURRENT_TIMESTAMP() as  etl_time,a.timer,a.create_time
         from ods.ods_edit_shuangwen_chapter a
                  left join ods.ods_book_novel_book_m b on (a.book_id*1000+a.site_id)=b.bookid and a.site_id =b.SiteID  and b.productid =3311
         where  a.Productid =3311
           and a.site_id =410
           and a.status!=-1  ) a ;

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dim_book_chapter_info
-- workflow_version : 21
-- create_user      : yanxh
-- task_name        : dim_book_chapter_info_ft
-- task_version     : 2
-- update_time      : 2025-04-09 16:39:52
-- sql_path         : \starrocks\tbl_dim_book_chapter_info\dim_book_chapter_info_ft
----------------------------------------------------------------
-- SQL语句
insert into dim.dim_book_chapter_info
--  繁体书籍 ----
select book_id,site_id,serial_number,chapter_id,chapter_name,chapter_length,public_time,timer,book_name,new_cid,
       new_cname,language_id,is_full,sexy2,Free_Chapter_Num ,create_time,etl_time
from (
         select  a.book_id  ,333 as site_id,a.serial_number,a.chapter_id,a.chapter_name,a.chapter_length,a.public_time,
                 b.bookname book_name,b.newcid new_cid,b.newcname new_cname,b.Language as language_id,b.isfull is_full,
                 b.sexy2 , case when b.FreeChapterNum=0 then a.vip
                                when b.FreeChapterNum>0 and  b.FreeChapterNum<a.serial_number then 1 else 0 end  as Free_Chapter_Num
                 ,CURRENT_TIMESTAMP() as  etl_time,a.timer,a.create_time
         from ods.ods_book_novel_chaptersync a
                  left join (
             select bookid , bookname ,newcid, newcname, Language,isfull,sexy2,freechapternum
             from ods.ods_book_novel_book_m
             where productid=3333
         ) b on a.book_id=b.bookid
                  join (
             select book_id from  dws.dws_read_user_readbook_ed drurd where dt>='2020-06-01' and product_id in (3333,8858,7757) group by 1
         ) c on a.book_id = c.book_id) a ;

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dim_book_chapter_info
-- workflow_version : 21
-- create_user      : yanxh
-- task_name        : dim_book_chapter_info_id
-- task_version     : 2
-- update_time      : 2025-04-09 16:39:52
-- sql_path         : \starrocks\tbl_dim_book_chapter_info\dim_book_chapter_info_id
----------------------------------------------------------------
-- SQL语句
insert into dim.dim_book_chapter_info
-- 印尼语书籍----
select book_id,site_id,serial_number,chapter_id,chapter_name,chapter_length,public_time,timer,book_name,new_cid,
       new_cname,language_id,is_full,sexy2,Free_Chapter_Num ,create_time,etl_time
from (
         select (a.book_id*1000+a.site_id) as book_id ,a.site_id,a.serial_number,a.chapter_id,a.chapter_name,a.chapter_length,
                a.public_time, b.bookname as book_name,b.newcid as new_cid,b.newcname as new_cname,b.Language as language_id,
                b.isfull as is_full,b.sexy2 ,
                case when b.FreeChapterNum=0 then a.vip
                     when b.FreeChapterNum>0 and  b.FreeChapterNum<a.serial_number then 1 else 0 end  as Free_Chapter_Num ,
                CURRENT_TIMESTAMP() as  etl_time,a.timer,a.create_time
         from ods.ods_edit_shuangwen_chapter a
                  left join ods.ods_book_novel_book_m b on (a.book_id*1000+a.site_id)=b.bookid and a.site_id =b.SiteID  and b.productid =3501
         where  a.Productid =3311
           and a.site_id =414
           and a.status!=-1) a ;

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dim_book_chapter_info
-- workflow_version : 21
-- create_user      : yanxh
-- task_name        : dim_book_chapter_info_jp
-- task_version     : 2
-- update_time      : 2025-04-09 16:39:52
-- sql_path         : \starrocks\tbl_dim_book_chapter_info\dim_book_chapter_info_jp
----------------------------------------------------------------
-- SQL语句
insert into dim.dim_book_chapter_info
--  日语书籍 ----
select book_id,site_id,serial_number,chapter_id,chapter_name,chapter_length,public_time,timer,book_name,new_cid,
       new_cname,language_id,is_full,sexy2,Free_Chapter_Num ,create_time,etl_time
from (
         select (a.book_id*1000+a.site_id) as book_id ,a.site_id,a.serial_number,a.chapter_id,a.chapter_name,a.chapter_length,
                a.public_time, b.bookname as book_name,b.newcid as new_cid,b.newcname as new_cname,b.Language as language_id,
                b.isfull as is_full,b.sexy2 ,
                case when b.FreeChapterNum=0 then a.vip
                     when b.FreeChapterNum>0 and  b.FreeChapterNum<a.serial_number then 1 else 0 end  as Free_Chapter_Num ,
                CURRENT_TIMESTAMP() as  etl_time,a.timer,a.create_time
         from ods.ods_edit_shuangwen_chapter a
                  left join ods.ods_book_novel_book_m b on (a.book_id*1000+a.site_id)=b.bookid and a.site_id =b.SiteID  and b.productid =3399
         where  a.Productid =3311
           and a.site_id  in (419)
           and a.status!=-1 ) a  ;

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dim_book_chapter_info
-- workflow_version : 21
-- create_user      : yanxh
-- task_name        : dim_book_chapter_info_pt
-- task_version     : 2
-- update_time      : 2025-04-09 16:39:52
-- sql_path         : \starrocks\tbl_dim_book_chapter_info\dim_book_chapter_info_pt
----------------------------------------------------------------
-- SQL语句
insert into dim.dim_book_chapter_info
-- 葡语书籍----
select book_id,site_id,serial_number,chapter_id,chapter_name,chapter_length,public_time,timer,book_name,new_cid,
       new_cname,language_id,is_full,sexy2,Free_Chapter_Num ,create_time,etl_time
from (
         select (a.book_id*1000+a.site_id) as book_id ,a.site_id,a.serial_number,a.chapter_id,a.chapter_name,a.chapter_length,
                a.public_time, b.bookname as book_name,b.newcid as new_cid,b.newcname as new_cname,b.Language as language_id,
                b.isfull as is_full,b.sexy2 ,
                case when b.FreeChapterNum=0 then a.vip
                     when b.FreeChapterNum>0 and  b.FreeChapterNum<a.serial_number then 1 else 0 end  as Free_Chapter_Num ,
                CURRENT_TIMESTAMP() as  etl_time,a.timer,a.create_time
         from ods.ods_edit_shuangwen_chapter a
                  left join ods.ods_book_novel_book_m b on (a.book_id*1000+a.site_id)=b.bookid and a.site_id =b.SiteID  and b.productid =3322
         where  a.Productid =3322
           and a.site_id =409
           and a.status!=-1) a ;

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dim_book_chapter_info
-- workflow_version : 21
-- create_user      : yanxh
-- task_name        : dim_book_chapter_info_ru
-- task_version     : 2
-- update_time      : 2025-04-09 16:39:52
-- sql_path         : \starrocks\tbl_dim_book_chapter_info\dim_book_chapter_info_ru
----------------------------------------------------------------
-- SQL语句
insert into dim.dim_book_chapter_info
--  俄语书籍 ----
select book_id,site_id,serial_number,chapter_id,chapter_name,chapter_length,public_time,timer,book_name,new_cid,
       new_cname,language_id,is_full,sexy2,Free_Chapter_Num ,create_time,etl_time
from (
         select (a.book_id*1000+a.site_id) as book_id ,a.site_id,a.serial_number,a.chapter_id,a.chapter_name,a.chapter_length,
                a.public_time, b.bookname as book_name,b.newcid as new_cid,b.newcname as new_cname,b.Language as language_id,
                b.isfull as is_full,b.sexy2 ,
                case when b.FreeChapterNum=0 then a.vip
                     when b.FreeChapterNum>0 and  b.FreeChapterNum<a.serial_number then 1 else 0 end  as Free_Chapter_Num ,
                CURRENT_TIMESTAMP() as  etl_time,a.timer,a.create_time
         from ods.ods_edit_shuangwen_chapter a
                  left join ods.ods_book_novel_book_m b on (a.book_id*1000+a.site_id)=b.bookid and a.site_id =b.SiteID  and b.productid =3371
         where  a.Productid =3311
           and a.site_id  in (418)
           and a.status!=-1) a ;

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dim_book_chapter_info
-- workflow_version : 21
-- create_user      : yanxh
-- task_name        : dim_book_chapter_info_sp
-- task_version     : 2
-- update_time      : 2025-04-09 16:39:52
-- sql_path         : \starrocks\tbl_dim_book_chapter_info\dim_book_chapter_info_sp
----------------------------------------------------------------
-- SQL语句
insert into dim.dim_book_chapter_info
--  西语书籍 ----
select book_id,site_id,serial_number,chapter_id,chapter_name,chapter_length,public_time,timer,book_name,new_cid,
       new_cname,language_id,is_full,sexy2,Free_Chapter_Num ,create_time,etl_time
from (
         select (a.book_id*1000+a.site_id) as book_id ,a.site_id,a.serial_number,a.chapter_id,a.chapter_name,a.chapter_length,
                a.public_time, b.bookname as book_name,b.newcid as new_cid,b.newcname as new_cname,b.Language as language_id,
                b.isfull as is_full,b.sexy2 ,
                case when b.FreeChapterNum=0 then a.vip
                     when b.FreeChapterNum>0 and  b.FreeChapterNum<a.serial_number then 1 else 0 end  as Free_Chapter_Num ,
                CURRENT_TIMESTAMP() as  etl_time,a.timer,a.create_time
         from ods.ods_edit_shuangwen_chapter a
                  left join ods.ods_book_novel_book_m b on (a.book_id*1000+a.site_id)=b.bookid and a.site_id =b.SiteID  and b.productid =3388
         where  a.Productid =3388
           and a.site_id  in (375)
           and a.status!=-1) a ;

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dim_book_chapter_info
-- workflow_version : 21
-- create_user      : yanxh
-- task_name        : dim_book_chapter_info_th
-- task_version     : 2
-- update_time      : 2025-04-09 16:39:52
-- sql_path         : \starrocks\tbl_dim_book_chapter_info\dim_book_chapter_info_th
----------------------------------------------------------------
-- SQL语句
insert into dim.dim_book_chapter_info
-- 泰语书籍----
select book_id,site_id,serial_number,chapter_id,chapter_name,chapter_length,public_time,timer,book_name,new_cid,
       new_cname,language_id,is_full,sexy2,Free_Chapter_Num ,create_time,etl_time
from (
         select (a.book_id*1000+a.site_id) as book_id ,a.site_id,a.serial_number,a.chapter_id,a.chapter_name,a.chapter_length,
                a.public_time, b.bookname as book_name,b.newcid as new_cid,b.newcname as new_cname,b.Language as language_id,
                b.isfull as is_full,b.sexy2 ,
                case when b.FreeChapterNum=0 then a.vip
                     when b.FreeChapterNum>0 and  b.FreeChapterNum<a.serial_number then 1 else 0 end  as Free_Chapter_Num ,
                CURRENT_TIMESTAMP() as  etl_time,a.timer,a.create_time
         from ods.ods_edit_shuangwen_chapter a
                  left join ods.ods_book_novel_book_m b on (a.book_id*1000+a.site_id)=b.bookid and a.site_id =b.SiteID  and b.productid =3511
         where  a.Productid =3311
           and a.site_id =433
           and a.status!=-1) a ;
