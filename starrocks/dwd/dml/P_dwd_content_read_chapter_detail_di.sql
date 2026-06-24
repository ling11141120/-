----------------------------------------------------------------
-- 程序功能： 内容域-用户章节阅读明细事实表
-- 程序名： P_dwd_content_read_chapter_detail_di
-- 目标表： dwd.dwd_content_read_chapter_detail_di
-- 负责人： qhr
-- 开发日期：2026-06-16
----------------------------------------------------------------

delete from dwd.dwd_content_read_chapter_detail_di where dt = '${bf_1_dt}';

insert into dwd.dwd_content_read_chapter_detail_di
select dt
     , Productid                                            as product_id
     , Id                                                   as autoid
     , if(BookId is null, -99, BookId)                      as book_id
     , if(ChapterId is null, -99, ChapterId)                as chapter_id
     , UserId                                               as user_id
     , if((ProdId is null) or (ProdId = ''), '-99', ProdId) as prod_id
     , CreateTime                                           as create_time
     , if(AppId is null, -99, AppId)                        as appid
     , Time                                                 as read_times
     , now()                                                as etl_time
  from ods_log.ods_book_user_readchapter
 where dt = '${bf_1_dt}'
;
