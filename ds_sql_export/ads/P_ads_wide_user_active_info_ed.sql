----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_wide_user_active_info_ed
-- workflow_version : 7
-- create_user      : yanxh
-- task_name        : ads_wide_user_active_info_ed
-- task_version     : 7
-- update_time      : 2024-10-16 15:38:40
-- sql_path         : \starrocks\tbl_ads_wide_user_active_info_ed\ads_wide_user_active_info_ed
----------------------------------------------------------------
-- 前置SQL语句
delete from ads.ads_wide_user_active_info_ed where dt= '${bf_1_dt}';

-- SQL语句
insert into ads.ads_wide_user_active_info_ed
select  a.dt,a.product_id,a.user_id,
a.corever,a.mt,a.ver,a.current_language,a.current_language2,
a.reg_country,a.country_level,
a.appver,a.reg_time as reg_date,a.reg_days,a.sex,
ifnull(b.user_type,0),b.user_period,b.user_value,b.source,
now() as etl_tm
from dws.dws_user_wide_active_ed a
left join
dws.dws_user_wide_tag_info_ed b
on a.dt =b.dt and a.product_id =b.product_id and a.user_id=b.user_id  and  b.dt>= '${bf_1_dt}' and  b.dt<'${dt}'
where  a.dt>= '${bf_1_dt}' and  a.dt<'${dt}'
and a.product_id !=6833;
