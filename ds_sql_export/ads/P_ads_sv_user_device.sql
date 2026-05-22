----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_sv_user_device
-- workflow_version : 2
-- create_user      : chenmo
-- task_name        : ads_sv_user_device
-- task_version     : 1
-- update_time      : 2025-08-06 16:06:33
-- sql_path         : \starrocks\tbl_ads_sv_user_device\ads_sv_user_device
----------------------------------------------------------------
-- SQL语句
insert into ads.ads_sv_user_device
select
    manufacturer,
    if(manufacturer in('XIAOMI', 'XİAOMİ', 'HUAWEI'), model, '') as model,
    now() as etl_time
from ods_log.ods_sensors_cd_video_production_signup
where manufacturer is not null
group by 1, 2;
