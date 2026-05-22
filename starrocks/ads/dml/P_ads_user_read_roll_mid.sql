----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_edm_userbook_info
-- workflow_version : 33
-- create_user      : linq
-- task_name        : ads_user_read_roll_mid
-- task_version     : 7
-- update_time      : 2025-04-18 20:35:42
-- sql_path         : \starrocks\tbl_ads_edm_userbook_info\ads_user_read_roll_mid
----------------------------------------------------------------
-- SQL语句
insert into ads.ads_user_read_roll_mid
select Product_id,User_Id,Book_Id,max(Create_Time) as last_read_time,now() as etl_time
from dwd.dwd_read_user_chapter_view where dt>='${bf_3_dt}' and dt<'${dt}'
group by 1,2,3;
