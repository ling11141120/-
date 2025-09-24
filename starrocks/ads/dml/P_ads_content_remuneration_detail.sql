----------------------------------------------------------------
-- 程序功能： 实时稿酬
-- 程序名： P_ads_content_remuneration_detail
-- 目标表： ads.ads_content_remuneration_detail
-- 负责人： xjc
-- 开发日期：2025-09-24
-- 版本号： v0.0.0
----------------------------------------------------------------

insert into ads.ads_content_remuneration_detail
select md5(concat_ws('_'
                     ,date(CreateTime)
                     ,a.ToLanguage
                     ,a.AuthorId
                     ,a.RoleType
                     ,b.PenName
                     ,c.BookName
                     ,d.ChapterName
                    )
          )                as md5_key       -- 唯一主键
      ,date(CreateTime)    as dt            -- 统计日期（完成时间）
      ,a.ToLanguage        as site_id       -- 语言ID
      ,a.AuthorId          as author_id     -- 译员ID
      ,a.RoleType          as role_type     -- 角色类型
      ,b.PenName           as pen_name      -- 译名
      ,a.bookId            as book_id       -- 书籍ID
      ,c.BookName          as book_name     -- 书名
      ,a.ChapterId         as chapter_id    -- 章节ID
      ,d.ChapterName       as chapter_name  -- 章节名
      ,now()               as etl_time      -- ETL时间
  from ods.ods_edit_book_RemunerationDetail a
  left join ods.ods_tidb_shuangwen_xx_objectauthor b
         on a.productid = b.productid
        and a.AuthorId = b.AccountId
        and a.ToLanguage = b.ToLanguage
  left join ods.ods_tidb_shuangwen_en_objectbook c
         on a.productid = c.productid
        and a.bookId = c.SwBookId
        and a.ToLanguage = c.ToLanguage
        and c.Status = 1
  left join ods.ods_tidb_shuangwen_xx_objectchapter d
         on a.productid = d.productid
        and c.id = d.ObjectBookId
        and a.ChapterId = d.Id
;