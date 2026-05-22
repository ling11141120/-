----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dws_flow_app_client_biz_admobaderror_ed
-- workflow_version : 3
-- create_user      : zhugl
-- task_name        : tbl_dws_flow_app_client_biz_admobaderror_ed
-- task_version     : 3
-- update_time      : 2024-01-30 18:18:29
-- sql_path         : \starrocks\tbl_dws_flow_app_client_biz_admobaderror_ed\tbl_dws_flow_app_client_biz_admobaderror_ed
----------------------------------------------------------------
-- 前置SQL语句
delete from dws.dws_flow_app_client_biz_admobaderror_ed where  dt ='${bf_1_dt}';

-- SQL语句
insert into dws.dws_flow_app_client_biz_admobaderror_ed
select
dt,
app_id,
case
	when app_channel is not null and array_length(split(app_channel,'_'))=4 then   split(app_channel,'_')[2]
	when appchannel is not null  and array_length(split(appchannel,'_'))=4 then   split(appchannel,'_')[2]
	when  ifnull(app_core_ver,appcorever) is not  null then concat('core',ifnull(app_core_ver,appcorever))
	else ''
	end as core,
upper (case
	when app_channel is not null and array_length(split(app_channel,'_'))=4  then   split(app_channel,'_')[3]
	when appchannel is not null  and array_length(split(appchannel,'_'))=4  then   split(appchannel,'_')[3]
	when lib  is  not  null then lib
	else ''
	end) as mt,
-- ifnull(app_product_id,'') app_product_id,
	case
	when app_channel is not null and array_length(split(app_channel,'_'))=4  then   split(app_channel,'_')[1]
	when appchannel is not null  and array_length(split(appchannel,'_'))=4  then   split(appchannel,'_')[1]
	else '' end  as product_id,
ifnull(app_version,'') app_version,
ifnull(biz_type,'') biz_type,
ifnull(biz_ads_type,'') biz_ads_type,
case
	when biz_error_message is not null  then if(regexp(biz_error_message, '(Request Error:|Presentation Error:|desc\\[|desc:\\[)')=1,regexp_extract(biz_error_message, '(Request Error:|Presentation Error:|desc\\[|desc:\\[)([a-zA-Z , 、]+)',2), biz_error_message )
	when biz_error_msg is not null then if(regexp(biz_error_msg, '(Request Error:|Presentation Error:|desc\\[|desc:\\[)')=1,regexp_extract(biz_error_msg, '(Request Error:|Presentation Error:|desc\\[|desc:\\[)([a-zA-Z , 、]+)',2), biz_error_msg )
	when biz_msg is not  null then if(regexp(biz_msg, '(Request Error:|Presentation Error:|desc\\[|desc:\\[)')=1,regexp_extract(biz_msg, '(Request Error:|Presentation Error:|desc\\[|desc:\\[)([a-zA-Z , 、]+)',2), biz_msg )
	else null end as biz_msg,
count(1) cnt,
NOW()
from dwd.dwd_flow_apperror_log_cdappclientbiz_view
where dt >='${bf_1_dt}' and biz_type ='AdMobAdError' and  lib !='js'
group by 1,2,3,4,5,6,7,8,9;
