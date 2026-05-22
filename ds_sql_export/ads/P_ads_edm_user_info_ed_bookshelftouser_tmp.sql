----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_edm_userbook_info
-- workflow_version : 33
-- create_user      : linq
-- task_name        : ads_edm_user_info_ed_bookshelftouser_tmp
-- task_version     : 6
-- update_time      : 2025-03-19 16:49:34
-- sql_path         : \starrocks\tbl_ads_edm_userbook_info\ads_edm_user_info_ed_bookshelftouser_tmp
----------------------------------------------------------------
-- SQL语句
insert into ads.ads_edm_user_info_ed_bookshelftouser_tmp
select Productid ,userid,bookid ,now() as etl_time
from ods.ods_tidb_readernovel_tidb_bookshelftouser
where CreateTime > '${bf_2_dt}'
group by 1,2,3;
