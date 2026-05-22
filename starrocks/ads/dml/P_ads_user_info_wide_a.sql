----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_user_info_wide_a
-- workflow_version : 16
-- create_user      : admin
-- task_name        : ads_user_info_wide_a_1
-- task_version     : 12
-- update_time      : 2025-06-21 18:39:01
-- sql_path         : \starrocks\tbl_ads_user_info_wide_a\ads_user_info_wide_a_1
----------------------------------------------------------------
-- SQL语句
insert into ads.ads_user_info_wide_a
with  userinfo as(
    select product_id  ,user_id  ,account  ,nick  ,birthday  ,sex  ,create_tm_account  ,mt ,corever  ,app_ver  ,ver  ,current_language  ,current_language2  ,country,reg_country,reg_country2  ,email  ,money  ,gift_money  ,email_bound_status  ,is_negative_user,`level` ,user_type  ,`point`  ,jifen  ,ads_type,ads_quality,last_login_tm,remarketing_time
    from dim.dim_user_all_info
    where product_id in (3388,3333,3501,3511,8858)
),
      market as (
          select  dt,product_id,user_id,mt,corever,lang2,first_bookid,last_bookid,last_source,isremarket,install_date,updatetime
          from  dws.dws_user_market_channel_info_detail_td where  dt= '${bf_1_dt}'
                                                             and  product_id in (3388,3333,3501,3511,8858)
      ),
      consume as  (select dt,product_id,user_id,con_amount,fst_time,lst_time,consume_cnt,con_chapter_nums,total_bat_ulk_cnt,total_fix_ulk_cnt,sup_ulk_cnt,sup_ulk_sum,total_bat_ulk_money,start_sup_ulk_chp_cnt,start_sup_ulk_chp_money,start_bat_ulk_gear,start_bat_ulk_chp_cnt,start_bat_ulk_money,start_bat_ulk_giftmoney,etl_time
                   from dws.dws_consume_user_consume_a where dt= '${bf_1_dt}' and  product_id in (3388,3333,3501,3511,8858)
      ),
      read1 as (
          select  dt,user_id,product_id,total_read_bookids,total_read_chp_ids,total_read_days,new_bookid_chapid,new_chp_book_cnt,etl_time
          from dws.dws_read_user_read_roll_a where dt= '${bf_1_dt}' and  product_id in (3388,3333,3501,3511,8858)
      ),
      trade as (select dt,user_id,product_id,first_subscribe,first_subscribe_type,first_subscribe_time,last_subscribe,last_subscribe_type,last_subscribe_time,subscribe_cnt,shopitems,mul_subscribe,has_subscribe,first_recharge,first_recharge_time,total_recharge,recharge_cnt,recharge_avg,recharge_max,month_recharge_max,last_recharge,last_recharge_time,charge_mode,charge_mode_cnt,charge_mode_lst_time,etl_time  from dws.dws_trade_user_recharge_roll_a where dt= '${bf_1_dt}' and  product_id in (3388,3333,3501,3511,8858)
      ),
      login as (select dt,Product_id,User_Id,first_login_time,last_login_time,new_login_time,first_login_ip,last_login_ip,new_login_ip,remain_day,login_days,login_times,etl_time from  dws.dws_user_login_a where  dt= '${bf_1_dt}' and  product_id in (3388,3333,3501,3511,8858))
