----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_dwd_flow_user_adposition_adwatchsuccess
-- workflow_version : 7
-- create_user      : yanxh
-- task_name        : dwd_flow_user_adposition_adwatchsuccess
-- task_version     : 6
-- update_time      : 2025-05-28 17:03:53
-- sql_path         : \starrocks\tbl_dwd_flow_user_adposition_adwatchsuccess\dwd_flow_user_adposition_adwatchsuccess
----------------------------------------------------------------
-- SQL语句
insert into  dwd.`dwd_flow_user_adposition_adwatchsuccess`
select  dt,id,track_id,rid,event_tm,device_id,login_id,login_id as user_id, device_lang ,event,distinct_id,identity_user_id,
        case when project_id=8 then 6833 else app_product_id end  as product_id,
        send_id,app_core_ver as corever,app_channel,app_product_x,app_lang_id as current_language,lib_version,app_version as appver,page_id,page_name,
        coalesce(ad_position_id1, ad_position_id) as ad_position_id,ad_id,ad_type,ad_platform,ad_source,
        project_id,now() as etl_tm
from ods_log.ods_sensors_production_adwatchsuccess
where dt='${bf_1_dt}'
  and login_id is not null
  and coalesce(ad_position_id1, ad_position_id) !=-1;
