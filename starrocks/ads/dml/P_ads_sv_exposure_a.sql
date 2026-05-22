----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_sv_exposure_a
-- workflow_version : 11
-- create_user      : linq
-- task_name        : ads_sv_exposure_a
-- task_version     : 3
-- update_time      : 2024-05-09 02:27:38
-- sql_path         : \starrocks\tbl_ads_sv_exposure_a\ads_sv_exposure_a
----------------------------------------------------------------
-- SQL语句
insert into ads.ads_sv_exposure_a
select dt, event_name, element_id, user_id, sum(reach_cnt) as reach_cnt,now() as etl_time
from(
    select '${dt}' as dt, event_name, element_id, user_id, reach_cnt
    from ads.ads_sv_exposure_a_mid where dt='${bf_11_dt}'
    union all
    select '${dt}' as dt,'operationPositionExposure' as event_name,element_id,login_id as user_id,count(1) as reach_cnt
    from dwd.dwd_sensors_cd_video_operationpositionexposure_view
    where dt>='${bf_10_dt}' and dt<='${dt}' and element_id='200900' and cast(login_id as bigint) >0
    group by 1,2,3,4
)t1
group by 1,2,3,4;