select
    '${bf_1_dt}' dt ,
    userinfo.product_id  ,
    userinfo.user_id  ,
    userinfo.account  ,
    userinfo.nick  ,
    userinfo.birthday  ,
    userinfo.sex  ,
    userinfo.create_tm_account as reg_tm ,
    userinfo.mt ,
    userinfo.corever  ,
    userinfo.app_ver  ,
    userinfo.ver  ,
    userinfo.current_language  ,
    userinfo.current_language2  ,
    userinfo.reg_country  ,
    userinfo.reg_country2,
    userinfo.email  ,
    userinfo.money  ,
    userinfo.gift_money  ,
    userinfo.email_bound_status  ,
    userinfo.is_negative_user,
    userinfo.`level` as  level_country,
    userinfo.user_type  ,
    userinfo.`point` as points  ,
    userinfo.jifen  ,
    userinfo.ads_type,
    userinfo.ads_quality,
    market.first_bookid as first_book_id,
    market.last_bookid as last_book_id ,
    market.last_source ,
    market.isremarket is_remarket,
    market.install_date ,
    CASE WHEN userinfo.product_id in('7757','8858','3333')   THEN  datediff(substr(userinfo.last_login_tm,1,10),SUBSTR(remarketing_time,1,10))
        ELSE datediff(substr(userinfo.last_login_tm,1,10),SUBSTR(from_unixtime(unix_timestamp(remarketing_time, 'yyyy-MM-dd HH:mm:ss') + 3600 * 13, 'yyyy-MM-dd HH:mm:ss'),1,10)) END,
    consume.con_amount ,
    consume.fst_time  as first_tm,
    consume.lst_time as last_tm,
    consume.consume_cnt ,
    consume.con_chapter_nums ,
    consume.total_bat_ulk_cnt ,
    consume.total_fix_ulk_cnt ,
    consume.sup_ulk_cnt ,
    consume.sup_ulk_sum,
    consume.total_bat_ulk_money,
    consume.start_sup_ulk_chp_cnt ,
    consume.start_sup_ulk_chp_money,
    consume.start_bat_ulk_gear,
    consume.start_bat_ulk_chp_cnt,
    consume.start_bat_ulk_money,
    consume.start_bat_ulk_giftmoney,
    bitmap_count(read1.total_read_bookids) total_read_bookids,
    bitmap_count(read1.total_read_chp_ids) total_read_chp_ids,
    read1.total_read_days,
    read1.new_chp_book_cnt,
    read1.total_read_days,
    trade.first_subscribe ,
    trade.first_subscribe_type,
    trade.first_subscribe_time ,
    trade.last_subscribe,
    trade.last_subscribe_type,
    trade.last_subscribe_time ,
    trade.subscribe_cnt,
    trade.mul_subscribe,
    trade.has_subscribe,
    trade.first_recharge,
    trade.first_recharge_time ,
    trade.total_recharge,
    trade.recharge_cnt,
    trade.recharge_avg,
    trade.recharge_max,
    trade.month_recharge_max,
    trade.last_recharge,
    trade.last_recharge_time ,
    trade.charge_mode ,
    login.first_login_time ,
    login.last_login_time ,
    login.new_login_time ,
    login.login_days,
    login.login_times,
    NOW() as etl_tm
FROM userinfo left join market
                        on userinfo.product_id = market.product_id and userinfo.user_id = market.user_id and  userinfo.mt = market.mt and userinfo.corever = market.corever and userinfo.current_language2 = market.lang2
              left  join consume
                         on userinfo.product_id = consume.product_id and  userinfo.user_id = consume.user_id
              left  join read1
                         on userinfo.product_id = read1.product_id and  userinfo.user_id = read1.user_id
              left  join trade
                         on userinfo.product_id = trade.product_id and  userinfo.user_id = trade.user_id
              left  join login
                         on userinfo.product_id = login.product_id and  userinfo.user_id = login.user_id;

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_user_info_wide_a
-- workflow_version : 16
-- create_user      : admin
-- task_name        : ads_user_info_wide_a_2
-- task_version     : 15
-- update_time      : 2025-06-21 18:39:01
-- sql_path         : \starrocks\tbl_ads_user_info_wide_a\ads_user_info_wide_a_2
----------------------------------------------------------------
-- SQL语句
insert into ads.ads_user_info_wide_a
with  userinfo as(
    select product_id  ,user_id  ,account  ,nick  ,birthday  ,sex  ,create_tm_account  ,mt ,corever  ,app_ver  ,ver  ,current_language  ,current_language2  ,country,reg_country,reg_country2  ,email  ,money  ,gift_money  ,email_bound_status  ,is_negative_user,`level` ,user_type  ,`point`  ,jifen  ,ads_type,ads_quality,last_login_tm,remarketing_time
    from dim.dim_user_all_info
    where product_id in (3322,3311,3371,7757,3399)
),
      market as (
          select  dt,product_id,user_id,mt,corever,lang2,first_bookid,last_bookid,last_source,isremarket,install_date,updatetime
          from  dws.dws_user_market_channel_info_detail_td where  dt= '${bf_1_dt}'
                                                             and  product_id in (3322,3311,3371,7757,3399)
      ),
      consume as  (select dt,product_id,user_id,con_amount,fst_time,lst_time,consume_cnt,con_chapter_nums,total_bat_ulk_cnt,total_fix_ulk_cnt,sup_ulk_cnt,sup_ulk_sum,total_bat_ulk_money,start_sup_ulk_chp_cnt,start_sup_ulk_chp_money,start_bat_ulk_gear,start_bat_ulk_chp_cnt,start_bat_ulk_money,start_bat_ulk_giftmoney,etl_time
                   from dws.dws_consume_user_consume_a where dt= '${bf_1_dt}' and  product_id in (3322,3311,3371,7757,3399)
      ),
      read1 as (
          select  dt,user_id,product_id,total_read_bookids,total_read_chp_ids,total_read_days,new_bookid_chapid,new_chp_book_cnt,etl_time
          from dws.dws_read_user_read_roll_a where dt= '${bf_1_dt}' and  product_id in (3322,3311,3371,7757,3399)
      ),
      trade as (select dt,user_id,product_id,first_subscribe,first_subscribe_type,first_subscribe_time,last_subscribe,last_subscribe_type,last_subscribe_time,subscribe_cnt,shopitems,mul_subscribe,has_subscribe,first_recharge,first_recharge_time,total_recharge,recharge_cnt,recharge_avg,recharge_max,month_recharge_max,last_recharge,last_recharge_time,charge_mode,charge_mode_cnt,charge_mode_lst_time,etl_time  from dws.dws_trade_user_recharge_roll_a where dt= '${bf_1_dt}' and  product_id in (3322,3311,3371,7757,3399)
      ),
      login as (select dt,Product_id,User_Id,first_login_time,last_login_time,new_login_time,first_login_ip,last_login_ip,new_login_ip,remain_day,login_days,login_times,etl_time from  dws.dws_user_login_a where  dt= '${bf_1_dt}' and  product_id in (3322,3311,3371,7757,3399))
