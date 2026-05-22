----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_sensors_user_info_init
-- workflow_version : 26
-- create_user      : zhugl
-- task_name        : tab_dwd_user_userrealtimetagvalue
-- task_version     : 1
-- update_time      : 2023-12-19 15:42:22
-- sql_path         : \starrocks\tbl_sensors_user_info_init\tab_dwd_user_userrealtimetagvalue
----------------------------------------------------------------
-- SQL语句
insert into  dwd.dwd_user_userrealtimetagvalue
select date_sub(CURRENT_DATE(),interval 1 day ) dt,id,productid,channelinfos,login_days,logininfo_json,recharged,first_recharge,total_recharge,
recharge_avg,recharge_max,month_recharge_max,last_recharge,recharge_cnt,last_recharge_time,subscribe,
start_subscribe,start_subscribe_time,mul_subscribe,his_mul_subscribe,purcharse_cnt,last_purcharse_time,
more_onem_total_read_books,total_read_chp,total_bat_ulk_cnt,start_bat_ulk_chp_cnt,total_fix_ulk_cnt,
start_sup_ulk_chp_cnt,sup_ulk_cnt,sup_ulk_sum,total_consumption,coin_consumption,certificate_consumption,
charge_mode,total_bat_ulk_money,subscribe_all_money,subscribe_svip_money,subscribe_signcardplus_money,
subscribe_signcardplusplus_money,total_subscribe_money,his_subscribe_svip_money,his_subscribe_signcardplus_money,
his_subscribe_signcardplusplus_money,start_bat_ulk_money,his_subscribe_all_money,row_update_time
from ods_log.ods_tidb_readernovel_tidb_xx_userrealtimetagvalue_hive;
