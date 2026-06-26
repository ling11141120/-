----------------------------------------------------------------
-- 程序功能： bi-书籍第5章留存信息表
-- 程序名： P_ads_bi_book_chap5_ret_rt_info.sql
-- 目标表： ads.ads_bi_book_chap5_ret_rt_info
-- 负责人： wx
-- 开发日期： 2025-11-05
-- 版本号： v0.0.0
----------------------------------------------------------------

insert into ads.ads_bi_book_chap5_ret_rt_info
with t1 as (
    select '${bf_1_dt}'               as dt
          ,a1.bookid                  as book_id
          ,a2.serial_number           as serial_number
          ,max(a2.site_id)            as site_id
          ,max(a2.new_cid)            as new_cid
          ,max(a2.new_cname)          as new_cname
          ,count(distinct a1.userid)  as chap5_read_num
      from ods_log.ods_book_user_readchapter    as a1
      join dim.dim_book_chapter_info            as a2
        on a1.bookid = a2.book_id
       and a1.ChapterId = a2.chapter_id
       and a1.dt <= '${bf_1_dt}'
       and a1.dt >= date_sub('${bf_1_dt}',interval 6 day)
      left join dim.dim_shuangwen_book_read_consume_info as a3
        on a1.bookid = a3.book_id
     where a2.serial_number = 5
       and a3.sexy2 < 4
       and a2.site_id <> 333
     group by 1, 2, 3
)
, t2 as (
    select '${bf_1_dt}'               as dt
          ,a1.bookid                  as book_id
          ,count(distinct a1.userid)  as ttl_chap_read_num
      from ods_log.ods_book_user_readchapter    as a1
     inner join (select book_id
                       ,chapter_id
                   from dim.dim_book_chapter_info
                  where site_id <> 333
                )    as a2
        on a1.bookid = a2.book_id
       and a1.ChapterId = a2.chapter_id
       and a1.dt <= '${bf_1_dt}'
       and a1.dt >= date_sub('${bf_1_dt}',interval 6 day)
     group by 1, 2
)
select t1.dt                      -- 日期
      ,t1.book_id                 -- 书籍id
      ,t1.site_id                 -- 语言id
      ,t1.new_cid                 -- 分类id
      ,t1.new_cname               -- 分类名称
      ,t1.chap5_read_num          -- 第五章阅读人数
      ,t2.ttl_chap_read_num       -- 总阅读人数
      ,round(t1.chap5_read_num / t2.ttl_chap_read_num, 4) as chap5_ret_rt    -- 第五章留存率
  from t1
  left join t2
    on t1.book_id = t2.book_id
;