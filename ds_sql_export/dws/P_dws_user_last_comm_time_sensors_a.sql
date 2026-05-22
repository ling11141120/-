----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_sensors_user_info_init
-- workflow_version : 26
-- create_user      : zhugl
-- task_name        : tbl_dws_user_last_comm_time_sensors_a
-- task_version     : 6
-- update_time      : 2023-12-21 10:25:47
-- sql_path         : \starrocks\tbl_sensors_user_info_init\tbl_dws_user_last_comm_time_sensors_a
----------------------------------------------------------------
-- SQL语句
insert  into dws.dws_user_last_comm_time_sensors_a
select date_sub(current_date(),interval 1 day ) dt,userid,last_common_time,last_common_productid
from(select userid,last_common_time,last_common_productid,ROW_NUMBER() over(partition by userid order by last_common_time desc) n
FROM  (
select userid,last_common_time,last_common_productid from dws.dws_user_last_comm_time_sensors_a where dt='2023-12-19'
union all
select user_id ,create_time,product_id  from dwd.dwd_readerlog_commonactionlog_view where dt >='2023-12-02'
)a)a where  n=1;
