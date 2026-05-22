----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_offline_label
-- workflow_version : 72
-- create_user      : zhengtt
-- task_name        : ads_offline_label_user_login_info
-- task_version     : 2
-- update_time      : 2024-10-16 11:25:04
-- sql_path         : \starrocks\tbl_ads_offline_label\ads_offline_label_user_login_info
----------------------------------------------------------------
-- SQL语句
insert into ads.ads_offline_label_user_login_info
select  a.dt,a.Product_id,a.User_Id,first_login_time,last_login_time,new_login_time,
        first_login_ip,last_login_ip,new_login_ip,null as first_login_location,
        null as last_login_location,null as new_login_location,remain_day,login_days,login_times,
        case
            when datediff('${bf_1_dt}', new_login_time) >= 7 then '流失用户'
            when datediff('${bf_1_dt}', new_login_time) >= 1 and datediff('${bf_1_dt}', new_login_time) < 7 then '预流失用户'
            when datediff('${bf_1_dt}', new_login_time) = 0 and datediff('${bf_1_dt}', last_login_time) >= 6 then '回流用户'
            when datediff('${bf_1_dt}', new_login_time) = 0 and datediff('${bf_1_dt}', create_tm_account) >= 7 then '活跃老用户'
            else '活跃用户'
            end as user_login_type,
        now() as etl_time
from
(   select  dt,Product_id,User_Id,first_login_time,last_login_time,new_login_time,
            first_login_ip,last_login_ip,new_login_ip,remain_day,login_days,login_times
    from dws.dws_user_login_a
    where dt = '${bf_1_dt}' and User_Id != 0
    ) a
left join dim.dim_user_all_info b
on a.Product_id = b.product_id and a.User_Id = b.user_id;
