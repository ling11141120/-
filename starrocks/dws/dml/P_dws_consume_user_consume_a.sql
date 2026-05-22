----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dws_consume_user_consume_a
-- workflow_version : 1
-- create_user      : xixg
-- task_name        : dws_consume_user_consume_a
-- task_version     : 1
-- update_time      : 2025-06-19 17:29:23
-- sql_path         : \starrocks\tbl_dws_consume_user_consume_a\dws_consume_user_consume_a
----------------------------------------------------------------
-- SQL语句
-- 表中的 解锁天数 用户每日平均付费解锁章节数两个指标 新增的只有从8月4号开始才有
insert into dws.dws_consume_user_consume_a
select a.dt,a.product_id ,
       a.user_id,
       a.con_amount,
       a.fst_time,
       a.lst_time,
       a.consume_cnt  ,
       a.con_chapter_nums, -- 解锁章节
       a.csum_days_cnt , -- 解锁天数
       a.avg_csum_amt, -- 用户每日平均付费解锁章节数
  ifnull(b.total_bat_ulk_cnt,0),
  ifnull(b.total_fix_ulk_cnt,0),
  ifnull(b.sup_ulk_cnt,0),
  ifnull(b.sup_ulk_sum,0),
  ifnull(b.total_bat_ulk_money,0),
  ifnull(b.start_sup_ulk_chp_cnt,0),
  ifnull(b.start_sup_ulk_chp_money,0),
  ifnull(b.start_bat_ulk_gear,0),
  ifnull(b.start_bat_ulk_chp_cnt,0),
  ifnull(b.start_bat_ulk_money,0),
  ifnull(b.start_bat_ulk_giftmoney,0), now() as etl_time
  from (
 select
       dt,
      product_id ,
      user_id,
      sum(con_amount) as con_amount ,
      min(fst_time) fst_time,
      max(lst_time) lst_time,
      round(sum(consume_cnt))  consume_cnt  ,
      bitmap_union_count(con_chapter_nums) con_chapter_nums,     -- 解锁章节
            -- 8月4号新增的 解锁天数 用户每日平均付费解锁章节数------------
      bitmap_union_count(csum_days_cnt) csum_days_cnt,     -- 解锁天数
      round(bitmap_union_count(con_chapter_nums)/bitmap_union_count(csum_days_cnt),2) as avg_csum_amt -- 用户每日平均付费解锁章节数
        from dws.dws_consume_user_consume_td_mid
    where dt='${bf_1_dt}'
    group by 1,2 ,3
 ) a
 left join
 (
 select dt,product_id, user_id, total_bat_ulk_cnt, total_fix_ulk_cnt, sup_ulk_cnt, sup_ulk_sum,
 total_bat_ulk_money, start_sup_ulk_chp_cnt, start_sup_ulk_chp_money,
 start_bat_ulk_gear, start_bat_ulk_chp_cnt, start_bat_ulk_money, start_bat_ulk_giftmoney
 from dws.dws_consume_user_chapter_ulk_td_mid
 where dt='${bf_1_dt}'
 ) b
 on a.dt=b.dt and a.product_id=b.product_id and a.user_id=b.user_id;
