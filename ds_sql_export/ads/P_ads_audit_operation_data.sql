----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_audit_operation_data
-- workflow_version : 2
-- create_user      : chenmo
-- task_name        : ads_audit_operation_data
-- task_version     : 2
-- update_time      : 2025-02-24 14:44:37
-- sql_path         : \starrocks\tbl_ads_audit_operation_data\ads_audit_operation_data
----------------------------------------------------------------
-- SQL语句
insert into ads.ads_audit_operation_data
with z1 as
(select
   -- dt,
   date_trunc('month', '${bf_1_dt}') ym,
	'MoboReader（阅读）' as types,
   count(distinct id) as con_user
from dim.dim_user_account_info_view
where DATE_FORMAT(dt, '%Y-%m') <= DATE_FORMAT('${bf_1_dt}', '%Y-%m')
group by 1,2
union all
select
	date_trunc('month', '${bf_1_dt}') ym,
	'MoboReels（短剧）' as types,
   count(distinct user_id) as con_user
from dim.dim_short_video_user_accountinfo
where DATE_FORMAT(dt, '%Y-%m') <= DATE_FORMAT('${bf_1_dt}', '%Y-%m')
group by 1,2

),

z2 as
(
select
	date_trunc('month', '${bf_1_dt}') ym,
	'MoboReader（阅读）' as types,
	count(distinct user_id) con_user
from ads.ads_sr_user_wide_active_ed_view a
where DATE_FORMAT(dt, '%Y-%m') = DATE_FORMAT('${bf_1_dt}', '%Y-%m')
group by 1,2
union all
select
	date_trunc('month', '${bf_1_dt}') ym,
	'MoboReels（短剧）' as types,
	count(distinct user_id) con_user
from dws.dws_user_short_video_wide_active_ed a
where DATE_FORMAT(dt, '%Y-%m') = DATE_FORMAT('${bf_1_dt}', '%Y-%m') and product_id='6833'
group by 1,2

)

select
date(z1.ym) as ym,
z1.types project_id,
z2.con_user mau,
z1.con_user user_num
from z1
left join z2
on z1.ym=z2.ym  and z1.types=z2.types;
