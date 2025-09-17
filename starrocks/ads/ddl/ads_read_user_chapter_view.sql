CREATE OR REPLACE VIEW ads.ads_read_user_chapter_view (
     dt                   COMMENT "createtime 分区"
    ,product_id           COMMENT "产品id"
    ,id                   COMMENT "自增id"
    ,book_id              COMMENT "书籍id"
    ,chapter_id           COMMENT "章节id"
    ,user_id              COMMENT "用户id"
    ,prod_id              COMMENT "x值（没有用）"
    ,create_time          COMMENT "阅读时间"
    ,appid                COMMENT "应用程序id"
    ,mt                   COMMENT "用户终端 0未知 1iphone 4安卓 9书城"    --新增字段
    ,read_times           COMMENT "阅读时长（秒）-没有用"
)
COMMENT "书籍章节阅读记录"
AS
select dt                                                             as dt
      ,productid                                                      as product_id
      ,id                                                             as id
      ,if((bookid is null) or (bookid = ''), -99, bookid)             as book_id
      ,if((chapterid is null) or (chapterid = ''), -99, chapterid)    as chapter_id
      ,userid                                                         as user_id
      ,if((prodid is null) or (prodid = ''), -99, prodid)             as prod_id
      ,createtime                                                     as create_time
      ,if((appid is null) or (appid = ''), -99, appid)                as appid
      ,coalesce(mt,'-99')                                             as mt
      ,time                                                           as read_times
  from ods_log.ods_book_user_readchapter   as a
  left join dim.dim_user_all_info          as b
    on a.userid=b.user_id
   and a.productid=b.product_id
;