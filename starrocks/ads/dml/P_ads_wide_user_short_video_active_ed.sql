----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_wide_user_short_video_active_ed
-- workflow_version : 5
-- create_user      : yanxh
-- task_name        : ads_wide_user_short_video_active_ed
-- task_version     : 5
-- update_time      : 2025-06-04 01:41:20
-- sql_path         : \starrocks\tbl_ads_wide_user_short_video_active_ed\ads_wide_user_short_video_active_ed
----------------------------------------------------------------
-- 前置SQL语句
delete from  ads.ads_wide_user_short_video_active_ed where dt>= '${bf_3_dt}';

-- SQL语句
insert into ads.ads_wide_user_short_video_active_ed
select a.dt,a.product_id,a.user_id,b.user_type,a.corever,a.mt,a.current_language,
a.current_language2,a.reg_country,a.country_level,a.reg_time as reg_date,a.reg_days,a.sex,a.is_acc_login,a.is_has_email,
b.user_period,b.user_value,b.source ,
now() as etl_tm
from  dws.dws_user_short_video_wide_active_ed a
left join
dws.dws_user_short_video_wide_tag_info_ed b
on a.dt =b.dt and a.product_id =b.product_id and a.user_id =b.user_id and  b.dt>= '${bf_3_dt}' and  b.dt<'${dt}'
where  a.dt>= '${bf_3_dt}' and a.dt<'${dt}' and a.product_id !=6883  and cast(a.user_id as int)>0;
