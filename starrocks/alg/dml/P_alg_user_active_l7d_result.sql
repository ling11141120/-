----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_alg_user_active_l7d_result
-- workflow_version : 9
-- create_user      : yanxh
-- task_name        : tbl_alg_user_active_l7d_result
-- task_version     : 9
-- update_time      : 2025-06-17 11:40:34
-- sql_path         : \starrocks\tbl_alg_user_active_l7d_result\tbl_alg_user_active_l7d_result
----------------------------------------------------------------
-- SQL语句
insert overwrite alg.alg_user_active_l7d_result partition(p'${pname}')
select dt,
       product_id,
       user_id,
       'lossfeat' as redis_key,
  concat(register_days,',', read_books_1d,',', read_books_3d, ',',read_books_7d, ',',read_chpts_1d,',', read_chpts_3d,',', read_chpts_7d,',',
   last_read_chpts,',', last_max_serial_number,',', csum_books_1d,',', csum_books_3d,',', csum_books_7d,',', csum_books_60d,',',
   con_chapter_num_1d, ',',con_chapter_num_3d,',', con_chapter_num_7d,',', con_chapter_num_60d,',', cast(coin_consumption_1d as int),',',
   cast(coin_consumption_3d as int),',', cast(coin_consumption_7d as int), ',',cast(coin_consumption_60d as int),',', cast(certificate_consumption_1d as int), ',',cast(certificate_consumption_3d as int),',',
   cast(certificate_consumption_7d as int),',', cast(certificate_consumption_60d as int),',', pay_num_7d, ',',pay_total_7d,',', pay_num_180d,',', pay_total_180d,',', last_pay_days, ',',
   send_gift_num_1d,',', send_gift_num_3d,',', send_gift_num_7d,',', expire_gift_num_1d,',', expire_gift_num_3d,',', expire_gift_num_7d,',', last_get_gift_days,',', visit_days, ',',last_visit_days, ',' , pay_num , ',', pay_total) as loss_feat
from (
select dt,
      concat('nv', user_id) user_id,
      product_id,
      max(coalesce(register_days, 0) )register_days,

        max(ifnull(read_books_1d,0)) as read_books_1d,
        max(ifnull(read_books_3d,0)) as read_books_3d,
        max(ifnull(read_books_7d,0)) as read_books_7d,
        max(ifnull(read_chpts_1d,0)) as read_chpts_1d,
        max(ifnull(read_chpts_3d,0)) as read_chpts_3d,
        max(ifnull(read_chpts_7d,0)) as read_chpts_7d,
        max(ifnull(last_read_chpts,0)) as last_read_chpts,
        max(ifnull(last_max_serial_number,0)) as last_max_serial_number,

        max(ifnull(csum_books_1d,0)) as csum_books_1d,
        max(ifnull(csum_books_3d,0)) as csum_books_3d,
        max(ifnull(csum_books_7d,0)) as csum_books_7d,
        max(ifnull(csum_books_60d,0)) as csum_books_60d,
        max(ifnull(con_chapter_num_1d,0)) as con_chapter_num_1d,
        max(ifnull(con_chapter_num_3d,0)) as con_chapter_num_3d,
        max(ifnull(con_chapter_num_7d,0)) as con_chapter_num_7d,
        max(ifnull(con_chapter_num_60d,0)) as con_chapter_num_60d,
        max(ifnull(coin_consumption_1d,0)) as coin_consumption_1d,
        max(ifnull(coin_consumption_3d,0)) as coin_consumption_3d,
        max(ifnull(coin_consumption_7d,0)) as coin_consumption_7d,
        max(ifnull(coin_consumption_60d,0)) as coin_consumption_60d,
        max(ifnull(certificate_consumption_1d,0)) as certificate_consumption_1d,
        max(ifnull(certificate_consumption_3d,0)) as certificate_consumption_3d,
        max(ifnull(certificate_consumption_7d,0)) as certificate_consumption_7d,
        max(ifnull(certificate_consumption_60d,0)) as certificate_consumption_60d,

        max(ifnull(pay_num_7d,0)) as pay_num_7d,
        max(ifnull(pay_total_7d,0)) as pay_total_7d,
        max(ifnull(pay_num_180d,0)) as pay_num_180d,
        max(ifnull(pay_total_180d,0)) as pay_total_180d,
        max(ifnull(pay_num,0)) as pay_num,
        max(ifnull(pay_total,0)) as pay_total,
        max(ifnull(last_pay_days, 10) ) last_pay_days,

        max(ifnull(send_gift_num_1d,0)) as send_gift_num_1d,
        max(ifnull(send_gift_num_3d,0)) as send_gift_num_3d,
        max(ifnull(send_gift_num_7d,0)) as send_gift_num_7d,
        max(ifnull(expire_gift_num_1d,0)) as expire_gift_num_1d,
        max(ifnull(expire_gift_num_3d,0)) as expire_gift_num_3d,
        max(ifnull(expire_gift_num_7d,0)) as expire_gift_num_7d,

        max(ifnull(last_get_gift_days, 10)) as last_get_gift_days ,

         max(ifnull(visit_days, 0)) as visit_days,
         max(ifnull(last_visit_days, 10)) as  last_visit_days

    from  alg.alg_user_active_l7d
    where dt='${bf_1_dt}'
    group by  1,2 ,3
    )  a;
