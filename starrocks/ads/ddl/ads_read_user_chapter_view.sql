create or replace view ads.ads_read_user_chapter_view (
     dt                   comment "createtime 分区"
    ,product_id           comment "产品id"
    ,id                   comment "自增id"
    ,book_id              comment "书籍id"
    ,chapter_id           comment "章节id"
    ,user_id              comment "用户id"
    ,prod_id              comment "x值（没有用）"
    ,create_time          comment "阅读时间"
    ,appid                comment "应用程序id"
    ,mt                   comment "用户终端"
    ,read_times           comment "阅读时长（秒）-没有用"
)
comment "书籍章节阅读记录"
as
select a1.dt                                                                   as dt
      ,a1.productid                                                            as product_id
      ,a1.id                                                                   as id
      ,if((a1.bookid is null) or (a1.bookid = ''), -99, a1.bookid)             as book_id
      ,if((a1.chapterid is null) or (a1.chapterid = ''), -99, a1.chapterid)    as chapter_id
      ,a1.userid                                                               as user_id
      ,if((a1.prodid is null) or (a1.prodid = ''), -99, a1.prodid)             as prod_id
      ,a1.createtime                                                           as create_time
      ,if((a1.appid is null) or (a1.appid = ''), -99, a1.appid)                as appid
      ,coalesce(b1.mt,-99)                                                     as mt
      ,a1.time                                                                 as read_times
  from ods_log.ods_book_user_readchapter    as a1
  left join dim.dim_user_all_info           as b1
    on a1.userid=b1.user_id
   and a1.productid=b1.product_id
;