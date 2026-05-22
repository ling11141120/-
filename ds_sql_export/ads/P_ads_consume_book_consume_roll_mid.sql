----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_wide_book_read_consume_info_a
-- workflow_version : 12
-- create_user      : linq
-- task_name        : ads_consume_book_consume_roll_mid
-- task_version     : 4
-- update_time      : 2023-12-20 20:19:43
-- sql_path         : \starrocks\tbl_ads_wide_book_read_consume_info_a\ads_consume_book_consume_roll_mid
----------------------------------------------------------------
-- 前置SQL语句
delete from ads.ads_consume_book_consume_roll_mid where dt = '${bf_1_dt}';

-- SQL语句
insert into ads.ads_consume_book_consume_roll_mid
select dt,book_id,
       bitmap_union(consume_unt_td) as consume_unt_td,
       sum(consume_amt_td) as consume_amt_td,
       sum(consume_cnt_td) as consume_cnt_td,
       bitmap_union(consume_chapter_cnt_td) as consume_chapter_cnt_td,
       bitmap_union(consume_money_unt_td) as consume_money_unt_td,
       sum(consume_money_amt_td) as consume_money_amt_td,
       sum(consume_money_cnt_td) as consume_money_cnt_td,
       bitmap_union(consume_money_chapter_cnt_td) as consume_money_chapter_cnt_td,
       bitmap_union(consume_gift_unt_td) as consume_gift_unt_td,
       sum(consume_gift_amt_td) as consume_gift_amt_td,
       sum(consume_gift_cnt_td) as consume_gift_cnt_td,
       bitmap_union(consume_gift_chapter_cnt_td) as consume_gift_chapter_cnt_td,
       now() as etl_time
from(
    select '${bf_1_dt}' as dt,book_id,consume_unt_td,consume_amt_td,consume_cnt_td,consume_chapter_cnt_td,
           consume_money_unt_td,consume_money_amt_td,consume_money_cnt_td,consume_money_chapter_cnt_td,
           consume_gift_unt_td,consume_gift_amt_td,consume_gift_cnt_td,consume_gift_chapter_cnt_td
    from ads.ads_consume_book_consume_roll_mid where dt='${bf_2_dt}'
    union all
    select dt,
           book_id,
           bitmap_union(to_bitmap(user_id))                      as consume_unt,
           round(sum(con_chp_amount))                            as consume_amt,
           round(sum(con_book_cnt))                              as consume_cnt,
           bitmap_union(to_bitmap(chapter_id))                   as consume_chapter_cnt,
           bitmap_union(if(types = 1, to_bitmap(user_id), null)) as consume_money_unt,
           round(sum(if(types = 1, con_chp_amount, 0)))          as consume_money_amt,
           round(sum(if(types = 1, con_book_cnt, 0)))               consume_money_cnt,
           bitmap_union(to_bitmap(if(types = 1, chapter_id, null))) consume_money_chapter_cnt,
           bitmap_union(if(types = 2, to_bitmap(user_id), null)) as consume_gift_unt,
           round(sum(if(types = 2, con_chp_amount, 0)))          as consume_gift_amt,
           round(sum(if(types = 2, con_book_cnt, 0)))               consume_gift_cnt,
           bitmap_union(to_bitmap(if(types = 2, chapter_id, null))) consume_gift_chapter_cnt
    from dwm.dwm_consume_user_consume_mild_ed
    where dt = '${bf_1_dt}'
    and pay_type <> 1103
    group by 1, 2
)t1
group by 1,2;
