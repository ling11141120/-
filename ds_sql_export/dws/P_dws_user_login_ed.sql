----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dws_user_login_ed
-- workflow_version : 17
-- create_user      : yanxh
-- task_name        : tbl_dws_user_login_ed
-- task_version     : 16
-- update_time      : 2025-06-17 16:03:35
-- sql_path         : \starrocks\tbl_dws_user_login_ed\tbl_dws_user_login_ed
----------------------------------------------------------------
-- SQL语句
delete from  dws.dws_user_login_ed where  dt ='${bf_1_dt}' ;

-- SQL语句
insert into dws.dws_user_login_ed
select a.dt,a.productid,b.corever,b.current_language,b.current_language2,b.appver,b.mt,b.ver,b.reg_country,
       a.userid,b.create_time as regtime,datediff(date(a.createtime),date(b.create_time)),count(1) as loginTimes,
       now() as etl_time
from
dwd.dwd_user_appstartlog a
left join
dim.dim_user_account_info_view b
 on a.productid=b.product_id and a.userid=b.id
 where a.dt ='${bf_1_dt}'  and userid>0
group by 1,2,3,4,5,6,7,8,9,10,11,12
;
