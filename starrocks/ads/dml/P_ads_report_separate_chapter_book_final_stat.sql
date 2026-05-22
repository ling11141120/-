----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_report_separate_chapter_book_final_stat
-- workflow_version : 6
-- create_user      : xixg
-- task_name        : ads_report_separate_chapter_book_final_stat
-- task_version     : 6
-- update_time      : 2024-05-12 23:28:40
-- sql_path         : \starrocks\tbl_ads_report_separate_chapter_book_final_stat\ads_report_separate_chapter_book_final_stat
----------------------------------------------------------------
-- SQL语句
insert into ads.ads_report_separate_chapter_book_final_stat
-- 先处理所有的子书（非根书）相关统计信息
select 	a.dt,
        a.book_id,
        a.product_id,
        CASE a.book_id%1000
            WHEN 322 THEN '英语'
            WHEN 445 THEN '菲律宾语'
            WHEN 375 THEN '西语'
            WHEN 410 THEN '法语'
            WHEN 409 THEN '葡语'
            WHEN 418 THEN '俄语'
            WHEN 419 THEN '日语'
            WHEN 414 THEN '印尼语'
            WHEN 433 THEN '泰语'
            WHEN 436 THEN '韩语'
       END AS book_language_name,
        a.book_name,
        a.from_book_name,
        a.to_book_name,
        a.if_root_book,
        a.book_code,
          a.publish_length,
          a.cost_amt_7,
          a.amount_7,
          a.cost_amt_30,
          a.amount_30,
          a.cost_amt_curmon,
          a.amount_curmon,
          a.cost_amt_td,
          a.amount_td,
          a.cost_rate_judge,
          NULL AS separate_chapter_book_income,
          a.read_7d_unt,
          a.read_30d_unt,
          a.consume_7d_unt,
          a.consume_30d_unt,
          now() as etl_time
from ads.ads_report_separate_chapter_book_stat a
where a.dt = '${dt}'
and a.if_root_book = 0
-- 再处理根书的相关统计信息
union all
select 	  b.dt,
          b.book_id,
          b.product_id,
        CASE b.book_id%1000
            WHEN 322 THEN '英语'
            WHEN 445 THEN '菲律宾语'
            WHEN 375 THEN '西语'
            WHEN 410 THEN '法语'
            WHEN 409 THEN '葡语'
            WHEN 418 THEN '俄语'
            WHEN 419 THEN '日语'
            WHEN 414 THEN '印尼语'
            WHEN 433 THEN '泰语'
            WHEN 436 THEN '韩语'
        END AS book_language_name,
          b.book_name,
          b.from_book_name,
          b.to_book_name,
          b.if_root_book,
          b.book_code,
          b.publish_length,
          b.cost_amt_7,
          b.amount_7,
          b.cost_amt_30,
          b.amount_30,
          b.cost_amt_curmon,
          b.amount_curmon,
          b.cost_amt_td,
          b.amount_td,
          b.cost_rate_judge,
          c.separate_chapter_book_income,
          b.read_7d_unt,
          b.read_30d_unt,
          b.consume_7d_unt,
          b.consume_30d_unt,
          now() as etl_time
from ads.ads_report_separate_chapter_book_stat b
left join  (
            select root_book_id,
                   sum(amount_curmon) as separate_chapter_book_income
            from ads.ads_report_separate_chapter_book_stat
            where dt = '${dt}'
              and if_root_book = 0
            group by root_book_id
            ) c
on b.book_id = c.root_book_id
where b.dt = '${dt}'
and b.if_root_book = 1;
