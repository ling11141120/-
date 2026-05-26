----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_sensors_user_info_init
-- workflow_version : 26
-- create_user      : zhugl
-- task_name        : tbl_dws_user_first_read_time_sensors_a
-- task_version     : 6
-- update_time      : 2023-12-21 10:25:47
-- sql_path         : \starrocks\tbl_sensors_user_info_init\tbl_dws_user_first_read_time_sensors_a
----------------------------------------------------------------
-- SQL语句
insert  into dws.dws_user_first_read_time_sensors_a
select date_sub(current_date(),interval 1 day ) dt,userid,createtime,timecount
from(select userid,createtime,timecount,ROW_NUMBER() over(partition by userid order by createtime asc) n
FROM  (
select userid,createtime,timecount from dws.dws_user_first_read_time_sensors_a where dt='2023-12-19'
union all
select create_time,user_id,read_times from dwd.dwd_read_user_chapter_view where dt >='2023-12-20'
)a)a where  n=1;
