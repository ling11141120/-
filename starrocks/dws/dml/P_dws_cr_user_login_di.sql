----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dws_cr_user_login_di
-- workflow_version : 3
-- create_user      : yanxh
-- task_name        : dws_cr_user_login_di
-- task_version     : 3
-- update_time      : 2024-10-23 10:42:10
-- sql_path         : \starrocks\tbl_dws_cr_user_login_di\dws_cr_user_login_di
----------------------------------------------------------------
-- SQL语句
--  登录表里存在的用户在账户表中不存在，经与开发了解，实际是测试的脏数据，因此用inner join  可过滤掉测试用户----

  insert into dws.dws_cr_user_login_di
 select   a.dt, a.product_id, a.user_id, 0 as self_type,
           c.appid as app_id,c.plat_form,c.corever2,
           c.current_language2, c.mt2, c.reg_country,
		   if(  c.account ='6654629eee97ef589659c776' , c.register_date, c.create_time)   as reg_tm,
           c.chl2,c.os,
		   DATEDIFF(a.dt,date(if(c.account ='6654629eee97ef589659c776' , c.register_date, c.create_time))) as reg_days,
		   count(a.user_id) as  login_cnt,
		   min(a.create_time) as  fst_login_tm,
		    max(a.create_time) as  lst_login_tm,
           now() as etl_time
    from dwd.dwd_cr_user_login_view  a
          inner join dim.dim_cr_accountinfo_view   c
     on  a.user_id = c.account
 where  a.dt >= '${bf_3_dt}' and  a.dt<='${dt}'
 group by 1,2,3,4,5,6,7,8,9,10,11,12,13,14;
