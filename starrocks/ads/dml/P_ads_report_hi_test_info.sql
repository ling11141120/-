----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_report_hi_test_info
-- workflow_version : 5
-- create_user      : yanxh
-- task_name        : tbl_ads_report_hi_test_info
-- task_version     : 5
-- update_time      : 2023-12-05 14:04:04
-- sql_path         : \starrocks\tbl_ads_report_hi_test_info\tbl_ads_report_hi_test_info
----------------------------------------------------------------
-- SQL语句
delete from ads.ads_report_hi_test_info  where dt>='${bf_14_dt}';

-- SQL语句
insert into ads.ads_report_hi_test_info
with high_user as
         (

             select   a.product_id,
                      (case when b.corever is null or b.corever='' then 1 else b.corever end) as corever,
                      b.mt2 as mt ,
                      a.user_id,
                      date(b.create_time) as reg_date,
                      (case when b.reg_country is null or b.reg_country='' then 'other' else b.reg_country end) as reg_country,
                      a.book_id,
                      a.message,
                      a.chapter_index,
                      a.chapter_id,
                      c.item_id,
                      a.dt ,
                      a.create_time as tag_time,
                      min(a.id)
             from
                 dwd.dwd_high_user_record_view  a
                     inner join  dim.dim_user_account_info_view  b on a.user_id=b.id and a.product_id =b.product_id
                     left join dim.dim_high_book_record_config_view  c
                               on a.product_id =c.product_id and  a.book_id=c.book_id  and a.create_time >=c.create_time and a.create_time<c.end_time

             where a.dt>='${bf_14_dt}'
             group by  1,2,3,4,5,6,7,8,9,10,11,12,13
         )

        ,
     read_info as (
         select high_user.product_id,high_user.corever,high_user.mt,high_user.dt,high_user.reg_country,high_user.book_id,high_user.message,high_user.chapter_id,high_user.chapter_index,(case when high_user.item_id is null then 0 else high_user.item_id end) as item_id,
                count(distinct high_user.user_id) as tag_num,
                count(distinct b.user_id) as read_num
         from
             high_user
                 left join
             (
                 select product_id,dt,user_id,book_id from dws.dws_read_user_readbook_ed
                 where dt>='${bf_14_dt}'
                   and  product_id in (3311,3322,3333,3366,3371,3388,3501,3511)
             ) b
             on high_user.product_id=b.product_id and  high_user.user_id=b.user_id and  high_user.book_id=b.book_id and b.dt>=high_user.dt and b.dt<=date_add(high_user.dt,interval 14 day)
         group by  1,2,3,4,5,6,7,8,9,10
     ) ,

     consume_info as
         (
             select high_user.product_id,high_user.corever,high_user.mt,high_user.dt,high_user.reg_country,high_user.book_id,high_user.message,high_user.chapter_id,high_user.chapter_index,(case when high_user.item_id is null then 0 else high_user.item_id end) as item_id,
                    count(distinct c.user_id) as con_num,
                    sum(case when c.dt>=high_user.dt and  c.dt<=date_add(high_user.dt,interval 2 day) then c.amount end) amount
             from
                 high_user
                     left  join

                 ( select product_id,dt,user_id,book_id,amount from dws.dws_consume_user_consume_ed
                   where    dt>='${bf_14_dt}'
                     and  product_id in (3311,3322,3333,3366,3371,3388,3501,3511)  and types=1  ) c
                 on high_user.product_id=c.product_id and  high_user.user_id=c.user_id and  high_user.book_id=c.book_id and c.dt>=high_user.dt and c.dt<=date_add(high_user.dt,interval 14 day)
             group by  1,2,3,4,5,6,7,8,9,10
         )

select read_info.dt,read_info.product_id,read_info.corever,read_info.mt,read_info.reg_country,read_info.book_id,read_info.message,read_info.chapter_id,read_info.chapter_index,read_info.item_id,read_info.tag_num,read_info.read_num,consume_info.con_num,consume_info.amount ,now() as etl_time
from
    read_info
        inner  join
    consume_info
    on read_info.product_id=consume_info.product_id and  read_info.corever=consume_info.corever and read_info.mt= consume_info.mt  and read_info.dt=consume_info.dt
        and read_info.reg_country =consume_info.reg_country and read_info.book_id=consume_info.book_id
        and read_info.message= consume_info.message and read_info.chapter_id= consume_info.chapter_id and read_info.chapter_index= consume_info.chapter_index  and read_info.item_id=consume_info.item_id;
