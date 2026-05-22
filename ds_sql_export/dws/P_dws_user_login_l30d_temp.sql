----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dws_user_login_l30d_temp
-- workflow_version : 1
-- create_user      : xixg
-- task_name        : dws_user_login_l30d_temp
-- task_version     : 1
-- update_time      : 2025-04-01 11:23:01
-- sql_path         : \starrocks\tbl_dws_user_login_l30d_temp\dws_user_login_l30d_temp
----------------------------------------------------------------
-- SQL语句
insert into dws.dws_user_login_l30d_temp
select  '${bf_1_dt}' as dt,
        productid as product_id,
        userid as user_id ,
        now() etl_time
  from dws.dws_user_login_ed
 where dt>=date_sub('${dt}',interval 180 day)
   and dt<'${dt}'
 group by 1,2,3;
