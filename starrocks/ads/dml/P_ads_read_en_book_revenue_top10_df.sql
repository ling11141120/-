----------------------------------------------------------------
-- 程序功能： 英文小说收入TOP10书籍信息
-- 程序名： P_ads_read_en_book_revenue_top10_df
-- 目标表： ads.ads_read_en_book_revenue_top10_df
-- 负责人： xjc
-- 开发日期：2026-03-01
-- 版本号： v0.0.0
----------------------------------------------------------------

insert into ads.ads_read_en_book_revenue_top10_df
with amount as (
    select '${bf_1_dt}'                       as dt
          ,a1.book_id                         as en_book_id
          ,a2.BookId                          as src_book_id
          ,coalesce(a2.BookId, a1.book_id)    as book_id
          ,if(a2.BookId is null, 0, 1)        as is_translated_from_zh
          ,sum(amount)                        as revenue
      from dwd.dwd_consume_user_consume    as a1
      left join (select concat(SwBookId, ToLanguage)    as SwBookId
                       ,FromLanguage
                       ,BookId 
                   from ods.ods_tidb_shuangwen_en_objectbook
                  where IsCustom = 0
                    and FromLanguage = 0
                  group by 1, 2, 3
                )                          as a2
        on a1.book_id = a2.SwBookId
      join (select BookID
              from ods.ods_book_novel_book_m
             where productid = 3366
               and SiteID = 322
             group by 1
           )                               as a3
        on a1.book_id = a3.bookid
     where a1.dt between '${bf_7_dt}'
       and '${bf_1_dt}'
       and a1.product_id = 3366
       and a1.types = 1
       and a1.book_id != 0
     group by 1, 2, 3, 4, 5
     order by sum(amount) desc
     limit 20
)
, tag as (
    select a1.bookid
          ,group_concat(distinct a2.Tag)    as tag_name
      from ods.ods_tidb_shuangwen_tidb_xx_tagbookinfo       as a1
      left join ods.ods_tidb_shuangwen_tidb_xx_tagconfig    as a2
        on a1.tagid = a2.id
       and a1.product_id = a2.product_id
     where a1.product_id = 3366
       and a1.isdelete = 0
       and a2.isdelete = 0
     group by 1
     union all
    select a1.bookid
          ,group_concat(distinct a2.Tag)    as tag_name
      from ods.ods_mysql_zhangzhong_xzz_tagbookinfo       as a1
      left join ods.ods_mysql_zhangzhong_xzz_tagconfig    as a2
        on a1.tagid = a2.id
     where a1.isdelete = 0
       and a2.isdelete = 0
     group by 1
)
, novel_book as (
    select BookID
          ,BookName
          ,SiteID
          ,Introduce 
          ,Alias
          ,row_number() over (partition by BookID, SiteID order by productid)    as rn
      from ods.ods_book_novel_book_m
)
select a1.dt
      ,a1.book_id
      ,a2.bookname
      ,a3.bookcode
      ,a2.siteid
      ,row_number() over (partition by a1.dt order by a1.revenue desc)    as rank
      ,a1.revenue
      ,a1.en_book_id                                                      as source_book_id
      ,is_translated_from_zh
      ,coalesce(a5.tag_name, a2.Alias)                                    as tag_name
      ,a2.Introduce
      ,now()                                                              as etl_tm
  from amount      as a1
  left join (select BookID
                   ,BookName
                   ,SiteID
                   ,Introduce 
                   ,Alias
               from novel_book
              where rn = 1
            )      as a2
    on a1.book_id = a2.BookID
  left join (select concat(BookId, lpad(siteid, 3, 0))    as book_id
                   ,BookCode 
               from ods.ods_edit_book
              group by 1, 2
              union
             select concat(BookId, lpad(siteid, 3, 0))    as book_id
                   ,BookCode 
               from ods.ods_mysql_zhangzhong_xzz_Book
              group by 1, 2
              union
             select book_id
                   ,Book_Code 
               from dim.dim_shuangwen_book_read_consume_info
              group by 1, 2
            )      as a3
    on a1.book_id = a3.book_id
  left join tag    as a5
    on a1.book_id = a5.bookid
;