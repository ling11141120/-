----------------------------------------------------------------
-- 程序功能： 书籍章节信息表
-- 程序名： P_dim_book_chapter_info
-- 目标表： dim.dim_book_chapter_info
-- 负责人： qhr
-- 开发日期： 2026-02-11
----------------------------------------------------------------

-- 法语书籍
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
   and b.productid = 3311
 where a.Productid = 3311
   and a.site_id = 410
   and a.status != -1
;

-- 印尼语书籍
insert into dim.dim_book_chapter_info
select a.book_id * 1000 + a.site_id      as book_id
     , a.site_id
     , a.serial_number
     , a.chapter_id
     , a.chapter_name
     , a.chapter_length
     , a.public_time
     , a.timer
     , b.bookname                        as book_name
     , b.newcid                          as new_cid
     , b.newcname                        as new_cname
     , b.Language                        as language_id
     , b.isfull                          as is_full
     , b.sexy2
     , case when b.FreeChapterNum = 0 then a.vip
            when b.FreeChapterNum > 0 and b.FreeChapterNum < a.serial_number then 1
            else 0
       end                               as Free_Chapter_Num
     , a.create_time
     , current_timestamp()               as etl_time
  from ods.ods_edit_shuangwen_chapter    as a
  left join ods.ods_book_novel_book_m    as b
    on (a.book_id * 1000 + a.site_id) = b.bookid
   and a.site_id = b.SiteID
   and b.productid = 3501
 where a.Productid = 3311
   and a.site_id = 414
   and a.status != -1
;

-- 泰语书籍
insert into dim.dim_book_chapter_info
select a.book_id * 1000 + a.site_id      as book_id
     , a.site_id
     , a.serial_number
     , a.chapter_id
     , a.chapter_name
     , a.chapter_length
     , a.public_time
     , a.timer
     , b.bookname                        as book_name
     , b.newcid                          as new_cid
     , b.newcname                        as new_cname
     , b.Language                        as language_id
     , b.isfull                          as is_full
     , b.sexy2
     , case when b.FreeChapterNum = 0 then a.vip
            when b.FreeChapterNum > 0 and b.FreeChapterNum < a.serial_number then 1
            else 0
        end                              as Free_Chapter_Num
     , a.create_time
     , current_timestamp()               as etl_time
  from ods.ods_edit_shuangwen_chapter    as a
  left join ods.ods_book_novel_book_m    as b
    on (a.book_id * 1000 + a.site_id) = b.bookid
   and a.site_id = b.SiteID
   and b.productid = 3511
 where a.Productid = 3311
   and a.site_id = 433
   and a.status != -1
;

-- 葡语书籍
insert into dim.dim_book_chapter_info
select (a.book_id * 1000 + a.site_id)    as book_id
     , a.site_id
     , a.serial_number
     , a.chapter_id
     , a.chapter_name
     , a.chapter_length
     , a.public_time
     , a.timer
     , b.bookname                        as book_name
     , b.newcid                          as new_cid
     , b.newcname                        as new_cname
     , b.Language                        as language_id
     , b.isfull                          as is_full
     , b.sexy2
     , case when b.FreeChapterNum = 0 then a.vip
            when b.FreeChapterNum > 0 and b.FreeChapterNum < a.serial_number then 1
            else 0
       end                               as Free_Chapter_Num
     , a.create_time
     , current_timestamp()               as etl_time
  from ods.ods_edit_shuangwen_chapter    as a
  left join ods.ods_book_novel_book_m    as b
    on (a.book_id * 1000 + a.site_id) = b.bookid
   and a.site_id = b.SiteID
   and b.productid = 3322
 where a.Productid = 3322
   and a.site_id = 409
   and a.status != -1
;

-- 英语 韩语、菲律宾、越南语 书籍
insert into dim.dim_book_chapter_info
select (a.book_id * 1000 + a.site_id)    as book_id
     , a.site_id
     , a.serial_number
     , a.chapter_id
     , a.chapter_name
     , a.chapter_length
     , a.public_time
     , a.timer
     , b.bookname                        as book_name
     , b.newcid                          as new_cid
     , b.newcname                        as new_cname
     , b.Language                        as language_id
     , b.isfull                          as is_full
     , b.sexy2
     , case when b.FreeChapterNum = 0 then a.vip
            when b.FreeChapterNum > 0 and b.FreeChapterNum < a.serial_number then 1
            else 0
       end                               as Free_Chapter_Num
     , a.create_time
     , current_timestamp()               as etl_time
  from ods.ods_edit_shuangwen_chapter    as a
  left join ods.ods_book_novel_book_m    as b
    on (a.book_id * 1000 + a.site_id) = b.bookid
   and a.site_id = b.SiteID
   and b.productid = 3366
 where a.Productid = 3366
   and a.site_id in (322, 436, 445, 435, 497)
   and (a.status != -1 or a.book_id in (61541, 58462, 58465, 60227, 60607, 58458, 58464, 58459, 61153, 61538)) ----兼容部分书籍删除的章节id（2024-09-13）
;

