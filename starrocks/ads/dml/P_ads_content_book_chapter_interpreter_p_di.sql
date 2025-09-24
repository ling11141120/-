----------------------------------------------------------------
-- 程序功能：内容域--书籍章节译员-稿酬表
-- 程序名： P_ads_content_book_chapter_interpreter_p_di
-- 目标表： ads.ads_content_book_chapter_interpreter_p_di
-- 负责人： xjc
-- 开发日期：2025-09-24
-- 版本号： v0.0.0 
----------------------------------------------------------------

insert into ads.ads_content_book_chapter_interpreter_p_di
with tmp_book_remuneration_detail as (
    select a.productid
          ,a.AuthorId
          ,a.bookId
          ,a.ChapterId
          ,a.ToLanguage
          ,a.FontLength
          ,a.CreateTime
          ,a.RoleType
          ,row_number() over(partition by productid, AuthorId, bookId, ChapterId order by CreateTime desc)    as row_num
      from ods.ods_edit_book_RemunerationDetail                                                               as a
     where date(a.CreateTime) = '${bf_1_dt}'
       and a.RoleType in (1, 2, 3)
)
select date(a.CreateTime)                             as dt
      ,a.AuthorId                                     as author_id
      ,a.bookId                                       as book_id
      ,a.ChapterId                                    as chapter_id
      ,a.ToLanguage                                   as site_id
      ,c.ObjectBookType                               as project_type
      ,b.PenName                                      as author_name
      ,a.RoleType                                     as role_type
      ,c.BookCode                                     as book_code
      ,c.BookName                                     as book_name
      ,d.ChapterName                                  as chapter_name
      ,a.FontLength                                   as font_length
      ,a.CreateTime                                   as create_time
      ,now()
  from tmp_book_remuneration_detail                   as a
  left join ods.ods_tidb_shuangwen_xx_objectauthor    as b
    on a.productid = b.productid
   and a.AuthorId = b.AccountId
   and a.ToLanguage = b.ToLanguage
  left join ods.ods_tidb_shuangwen_en_objectbook      as c
    on a.productid = c.productid
   and a.bookId = c.SwBookId
   and a.ToLanguage = c.ToLanguage
   and c.Status = 1
  left join ods.ods_tidb_shuangwen_xx_objectchapter   as d
    on a.productid = d.productid
   and c.id = d.ObjectBookId
   and a.ChapterId = d.Id
 where a.row_num = 1