select
    '${bf_1_dt}' dt ,
    userinfo.product_id  ,
    userinfo.user_id  ,
    userinfo.account  ,
    userinfo.nick  ,
    userinfo.birthday  ,
    userinfo.sex  ,
    userinfo.create_tm_account as reg_tm ,
    userinfo.mt ,
    userinfo.corever  ,
    userinfo.app_ver  ,
    userinfo.ver  ,
    userinfo.current_language  ,
    userinfo.current_language2  ,
    userinfo.reg_country  ,
    userinfo.reg_country2,
    userinfo.email  ,
    userinfo.money  ,
    userinfo.gift_money  ,
    userinfo.email_bound_status  ,
    userinfo.is_negative_user,
    userinfo.`level` as  level_country,
    userinfo.user_type  ,
    userinfo.`point` as points  ,
    userinfo.jifen  ,
    userinfo.ads_type,
    userinfo.ads_quality,
    market.first_bookid as first_book_id,
    market.last_bookid as last_book_id ,
    market.last_source ,
    market.isremarket is_remarket,
    market.install_date ,
    CASE WHEN userinfo.product_id in('7757','8858','3333')  THEN datediff(substr(userinfo.last_login_tm,1,10),SUBSTR(remarketing_time,1,10))
        ELSE datediff(substr(userinfo.last_login_tm,1,10),SUBSTR(from_unixtime(unix_timestamp(remarketing_time, 'yyyy-MM-dd HH:mm:ss') + 3600 * 13, 'yyyy-MM-dd HH:mm:ss'),1,10)) END ,
    consume.con_amount ,
    consume.fst_time  as first_tm,
    consume.lst_time as last_tm,
    consume.consume_cnt ,
    consume.con_chapter_nums ,
    consume.total_bat_ulk_cnt ,
    consume.total_fix_ulk_cnt ,
    consume.sup_ulk_cnt ,
    consume.sup_ulk_sum,
    consume.total_bat_ulk_money,
    consume.start_sup_ulk_chp_cnt ,
    consume.start_sup_ulk_chp_money,
    consume.start_bat_ulk_gear,
    consume.start_bat_ulk_chp_cnt,
    consume.start_bat_ulk_money,
    consume.start_bat_ulk_giftmoney,
    bitmap_count(read1.total_read_bookids) total_read_bookids,
    bitmap_count(read1.total_read_chp_ids) total_read_chp_ids,
    read1.total_read_days,
    read1.new_chp_book_cnt,
    read1.total_read_days,
    trade.first_subscribe ,
    trade.first_subscribe_type,
    trade.first_subscribe_time ,
    trade.last_subscribe,
    trade.last_subscribe_type,
    trade.last_subscribe_time ,
    trade.subscribe_cnt,
    trade.mul_subscribe,
    trade.has_subscribe,
    trade.first_recharge,
    trade.first_recharge_time ,
    trade.total_recharge,
    trade.recharge_cnt,
    trade.recharge_avg,
    trade.recharge_max,
    trade.month_recharge_max,
    trade.last_recharge,
    trade.last_recharge_time ,
    trade.charge_mode ,
    login.first_login_time ,
    login.last_login_time ,
    login.new_login_time ,
    login.login_days,
    login.login_times,
    NOW() as etl_tm
