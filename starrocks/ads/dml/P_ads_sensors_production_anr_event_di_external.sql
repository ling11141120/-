----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_sensors_production_anr_event_di_external
-- workflow_version : 30
-- create_user      : hufengju
-- task_name        : ads_sensors_production_anr_event_di_external_apppageleave
-- task_version     : 16
-- update_time      : 2025-03-14 15:26:23
-- sql_path         : \starrocks\tbl_ads_sensors_production_anr_event_di_external\ads_sensors_production_anr_event_di_external_apppageleave
----------------------------------------------------------------
-- SQL语句
insert into ads.ads_sensors_production_anr_event_di_external
SELECT
dt,
concat(id,'-',event) as id,
track_id,
rid,
event_tm,
device_id,
login_id,
identity_login_id,
device_lang,
event,
distinct_id,
app_id,
applangid,
appchannel,
appversioncode,
android_id,
gaid,
deviceLang,
mt,
identity_user_id,
app_version_code,
app_product_id,
send_id,
app_core_ver,
app_channel,
app_product_x,
case left(app_product_id,3)
when '775' then '1'
when '333' then '2'
when '336' then '3'
when '338' then '4'
when '332' then '5'
when '331' then '6'
when '337' then '7'
when '339' then '9'
when '350' then '11'
when '351' then '12'
end as app_lang_id,
title,
screen_name,
url,
referrer,
is_first_day,
os,
os_version,
lib,
manufacturer,
app_version,
carrier,
app_name,
referrer_title,
ip,
city,
province,
country,
identity_android_id,
'5' as project_id,
app_lang_id as interface_language,
etl_tm
FROM dwd.dwd_sensors_production_apppageleave_view
WHERE dt='${bf_1_dt}';

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_sensors_production_anr_event_di_external
-- workflow_version : 30
-- create_user      : hufengju
-- task_name        : ads_sensors_production_anr_event_di_external_ey_ft_xy
-- task_version     : 16
-- update_time      : 2025-03-14 15:26:23
-- sql_path         : \starrocks\tbl_ads_sensors_production_anr_event_di_external\ads_sensors_production_anr_event_di_external_ey_ft_xy
----------------------------------------------------------------
-- SQL语句
insert into ads.ads_sensors_production_anr_event_di_external
SELECT
dt,
concat(id,'-',event) as id,
track_id,
rid,
event_tm,
device_id,
login_id,
identity_login_id,
device_lang,
event,
distinct_id,
app_id,
applangid,
appchannel,
appversioncode,
android_id,
gaid,
deviceLang,
mt,
identity_user_id,
app_version_code,
app_product_id,
send_id,
app_core_ver,
app_channel,
app_product_x,
case left(app_product_id,3)
when '775' then '1'
when '333' then '2'
when '336' then '3'
when '338' then '4'
when '332' then '5'
when '331' then '6'
when '337' then '7'
when '339' then '9'
when '350' then '11'
when '351' then '12'
end as app_lang_id,
title,
screen_name,
url,
referrer,
is_first_day,
os,
os_version,
lib,
manufacturer,
app_version,
carrier,
app_name,
referrer_title,
ip,
city,
province,
country,
identity_android_id,
'5' as project_id,
app_lang_id as interface_language,
etl_tm
FROM dwd.dwd_sensors_production_appviewscreen_view
WHERE dt='${bf_1_dt}'
and app_product_id in ('3371','3333','3388');

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_sensors_production_anr_event_di_external
-- workflow_version : 30
-- create_user      : hufengju
-- task_name        : ads_sensors_production_anr_event_di_external_other
-- task_version     : 17
-- update_time      : 2025-03-14 15:26:23
-- sql_path         : \starrocks\tbl_ads_sensors_production_anr_event_di_external\ads_sensors_production_anr_event_di_external_other
----------------------------------------------------------------
-- SQL语句
insert into ads.ads_sensors_production_anr_event_di_external
SELECT
dt,
concat(id,'-',event) as id,
track_id,
rid,
event_tm,
device_id,
login_id,
identity_login_id,
device_lang,
event,
distinct_id,
app_id,
applangid,
appchannel,
appversioncode,
android_id,
gaid,
deviceLang,
mt,
identity_user_id,
app_version_code,
app_product_id,
send_id,
app_core_ver,
app_channel,
app_product_x,
case left(app_product_id,3)
when '775' then '1'
when '333' then '2'
when '336' then '3'
when '338' then '4'
when '332' then '5'
when '331' then '6'
when '337' then '7'
when '339' then '9'
when '350' then '11'
when '351' then '12'
end as app_lang_id,
title,
screen_name,
url,
referrer,
is_first_day,
os,
os_version,
lib,
manufacturer,
app_version,
carrier,
app_name,
referrer_title,
ip,
city,
province,
country,
identity_android_id,
'5' as project_id,
app_lang_id as interface_language,
etl_tm
FROM dwd.dwd_sensors_production_appviewscreen_view
WHERE dt='${bf_1_dt}'
and app_product_id not in ('3322', '3371','3333','3388');

----------------------------------------------------------------
-- project_name     : starrocks
-- workflow_name    : tbl_ads_sensors_production_anr_event_di_external
-- workflow_version : 30
-- create_user      : hufengju
-- task_name        : ads_sensors_production_anr_event_di_external_pt
-- task_version     : 19
-- update_time      : 2025-03-14 15:26:23
-- sql_path         : \starrocks\tbl_ads_sensors_production_anr_event_di_external\ads_sensors_production_anr_event_di_external_pt
----------------------------------------------------------------
-- SQL语句
insert into ads.ads_sensors_production_anr_event_di_external
SELECT
dt,
concat(id,'-',event) as id,
track_id,
rid,
event_tm,
device_id,
login_id,
identity_login_id,
device_lang,
event,
distinct_id,
app_id,
applangid,
appchannel,
appversioncode,
android_id,
gaid,
deviceLang,
mt,
identity_user_id,
app_version_code,
app_product_id,
send_id,
app_core_ver,
app_channel,
app_product_x,
case left(app_product_id,3)
when '775' then '1'
when '333' then '2'
when '336' then '3'
when '338' then '4'
when '332' then '5'
when '331' then '6'
when '337' then '7'
when '339' then '9'
when '350' then '11'
when '351' then '12'
end as app_lang_id,
title,
screen_name,
url,
referrer,
is_first_day,
os,
os_version,
lib,
manufacturer,
app_version,
carrier,
app_name,
referrer_title,
ip,
city,
province,
country,
identity_android_id,
'5' as project_id,
app_lang_id as interface_language,
etl_tm
FROM dwd.dwd_sensors_production_appviewscreen_view
WHERE dt='${bf_1_dt}'
and app_product_id='3322';
