----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dws_user_short_video_user_login_info_ed
-- workflow_version : 8
-- create_user      : yanxh
-- task_name        : tbl_dws_user_short_video_user_login_info_ed
-- task_version     : 8
-- update_time      : 2025-06-03 10:12:52
-- sql_path         : \starrocks\tbl_dws_user_short_video_user_login_info_ed\tbl_dws_user_short_video_user_login_info_ed
----------------------------------------------------------------
-- 前置SQL语句
delete from  dws.dws_user_short_video_user_login_info_ed  where  dt ='${bf_1_dt}';

-- SQL语句
insert into  dws.dws_user_short_video_user_login_info_ed
select
a.dt,a.product_id, a.user_id, a.corever,a.lang_id as  current_language,
b.current_language2, a.appver, a.mt, a.ver, a.device, a.device2, b.reg_country, b.create_time  as reg_time,
DATEDIFF(a.dt,date(b.create_time)) as reg_days,count(a.user_id) as  login_times,now() as etl_time
from  dwd.dwd_user_short_video_user_login_view a
left join
dim.dim_short_video_user_accountinfo b
on a.user_id=b.user_id  and a.product_id=b.product_id
where a.dt>='${bf_1_dt}' and a.dt<date(date_add('${bf_1_dt}',interval 1 day )) and a.user_id is not null  and cast(a.user_id as int) >0
group by 1,2,3,4,5,6,7,8,9,10,11,12 ,13,14;
