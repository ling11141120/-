----------------------------------------------------------------
-- 程序功能： 长篇孵化-书籍评论看板
-- 程序名： P_ads_content_book_comment_info
-- 目标表： ads.ads_content_book_comment_info
-- 负责人： xjc
-- 开发日期： 2026-02-12
-- 版本号： v0.0.1
----------------------------------------------------------------

insert into ads.ads_content_book_comment_info
select
     a1.dt                                          as dt              -- 分区日期
    ,a1.productid                                   as product_id      -- 产品id
    ,a1.id                                          as id              -- 评论id
    ,if(length(a1.chapterid)>1,3,1)                 as comment_type    -- 评论类型
    ,substr(a1.pid,1,length(a1.pid)-3)              as book_id         -- 书籍id
    ,a2.BookName                                    as book_name       -- 书籍名称
    ,a2.BookCode                                    as book_code       -- 书籍代号
    ,regexp_extract(BookCode, '^([A-Za-z]+)', 1)    as book_series     -- 系列
    ,right(a1.pid, 3)                               as site_id         -- 数据语言site_id
    ,a2.Language                                    as language_id     -- 书籍语言
    ,a2.StoryType                                   as story_type      -- 长短篇信息
    ,a1.content                                     as content         -- 评论内容
    ,a1.chapterid                                   as chapterid       -- 评论对应的章节id
    ,null                                           as paraindex       -- 段落索引
    ,a1.classify                                    as classify        -- 评论属性 0,1:正常评论 2:垃圾评论
    ,a1.spamsource                                  as spamsource      -- 被标记的垃圾源
    ,a1.sendtime                                    as sendtime        -- 评论发送时间
    ,now()                                          as etl_tm          -- etl清洗时间
  from ods.ods_tidb_readernovel_tidb_xx_bookcommentitem    as a1
  join ods.ods_edit_book                                   as a2
    on a1.productid = a2.productid
   and a1.pid=a2.BookId*1000+a2.SiteId
   and a2.IsWashingBook = 1
 where a1.dt = '${bf_1_dt}'
   and a1.bookcommenttype = 0
 union all
select
     a1.dt                                          as dt              -- 分区日期
    ,a1.productid                                   as product_id      -- 产品id
    ,a1.id                                          as id              -- 评论id
    ,2                                              as comment_type    -- 评论类型
    ,substr(a1.pid,1,length(a1.pid)-3)              as book_id         -- 书籍id
    ,a2.BookName                                    as book_name       -- 书籍名称
    ,a2.BookCode                                    as book_code       -- 书籍代号
    ,regexp_extract(BookCode, '^([A-Za-z]+)', 1)    as book_series     -- 系列
    ,right(a1.pid, 3)                               as site_id         -- 数据语言site_id
    ,a2.Language                                    as language_id     -- 书籍语言
    ,a2.StoryType                                   as story_type      -- 长短篇信息
    ,a1.content                                     as content         -- 评论内容
    ,a1.chapterid                                   as chapterid       -- 评论对应的章节id
    ,paraindex                                      as paraindex       -- 段落索引
    ,a1.classify                                    as classify        -- 评论鉴别 0,1:正常评论 2:垃圾评论
    ,a1.spamsource                                  as spamsource      -- 被标记的垃圾源
    ,a1.sendtime                                    as sendtime        -- 评论发送时间
    ,now()                                          as etl_tm          -- etl清洗时间
  from ods.ods_tidb_readernovel_tidb_xx_paragraphcommentitem    as a1
  join ods_edit_book                                            as a2
    on a1.productid = a2.productid
   and a1.pid=a2.BookId*1000+a2.SiteId
   and a2.IsWashingBook = 1
 where a1.dt = '${bf_1_dt}'
;
