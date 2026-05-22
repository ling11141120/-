----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_wide_book_read_consume_info_ed
-- workflow_version : 5
-- create_user      : yanxh
-- task_name        : tbl_ads_wide_book_read_consume_info_ed
-- task_version     : 5
-- update_time      : 2023-12-29 09:30:43
-- sql_path         : \starrocks\tbl_ads_wide_book_read_consume_info_ed\tbl_ads_wide_book_read_consume_info_ed
----------------------------------------------------------------
-- 前置SQL语句
delete from ads.ads_wide_book_read_consume_info_ed where dt>='${bf_1_dt}' and dt<'${dt}';

-- SQL语句
insert into ads.ads_wide_book_read_consume_info_ed
select acc.dt,acc.book_id,acc.book_name,acc.site_id2,acc.languageid as language_id,acc.create_time, acc.update_time, acc.book_nature,
       acc.sign_type,acc.channel, acc.is_full, acc.price_per_thousand, acc.new_cid,acc.new_cname, acc.sexy2, acc.normal_chapter_num_f,
       acc.build_time,acc.font_length,acc.full_time,acc.public_fontlength, acc.author_id, acc.author_name, acc.Free_ChapterNum,
       acc.latest_update_time ,
       read_book.read_unt,  -- ----
       read_book.read_pay_unt,   -- --------
       read_book.read_chapter_cnt, -- -----
       read_book.read_pay_chapter_cnt , -- -------
       read_times.read_times, -- ----
       csm.consume_unt, -- ----
       csm.consume_amt , --   ----
       csm.consume_cnt  ,-- -- ----
       csm.consume_chapter_cnt, -- -----
       csm.consume_money_unt, -- ------
       csm.consume_money_amt , --   ------
       csm.consume_money_cnt  ,-- -- ------
       csm.consume_money_chapter_cnt, -- -------
       csm.consume_gift_unt, -- ------
       csm.consume_gift_amt , --    ------
       csm.consume_gift_cnt  ,-- -- ------
       csm.consume_gift_chapter_cnt ,-- -------
       consume_award_unt, -- ------
       consume_award_amt , --    ------
       consume_award_cnt  ,-- -- ------
       consume_award_chapter_cnt, -- -------

       consume_vip_unt, -- ------
       consume_vip_amt , --    ------
       consume_vip_cnt  ,-- -- ------
       consume_vip_chapter_cnt, -- -------
       now() as etl_tm
from (
    select dt.datestr as dt,book_id,book_name,site_id2,languageid,create_time,update_time,book_nature,sign_type,channel,is_full,
           price_per_thousand,new_cid,new_cname,sexy2,normal_chapter_num_f,build_time,font_length,full_time,public_fontlength,
           author_id,author_name,Free_ChapterNum,latest_update_time
    from  dim.dim_shuangwen_book_read_consume_info
    left join (
        select datestr
        from dim.dim_date
        where datestr>='${bf_1_dt}' and datestr<'${dt}'
        )dt on 1=1
    )  acc
left join(
    -- --------------------------------------------------------
    select a.dt,a.book_id,
           bitmap_union(a.user_id) read_unt,  -- ----
           bitmap_union(case when b.serial_number >0 then a.user_id end) read_pay_unt,   -- --------
           count(distinct a.chapter_id) as  read_chapter_cnt, -- -----
           count(distinct case when b.serial_number >0 then a.chapter_id end) as  read_pay_chapter_cnt  -- -------
    from dws.dws_read_book_chapter_ed a
    left join dwd.dwd_read_pay_chapter_temp b
           on a.book_id =b.book_id  and a.chapter_id =b.chapter_id
    where a.dt>='${bf_1_dt}' and a.dt<'${dt}'
    group by 1,2
) read_book
on acc.dt=read_book.dt and acc.book_id=read_book.book_id
left join(
    -- ------------------------------------------
    select dt ,book_id,sum(read_times) as  read_times from dws.dws_read_user_book_readtime_ed where dt='${bf_1_dt}'group by 1,2
) read_times
on acc.dt=read_times.dt and acc.book_id=read_times.book_id
left join(
    -- -------------------------------------------------------------
    select
          dt ,
          book_id ,
          bitmap_union(to_bitmap(user_id)) as consume_unt, -- ----
          round(sum(con_chp_amount)) as consume_amt , --   ----
          round(sum(con_book_cnt)) consume_cnt  ,-- -- ----
          count(distinct (CONCAT(book_id,chapter_id))) consume_chapter_cnt, -- -----

          bitmap_union(if(types=1, to_bitmap(user_id),null)) as consume_money_unt, -- ------
          round(sum(if(types=1, con_chp_amount,0))) as consume_money_amt , --   ------
          round(sum(if(types=1,con_book_cnt,0)))  consume_money_cnt  ,-- -- ------
          count(distinct (if(types=1,CONCAT(book_id,chapter_id),null))) consume_money_chapter_cnt, -- -------

          bitmap_union(if(types=2, to_bitmap(user_id),null)) as consume_gift_unt, -- ------
          round(sum(if(types=2, con_chp_amount,0))) as consume_gift_amt , --    ------
          round(sum(if(types=2,con_book_cnt,0)))  consume_gift_cnt  ,-- -- ------
          count(distinct (if(types=2,CONCAT(book_id,chapter_id),null))) consume_gift_chapter_cnt, -- -------

          bitmap_union(if(types=3, to_bitmap(user_id),null)) as consume_award_unt, -- ------
          round(sum(if(types=3, con_chp_amount,0))) as consume_award_amt , --    ------
          round(sum(if(types=3,con_book_cnt,0)))  consume_award_cnt  ,-- -- ------
          count(distinct (if(types=3,CONCAT(book_id,chapter_id),null))) consume_award_chapter_cnt, -- -------

          bitmap_union(if(types=4, to_bitmap(user_id),null)) as consume_vip_unt, -- ------
          round(sum(if(types=4, con_chp_amount,0))) as consume_vip_amt , --    ------
          round(sum(if(types=4,con_book_cnt,0)))  consume_vip_cnt  ,-- -- ------
          count(distinct (if(types=4,CONCAT(book_id,chapter_id),null))) consume_vip_chapter_cnt -- -------
    from dwm.dwm_consume_user_consume_mild_ed
    where dt>='${bf_1_dt}' and dt<'${dt}'
    and pay_type <>1103
    group by 1,2
) csm
on acc.dt=csm.dt and acc.book_id=csm.book_id
where acc.site_id2 !=777;
