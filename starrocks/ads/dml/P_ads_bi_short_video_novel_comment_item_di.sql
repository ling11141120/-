----------------------------------------------------------------
-- 程序功能：海阅书籍评论同步至海剧 TiDB 源表
-- 程序名： P_ads_bi_short_video_novel_comment_item_di
-- 目标表：ads.ads_bi_short_video_novel_comment_item_di
-- 负责人：lwb
-- 开发日期：2026-06-24
----------------------------------------------------------------

delete from ads.ads_bi_short_video_novel_comment_item_di
 where send_time >= date_sub('${bf_1_dt}', interval 3 year)
   and send_time < date_add('${bf_1_dt}', interval 1 day);

insert into ads.ads_bi_short_video_novel_comment_item_di (
     id
    ,account_id
    ,nickname
    ,avatar
    ,book_id
    ,chapter_id
    ,ex_comment_id
    ,title
    ,content
    ,score
    ,comment_status
    ,top_time
    ,is_top
    ,is_choice
    ,is_author
    ,support_count
    ,reply_count
    ,classify
    ,classification
    ,comment_source
    ,my_classify
    ,hot_num
    ,audit_status
    ,spam_source
    ,book_comment_type
    ,send_time
    ,send_timestamp
    ,create_time
    ,update_time
)
select c.Id                                      as id
     , c.SenderId                                as account_id
     , coalesce(c.SenderName, '')                as nickname
     , cast(c.HeadId as varchar)                 as avatar
     , c.Pid                                     as book_id
     , c.ChapterId                               as chapter_id
     , c.ExCommentId                             as ex_comment_id
     , coalesce(c.Title, '')                     as title
     , c.Content                                 as content
     , c.Score                                   as score
     , c.CommentStatus                           as comment_status
     , c.TopTime                                as top_time
     , c.IsTop                                   as is_top
     , c.IsChoice                                as is_choice
     , c.IsAuthor                                as is_author
     , c.SupportCount                            as support_count
     , c.ReplyCount                              as reply_count
     , c.Classify                                as classify
     , c.Classification                          as classification
     , c.CommentSource                           as comment_source
     , c.MyClassify                              as my_classify
     , c.HotNum                                  as hot_num
     , c.IsCheck                                 as audit_status
     , c.spamsource                              as spam_source
     , c.bookcommenttype                         as book_comment_type
     , c.SendTime                                as send_time
     , unix_timestamp(c.SendTime)                as send_timestamp
     , c.SendTime                                as create_time
     , coalesce(c.UpdateTime, c.SendTime)         as update_time
  from ods.ods_tidb_readernovel_tidb_xx_bookcommentitem c
 where c.dt >= date_sub('${bf_1_dt}', interval 3 year)
   and c.dt <= '${bf_1_dt}'
   and c.Id > 0
   and c.SenderId > 0
   and c.Pid > 0
;