FROM userinfo left join market
                        on userinfo.product_id = market.product_id and userinfo.user_id = market.user_id and  userinfo.mt = market.mt and userinfo.corever = market.corever and userinfo.current_language2 = market.lang2
              left  join consume
                         on userinfo.product_id = consume.product_id and  userinfo.user_id = consume.user_id
              left  join read1
                         on userinfo.product_id = read1.product_id and  userinfo.user_id = read1.user_id
              left  join trade
                         on userinfo.product_id = trade.product_id and  userinfo.user_id = trade.user_id
              left  join login
                         on userinfo.product_id = login.product_id and  userinfo.user_id = login.user_id;

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_user_info_wide_a
-- workflow_version : 16
-- create_user      : admin
-- task_name        : ads_user_info_wide_a_3366
-- task_version     : 1
-- update_time      : 2025-06-21 18:04:20
-- sql_path         : \starrocks\tbl_ads_user_info_wide_a\ads_user_info_wide_a_3366
----------------------------------------------------------------
-- SQL语句
insert into ads.ads_user_info_wide_a
with  userinfo as(
    select product_id  ,user_id  ,account  ,nick  ,birthday  ,sex  ,create_tm_account  ,mt ,corever  ,app_ver  ,ver  ,current_language  ,current_language2  ,country,reg_country,reg_country2  ,email  ,money  ,gift_money  ,email_bound_status  ,is_negative_user,`level` ,user_type  ,`point`  ,jifen  ,ads_type,ads_quality,last_login_tm,remarketing_time
    from dim.dim_user_all_info
    where product_id in (3366)
),
      market as (
          select  dt,product_id,user_id,mt,corever,lang2,first_bookid,last_bookid,last_source,isremarket,install_date,updatetime
          from  dws.dws_user_market_channel_info_detail_td where  dt= '${bf_1_dt}'
                                                             and  product_id in (3366)
      ),
      consume as  (select dt,product_id,user_id,con_amount,fst_time,lst_time,consume_cnt,con_chapter_nums,total_bat_ulk_cnt,total_fix_ulk_cnt,sup_ulk_cnt,sup_ulk_sum,total_bat_ulk_money,start_sup_ulk_chp_cnt,start_sup_ulk_chp_money,start_bat_ulk_gear,start_bat_ulk_chp_cnt,start_bat_ulk_money,start_bat_ulk_giftmoney,etl_time
                   from dws.dws_consume_user_consume_a where dt= '${bf_1_dt}' and  product_id in (3366)
      ),
      read1 as (
          select  dt,user_id,product_id,total_read_bookids,total_read_chp_ids,total_read_days,new_bookid_chapid,new_chp_book_cnt,etl_time
          from dws.dws_read_user_read_roll_a where dt= '${bf_1_dt}' and  product_id in (3366)
      ),
      trade as (select dt,user_id,product_id,first_subscribe,first_subscribe_type,first_subscribe_time,last_subscribe,last_subscribe_type,last_subscribe_time,subscribe_cnt,shopitems,mul_subscribe,has_subscribe,first_recharge,first_recharge_time,total_recharge,recharge_cnt,recharge_avg,recharge_max,month_recharge_max,last_recharge,last_recharge_time,charge_mode,charge_mode_cnt,charge_mode_lst_time,etl_time  from dws.dws_trade_user_recharge_roll_a where dt= '${bf_1_dt}' and  product_id in (3366)
      ),
      login as (select dt,Product_id,User_Id,first_login_time,last_login_time,new_login_time,first_login_ip,last_login_ip,new_login_ip,remain_day,login_days,login_times,etl_time from  dws.dws_user_login_a where  dt= '${bf_1_dt}' and  product_id in (3366))
