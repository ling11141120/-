----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_sensors_user_info_init
-- workflow_version : 26
-- create_user      : zhugl
-- task_name        : ads_userinfo_all_sensors_1
-- task_version     : 1
-- update_time      : 2023-12-22 14:51:36
-- sql_path         : \starrocks\tbl_sensors_user_info_init\ads_userinfo_all_sensors_1
----------------------------------------------------------------
-- SQL语句
insert into  ads.ads_userinfo_all_sensors
select
userid,
-- udf.deal_json_null(
JSON_OBJECT('distinct_id',userid,'type','profile_set',
'time',cast (cast(UNIX_TIMESTAMP(NOW())  as double )*1000 as bigint) ,
'project','default',
'identities',
JSON_OBJECT('identity_userID',userid,'\$identity_login_id',userid),
'properties',
JSON_OBJECT(
'userID',userID,
'first_book',first_book,
'last_book',last_book,
'login_days',login_days,
'recharged',recharged,
'last_recharge_time',last_recharge_time,
'subscribe',subscribe,
'purcharse',purcharse,
'last_purcharse_time',last_purcharse_time,
'coin_cnt',coin_cnt,
'is_read',is_read,
'total_read_time',total_read_time,
'first_currentlanguage2',first_currentlanguage2,
'last_currentlanguage2',last_currentlanguage2,
'certificate_cnt',certificate_cnt,
'last_login_time',last_login_time,
'createtime',createtime,
'createtime_hours',createtime_hours,
'is_left',is_left,
'is_remarketing',is_remarketing,
'ads_quality',ads_quality,
'first_media_name',first_media_name,
'last_media_name',last_media_name,
'charge_mode',charge_mode,
'subscribe_svip_money',subscribe_svip_money,
'his_subscribe_svip_money',his_subscribe_svip_money,
'his_subscribe_all_money',his_subscribe_all_money,
'remarketingTimeDays',remarketingTimeDays,
'first_recharge_time',cast(first_recharge_time as string ),
'first_read_time',cast(first_read_time as string ),
'first_recharge',first_recharge,
'total_recharge',total_recharge,
'recharge_avg',recharge_avg,
'recharge_max',recharge_max,
'month_recharge_max',month_recharge_max,
'last_recharge',last_recharge,
'recharge_cnt',recharge_cnt,
'start_subscribe',start_subscribe,
'mul_subscribe',mul_subscribe,
'his_subscribe',his_subscribe,
'more_onem_total_read_books',more_onem_total_read_books,
'total_read_chp',total_read_chp,
'read_time_da_avg',read_time_da_avg,
'total_bat_ulk',total_bat_ulk,
'start_bat_ulk_chp_cnt',start_bat_ulk_chp_cnt,
'total_bat_ulk_cnt',total_bat_ulk_cnt,
'total_fix_ulk',total_fix_ulk,
'total_fix_ulk_cnt',total_fix_ulk_cnt,
'start_sup_ulk_chp',start_sup_ulk_chp,
'start_sup_ulk_chp_cnt',start_sup_ulk_chp_cnt,
'sup_ulk_cnt',sup_ulk_cnt,
'sup_ulk_sum',sup_ulk_sum,
'total_consumption',total_consumption,
'coin_consumption',coin_consumption,
'certificate_consumption',certificate_consumption,
'purcharse_cnt',purcharse_cnt,
'total_bat_ulk_money',total_bat_ulk_money,
'subscribe_all_money',subscribe_all_money,
'subscribe_signcardplus_money',subscribe_signcardplus_money,
'subscribe_signcardplusplus_money',subscribe_signcardplusplus_money,
'total_subscribe_money',total_subscribe_money,
'his_subscribe_signcardplus_money',his_subscribe_signcardplus_money,
'his_subscribe_signcardplusplus_money',his_subscribe_signcardplusplus_money,
'his_mul_subscribe',his_mul_subscribe,
'start_bat_ulk_money',start_bat_ulk_money,
'last_country',last_country
)) json1
from  dws.dws_user_allinfo_sensors_end_a where userid>125229077 ;

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_sensors_user_info_init
-- workflow_version : 26
-- create_user      : zhugl
-- task_name        : tbl_ads_userinfo_all_sensors
-- task_version     : 10
-- update_time      : 2023-12-22 14:51:36
-- sql_path         : \starrocks\tbl_sensors_user_info_init\tbl_ads_userinfo_all_sensors
----------------------------------------------------------------
-- 前置SQL语句
truncate table ads.ads_userinfo_all_sensors;

-- SQL语句
insert into  ads.ads_userinfo_all_sensors
select
userid,
-- udf.deal_json_null(
JSON_OBJECT('distinct_id',userid,'type','profile_set',
'time',cast (cast(UNIX_TIMESTAMP(NOW())  as double )*1000 as bigint) ,
'project','default',
'identities',
JSON_OBJECT('identity_userID',userid,'\$identity_login_id',userid),
'properties',
JSON_OBJECT(
'userID',userID,
'first_book',first_book,
'last_book',last_book,
'login_days',login_days,
'recharged',recharged,
'last_recharge_time',last_recharge_time,
'subscribe',subscribe,
'purcharse',purcharse,
'last_purcharse_time',last_purcharse_time,
'coin_cnt',coin_cnt,
'is_read',is_read,
'total_read_time',total_read_time,
'first_currentlanguage2',first_currentlanguage2,
'last_currentlanguage2',last_currentlanguage2,
'certificate_cnt',certificate_cnt,
'last_login_time',last_login_time,
'createtime',createtime,
'createtime_hours',createtime_hours,
'is_left',is_left,
'is_remarketing',is_remarketing,
'ads_quality',ads_quality,
'first_media_name',first_media_name,
'last_media_name',last_media_name,
'charge_mode',charge_mode,
'subscribe_svip_money',subscribe_svip_money,
'his_subscribe_svip_money',his_subscribe_svip_money,
'his_subscribe_all_money',his_subscribe_all_money,
'remarketingTimeDays',remarketingTimeDays,
'first_recharge_time',cast(first_recharge_time as string ),
'first_read_time',cast(first_read_time as string ),
'first_recharge',first_recharge,
'total_recharge',total_recharge,
'recharge_avg',recharge_avg,
'recharge_max',recharge_max,
'month_recharge_max',month_recharge_max,
'last_recharge',last_recharge,
'recharge_cnt',recharge_cnt,
'start_subscribe',start_subscribe,
'mul_subscribe',mul_subscribe,
'his_subscribe',his_subscribe,
'more_onem_total_read_books',more_onem_total_read_books,
'total_read_chp',total_read_chp,
'read_time_da_avg',read_time_da_avg,
'total_bat_ulk',total_bat_ulk,
'start_bat_ulk_chp_cnt',start_bat_ulk_chp_cnt,
'total_bat_ulk_cnt',total_bat_ulk_cnt,
'total_fix_ulk',total_fix_ulk,
'total_fix_ulk_cnt',total_fix_ulk_cnt,
'start_sup_ulk_chp',start_sup_ulk_chp,
'start_sup_ulk_chp_cnt',start_sup_ulk_chp_cnt,
'sup_ulk_cnt',sup_ulk_cnt,
'sup_ulk_sum',sup_ulk_sum,
'total_consumption',total_consumption,
'coin_consumption',coin_consumption,
'certificate_consumption',certificate_consumption,
'purcharse_cnt',purcharse_cnt,
'total_bat_ulk_money',total_bat_ulk_money,
'subscribe_all_money',subscribe_all_money,
'subscribe_signcardplus_money',subscribe_signcardplus_money,
'subscribe_signcardplusplus_money',subscribe_signcardplusplus_money,
'total_subscribe_money',total_subscribe_money,
'his_subscribe_signcardplus_money',his_subscribe_signcardplus_money,
'his_subscribe_signcardplusplus_money',his_subscribe_signcardplusplus_money,
'his_mul_subscribe',his_mul_subscribe,
'start_bat_ulk_money',start_bat_ulk_money,
'last_country',last_country
)) json1
from  dws.dws_user_allinfo_sensors_end_a where userid<=125229077 ;
