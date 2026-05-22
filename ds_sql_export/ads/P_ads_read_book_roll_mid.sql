----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_wide_book_read_consume_info_a
-- workflow_version : 12
-- create_user      : linq
-- task_name        : ads_read_book_roll_mid
-- task_version     : 4
-- update_time      : 2023-12-20 20:19:43
-- sql_path         : \starrocks\tbl_ads_wide_book_read_consume_info_a\ads_read_book_roll_mid
----------------------------------------------------------------
-- 前置SQL语句
delete from ads.ads_read_book_roll_mid where dt='${bf_1_dt}';

-- SQL语句
insert into ads.ads_read_book_roll_mid
select dt,book_id,
       bitmap_union(read_unt_td) as read_unt_td,
       bitmap_union(read_pay_unt_td) as read_pay_unt_td,
       bitmap_union(read_chapter_cnt_td) as read_chapter_cnt_td,
       bitmap_union(read_pay_chapter_cnt_td) as read_pay_chapter_cnt_td,
       now() as etl_time
from(
    select '${bf_1_dt}' as dt, book_id, read_unt_td, read_pay_unt_td, read_chapter_cnt_td, read_pay_chapter_cnt_td
    from ads.ads_read_book_roll_mid where dt='${bf_2_dt}'
    union all
    select dt,a.book_id,
           bitmap_union(a.user_id) read_unt_td,
           bitmap_union(case when b.serial_number >0 then a.user_id end) read_pay_unt_td,
           bitmap_union(to_bitmap(a.chapter_id)) as  read_chapter_cnt_td,
           bitmap_union(case when b.serial_number >0 then to_bitmap(a.chapter_id) end) as  read_pay_chapter_cnt_cnt
    from dws.dws_read_book_chapter_ed a
    left join dwd.dwd_read_pay_chapter_temp b on a.book_id =b.book_id  and a.chapter_id =b.chapter_id
    where a.dt='${bf_1_dt}'
    group by 1,2
)t1
group by 1,2;