select
    '${bf_1_dt}' dt ,
    userinfo.product_id  ,
    userinfo.user_id  ,
    userinfo.account  ,
    userinfo.nick  ,
    userinfo.birthday  ,
    userinfo.sex  ,
    userinfo.create_tm_account as reg_tm ,
    userinfo.mt ,
    userinfo.corever  ,
    userinfo.app_ver  ,
    userinfo.ver  ,
    userinfo.current_language  ,
    userinfo.current_language2  ,
    userinfo.reg_country  ,
    userinfo.reg_country2,
    userinfo.email  ,
    userinfo.money  ,
    userinfo.gift_money  ,
    userinfo.email_bound_status  ,
    userinfo.is_negative_user,
    userinfo.`level` as  level_country,
    userinfo.user_type  ,
    userinfo.`point` as points  ,
    userinfo.jifen  ,
    userinfo.ads_type,
    userinfo.ads_quality,
    market.first_bookid as first_book_id,
    market.last_bookid as last_book_id ,
    market.last_source ,
    market.isremarket is_remarket,
    market.install_date ,
    CASE WHEN userinfo.product_id in('7757','8858','3333')  THEN datediff(substr(userinfo.last_login_tm,1,10),SUBSTR(remarketing_time,1,10))
        ELSE datediff(substr(userinfo.last_login_tm,1,10),SUBSTR(from_unixtime(unix_timestamp(remarketing_time, 'yyyy-MM-dd HH:mm:ss') + 3600 * 13, 'yyyy-MM-dd HH:mm:ss'),1,10)) END ,
    consume.con_amount ,
    consume.fst_time  as first_tm,
    consume.lst_time as last_tm,
    consume.consume_cnt ,
    consume.con_chapter_nums ,
    consume.total_bat_ulk_cnt ,
    consume.total_fix_ulk_cnt ,
    consume.sup_ulk_cnt ,
    consume.sup_ulk_sum,
    consume.total_bat_ulk_money,
    consume.start_sup_ulk_chp_cnt ,
    consume.start_sup_ulk_chp_money,
    consume.start_bat_ulk_gear,
    consume.start_bat_ulk_chp_cnt,
    consume.start_bat_ulk_money,
    consume.start_bat_ulk_giftmoney,
    bitmap_count(read1.total_read_bookids) total_read_bookids,
    bitmap_count(read1.total_read_chp_ids) total_read_chp_ids,
    read1.total_read_days,
    read1.new_chp_book_cnt,
    read1.total_read_days,
    trade.first_subscribe ,
    trade.first_subscribe_type,
    trade.first_subscribe_time ,
    trade.last_subscribe,
    trade.last_subscribe_type,
    trade.last_subscribe_time ,
    trade.subscribe_cnt,
    trade.mul_subscribe,
    trade.has_subscribe,
    trade.first_recharge,
    trade.first_recharge_time ,
    trade.total_recharge,
    trade.recharge_cnt,
    trade.recharge_avg,
    trade.recharge_max,
    trade.month_recharge_max,
    trade.last_recharge,
    trade.last_recharge_time ,
    trade.charge_mode ,
    login.first_login_time ,
    login.last_login_time ,
    login.new_login_time ,
    login.login_days,
    login.login_times,
    NOW() as etl_tm
FROM userinfo left join market
                        on userinfo.product_id = market.product_id and userinfo.user_id = market.user_id and  userinfo.mt = market.mt and userinfo.corever = market.corever and userinfo.current_language2 = market.lang2
              left  join consume
                         on userinfo.product_id = consume.product_id and  userinfo.user_id = consume.user_id
              left  join read1
                         on userinfo.product_id = read1.product_id and  userinfo.user_id = read1.user_id
              left  join trade
                         on userinfo.product_id = trade.product_id and  userinfo.user_id = trade.user_id
              left  join login
                         on userinfo.product_id = login.product_id and  userinfo.user_id = login.user_id;
