----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_edm_book_consume_l30d
-- workflow_version : 2
-- create_user      : yanxh
-- task_name        : ads_edm_book_consume_l30d
-- task_version     : 2
-- update_time      : 2023-10-27 14:07:34
-- sql_path         : \starrocks\tbl_ads_edm_book_consume_l30d\ads_edm_book_consume_l30d
----------------------------------------------------------------
-- SQL语句
insert overwrite ads.ads_edm_book_consume_l30d
select CURRENT_DATE() as   dt,
       a.language_id,
       a.channel,
       a.new_cid,
       a.book_id,
       a.amount,
       CURRENT_TIMESTAMP() etl_time
from (
         select a.language_id,
                b.channel,
                b.new_cid,
                a.book_id,
                a.amount,
                ROW_NUMBER() over (PARTITION by a.language_id,b.new_cid order by a.amount desc ) ranks
         from (
                  select case
                             when site_id = 322 then 3
                             when site_id = 375 then 4
                             when site_id = 333 then 2
                             when site_id = 409 then 5
                             when site_id = 410 then 6
                             when site_id = 418 then 7
                             when site_id = 419 then 9
                             when site_id = 414 then 11
                             when site_id = 433 then 12
                             when site_id = 435 then 13
                             when site_id = 436 then 14
                             when site_id = 445 then 15 end as language_id,
                         book_id,
                         sum(amount)                           amount
                  from dws.dws_consume_user_consume_ed
                  where dt >= DATE_SUB(CURRENT_DATE(), interval 30 day)
                    and dt < CURRENT_DATE()
                    and types in (1, 2)
                    and product_id not in (7777, 8888, 8858, 7757)
                  group by 1, 2
              ) a
                  inner join
              dim.dim_shuangwen_book_read_consume_info b
              on a.book_id = b.book_id and b.sexy2 = 0 and site_id2!=777--  and b.new_cid in (10007,20007 )
         where a.book_id not in -- --------
               (select bookid from dim.dim_mutexconfigbook_view where IsMainPush = 0)
         -- and a.site_id=333
     ) a
where ranks <= 50;
