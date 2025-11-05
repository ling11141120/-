----------------------------------------------------------------
-- 程序功能： bi-书籍第5章留存信息表
-- 程序名： P_ads_bi_book_chap5_ret_rt_info.sql
-- 目标表： ads.ads_bi_book_chap5_ret_rt_info
-- 负责人： wx
-- 开发日期： 2025-11-05
-- 版本号： v0.0.0
----------------------------------------------------------------

insert into ads.ads_bi_book_chap5_ret_rt_info (
     dt                   -- 日期
    ,book_id              -- 书籍id
    ,site_id              -- 语言id
    ,new_cid              -- 分类id
    ,new_cname            -- 分类名称
    ,chap5_read_num       -- 第五章阅读人数
    ,ttl_chap_read_num    -- 总阅读人数
    ,chap5_ret_rt         -- 第五章留存率
)
with t1 as (
    select '${bf_1_dt}' as dt
          ,a1.bookid    as book_id
          ,a2.serial_number as serial_number
          ,max(a2.site_id) as site_id
          ,max(a2.new_cid) as new_cid
          ,max(a2.new_cname) as new_cname
          ,count(distinct a1.userid) as chap5_read_num
          ,count(distinct a1.userid) as ttl_chap_read_num
      from ods_log.ods_book_user_readchapter     as a1
      left join dim.dim_book_chapter_info    as a2
        on a1.BookId = a2.book_id
       and a1.ChapterId = a2.chapter_id
     where a1.dt >= date_sub('${bf_1_dt}',interval 6 day)
       and a1.dt <= '${bf_1_dt}'
       and a2.serial_number = 5
     group by 1,2,3
)
select dt
      ,book_id
      ,site_id
      ,new_cid
      ,new_cname
      ,chap5_read_num
      ,ttl_chap_read_num
      ,sum(chap5_read_num)over(partition by dt, book_id, serial_number) as ttl_chap5_read_num
from t1