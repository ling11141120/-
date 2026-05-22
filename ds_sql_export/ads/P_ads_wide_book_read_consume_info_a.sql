----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_wide_book_read_consume_info_a
-- workflow_version : 12
-- create_user      : linq
-- task_name        : ads_wide_book_read_consume_info_a
-- task_version     : 4
-- update_time      : 2023-12-20 20:19:43
-- sql_path         : \starrocks\tbl_ads_wide_book_read_consume_info_a\ads_wide_book_read_consume_info_a
----------------------------------------------------------------
-- SQL语句
insert into ads.ads_wide_book_read_consume_info_a
select '${bf_1_dt}' as dt,acc.book_id,acc.book_name,acc.site_id2,acc.languageid as language_id,acc.create_time,
       acc.update_time, acc.book_nature, acc.sign_type,acc.channel, acc.is_full, acc.price_per_thousand, acc.new_cid,
       acc.new_cname, acc.sexy2, acc.normal_chapter_num_f, acc.build_time,acc.font_length,acc.full_time,acc.public_fontlength,
       acc.author_id, acc.author_name, acc.Free_ChapterNum, acc.latest_update_time ,
       read_book.read_unt_td,
       read_book.read_pay_unt_td,
       read_book.read_chapter_cnt_td,
       read_book.read_pay_chapter_cnt_td ,
       read_times.read_time_td,
       csm.consume_unt_td,
       csm.consume_amt_td,
       csm.consume_cnt_td,
       csm.consume_chapter_cnt_td,
       csm.consume_money_unt_td,
       csm.consume_money_amt_td,
       csm.consume_money_cnt_td,
       csm.consume_money_chapter_cnt_td,
       csm.consume_gift_unt_td,
       csm.consume_gift_amt_td,
       csm.consume_gift_cnt_td,
       csm.consume_gift_chapter_cnt_td,
       now() as etl_tm
from dim.dim_shuangwen_book_read_consume_info  acc
left join(
    select book_id,
           bitmap_count(read_unt_td) as read_unt_td, bitmap_count(read_pay_unt_td) as read_pay_unt_td,
           bitmap_count(read_chapter_cnt_td) as read_chapter_cnt_td, bitmap_count(read_pay_chapter_cnt_td) as read_pay_chapter_cnt_td,
           etl_time
    from ads.ads_read_book_roll_mid
    where dt='${bf_1_dt}'
) read_book on acc.book_id=read_book.book_id
left join(
    select book_id, read_day_td, read_time_td from ads.ads_read_book_readtime_mid
) read_times on acc.book_id=read_times.book_id
left join(
    select book_id,
           bitmap_count(consume_unt_td) as consume_unt_td,consume_amt_td,consume_cnt_td,bitmap_count(consume_chapter_cnt_td) as consume_chapter_cnt_td,
           bitmap_count(consume_money_unt_td) as consume_money_unt_td,consume_money_amt_td,consume_money_cnt_td,bitmap_count(consume_money_chapter_cnt_td) as consume_money_chapter_cnt_td,
           bitmap_count(consume_gift_unt_td) as consume_gift_unt_td,consume_gift_amt_td,consume_gift_cnt_td,bitmap_count(consume_gift_chapter_cnt_td) as consume_gift_chapter_cnt_td
    from ads.ads_consume_book_consume_roll_mid
    where dt='${bf_1_dt}'
) csm
on acc.book_id=csm.book_id
where acc.site_id2 !=777;