-- 西语书籍
insert into dim.dim_book_chapter_info
select (a.book_id * 1000 + a.site_id)    as book_id
     , a.site_id
     , a.serial_number
     , a.chapter_id
     , a.chapter_name
     , a.chapter_length
     , a.public_time
     , a.timer
     , b.bookname                        as book_name
     , b.newcid                          as new_cid
     , b.newcname                        as new_cname
     , b.Language                        as language_id
     , b.isfull                          as is_full
     , b.sexy2
     , case when b.FreeChapterNum = 0 then a.vip
            when b.FreeChapterNum > 0 and b.FreeChapterNum < a.serial_number then 1
            else 0
       end                               as Free_Chapter_Num
     , a.create_time
     , current_timestamp()               as etl_time
  from ods.ods_edit_shuangwen_chapter    as a
  left join ods.ods_book_novel_book_m    as b
    on (a.book_id * 1000 + a.site_id) = b.bookid
   and a.site_id = b.SiteID
   and b.productid = 3388
 where a.Productid = 3388
   and a.site_id = 375
   and a.status != -1
;

-- 俄语书籍
insert into dim.dim_book_chapter_info
select (a.book_id * 1000 + a.site_id)    as book_id
     , a.site_id
     , a.serial_number
     , a.chapter_id
     , a.chapter_name
     , a.chapter_length
     , a.public_time
     , a.timer
     , b.bookname                        as book_name
     , b.newcid                          as new_cid
     , b.newcname                        as new_cname
     , b.Language                        as language_id
     , b.isfull                          as is_full
     , b.sexy2
     , case when b.FreeChapterNum = 0 then a.vip
            when b.FreeChapterNum > 0 and b.FreeChapterNum < a.serial_number then 1
            else 0
       end                               as Free_Chapter_Num
     , a.create_time
     , current_timestamp()               as etl_time
  from ods.ods_edit_shuangwen_chapter    as a
  left join ods.ods_book_novel_book_m    as b
    on (a.book_id * 1000 + a.site_id) = b.bookid
   and a.site_id = b.SiteID
   and b.productid = 3371
 where a.Productid = 3311
   and a.site_id = 418
   and a.status != -1
;

-- 日语书籍
insert into dim.dim_book_chapter_info
select (a.book_id * 1000 + a.site_id)    as book_id
     , a.site_id
     , a.serial_number
     , a.chapter_id
     , a.chapter_name
     , a.chapter_length
     , a.public_time
     , a.timer
     , b.bookname                        as book_name
     , b.newcid                          as new_cid
     , b.newcname                        as new_cname
     , b.Language                        as language_id
     , b.isfull                          as is_full
     , b.sexy2
     , case when b.FreeChapterNum = 0 then a.vip
            when b.FreeChapterNum > 0 and b.FreeChapterNum < a.serial_number then 1
            else 0
       end                               as Free_Chapter_Num
     , a.create_time
     , current_timestamp()               as etl_time
  from ods.ods_edit_shuangwen_chapter    as a
  left join ods.ods_book_novel_book_m    as b
    on (a.book_id * 1000 + a.site_id) = b.bookid
   and a.site_id = b.SiteID
   and b.productid = 3399
 where a.Productid = 3311
   and a.site_id = 419
   and a.status != -1
;

-- 繁体书籍
insert into dim.dim_book_chapter_info
select a.book_id
     , 333                 as site_id
     , a.serial_number
     , a.chapter_id
     , a.chapter_name
     , a.chapter_length
     , a.public_time
     , a.timer
     , b.bookname          as book_name
     , b.newcid            as new_cid
     , b.newcname          as new_cname
     , b.Language          as language_id
     , b.isfull            as is_full
     , b.sexy2
     , case when b.FreeChapterNum = 0 then a.vip
            when b.FreeChapterNum > 0 and b.FreeChapterNum < a.serial_number then 1
            else 0
       end                 as Free_Chapter_Num
     , a.create_time
     , current_timestamp() as etl_time
  from ods.ods_book_novel_chaptersync as a
  left join ods.ods_book_novel_book_m as b
    on a.book_id = b.bookid
   and b.productid = 3333
  join (select book_id
          from dws.dws_read_user_readbook_ed drurd
         where dt >= '2020-06-01'
           and product_id in (3333, 8858, 7757)
         group by 1
       )                              as c
    on a.book_id = c.book_id
;

-- 德语书籍
insert into dim.dim_book_chapter_info
select (a.book_id * 1000 + a.site_id) as book_id
     , a.site_id
     , a.serial_number
     , a.chapter_id
     , a.chapter_name
     , a.chapter_length
     , a.public_time
     , a.timer
     , b.bookname                     as book_name
     , b.newcid                       as new_cid
     , b.newcname                     as new_cname
     , b.Language                     as language_id
     , b.isfull                       as is_full
     , b.sexy2
     , case when b.FreeChapterNum = 0 then a.vip
            when b.FreeChapterNum > 0 and b.FreeChapterNum < a.serial_number then 1
            else 0
       end                            as Free_Chapter_Num
     , a.create_time
     , current_timestamp()            as etl_time
  from ods.ods_edit_shuangwen_chapter a
  left join ods.ods_book_novel_book_m b
    on (a.book_id * 1000 + a.site_id) = b.bookid
   and a.site_id = b.SiteID
   and b.productid = 3311
 where a.Productid = 3311
   and a.site_id = 412
   and a.status != -1
;

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