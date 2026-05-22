----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_offline_label
-- workflow_version : 72
-- create_user      : zhengtt
-- task_name        : ads_offline_label_user_recharge_consume
-- task_version     : 2
-- update_time      : 2024-10-16 11:25:04
-- sql_path         : \starrocks\tbl_ads_offline_label\ads_offline_label_user_recharge_consume
----------------------------------------------------------------
-- SQL语句
insert  into ads.ads_offline_label_user_recharge_consume
with trade as (  -- 订阅
select  dt,user_id,product_id,first_subscribe,first_subscribe_type,first_subscribe_time,last_subscribe,
last_subscribe_type,last_subscribe_time,subscribe_cnt,shopitems,mul_subscribe,has_subscribe,first_recharge,
first_recharge_time,total_recharge,recharge_cnt,recharge_avg,recharge_max,recharge_min,month_recharge_max,
last_recharge,last_recharge_time,charge_mode,charge_mode_cnt,charge_mode_lst_time,etl_time
FROM  dws.dws_trade_user_recharge_roll_a  where dt ='${bf_1_dt}'
),
consume as (  -- 解锁
select dt,Product_id,User_Id,con_amount,fst_time,lst_time,consume_cnt,con_chapter_nums,total_bat_ulk_cnt,
total_fix_ulk_cnt,sup_ulk_cnt,sup_ulk_sum,total_bat_ulk_money,start_sup_ulk_chp_cnt,start_sup_ulk_chp_money,
start_bat_ulk_gear,start_bat_ulk_chp_cnt,start_bat_ulk_money,start_bat_ulk_giftmoney,etl_time
FROM  dws.dws_consume_user_consume_a where dt ='${bf_1_dt}'
),
coin as (  -- 阅币 礼券金额
select dt,Product_id,User_Id,
sum(if (types =1 ,con_amount,0)) coin_consumption,
sum(if (types =2 ,con_amount,0)) certificate_consumption -- 礼券
from dws.dws_consume_user_consume_td_mid where dt ='${bf_1_dt}' group by dt,Product_id,User_Id
),
fir as  (
select  dt,product_id,user_id,cnt,max_create_tm,min_create_tm FROM  dws.dws_consume_chapter_cnt_a  where dt ='${bf_1_dt}'
)
select
COALESCE(trade.dt,consume.dt,coin.dt,fir.dt) dt,
COALESCE(trade.user_id,consume.user_id,coin.user_id,fir.user_id) user_id,
COALESCE(trade.product_id,consume.product_id,coin.product_id,fir.product_id),
trade.first_subscribe start_subscribe,
trade.first_subscribe_type start_subscribe_type,
trade.first_subscribe_time start_subscribe_time,
trade.last_subscribe,
trade.last_subscribe_type,
trade.last_subscribe_time,
--trade.is_month_card,
--trade.is_subscribeing,
if(trade.last_subscribe_time>date_sub('${bf_0_dt}',30),1,0) as is_month_card,
if(trade.last_subscribe_time>date_sub('${bf_0_dt}',30),1,0) as is_subscribeing,
trade.subscribe_cnt,
trade.shopitems,
trade.mul_subscribe,
trade.has_subscribe his_subscribe,
trade.first_recharge,
trade.first_recharge_time,
trade.total_recharge,
trade.recharge_cnt,
trade.recharge_avg,
trade.recharge_max,
trade.month_recharge_max,
trade.last_recharge,
trade.last_recharge_time,
--解锁
consume.start_bat_ulk_gear,
consume.start_bat_ulk_chp_cnt,
consume.total_bat_ulk_cnt,
consume.total_fix_ulk_cnt,
consume.start_sup_ulk_chp_cnt,
consume.sup_ulk_cnt,
consume.sup_ulk_sum,
coin.coin_consumption,
coin.certificate_consumption,
fir.cnt purcharse_cnt,
fir.max_create_tm last_purcharse_time,
consume.con_chapter_nums total_consumption,
NOW()
from trade
full join consume on trade.user_id = consume.user_id and  trade.product_id = consume.product_id
full join coin on COALESCE(trade.user_id,consume.user_id) = coin.user_id and  COALESCE(trade.product_id,consume.product_id) = coin.product_id
full join fir on COALESCE(trade.user_id,consume.user_id,coin.user_id) = fir.user_id and  COALESCE(trade.product_id,consume.product_id,coin.product_id) = fir.product_id;

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_offline_label_user_recharge_consume
-- workflow_version : 5
-- create_user      : zhugl
-- task_name        : tab_ads_offline_label_user_recharge_consume
-- task_version     : 5
-- update_time      : 2024-01-24 11:09:57
-- sql_path         : \starrocks\tbl_ads_offline_label_user_recharge_consume\tab_ads_offline_label_user_recharge_consume
----------------------------------------------------------------
-- SQL语句
insert  into ads.ads_offline_label_user_recharge_consume
with trade as (  -- 订阅
select  dt,user_id,product_id,first_subscribe,first_subscribe_type,first_subscribe_time,last_subscribe,
last_subscribe_type,last_subscribe_time,subscribe_cnt,shopitems,mul_subscribe,has_subscribe,first_recharge,
first_recharge_time,total_recharge,recharge_cnt,recharge_avg,recharge_max,recharge_min,month_recharge_max,
last_recharge,last_recharge_time,charge_mode,charge_mode_cnt,charge_mode_lst_time,etl_time
FROM  dws.dws_trade_user_recharge_roll_a  where dt ='${bf_1_dt}'
),
consume as (  -- 解锁
select dt,product_id,user_id,con_amount,fst_time,lst_time,consume_cnt,con_chapter_nums,total_bat_ulk_cnt,
total_fix_ulk_cnt,sup_ulk_cnt,sup_ulk_sum,total_bat_ulk_money,start_sup_ulk_chp_cnt,start_sup_ulk_chp_money,
start_bat_ulk_gear,start_bat_ulk_chp_cnt,start_bat_ulk_money,start_bat_ulk_giftmoney,etl_time
FROM  dws.dws_consume_user_consume_a where dt ='${bf_1_dt}'
),
coin as (  -- 阅币 礼券金额
select dt,Product_id,User_Id,
sum(if (types =1 ,con_amount,0)) coin_consumption,
sum(if (types =2 ,con_amount,0)) certificate_consumption -- 礼券
from dws.dws_consume_user_consume_td_mid where dt ='${bf_1_dt}' group by dt,Product_id,User_Id
),
fir as  (
select  dt,product_id,user_id,cnt,max_create_tm,min_create_tm FROM  dws.dws_consume_chapter_cnt_a  where dt ='${bf_1_dt}'
)
select
COALESCE(trade.dt,consume.dt,coin.dt,fir.dt) dt,
COALESCE(trade.user_id,consume.user_id,coin.user_id,fir.user_id) user_id,
COALESCE(trade.product_id,consume.product_id,coin.product_id,fir.product_id),
trade.first_subscribe start_subscribe,
trade.first_subscribe_type start_subscribe_type,
trade.first_subscribe_time start_subscribe_time,
trade.last_subscribe,
trade.last_subscribe_type,
trade.last_subscribe_time,
--trade.is_month_card,
--trade.is_subscribeing,
if(trade.last_subscribe_time>date_sub('${bf_0_dt}',30),1,0) as is_month_card,
if(trade.last_subscribe_time>date_sub('${bf_0_dt}',30),1,0) as is_subscribeing,
trade.subscribe_cnt,
trade.shopitems,
trade.mul_subscribe,
trade.has_subscribe his_subscribe,
trade.first_recharge,
trade.first_recharge_time,
trade.total_recharge,
trade.recharge_cnt,
trade.recharge_avg,
trade.recharge_max,
trade.month_recharge_max,
trade.last_recharge,
trade.last_recharge_time,
--解锁
consume.start_bat_ulk_gear,
consume.start_bat_ulk_chp_cnt,
consume.total_bat_ulk_cnt,
consume.total_fix_ulk_cnt,
consume.start_sup_ulk_chp_cnt,
consume.sup_ulk_cnt,
consume.sup_ulk_sum,
coin.coin_consumption,
coin.certificate_consumption,
fir.cnt purcharse_cnt,
fir.max_create_tm last_purcharse_time,
consume.con_chapter_nums total_consumption,
NOW()
from trade
full join consume on trade.user_id = consume.user_id and  trade.product_id = consume.product_id
full join coin on COALESCE(trade.user_id,consume.user_id) = coin.user_id and  COALESCE(trade.product_id,consume.product_id) = coin.product_id
full join fir on COALESCE(trade.user_id,consume.user_id,coin.user_id) = fir.user_id and  COALESCE(trade.product_id,consume.product_id,coin.product_id) = fir.product_id;
