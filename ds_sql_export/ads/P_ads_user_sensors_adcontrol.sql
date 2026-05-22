----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_user_sensors_adcontrol
-- workflow_version : 5
-- create_user      : hufengju
-- task_name        : ads.ads_user_sensors_adcontrol
-- task_version     : 5
-- update_time      : 2024-10-16 11:17:59
-- sql_path         : \starrocks\tbl_ads_user_sensors_adcontrol\ads.ads_user_sensors_adcontrol
----------------------------------------------------------------
-- 前置SQL语句
delete from ads.ads_user_sensors_adcontrol where dt='${bf_1_dt}';

-- SQL语句
insert into ads.ads_user_sensors_adcontrol
select dt,lang,corever,device_id,now() as etl_tm
from (
 select distinct dt,
                    case
                        when product_id = 3366 then 'en'
                        when product_id = 3388 then 'sp'
                        when product_id = 3322 then 'pt'
                        when product_id = 3311 then 'fr'
                        when product_id = 3371 then 'ru'
                        when product_id = 3501 then 'id'
                        when product_id = 3511 then 'th'
                        when product_id = 3333 then 'ft'
                        else product_id end as lang,
                    corever,
                    device_id
    from dwd.dwd_hive_sensors_adcontrol_view
    where dt ='${bf_1_dt}'
      and event = 'AdControl'
      AND type = 'initAd'
) a
where lang is not null and corever is not null and device_id is not null
;

-- 后置SQL语句
delete from ads.ads_user_sensors_adcontrol where dt<='${bf_30_dt}';
