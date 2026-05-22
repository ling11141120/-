----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_sensors_user_info_init
-- workflow_version : 26
-- create_user      : zhugl
-- task_name        : tbl_dws_user_logininfo_sensors_a
-- task_version     : 7
-- update_time      : 2023-12-22 10:50:24
-- sql_path         : \starrocks\tbl_sensors_user_info_init\tbl_dws_user_logininfo_sensors_a
----------------------------------------------------------------
-- SQL语句
insert into dws.dws_user_logininfo_sensors_a
select  date_sub(CURRENT_DATE(),interval 1 day ),a.userid,last_login_time,last_login_productid,first_login_time,first_login_productid,
last_common_time,last_common_productid ,now()
from (
select date_sub(CURRENT_DATE(),interval 1 day ) dt,userid,last_login_time,last_login_productid,first_login_time,first_login_productid,NOW()
from (select userid,
FIRST_VALUE (last_login_time) over(partition by userid order by last_login_time desc rows between unbounded preceding and unbounded following) last_login_time,
FIRST_VALUE (last_login_productid) over(partition by userid order by last_login_time desc rows between unbounded preceding and unbounded following) last_login_productid,
last_VALUE (first_login_time) over(partition by userid order by first_login_time desc rows between unbounded preceding and unbounded following) first_login_time,
last_VALUE (first_login_productid) over(partition by userid order by first_login_time desc rows between unbounded preceding and unbounded following) first_login_productid,
row_number()over(partition by userid order by last_login_time desc ) n
from (
select dt,userid,last_login_time,last_login_productid,first_login_time,first_login_productid from dws.dws_user_logininfo_sensors_a where dt ='2023-12-17'
union all
select dt,userid,createtime,productid,createtime,productid from dwd.dwd_user_appstartlog where dt >='2023-12-18' )a
)a where n=1)a left join
(select userid,last_common_time,last_common_productid from dws.dws_user_last_comm_time_sensors_a where  dt = date_sub(CURRENT_DATE(),interval 1 day ))b on a.userid=b.userid;
