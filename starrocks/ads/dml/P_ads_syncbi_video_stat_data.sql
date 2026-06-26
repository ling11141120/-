----------------------------------------------------------------
-- 程序功能： 海阅书籍阅读统计数据同步至海剧
-- 程序名： P_ads_syncbi_video_stat_data
-- 目标表： ads.syncbi_video_stat_data
-- 负责人：lwbl
-- 开发日期： 2026-06-22
----------------------------------------------------------------
insert overwrite ads.syncbi_video_stat_data (
     productid
    ,AutoId
    ,BookId
    ,StatField
    ,RankClass
    ,Code
    ,Value
    ,realnum
    ,etl_tm
)
select a.productid
     , a.AutoId
     , a.BookId
     , a.StatField
     , a.RankClass
     , a.Code
     , a.Value
     , a.realnum
     , now() as etl_tm
  from ods.ods_tidb_readernovel_tidb_xx_stat_data a
 where a.StatField = 'ReadNum'
   and a.RankClass = 'Total'
   and exists (
       select 1
         from ods.ods_tidb_short_video_admin_novel_book b
        where b.bookid = a.BookId
   )
;
