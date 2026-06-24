----------------------------------------------------------------
-- 程序功能： 内容域-用户书籍长期阅读状态表日常增量写入
-- 程序名： P_dws_content_read_book_user_status_td
-- 目标表： dws.dws_content_read_book_user_status_td
-- 负责人： qhr
-- 开发日期：2026-06-23
-- 说明：仅处理晚于 idx_dt 的业务日期；历史日期修正须重新初始化后顺序补跑。
----------------------------------------------------------------

set cbo_cte_reuse = true;

insert into dws.dws_content_read_book_user_status_td
with day_status as (
    select dt
         , product_id
         , user_id
         , book_id
         , fst_read_tm
         , fst_chapter_id
         , lst_read_tm
         , lst_chapter_id
         , coalesce(read_cnt, 0)     as read_cnt
         , coalesce(read_seconds, 0) as read_seconds
      from dws.dws_content_read_book_user_agg_di
     where dt = '${bf_1_dt}'
       and product_id is not null
       and user_id is not null
       and book_id > 0
)
, old_status as (
    select s.product_id
         , s.user_id
         , s.book_id
         , s.fst_read_tm
         , s.fst_chapter_id
         , s.lst_read_tm
         , s.lst_chapter_id
         , s.read_cnt_td
         , s.read_seconds_td
         , s.idx_dt
      from dws.dws_content_read_book_user_status_td as s
      join day_status                               as d
        on s.product_id = d.product_id
       and s.user_id = d.user_id
       and s.book_id = d.book_id
)
select d.product_id                                                       -- 产品id
     , d.user_id                                                          -- 用户id
     , d.book_id                                                          -- 书籍id
     , case when o.fst_read_tm is null then d.fst_read_tm
            when d.fst_read_tm is null then o.fst_read_tm
            when o.fst_read_tm <= d.fst_read_tm then o.fst_read_tm
            else d.fst_read_tm
        end                                            as fst_read_tm     -- 历史首次阅读时间
     , case when o.fst_read_tm is null then d.fst_chapter_id
            when d.fst_read_tm is null then o.fst_chapter_id
            when o.fst_read_tm <= d.fst_read_tm then o.fst_chapter_id
            else d.fst_chapter_id
        end                                            as fst_chapter_id  -- 历史首次阅读章节id
     , case when o.lst_read_tm is null then d.lst_read_tm
            when d.lst_read_tm is null then o.lst_read_tm
            when o.lst_read_tm >= d.lst_read_tm then o.lst_read_tm
            else d.lst_read_tm
        end                                            as lst_read_tm     -- 历史最近阅读时间
     , case when o.lst_read_tm is null then d.lst_chapter_id
            when d.lst_read_tm is null then o.lst_chapter_id
            when o.lst_read_tm >= d.lst_read_tm then o.lst_chapter_id
            else d.lst_chapter_id
        end                                            as lst_chapter_id  -- 历史最近阅读章节id
     , coalesce(o.read_cnt_td, 0) + d.read_cnt         as read_cnt_td     -- 累计阅读次数
     , coalesce(o.read_seconds_td, 0) + d.read_seconds as read_seconds_td -- 累计阅读时长(秒)
     , d.dt                                            as idx_dt          -- 最后成功合入的阅读业务日期
     , now()                                           as etl_time        -- etl写入时间
  from day_status      as d
  left join old_status as o
    on d.product_id = o.product_id
   and d.user_id = o.user_id
   and d.book_id = o.book_id
 where o.idx_dt is null
    or o.idx_dt < d.dt
;