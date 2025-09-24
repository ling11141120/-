----------------------------------------------------------------
-- 程序功能： 内容域--英语书籍翻译统计
-- 程序名： P_ads_content_en_book_stat
-- 目标表： ads.ads_content_en_book_stat
-- 负责人： xjc
-- 开发日期：2025-09-24
-- 版本号： v0.0.0
----------------------------------------------------------------

insert into ads.ads_content_en_book_stat
with jt_book_bf_1_dt as (
    select book_id
          ,app_font_length
      from dim.dim_ft_book_info
     where dt = '${bf_1_dt}'
)
,jt_book_bf_7_dt as (
    select book_id
          ,app_font_length
      from dim.dim_ft_book_info
     where dt = '${bf_7_dt}'
)
,jt_book_7days_words as (
    select a.book_id
          ,(a.app_font_length - b.app_font_length)  as 7days_words
      from jt_book_bf_1_dt a
      left join jt_book_bf_7_dt b
        on a.book_id = b.book_id
)
,en_book_chapter as (
    select a.SwBookId as book_id
          ,a.ToLanguage as site_id
          ,SUM(b.Length) as source_chapter_words
          ,SUM(b.EnLength) as target_chapter_words
     from ods.ods_tidb_shuangwen_en_objectbook a
     left join ods.ods_tidb_shuangwen_xx_objectchapter b
       on a.productid = b.productid
      and a.id = b.ObjectBookId
      and b.ChapterNumber <= 10
    where a.ToLanguage = 322
      and a.Status = 1
    group by a.SwBookId, a.ToLanguage
)
select a.dt
      ,a.book_id
      ,g.book_code
      ,a.putaway_status
      ,b.first_translate_day
      ,b.proofread_length
      ,c.target_chapter_words
      ,c.source_chapter_words
      ,e.app_font_length
      ,d.7days_words
      ,now()
  from ads.ads_content_book_publish_mgr a
  left join ads.ads_report_book_capacity_rate_stat b
    on a.dt = b.dt
   and a.book_id = b.book_id
  left join en_book_chapter c
    on a.book_id = (c.book_id * 1000 + c.site_id)
  left join dwd.dwd_edit_book_languagebooktotal_da f
    on a.book_id = f.to_book_id
   and f.dt = '${bf_1_dt}'
  left join jt_book_bf_1_dt e
    on f.from_book_id = e.book_id
  left join jt_book_7days_words d
    on f.from_book_id = d.book_id
  left join dim.dim_shuangwen_book_read_consume_info g
    on a.book_id = g.book_id
 where a.dt = '${bf_1_dt}'
   and a.language_name = '英语'
   and a.book_code != '-'
