create or replace view dwd.dwd_read_user_chapter_view(
     dt             comment "createtime 分区"
    ,product_id     comment "产品id"
    ,autoid         comment "自增id"
    ,book_id        comment "书籍id"
    ,chapter_id     comment "章节id"
    ,user_id        comment "用户id"
    ,prod_id        comment "x值（没有用）"
    ,create_time    comment "阅读时间"
    ,appid          comment "应用程序id"
    ,read_times     comment "阅读时长（秒）-没有用"
)
comment "书籍章节阅读记录"
as
select dt
      ,productid                                             as product_id
      ,id                                                    as autoid
      ,if(bookid is null, -99, bookid)                       as book_id
      ,if(chapterid is null, -99, chapterid)                 as chapter_id
      ,userid                                                as user_id
      ,if((prodid is null) or (prodid = ''), -99, prodid)    as prod_id
      ,createtime                                            as create_time
      ,if(appid is null, -99, appid)                         as appid
      ,time                                                  as read_times
  from ods_log.ods_book_user_readchapter
;