----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_sensors_user_info_init
-- workflow_version : 26
-- create_user      : zhugl
-- task_name        : tbl_dws_user_allinfo_sensors_a_1
-- task_version     : 8
-- update_time      : 2023-12-21 18:26:14
-- sql_path         : \starrocks\tbl_sensors_user_info_init\tbl_dws_user_allinfo_sensors_a_1
----------------------------------------------------------------
-- SQL语句
insert into dws.dws_user_allinfo_sensors_a
with usertag as  (select dt,user_id userid,product_id productid,first_book,last_book,login_days,recharged,first_recharge,total_recharge,
recharge_avg,recharge_max,month_recharge_max,last_recharge,recharge_cnt,last_recharge_time,subscribe,start_subscribe,
start_subscribe_time,mul_subscribe,his_mul_subscribe,last_purcharse_time,coin_cn,total_read_time,more_onem_total_read_books,
total_read_chp,start_bat_ulk_chp_cnt,total_bat_ulk_cnt,total_fix_ulk_cnt,start_sup_ulk_chp_cnt,sup_ulk_cnt,sup_ulk_sum,
total_consumption,first_currentlanguage2,last_currentlanguage2,certificate_cnt,last_login_time,createtime,coin_consumption,
certificate_consumption,purcharse_cnt,is_left,is_remarketing,ads_quality,first_media_name,last_media_name,total_bat_ulk_money,
subscribe_all_money,subscribe_svip_money,subscribe_signcardplus_money,subscribe_signcardplusplus_money,total_subscribe_money,
his_subscribe_svip_money,his_subscribe_signcardplus_money,his_subscribe_signcardplusplus_money,his_subscribe_all_money,remarketingtime,
last_country,mt from dwd.dwd_user_userrealtimetagvalue_userinfo where dt = date_sub(current_date(),interval 1 day ) and user_id<=110229077),
-- 用户登录 dws.dws_user_logininfo_sensors_a
user_login as (select dt,userid,last_login_time last_save_time ,last_login_productid,first_login_time,first_login_productid
last_common_time,last_common_productid
from dws.dws_user_logininfo_sensors_a where dt =  date_sub(current_date(),interval 1 day ) and userid<=110229077),
-- 登录天数  dws.dws_user_logindays_sensors_a
user_d as (select dt,userid,cnt login_days  FROM dws.dws_user_logindays_sensors_a
where dt = date_sub(current_date(),interval 1 day ) and userid<=110229077 ),
-- 首次媒体 dws.dws_userfist_lastmarket_sensors_a
lastmarket as (select dt,userid,first_media_name,last_media_name,first_book,last_book,first_currentlanguage2,last_currentlanguage2
from dws.dws_userfist_lastmarket_sensors_a where dt = date_sub(current_date(),interval 1 day ) and userid<=110229077),
-- 充值金额 dws.dws_user_charge_first_last_sensors_a 没有dt
charge as (select userid,itemcount,charge_cnt,last_charge_time,first_charge_time,frist_itemcount,first_read_time
FROM dws.dws_user_charge_first_last_sensors_a where   userid<=110229077),
-- 首次订阅
sub as (select user_id userid,first_subscribe start_subscribe,first_subscribe_time
from(
select user_id,first_subscribe,first_subscribe_time,
ROW_NUMBER() over(partition by user_id order by first_subscribe_time) n
from  dws.dws_trade_user_recharge_roll_a where dt=date_sub(current_date(),interval 1 day ) and  first_subscribe is  not  null
)a where n=1 and user_id<=110229077),
-- 批量解锁
chpt as (select
user_id userid,
FIRST_VALUE(start_bat_ulk_chp_cnt) over(partition by user_id order by  start_bat_ulk_time asc rows between unbounded preceding and unbounded following) start_bat_ulk_chp_cnt,
FIRST_VALUE(start_bat_ulk_money) over(partition by user_id order by  start_bat_ulk_time asc rows between unbounded preceding and unbounded following) start_bat_ulk_money,
FIRST_VALUE(start_sup_ulk_chp_cnt) over(partition by user_id order by  start_sup_ulk_chp_time asc rows between unbounded preceding and unbounded following) start_sup_ulk_chp_cnt,
ROW_NUMBER() over (partition by user_id order by start_bat_ulk_time) n
from dws.dws_consume_user_chapter_ulk_td_mid where dt =date_sub(current_date(),interval 1 day )  and user_id<=110229077),
-- 阅读时长
readt as (
select  userid,createtime from dws.dws_user_first_read_time_sensors_a where  userid<=110229077)
select
usertag.userID,
lastmarket.first_book,
lastmarket.last_book,
user_d.login_days,
'' recharged,
frist_itemcount first_recharge ,
SUM(total_recharge) over (partition by usertag.userID ) total_recharge,
max(recharge_max) over (partition by usertag.userID ) recharge_max,
max(month_recharge_max) over (partition by usertag.userID ) month_recharge_max,
first_value(last_recharge) over (partition by usertag.userID order by last_recharge_time desc rows between unbounded preceding and unbounded following)last_recharge,
SUM(recharge_cnt) over (partition by usertag.userID ) recharge_cnt,
max(last_recharge_time) over (partition by usertag.userID ) last_recharge_time,
last_value(subscribe) over (partition by usertag.userID order by if(productid =last_login_productid,last_login_time,null) ASC rows between unbounded preceding and unbounded following)subscribe,
sub.start_subscribe,
last_value(mul_subscribe) over (partition by usertag.userID order by if(productid =last_login_productid,last_login_time,null) ASC rows between unbounded preceding and unbounded following)mul_subscribe,
SUM(purcharse_cnt) over (partition by usertag.userID ) purcharseCnt,
first_value(last_purcharse_time) over (partition by usertag.userID order by last_purcharse_time desc rows between unbounded preceding and unbounded following) last_purcharse_time,
last_value(coin_cn) over (partition by usertag.userID order by if (productid =last_login_productid,last_login_time,null) ASC rows between unbounded preceding and unbounded following) coin_cnt,
SUM(total_read_time) over (partition by usertag.userID )total_read_time ,
SUM(more_onem_total_read_books) over (partition by usertag.userID ) more_onem_total_read_books ,
SUM(total_read_chp) over (partition by usertag.userID )total_read_chp ,
'' total_bat_ulk,
chpt.start_bat_ulk_chp_cnt ,
SUM(total_bat_ulk_cnt) over (partition by usertag.userID )total_bat_ulk_cnt ,
'' total_fix_ulk ,
SUM(total_fix_ulk_cnt) over (partition by usertag.userID )total_fix_ulk_cnt ,
'' start_sup_ulk_chp,
chpt.start_sup_ulk_chp_cnt,
SUM(sup_ulk_cnt) over (partition by usertag.userID )sup_ulk_cnt ,
SUM(sup_ulk_sum) over (partition by usertag.userID )sup_ulk_sum ,
SUM(total_consumption) over (partition by usertag.userID )total_consumption ,
lastmarket.first_currentlanguage2 ,
lastmarket.last_currentlanguage2 ,
last_value(certificate_cnt) over (partition by usertag.userID order by if (productid =last_login_productid,last_login_time,null) ASC rows between unbounded preceding and unbounded following) certificate_cnt ,
max(last_login_time) over (partition by usertag.userID ) last_login_time,
min(createtime) over (partition by usertag.userID )createtime ,
0.0 createtime_hours,
SUM(coin_consumption) over (partition by usertag.userID ) coin_consumption,
SUM(certificate_consumption) over (partition by usertag.userID ) certificate_consumption,
SUM(purcharse_cnt) over (partition by usertag.userID ) purcharse_cnt,
last_value(is_left) over (partition by usertag.userID order by if (productid =last_login_productid,last_login_time,null) ASC rows between unbounded preceding and unbounded following) is_left ,
last_value(is_remarketing) over (partition by usertag.userID order by if (productid =last_login_productid,last_login_time,null) ASC rows between unbounded preceding and unbounded following) is_remarketing,
last_value(ads_quality) over (partition by usertag.userID order by if (productid =last_login_productid,last_login_time,null) ASC rows between unbounded preceding and unbounded following) ads_quality,
lastmarket.first_media_name,
lastmarket.last_media_name,
charge.itemcount charge_mode ,
SUM(total_bat_ulk_money) over (partition by usertag.userID ) total_bat_ulk_money,
last_value(subscribe_all_money) over (partition by usertag.userID order by if (productid =last_login_productid,last_login_time,null) ASC rows between unbounded preceding and unbounded following) subscribe_all_money ,
last_value(subscribe_svip_money) over (partition by usertag.userID order by if (productid =last_login_productid,last_login_time,null) ASC rows between unbounded preceding and unbounded following) subscribe_svip_money ,
last_value(subscribe_signcardplus_money) over (partition by usertag.userID order by if (productid =last_login_productid,last_login_time,null) ASC rows between unbounded preceding and unbounded following) subscribe_signcardplus_money ,
last_value(subscribe_signcardplusplus_money) over (partition by usertag.userID order by if (productid =last_login_productid,last_login_time,null) ASC rows between unbounded preceding and unbounded following) subscribe_signcardplusplus_money ,
-- ARRAY_AGG(split(cast (total_subscribe_money as string ),',')) over(partition by usertag.userID ) total_subscribe_money ,
last_value(his_subscribe_svip_money) over (partition by usertag.userID order by if (productid =last_login_productid,last_login_time,null) ASC rows between unbounded preceding and unbounded following) his_subscribe_svip_money ,
-- ARRAY_AGG(split(cast (his_subscribe_signcardplus_money as string ),',')) over(partition by usertag.userID ) his_subscribe_signcardplus_money,
-- ARRAY_AGG(split(cast (his_subscribe_signcardplusplus_money as string ),',')) over(partition by usertag.userID ) his_subscribe_signcardplusplus_money,
max(his_mul_subscribe) over (partition by usertag.userID ) his_mul_subscribe,
chpt.start_bat_ulk_money,
last_value(his_subscribe_all_money) over (partition by usertag.userID order by if (productid =last_login_productid,last_login_time,null) ASC rows between unbounded preceding and unbounded following) his_subscribe_all_money ,
min(if(substr(remarketingtime,0,10)='1970-01-01',null,remarketingtime)) over(partition by usertag.userID ) remarketingtime,
charge.first_charge_time first_recharge_time, -- 首充时间
charge.first_read_time, -- 首次阅读时间
0 timecount,
last_save_time,
last_common_time,
last_login_productid productid,
last_value(last_country) over (partition by usertag.userID order by if (productid =last_login_productid,last_login_time,null) ASC rows between unbounded preceding and unbounded following) last_country ,
ROW_NUMBER() over (partition by usertag.userid ) n,
last_value(mt) over (partition by usertag.userID order by if (productid =last_login_productid,last_login_time,null) ASC rows between unbounded preceding and unbounded following) mt
from
usertag
left join user_login  on    usertag.userid = user_login.userid
left join user_d  on     usertag.userid = user_d.userid
left join lastmarket on usertag.userid = lastmarket.userid
left join charge on usertag.userid = charge.userid
left join sub on usertag.userid = sub.userid
left join chpt on usertag.userid = chpt.userid;

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_sensors_user_info_init
-- workflow_version : 26
-- create_user      : zhugl
-- task_name        : tbl_dws_user_allinfo_sensors_a_1_10m
-- task_version     : 8
-- update_time      : 2023-12-21 18:26:14
-- sql_path         : \starrocks\tbl_sensors_user_info_init\tbl_dws_user_allinfo_sensors_a_1_10m
----------------------------------------------------------------
-- SQL语句
insert into dws.dws_user_allinfo_sensors_a
with usertag as  (select dt,user_id userid,product_id productid,first_book,last_book,login_days,recharged,first_recharge,total_recharge,
recharge_avg,recharge_max,month_recharge_max,last_recharge,recharge_cnt,last_recharge_time,subscribe,start_subscribe,
start_subscribe_time,mul_subscribe,his_mul_subscribe,last_purcharse_time,coin_cn,total_read_time,more_onem_total_read_books,
total_read_chp,start_bat_ulk_chp_cnt,total_bat_ulk_cnt,total_fix_ulk_cnt,start_sup_ulk_chp_cnt,sup_ulk_cnt,sup_ulk_sum,
total_consumption,first_currentlanguage2,last_currentlanguage2,certificate_cnt,last_login_time,createtime,coin_consumption,
certificate_consumption,purcharse_cnt,is_left,is_remarketing,ads_quality,first_media_name,last_media_name,total_bat_ulk_money,
subscribe_all_money,subscribe_svip_money,subscribe_signcardplus_money,subscribe_signcardplusplus_money,total_subscribe_money,
his_subscribe_svip_money,his_subscribe_signcardplus_money,his_subscribe_signcardplusplus_money,his_subscribe_all_money,remarketingtime,
last_country,mt from dwd.dwd_user_userrealtimetagvalue_userinfo where dt = date_sub(current_date(),interval 1 day ) and user_id>120229077 and user_id<=130229077),
-- 用户登录 dws.dws_user_logininfo_sensors_a
user_login as (select dt,userid,last_login_time last_save_time ,last_login_productid,first_login_time,first_login_productid
last_common_time,last_common_productid
from dws.dws_user_logininfo_sensors_a where dt =  date_sub(current_date(),interval 1 day ) and userid>120229077 and userid<=130229077),
-- 登录天数  dws.dws_user_logindays_sensors_a
user_d as (select dt,userid,cnt login_days  FROM dws.dws_user_logindays_sensors_a
where dt = date_sub(current_date(),interval 1 day ) and userid>120229077 and userid<=130229077 ),
-- 首次媒体 dws.dws_userfist_lastmarket_sensors_a
lastmarket as (select dt,userid,first_media_name,last_media_name,first_book,last_book,first_currentlanguage2,last_currentlanguage2
from dws.dws_userfist_lastmarket_sensors_a where dt = date_sub(current_date(),interval 1 day ) and userid>120229077 and userid<=130229077),
-- 充值金额 dws.dws_user_charge_first_last_sensors_a 没有dt
charge as (select userid,itemcount,charge_cnt,last_charge_time,first_charge_time,frist_itemcount,first_read_time
FROM dws.dws_user_charge_first_last_sensors_a where   userid>120229077 and userid<=130229077),
-- 首次订阅
sub as (select user_id userid,first_subscribe start_subscribe,first_subscribe_time
from(
select user_id,first_subscribe,first_subscribe_time,
ROW_NUMBER() over(partition by user_id order by first_subscribe_time) n
from  dws.dws_trade_user_recharge_roll_a where dt=date_sub(current_date(),interval 1 day ) and  first_subscribe is  not  null
)a where n=1 and user_id>120229077 and user_id<=130229077),
-- 批量解锁
chpt as (select
user_id userid,
FIRST_VALUE(start_bat_ulk_chp_cnt) over(partition by user_id order by  start_bat_ulk_time asc rows between unbounded preceding and unbounded following) start_bat_ulk_chp_cnt,
FIRST_VALUE(start_bat_ulk_money) over(partition by user_id order by  start_bat_ulk_time asc rows between unbounded preceding and unbounded following) start_bat_ulk_money,
FIRST_VALUE(start_sup_ulk_chp_cnt) over(partition by user_id order by  start_sup_ulk_chp_time asc rows between unbounded preceding and unbounded following) start_sup_ulk_chp_cnt,
ROW_NUMBER() over (partition by user_id order by start_bat_ulk_time) n
from dws.dws_consume_user_chapter_ulk_td_mid where dt =date_sub(current_date(),interval 1 day )  and user_id>120229077 and user_id<=130229077),
-- 阅读时长
readt as (
select  userid,createtime from dws.dws_user_first_read_time_sensors_a where  userid>120229077 and userid<=130229077)
select
usertag.userID,
lastmarket.first_book,
lastmarket.last_book,
user_d.login_days,
'' recharged,
frist_itemcount first_recharge ,
SUM(total_recharge) over (partition by usertag.userID ) total_recharge,
max(recharge_max) over (partition by usertag.userID ) recharge_max,
max(month_recharge_max) over (partition by usertag.userID ) month_recharge_max,
first_value(last_recharge) over (partition by usertag.userID order by last_recharge_time desc rows between unbounded preceding and unbounded following)last_recharge,
SUM(recharge_cnt) over (partition by usertag.userID ) recharge_cnt,
max(last_recharge_time) over (partition by usertag.userID ) last_recharge_time,
last_value(subscribe) over (partition by usertag.userID order by if(productid =last_login_productid,last_login_time,null) ASC rows between unbounded preceding and unbounded following)subscribe,
sub.start_subscribe,
last_value(mul_subscribe) over (partition by usertag.userID order by if(productid =last_login_productid,last_login_time,null) ASC rows between unbounded preceding and unbounded following)mul_subscribe,
SUM(purcharse_cnt) over (partition by usertag.userID ) purcharseCnt,
first_value(last_purcharse_time) over (partition by usertag.userID order by last_purcharse_time desc rows between unbounded preceding and unbounded following) last_purcharse_time,
last_value(coin_cn) over (partition by usertag.userID order by if (productid =last_login_productid,last_login_time,null) ASC rows between unbounded preceding and unbounded following) coin_cnt,
SUM(total_read_time) over (partition by usertag.userID )total_read_time ,
SUM(more_onem_total_read_books) over (partition by usertag.userID ) more_onem_total_read_books ,
SUM(total_read_chp) over (partition by usertag.userID )total_read_chp ,
'' total_bat_ulk,
chpt.start_bat_ulk_chp_cnt ,
SUM(total_bat_ulk_cnt) over (partition by usertag.userID )total_bat_ulk_cnt ,
'' total_fix_ulk ,
SUM(total_fix_ulk_cnt) over (partition by usertag.userID )total_fix_ulk_cnt ,
'' start_sup_ulk_chp,
chpt.start_sup_ulk_chp_cnt,
SUM(sup_ulk_cnt) over (partition by usertag.userID )sup_ulk_cnt ,
SUM(sup_ulk_sum) over (partition by usertag.userID )sup_ulk_sum ,
SUM(total_consumption) over (partition by usertag.userID )total_consumption ,
lastmarket.first_currentlanguage2 ,
lastmarket.last_currentlanguage2 ,
last_value(certificate_cnt) over (partition by usertag.userID order by if (productid =last_login_productid,last_login_time,null) ASC rows between unbounded preceding and unbounded following) certificate_cnt ,
max(last_login_time) over (partition by usertag.userID ) last_login_time,
min(createtime) over (partition by usertag.userID )createtime ,
0.0 createtime_hours,
SUM(coin_consumption) over (partition by usertag.userID ) coin_consumption,
SUM(certificate_consumption) over (partition by usertag.userID ) certificate_consumption,
SUM(purcharse_cnt) over (partition by usertag.userID ) purcharse_cnt,
last_value(is_left) over (partition by usertag.userID order by if (productid =last_login_productid,last_login_time,null) ASC rows between unbounded preceding and unbounded following) is_left ,
last_value(is_remarketing) over (partition by usertag.userID order by if (productid =last_login_productid,last_login_time,null) ASC rows between unbounded preceding and unbounded following) is_remarketing,
last_value(ads_quality) over (partition by usertag.userID order by if (productid =last_login_productid,last_login_time,null) ASC rows between unbounded preceding and unbounded following) ads_quality,
lastmarket.first_media_name,
lastmarket.last_media_name,
charge.itemcount charge_mode ,
SUM(total_bat_ulk_money) over (partition by usertag.userID ) total_bat_ulk_money,
last_value(subscribe_all_money) over (partition by usertag.userID order by if (productid =last_login_productid,last_login_time,null) ASC rows between unbounded preceding and unbounded following) subscribe_all_money ,
last_value(subscribe_svip_money) over (partition by usertag.userID order by if (productid =last_login_productid,last_login_time,null) ASC rows between unbounded preceding and unbounded following) subscribe_svip_money ,
last_value(subscribe_signcardplus_money) over (partition by usertag.userID order by if (productid =last_login_productid,last_login_time,null) ASC rows between unbounded preceding and unbounded following) subscribe_signcardplus_money ,
last_value(subscribe_signcardplusplus_money) over (partition by usertag.userID order by if (productid =last_login_productid,last_login_time,null) ASC rows between unbounded preceding and unbounded following) subscribe_signcardplusplus_money ,
-- ARRAY_AGG(split(cast (total_subscribe_money as string ),',')) over(partition by usertag.userID ) total_subscribe_money ,
last_value(his_subscribe_svip_money) over (partition by usertag.userID order by if (productid =last_login_productid,last_login_time,null) ASC rows between unbounded preceding and unbounded following) his_subscribe_svip_money ,
-- ARRAY_AGG(split(cast (his_subscribe_signcardplus_money as string ),',')) over(partition by usertag.userID ) his_subscribe_signcardplus_money,
-- ARRAY_AGG(split(cast (his_subscribe_signcardplusplus_money as string ),',')) over(partition by usertag.userID ) his_subscribe_signcardplusplus_money,
max(his_mul_subscribe) over (partition by usertag.userID ) his_mul_subscribe,
chpt.start_bat_ulk_money,
last_value(his_subscribe_all_money) over (partition by usertag.userID order by if (productid =last_login_productid,last_login_time,null) ASC rows between unbounded preceding and unbounded following) his_subscribe_all_money ,
min(if(substr(remarketingtime,0,10)='1970-01-01',null,remarketingtime)) over(partition by usertag.userID ) remarketingtime,
charge.first_charge_time first_recharge_time, -- 首充时间
charge.first_read_time, -- 首次阅读时间
0 timecount,
last_save_time,
last_common_time,
last_login_productid productid,
last_value(last_country) over (partition by usertag.userID order by if (productid =last_login_productid,last_login_time,null) ASC rows between unbounded preceding and unbounded following) last_country ,
ROW_NUMBER() over (partition by usertag.userid ) n,
last_value(mt) over (partition by usertag.userID order by if (productid =last_login_productid,last_login_time,null) ASC rows between unbounded preceding and unbounded following) mt
from
usertag
left join user_login  on    usertag.userid = user_login.userid
left join user_d  on     usertag.userid = user_d.userid
left join lastmarket on usertag.userid = lastmarket.userid
left join charge on usertag.userid = charge.userid
left join sub on usertag.userid = sub.userid
left join chpt on usertag.userid = chpt.userid;

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_sensors_user_info_init
-- workflow_version : 26
-- create_user      : zhugl
-- task_name        : tbl_dws_user_allinfo_sensors_a_1_1w9
-- task_version     : 8
-- update_time      : 2023-12-21 18:26:14
-- sql_path         : \starrocks\tbl_sensors_user_info_init\tbl_dws_user_allinfo_sensors_a_1_1w9
----------------------------------------------------------------
-- SQL语句
insert into dws.dws_user_allinfo_sensors_a
with usertag as  (select dt,user_id userid,product_id productid,first_book,last_book,login_days,recharged,first_recharge,total_recharge,
recharge_avg,recharge_max,month_recharge_max,last_recharge,recharge_cnt,last_recharge_time,subscribe,start_subscribe,
start_subscribe_time,mul_subscribe,his_mul_subscribe,last_purcharse_time,coin_cn,total_read_time,more_onem_total_read_books,
total_read_chp,start_bat_ulk_chp_cnt,total_bat_ulk_cnt,total_fix_ulk_cnt,start_sup_ulk_chp_cnt,sup_ulk_cnt,sup_ulk_sum,
total_consumption,first_currentlanguage2,last_currentlanguage2,certificate_cnt,last_login_time,createtime,coin_consumption,
certificate_consumption,purcharse_cnt,is_left,is_remarketing,ads_quality,first_media_name,last_media_name,total_bat_ulk_money,
subscribe_all_money,subscribe_svip_money,subscribe_signcardplus_money,subscribe_signcardplusplus_money,total_subscribe_money,
his_subscribe_svip_money,his_subscribe_signcardplus_money,his_subscribe_signcardplusplus_money,his_subscribe_all_money,remarketingtime,
last_country,mt from dwd.dwd_user_userrealtimetagvalue_userinfo where dt = date_sub(current_date(),interval 1 day ) and user_id>140229077),
-- 用户登录 dws.dws_user_logininfo_sensors_a
user_login as (select dt,userid,last_login_time last_save_time ,last_login_productid,first_login_time,first_login_productid
last_common_time,last_common_productid
from dws.dws_user_logininfo_sensors_a where dt =  date_sub(current_date(),interval 1 day ) and userid>140229077),
-- 登录天数  dws.dws_user_logindays_sensors_a
user_d as (select dt,userid,cnt login_days  FROM dws.dws_user_logindays_sensors_a
where dt = date_sub(current_date(),interval 1 day ) and userid>140229077 ),
-- 首次媒体 dws.dws_userfist_lastmarket_sensors_a
lastmarket as (select dt,userid,first_media_name,last_media_name,first_book,last_book,first_currentlanguage2,last_currentlanguage2
from dws.dws_userfist_lastmarket_sensors_a where dt = date_sub(current_date(),interval 1 day ) and userid>140229077),
-- 充值金额 dws.dws_user_charge_first_last_sensors_a 没有dt
charge as (select userid,itemcount,charge_cnt,last_charge_time,first_charge_time,frist_itemcount,first_read_time
FROM dws.dws_user_charge_first_last_sensors_a where   userid>140229077),
-- 首次订阅
sub as (select user_id userid,first_subscribe start_subscribe,first_subscribe_time
from(
select user_id,first_subscribe,first_subscribe_time,
ROW_NUMBER() over(partition by user_id order by first_subscribe_time) n
from  dws.dws_trade_user_recharge_roll_a where dt=date_sub(current_date(),interval 1 day ) and  first_subscribe is  not  null
)a where n=1 and user_id>140229077),
-- 批量解锁
chpt as (select
user_id userid,
FIRST_VALUE(start_bat_ulk_chp_cnt) over(partition by user_id order by  start_bat_ulk_time asc rows between unbounded preceding and unbounded following) start_bat_ulk_chp_cnt,
FIRST_VALUE(start_bat_ulk_money) over(partition by user_id order by  start_bat_ulk_time asc rows between unbounded preceding and unbounded following) start_bat_ulk_money,
FIRST_VALUE(start_sup_ulk_chp_cnt) over(partition by user_id order by  start_sup_ulk_chp_time asc rows between unbounded preceding and unbounded following) start_sup_ulk_chp_cnt,
ROW_NUMBER() over (partition by user_id order by start_bat_ulk_time) n
from dws.dws_consume_user_chapter_ulk_td_mid where dt =date_sub(current_date(),interval 1 day )  and user_id>140229077),
-- 阅读时长
readt as (
select  userid,createtime from dws.dws_user_first_read_time_sensors_a where  userid>140229077)
select
usertag.userID,
lastmarket.first_book,
lastmarket.last_book,
user_d.login_days,
'' recharged,
frist_itemcount first_recharge ,
SUM(total_recharge) over (partition by usertag.userID ) total_recharge,
max(recharge_max) over (partition by usertag.userID ) recharge_max,
max(month_recharge_max) over (partition by usertag.userID ) month_recharge_max,
first_value(last_recharge) over (partition by usertag.userID order by last_recharge_time desc rows between unbounded preceding and unbounded following)last_recharge,
SUM(recharge_cnt) over (partition by usertag.userID ) recharge_cnt,
max(last_recharge_time) over (partition by usertag.userID ) last_recharge_time,
last_value(subscribe) over (partition by usertag.userID order by if(productid =last_login_productid,last_login_time,null) ASC rows between unbounded preceding and unbounded following)subscribe,
sub.start_subscribe,
last_value(mul_subscribe) over (partition by usertag.userID order by if(productid =last_login_productid,last_login_time,null) ASC rows between unbounded preceding and unbounded following)mul_subscribe,
SUM(purcharse_cnt) over (partition by usertag.userID ) purcharseCnt,
first_value(last_purcharse_time) over (partition by usertag.userID order by last_purcharse_time desc rows between unbounded preceding and unbounded following) last_purcharse_time,
last_value(coin_cn) over (partition by usertag.userID order by if (productid =last_login_productid,last_login_time,null) ASC rows between unbounded preceding and unbounded following) coin_cnt,
SUM(total_read_time) over (partition by usertag.userID )total_read_time ,
SUM(more_onem_total_read_books) over (partition by usertag.userID ) more_onem_total_read_books ,
SUM(total_read_chp) over (partition by usertag.userID )total_read_chp ,
'' total_bat_ulk,
chpt.start_bat_ulk_chp_cnt ,
SUM(total_bat_ulk_cnt) over (partition by usertag.userID )total_bat_ulk_cnt ,
'' total_fix_ulk ,
SUM(total_fix_ulk_cnt) over (partition by usertag.userID )total_fix_ulk_cnt ,
'' start_sup_ulk_chp,
chpt.start_sup_ulk_chp_cnt,
SUM(sup_ulk_cnt) over (partition by usertag.userID )sup_ulk_cnt ,
SUM(sup_ulk_sum) over (partition by usertag.userID )sup_ulk_sum ,
SUM(total_consumption) over (partition by usertag.userID )total_consumption ,
lastmarket.first_currentlanguage2 ,
lastmarket.last_currentlanguage2 ,
last_value(certificate_cnt) over (partition by usertag.userID order by if (productid =last_login_productid,last_login_time,null) ASC rows between unbounded preceding and unbounded following) certificate_cnt ,
max(last_login_time) over (partition by usertag.userID ) last_login_time,
min(createtime) over (partition by usertag.userID )createtime ,
0.0 createtime_hours,
SUM(coin_consumption) over (partition by usertag.userID ) coin_consumption,
SUM(certificate_consumption) over (partition by usertag.userID ) certificate_consumption,
SUM(purcharse_cnt) over (partition by usertag.userID ) purcharse_cnt,
last_value(is_left) over (partition by usertag.userID order by if (productid =last_login_productid,last_login_time,null) ASC rows between unbounded preceding and unbounded following) is_left ,
last_value(is_remarketing) over (partition by usertag.userID order by if (productid =last_login_productid,last_login_time,null) ASC rows between unbounded preceding and unbounded following) is_remarketing,
last_value(ads_quality) over (partition by usertag.userID order by if (productid =last_login_productid,last_login_time,null) ASC rows between unbounded preceding and unbounded following) ads_quality,
lastmarket.first_media_name,
lastmarket.last_media_name,
charge.itemcount charge_mode ,
SUM(total_bat_ulk_money) over (partition by usertag.userID ) total_bat_ulk_money,
last_value(subscribe_all_money) over (partition by usertag.userID order by if (productid =last_login_productid,last_login_time,null) ASC rows between unbounded preceding and unbounded following) subscribe_all_money ,
last_value(subscribe_svip_money) over (partition by usertag.userID order by if (productid =last_login_productid,last_login_time,null) ASC rows between unbounded preceding and unbounded following) subscribe_svip_money ,
last_value(subscribe_signcardplus_money) over (partition by usertag.userID order by if (productid =last_login_productid,last_login_time,null) ASC rows between unbounded preceding and unbounded following) subscribe_signcardplus_money ,
last_value(subscribe_signcardplusplus_money) over (partition by usertag.userID order by if (productid =last_login_productid,last_login_time,null) ASC rows between unbounded preceding and unbounded following) subscribe_signcardplusplus_money ,
-- ARRAY_AGG(split(cast (total_subscribe_money as string ),',')) over(partition by usertag.userID ) total_subscribe_money ,
last_value(his_subscribe_svip_money) over (partition by usertag.userID order by if (productid =last_login_productid,last_login_time,null) ASC rows between unbounded preceding and unbounded following) his_subscribe_svip_money ,
-- ARRAY_AGG(split(cast (his_subscribe_signcardplus_money as string ),',')) over(partition by usertag.userID ) his_subscribe_signcardplus_money,
-- ARRAY_AGG(split(cast (his_subscribe_signcardplusplus_money as string ),',')) over(partition by usertag.userID ) his_subscribe_signcardplusplus_money,
max(his_mul_subscribe) over (partition by usertag.userID ) his_mul_subscribe,
chpt.start_bat_ulk_money,
last_value(his_subscribe_all_money) over (partition by usertag.userID order by if (productid =last_login_productid,last_login_time,null) ASC rows between unbounded preceding and unbounded following) his_subscribe_all_money ,
min(if(substr(remarketingtime,0,10)='1970-01-01',null,remarketingtime)) over(partition by usertag.userID ) remarketingtime,
charge.first_charge_time first_recharge_time, -- 首充时间
charge.first_read_time, -- 首次阅读时间
0 timecount,
last_save_time,
last_common_time,
last_login_productid productid,
last_value(last_country) over (partition by usertag.userID order by if (productid =last_login_productid,last_login_time,null) ASC rows between unbounded preceding and unbounded following) last_country ,
ROW_NUMBER() over (partition by usertag.userid ) n,
last_value(mt) over (partition by usertag.userID order by if (productid =last_login_productid,last_login_time,null) ASC rows between unbounded preceding and unbounded following) mt
from
usertag
left join user_login  on    usertag.userid = user_login.userid
left join user_d  on     usertag.userid = user_d.userid
left join lastmarket on usertag.userid = lastmarket.userid
left join charge on usertag.userid = charge.userid
left join sub on usertag.userid = sub.userid
left join chpt on usertag.userid = chpt.userid;

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_sensors_user_info_init
-- workflow_version : 26
-- create_user      : zhugl
-- task_name        : tbl_dws_user_allinfo_sensors_a_1_2o0
-- task_version     : 8
-- update_time      : 2023-12-21 18:26:14
-- sql_path         : \starrocks\tbl_sensors_user_info_init\tbl_dws_user_allinfo_sensors_a_1_2o0
----------------------------------------------------------------
-- SQL语句
insert into dws.dws_user_allinfo_sensors_a
with usertag as  (select dt,user_id userid,product_id productid,first_book,last_book,login_days,recharged,first_recharge,total_recharge,
recharge_avg,recharge_max,month_recharge_max,last_recharge,recharge_cnt,last_recharge_time,subscribe,start_subscribe,
start_subscribe_time,mul_subscribe,his_mul_subscribe,last_purcharse_time,coin_cn,total_read_time,more_onem_total_read_books,
total_read_chp,start_bat_ulk_chp_cnt,total_bat_ulk_cnt,total_fix_ulk_cnt,start_sup_ulk_chp_cnt,sup_ulk_cnt,sup_ulk_sum,
total_consumption,first_currentlanguage2,last_currentlanguage2,certificate_cnt,last_login_time,createtime,coin_consumption,
certificate_consumption,purcharse_cnt,is_left,is_remarketing,ads_quality,first_media_name,last_media_name,total_bat_ulk_money,
subscribe_all_money,subscribe_svip_money,subscribe_signcardplus_money,subscribe_signcardplusplus_money,total_subscribe_money,
his_subscribe_svip_money,his_subscribe_signcardplus_money,his_subscribe_signcardplusplus_money,his_subscribe_all_money,remarketingtime,
last_country,mt from dwd.dwd_user_userrealtimetagvalue_userinfo where dt = date_sub(current_date(),interval 1 day ) and user_id>110229077 and user_id<=120229077),
-- 用户登录 dws.dws_user_logininfo_sensors_a
user_login as (select dt,userid,last_login_time last_save_time ,last_login_productid,first_login_time,first_login_productid
last_common_time,last_common_productid
from dws.dws_user_logininfo_sensors_a where dt =  date_sub(current_date(),interval 1 day ) and userid>110229077 and userid<=120229077),
-- 登录天数  dws.dws_user_logindays_sensors_a
user_d as (select dt,userid,cnt login_days  FROM dws.dws_user_logindays_sensors_a
where dt = date_sub(current_date(),interval 1 day ) and userid>110229077 and userid<=120229077 ),
-- 首次媒体 dws.dws_userfist_lastmarket_sensors_a
lastmarket as (select dt,userid,first_media_name,last_media_name,first_book,last_book,first_currentlanguage2,last_currentlanguage2
from dws.dws_userfist_lastmarket_sensors_a where dt = date_sub(current_date(),interval 1 day ) and userid>110229077 and userid<=120229077),
-- 充值金额 dws.dws_user_charge_first_last_sensors_a 没有dt
charge as (select userid,itemcount,charge_cnt,last_charge_time,first_charge_time,frist_itemcount,first_read_time
FROM dws.dws_user_charge_first_last_sensors_a where   userid>110229077 and userid<=120229077),
-- 首次订阅
sub as (select user_id userid,first_subscribe start_subscribe,first_subscribe_time
from(
select user_id,first_subscribe,first_subscribe_time,
ROW_NUMBER() over(partition by user_id order by first_subscribe_time) n
from  dws.dws_trade_user_recharge_roll_a where dt=date_sub(current_date(),interval 1 day ) and  first_subscribe is  not  null
)a where n=1 and user_id>110229077 and user_id<=120229077),
-- 批量解锁
chpt as (select
user_id userid,
FIRST_VALUE(start_bat_ulk_chp_cnt) over(partition by user_id order by  start_bat_ulk_time asc rows between unbounded preceding and unbounded following) start_bat_ulk_chp_cnt,
FIRST_VALUE(start_bat_ulk_money) over(partition by user_id order by  start_bat_ulk_time asc rows between unbounded preceding and unbounded following) start_bat_ulk_money,
FIRST_VALUE(start_sup_ulk_chp_cnt) over(partition by user_id order by  start_sup_ulk_chp_time asc rows between unbounded preceding and unbounded following) start_sup_ulk_chp_cnt,
ROW_NUMBER() over (partition by user_id order by start_bat_ulk_time) n
from dws.dws_consume_user_chapter_ulk_td_mid where dt =date_sub(current_date(),interval 1 day )  and user_id>110229077 and user_id<=120229077),
-- 阅读时长
readt as (
select  userid,createtime from dws.dws_user_first_read_time_sensors_a where  userid>110229077 and userid<=120229077)
select
usertag.userID,
lastmarket.first_book,
lastmarket.last_book,
user_d.login_days,
'' recharged,
frist_itemcount first_recharge ,
SUM(total_recharge) over (partition by usertag.userID ) total_recharge,
max(recharge_max) over (partition by usertag.userID ) recharge_max,
max(month_recharge_max) over (partition by usertag.userID ) month_recharge_max,
first_value(last_recharge) over (partition by usertag.userID order by last_recharge_time desc rows between unbounded preceding and unbounded following)last_recharge,
SUM(recharge_cnt) over (partition by usertag.userID ) recharge_cnt,
max(last_recharge_time) over (partition by usertag.userID ) last_recharge_time,
last_value(subscribe) over (partition by usertag.userID order by if(productid =last_login_productid,last_login_time,null) ASC rows between unbounded preceding and unbounded following)subscribe,
sub.start_subscribe,
last_value(mul_subscribe) over (partition by usertag.userID order by if(productid =last_login_productid,last_login_time,null) ASC rows between unbounded preceding and unbounded following)mul_subscribe,
SUM(purcharse_cnt) over (partition by usertag.userID ) purcharseCnt,
first_value(last_purcharse_time) over (partition by usertag.userID order by last_purcharse_time desc rows between unbounded preceding and unbounded following) last_purcharse_time,
last_value(coin_cn) over (partition by usertag.userID order by if (productid =last_login_productid,last_login_time,null) ASC rows between unbounded preceding and unbounded following) coin_cnt,
SUM(total_read_time) over (partition by usertag.userID )total_read_time ,
SUM(more_onem_total_read_books) over (partition by usertag.userID ) more_onem_total_read_books ,
SUM(total_read_chp) over (partition by usertag.userID )total_read_chp ,
'' total_bat_ulk,
chpt.start_bat_ulk_chp_cnt ,
SUM(total_bat_ulk_cnt) over (partition by usertag.userID )total_bat_ulk_cnt ,
'' total_fix_ulk ,
SUM(total_fix_ulk_cnt) over (partition by usertag.userID )total_fix_ulk_cnt ,
'' start_sup_ulk_chp,
chpt.start_sup_ulk_chp_cnt,
SUM(sup_ulk_cnt) over (partition by usertag.userID )sup_ulk_cnt ,
SUM(sup_ulk_sum) over (partition by usertag.userID )sup_ulk_sum ,
SUM(total_consumption) over (partition by usertag.userID )total_consumption ,
lastmarket.first_currentlanguage2 ,
lastmarket.last_currentlanguage2 ,
last_value(certificate_cnt) over (partition by usertag.userID order by if (productid =last_login_productid,last_login_time,null) ASC rows between unbounded preceding and unbounded following) certificate_cnt ,
max(last_login_time) over (partition by usertag.userID ) last_login_time,
min(createtime) over (partition by usertag.userID )createtime ,
0.0 createtime_hours,
SUM(coin_consumption) over (partition by usertag.userID ) coin_consumption,
SUM(certificate_consumption) over (partition by usertag.userID ) certificate_consumption,
SUM(purcharse_cnt) over (partition by usertag.userID ) purcharse_cnt,
last_value(is_left) over (partition by usertag.userID order by if (productid =last_login_productid,last_login_time,null) ASC rows between unbounded preceding and unbounded following) is_left ,
last_value(is_remarketing) over (partition by usertag.userID order by if (productid =last_login_productid,last_login_time,null) ASC rows between unbounded preceding and unbounded following) is_remarketing,
last_value(ads_quality) over (partition by usertag.userID order by if (productid =last_login_productid,last_login_time,null) ASC rows between unbounded preceding and unbounded following) ads_quality,
lastmarket.first_media_name,
lastmarket.last_media_name,
charge.itemcount charge_mode ,
SUM(total_bat_ulk_money) over (partition by usertag.userID ) total_bat_ulk_money,
last_value(subscribe_all_money) over (partition by usertag.userID order by if (productid =last_login_productid,last_login_time,null) ASC rows between unbounded preceding and unbounded following) subscribe_all_money ,
last_value(subscribe_svip_money) over (partition by usertag.userID order by if (productid =last_login_productid,last_login_time,null) ASC rows between unbounded preceding and unbounded following) subscribe_svip_money ,
last_value(subscribe_signcardplus_money) over (partition by usertag.userID order by if (productid =last_login_productid,last_login_time,null) ASC rows between unbounded preceding and unbounded following) subscribe_signcardplus_money ,
last_value(subscribe_signcardplusplus_money) over (partition by usertag.userID order by if (productid =last_login_productid,last_login_time,null) ASC rows between unbounded preceding and unbounded following) subscribe_signcardplusplus_money ,
-- ARRAY_AGG(split(cast (total_subscribe_money as string ),',')) over(partition by usertag.userID ) total_subscribe_money ,
last_value(his_subscribe_svip_money) over (partition by usertag.userID order by if (productid =last_login_productid,last_login_time,null) ASC rows between unbounded preceding and unbounded following) his_subscribe_svip_money ,
-- ARRAY_AGG(split(cast (his_subscribe_signcardplus_money as string ),',')) over(partition by usertag.userID ) his_subscribe_signcardplus_money,
-- ARRAY_AGG(split(cast (his_subscribe_signcardplusplus_money as string ),',')) over(partition by usertag.userID ) his_subscribe_signcardplusplus_money,
max(his_mul_subscribe) over (partition by usertag.userID ) his_mul_subscribe,
chpt.start_bat_ulk_money,
last_value(his_subscribe_all_money) over (partition by usertag.userID order by if (productid =last_login_productid,last_login_time,null) ASC rows between unbounded preceding and unbounded following) his_subscribe_all_money ,
min(if(substr(remarketingtime,0,10)='1970-01-01',null,remarketingtime)) over(partition by usertag.userID ) remarketingtime,
charge.first_charge_time first_recharge_time, -- 首充时间
charge.first_read_time, -- 首次阅读时间
0 timecount,
last_save_time,
last_common_time,
last_login_productid productid,
last_value(last_country) over (partition by usertag.userID order by if (productid =last_login_productid,last_login_time,null) ASC rows between unbounded preceding and unbounded following) last_country ,
ROW_NUMBER() over (partition by usertag.userid ) n,
last_value(mt) over (partition by usertag.userID order by if (productid =last_login_productid,last_login_time,null) ASC rows between unbounded preceding and unbounded following) mt
from
usertag
left join user_login  on    usertag.userid = user_login.userid
left join user_d  on     usertag.userid = user_d.userid
left join lastmarket on usertag.userid = lastmarket.userid
left join charge on usertag.userid = charge.userid
left join sub on usertag.userid = sub.userid
left join chpt on usertag.userid = chpt.userid;

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_sensors_user_info_init
-- workflow_version : 26
-- create_user      : zhugl
-- task_name        : tbl_dws_user_allinfo_sensors_a_1_5uo
-- task_version     : 8
-- update_time      : 2023-12-21 18:26:14
-- sql_path         : \starrocks\tbl_sensors_user_info_init\tbl_dws_user_allinfo_sensors_a_1_5uo
----------------------------------------------------------------
-- SQL语句
insert into dws.dws_user_allinfo_sensors_a
with usertag as  (select dt,user_id userid,product_id productid,first_book,last_book,login_days,recharged,first_recharge,total_recharge,
recharge_avg,recharge_max,month_recharge_max,last_recharge,recharge_cnt,last_recharge_time,subscribe,start_subscribe,
start_subscribe_time,mul_subscribe,his_mul_subscribe,last_purcharse_time,coin_cn,total_read_time,more_onem_total_read_books,
total_read_chp,start_bat_ulk_chp_cnt,total_bat_ulk_cnt,total_fix_ulk_cnt,start_sup_ulk_chp_cnt,sup_ulk_cnt,sup_ulk_sum,
total_consumption,first_currentlanguage2,last_currentlanguage2,certificate_cnt,last_login_time,createtime,coin_consumption,
certificate_consumption,purcharse_cnt,is_left,is_remarketing,ads_quality,first_media_name,last_media_name,total_bat_ulk_money,
subscribe_all_money,subscribe_svip_money,subscribe_signcardplus_money,subscribe_signcardplusplus_money,total_subscribe_money,
his_subscribe_svip_money,his_subscribe_signcardplus_money,his_subscribe_signcardplusplus_money,his_subscribe_all_money,remarketingtime,
last_country,mt from dwd.dwd_user_userrealtimetagvalue_userinfo where dt = date_sub(current_date(),interval 1 day ) and user_id>130229077 and  user_id<=140229077),
-- 用户登录 dws.dws_user_logininfo_sensors_a
user_login as (select dt,userid,last_login_time last_save_time ,last_login_productid,first_login_time,first_login_productid
last_common_time,last_common_productid
from dws.dws_user_logininfo_sensors_a where dt =  date_sub(current_date(),interval 1 day ) and userid>130229077 and  userid<=140229077),
-- 登录天数  dws.dws_user_logindays_sensors_a
user_d as (select dt,userid,cnt login_days  FROM dws.dws_user_logindays_sensors_a
where dt = date_sub(current_date(),interval 1 day ) and userid>130229077 and  userid<=140229077 ),
-- 首次媒体 dws.dws_userfist_lastmarket_sensors_a
lastmarket as (select dt,userid,first_media_name,last_media_name,first_book,last_book,first_currentlanguage2,last_currentlanguage2
from dws.dws_userfist_lastmarket_sensors_a where dt = date_sub(current_date(),interval 1 day ) and userid>130229077 and  userid<=140229077),
-- 充值金额 dws.dws_user_charge_first_last_sensors_a 没有dt
charge as (select userid,itemcount,charge_cnt,last_charge_time,first_charge_time,frist_itemcount,first_read_time
FROM dws.dws_user_charge_first_last_sensors_a where   userid>130229077 and  userid<=140229077),
-- 首次订阅
sub as (select user_id userid,first_subscribe start_subscribe,first_subscribe_time
from(
select user_id,first_subscribe,first_subscribe_time,
ROW_NUMBER() over(partition by user_id order by first_subscribe_time) n
from  dws.dws_trade_user_recharge_roll_a where dt=date_sub(current_date(),interval 1 day ) and  first_subscribe is  not  null
)a where n=1 and user_id>130229077 and  user_id<=140229077),
-- 批量解锁
chpt as (select
user_id userid,
FIRST_VALUE(start_bat_ulk_chp_cnt) over(partition by user_id order by  start_bat_ulk_time asc rows between unbounded preceding and unbounded following) start_bat_ulk_chp_cnt,
FIRST_VALUE(start_bat_ulk_money) over(partition by user_id order by  start_bat_ulk_time asc rows between unbounded preceding and unbounded following) start_bat_ulk_money,
FIRST_VALUE(start_sup_ulk_chp_cnt) over(partition by user_id order by  start_sup_ulk_chp_time asc rows between unbounded preceding and unbounded following) start_sup_ulk_chp_cnt,
ROW_NUMBER() over (partition by user_id order by start_bat_ulk_time) n
from dws.dws_consume_user_chapter_ulk_td_mid where dt =date_sub(current_date(),interval 1 day )  and user_id>130229077 and  user_id<=140229077),
-- 阅读时长
readt as (
select  userid,createtime from dws.dws_user_first_read_time_sensors_a where  userid>130229077 and  userid<=140229077)
select
usertag.userID,
lastmarket.first_book,
lastmarket.last_book,
user_d.login_days,
'' recharged,
frist_itemcount first_recharge ,
SUM(total_recharge) over (partition by usertag.userID ) total_recharge,
max(recharge_max) over (partition by usertag.userID ) recharge_max,
max(month_recharge_max) over (partition by usertag.userID ) month_recharge_max,
first_value(last_recharge) over (partition by usertag.userID order by last_recharge_time desc rows between unbounded preceding and unbounded following)last_recharge,
SUM(recharge_cnt) over (partition by usertag.userID ) recharge_cnt,
max(last_recharge_time) over (partition by usertag.userID ) last_recharge_time,
last_value(subscribe) over (partition by usertag.userID order by if(productid =last_login_productid,last_login_time,null) ASC rows between unbounded preceding and unbounded following)subscribe,
sub.start_subscribe,
last_value(mul_subscribe) over (partition by usertag.userID order by if(productid =last_login_productid,last_login_time,null) ASC rows between unbounded preceding and unbounded following)mul_subscribe,
SUM(purcharse_cnt) over (partition by usertag.userID ) purcharseCnt,
first_value(last_purcharse_time) over (partition by usertag.userID order by last_purcharse_time desc rows between unbounded preceding and unbounded following) last_purcharse_time,
last_value(coin_cn) over (partition by usertag.userID order by if (productid =last_login_productid,last_login_time,null) ASC rows between unbounded preceding and unbounded following) coin_cnt,
SUM(total_read_time) over (partition by usertag.userID )total_read_time ,
SUM(more_onem_total_read_books) over (partition by usertag.userID ) more_onem_total_read_books ,
SUM(total_read_chp) over (partition by usertag.userID )total_read_chp ,
'' total_bat_ulk,
chpt.start_bat_ulk_chp_cnt ,
SUM(total_bat_ulk_cnt) over (partition by usertag.userID )total_bat_ulk_cnt ,
'' total_fix_ulk ,
SUM(total_fix_ulk_cnt) over (partition by usertag.userID )total_fix_ulk_cnt ,
'' start_sup_ulk_chp,
chpt.start_sup_ulk_chp_cnt,
SUM(sup_ulk_cnt) over (partition by usertag.userID )sup_ulk_cnt ,
SUM(sup_ulk_sum) over (partition by usertag.userID )sup_ulk_sum ,
SUM(total_consumption) over (partition by usertag.userID )total_consumption ,
lastmarket.first_currentlanguage2 ,
lastmarket.last_currentlanguage2 ,
last_value(certificate_cnt) over (partition by usertag.userID order by if (productid =last_login_productid,last_login_time,null) ASC rows between unbounded preceding and unbounded following) certificate_cnt ,
max(last_login_time) over (partition by usertag.userID ) last_login_time,
min(createtime) over (partition by usertag.userID )createtime ,
0.0 createtime_hours,
SUM(coin_consumption) over (partition by usertag.userID ) coin_consumption,
SUM(certificate_consumption) over (partition by usertag.userID ) certificate_consumption,
SUM(purcharse_cnt) over (partition by usertag.userID ) purcharse_cnt,
last_value(is_left) over (partition by usertag.userID order by if (productid =last_login_productid,last_login_time,null) ASC rows between unbounded preceding and unbounded following) is_left ,
last_value(is_remarketing) over (partition by usertag.userID order by if (productid =last_login_productid,last_login_time,null) ASC rows between unbounded preceding and unbounded following) is_remarketing,
last_value(ads_quality) over (partition by usertag.userID order by if (productid =last_login_productid,last_login_time,null) ASC rows between unbounded preceding and unbounded following) ads_quality,
lastmarket.first_media_name,
lastmarket.last_media_name,
charge.itemcount charge_mode ,
SUM(total_bat_ulk_money) over (partition by usertag.userID ) total_bat_ulk_money,
last_value(subscribe_all_money) over (partition by usertag.userID order by if (productid =last_login_productid,last_login_time,null) ASC rows between unbounded preceding and unbounded following) subscribe_all_money ,
last_value(subscribe_svip_money) over (partition by usertag.userID order by if (productid =last_login_productid,last_login_time,null) ASC rows between unbounded preceding and unbounded following) subscribe_svip_money ,
last_value(subscribe_signcardplus_money) over (partition by usertag.userID order by if (productid =last_login_productid,last_login_time,null) ASC rows between unbounded preceding and unbounded following) subscribe_signcardplus_money ,
last_value(subscribe_signcardplusplus_money) over (partition by usertag.userID order by if (productid =last_login_productid,last_login_time,null) ASC rows between unbounded preceding and unbounded following) subscribe_signcardplusplus_money ,
-- ARRAY_AGG(split(cast (total_subscribe_money as string ),',')) over(partition by usertag.userID ) total_subscribe_money ,
last_value(his_subscribe_svip_money) over (partition by usertag.userID order by if (productid =last_login_productid,last_login_time,null) ASC rows between unbounded preceding and unbounded following) his_subscribe_svip_money ,
-- ARRAY_AGG(split(cast (his_subscribe_signcardplus_money as string ),',')) over(partition by usertag.userID ) his_subscribe_signcardplus_money,
-- ARRAY_AGG(split(cast (his_subscribe_signcardplusplus_money as string ),',')) over(partition by usertag.userID ) his_subscribe_signcardplusplus_money,
max(his_mul_subscribe) over (partition by usertag.userID ) his_mul_subscribe,
chpt.start_bat_ulk_money,
last_value(his_subscribe_all_money) over (partition by usertag.userID order by if (productid =last_login_productid,last_login_time,null) ASC rows between unbounded preceding and unbounded following) his_subscribe_all_money ,
min(if(substr(remarketingtime,0,10)='1970-01-01',null,remarketingtime)) over(partition by usertag.userID ) remarketingtime,
charge.first_charge_time first_recharge_time, -- 首充时间
charge.first_read_time, -- 首次阅读时间
0 timecount,
last_save_time,
last_common_time,
last_login_productid productid,
last_value(last_country) over (partition by usertag.userID order by if (productid =last_login_productid,last_login_time,null) ASC rows between unbounded preceding and unbounded following) last_country ,
ROW_NUMBER() over (partition by usertag.userid ) n,
last_value(mt) over (partition by usertag.userID order by if (productid =last_login_productid,last_login_time,null) ASC rows between unbounded preceding and unbounded following) mt
from
usertag
left join user_login  on    usertag.userid = user_login.userid
left join user_d  on     usertag.userid = user_d.userid
left join lastmarket on usertag.userid = lastmarket.userid
left join charge on usertag.userid = charge.userid
left join sub on usertag.userid = sub.userid
left join chpt on usertag.userid = chpt.userid;
