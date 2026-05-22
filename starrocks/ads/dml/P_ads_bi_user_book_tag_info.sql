----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_bi_user_book_tag_info_today
-- workflow_version : 9
-- create_user      : yanxh
-- task_name        : ads_bi_user_book_tag_info
-- task_version     : 5
-- update_time      : 2025-03-19 20:54:57
-- sql_path         : \starrocks\tbl_ads_bi_user_book_tag_info_today\ads_bi_user_book_tag_info
----------------------------------------------------------------
-- 前置SQL语句
delete from  ads.ads_bi_user_book_tag_info where dt='${dt}';

-- SQL语句
-- ========每天的增量=======================
-- -----------2.首次初始化之后，每次同步有变化的数据,每次导出就导有更新的数据---------------------------------------

insert into ads.ads_bi_user_book_tag_info
with full_data as (
    -- ------------跑截止当前时间最新的数据 ----------------
    select   a.product_id,
             a.user_id,
             a.book_id,
             max(b.serial_number) as max_serial_number
    from dwd.dwd_read_user_chapter_view a
             left join dim.dim_book_chapter_info b
                       on a.book_id =b.book_id
                           and a.chapter_id =b.chapter_id
    where a.dt>= DATE_SUB(CURRENT_date(),interval 90 day ) and  a.create_time <DATE_SUB(now(),interval 1 minute )
      and a.product_id  in (3311,3322,3333,3366,3371,3388,3399,3501,3511)
    --  and a.user_id in (128555785 ) and a.book_id in (40781322)
    group by 1,2 ,3
    --  order by 2
),

yesterday  as (  -- ------------先跑截止昨天的数据，用户每个用户每本书的最大章节数----------------
 select   a.product_id,
          a.user_id,
          a.book_id,
          max(b.serial_number) as max_serial_number
 from dwd.dwd_read_user_chapter_view a
          left join dim.dim_book_chapter_info b
                    on a.book_id =b.book_id  and a.chapter_id =b.chapter_id
 where  a.dt>= DATE_SUB(CURRENT_date(),interval 90 day )
   and a.dt<CURRENT_date()
   and a.product_id  in (3311,3322,3333,3366,3371,3388,3399,3501,3511)
 --  and   a.user_id in ( 153812935) and a.book_id in  (10251418)
 group by 1,2 ,3
 --  order by 2
),
-- 是否有变化  1：是 0 ：否
-- status=1 表示最大章节有变化的新数据，status=0表示没有变化的数据-----------------
-- -----------------------章节差值-----------------
book_serial_num as (
 select book_id,
        max(serial_number) as last_serial_number
 from dim.dim_book_chapter_info
 group by 1

)

select
    '${dt}' as dt  ,
    a.product_id,
    a.user_id,
    array_join(array_agg(CONCAT_WS('_',a.book_id,(b.last_serial_number - a.max_serial_number))),',') chp_gap,
    now() as etl_tm
from
    (
        select  full_data.product_id,
                full_data.user_id,
                full_data.book_id,
                CASE WHEN full_data.max_serial_number>yesterday.max_serial_number or yesterday.max_serial_number is null
                         THEN full_data.max_serial_number
                     ELSE yesterday.max_serial_number
                    END as max_serial_number,
                CASE WHEN full_data.max_serial_number>yesterday.max_serial_number or yesterday.max_serial_number is null
                         THEN 1 ELSE 0 END as status
        from  full_data
                  left join  yesterday
                             on full_data.product_id=yesterday.product_id
                                 and full_data.user_id=yesterday.user_id
                                 and  full_data.book_id=yesterday.book_id
        having status=1
    ) a
left join book_serial_num b
          on a.book_id =b.book_id
group by 1,2 ,3;

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_bi_user_book_tag_info_yesterday
-- workflow_version : 7
-- create_user      : yanxh
-- task_name        : ads_bi_user_book_tag_info
-- task_version     : 2
-- update_time      : 2024-06-07 16:02:00
-- sql_path         : \starrocks\tbl_ads_bi_user_book_tag_info_yesterday\ads_bi_user_book_tag_info
----------------------------------------------------------------
-- SQL语句
-- -----------1.当天就第一次同步全量的数据------------------------
  insert into ads.ads_bi_user_book_tag_info
 with max_chp as (
 -- ------------先跑截止昨天的数据，用户每个用户每本书的最大章节数----------------
   select '${dt}' as dt,a.product_id,a.user_id,a.book_id,max(b.serial_number) as max_serial_number
  from dwd.dwd_read_user_chapter_view a
  left join
    dim.dim_book_chapter_info b
   on a.book_id =b.book_id  and a.chapter_id =b.chapter_id
where a.dt>= DATE_SUB(CURRENT_date(),interval 90 day )   and a.dt<CURRENT_date() -- ---------先跑截止昨天的数据------
and a.product_id  in (3311,3322,3333,3366,3371,3388,3399,3501,3511)
  group by 1,2 ,3 ,4
 )

 -- -----------------------章节差值-----------------
 select
   max_chp.dt,max_chp.product_id,max_chp.user_id,array_join(array_agg(CONCAT_WS('_',max_chp.book_id,(b.last_serial_number - max_chp.max_serial_number))),',') chp_gap,now() as etl_tm
   from max_chp
   left join
(select book_id,max(serial_number) as last_serial_number from dim.dim_book_chapter_info group by 1  ) b
 on max_chp.book_id =b.book_id
 group by 1,2 ,3;
