----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_edm_userbook_info
-- workflow_version : 33
-- create_user      : linq
-- task_name        : ads_user_login_roll_mid
-- task_version     : 6
-- update_time      : 2023-11-27 14:47:06
-- sql_path         : \starrocks\tbl_ads_edm_userbook_info\ads_user_login_roll_mid
----------------------------------------------------------------
-- SQL语句
insert into ads.ads_user_login_roll_mid
select Productid as product_id, UserId as user_id, max(createtime) as last_login_time,now() as etl_time
from dwd.dwd_user_appstartlog
where dt = '${bf_1_dt}'
group by 1, 2;
