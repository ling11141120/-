----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_sensors_user_info_init
-- workflow_version : 26
-- create_user      : zhugl
-- task_name        : tbl_dws_user_logindays_sensors_a
-- task_version     : 6
-- update_time      : 2023-12-21 10:25:47
-- sql_path         : \starrocks\tbl_sensors_user_info_init\tbl_dws_user_logindays_sensors_a
----------------------------------------------------------------
-- SQL语句
insert into dws.dws_user_logindays_sensors_a
select date_sub(CURRENT_DATE(),interval 1 day )  dt,userid,sum(cnt) cnt,NOW()
from (
select dt, cnt,userid from dws.dws_user_logindays_sensors_a where dt ='2023-12-17'
union all
select dt,count(distinct dt) cnt,userid from dwd.dwd_user_appstartlog where dt >='2023-12-18' group by 1,3
)a group by 2;
