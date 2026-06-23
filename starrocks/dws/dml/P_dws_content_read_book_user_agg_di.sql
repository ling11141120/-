----------------------------------------------------------------
-- 程序功能： 内容域-用户书籍日阅读聚合表
-- 程序名： P_dws_content_read_book_user_agg_di
-- 目标表： dws.dws_content_read_book_user_agg_di
-- 负责人： qhr
-- 开发日期：2026-06-23
----------------------------------------------------------------

truncate table dws.dws_content_read_book_user_agg_di partition (${bf_1_dt_pname});

insert into dws.dws_content_read_book_user_agg_di
with day_detail as (
    select dt
         , product_id
         , autoid
         , user_id
         , book_id
         , chapter_id
         , create_time
         , coalesce(read_times, 0) as read_times
      from dwd.dwd_content_read_chapter_detail_di
     where dt = '${bf_1_dt}'
)
, day_agg as (
    select dt
         , product_id
         , user_id
         , book_id
         , min(create_time) as fst_read_tm
         , max(create_time) as lst_read_tm
         , count(1)         as read_cnt
         , sum(read_times)  as read_seconds
      from day_detail
     group by 1, 2, 3, 4
)
, timed_detail as (
    select dt
         , product_id
         , autoid
         , user_id
         , book_id
         , chapter_id
         , create_time
      from day_detail
     where create_time is not null
)
, first_read as (
    select dt
         , product_id
         , user_id
         , book_id
         , chapter_id as fst_chapter_id
      from timed_detail
   qualify row_number() over (partition by dt, product_id, user_id, book_id
                                 order by create_time, autoid
                            ) = 1
)
, last_read as (
    select dt
         , product_id
         , user_id
         , book_id
         , chapter_id as lst_chapter_id
      from timed_detail
   qualify row_number() over (partition by dt, product_id, user_id, book_id
                                 order by create_time desc, autoid desc
                            ) = 1
)
select a.dt              -- 阅读日期
     , a.product_id      -- 产品id
     , a.user_id         -- 用户id
     , a.book_id         -- 书籍id
     , a.fst_read_tm     -- 首次阅读时间
     , f.fst_chapter_id  -- 首次阅读章节id
     , a.lst_read_tm     -- 最近阅读时间
     , l.lst_chapter_id  -- 最近阅读章节id
     , a.read_cnt        -- 阅读次数
     , a.read_seconds    -- 阅读时长(秒)
     , now() as etl_time -- etl写入时间
  from day_agg         as a
  left join first_read as f
    on a.dt = f.dt
   and a.product_id = f.product_id
   and a.user_id <=> f.user_id
   and a.book_id <=> f.book_id
  left join last_read as l
    on a.dt = l.dt
   and a.product_id = l.product_id
   and a.user_id <=> l.user_id
   and a.book_id <=> l.book_id
;
