----------------------------------------------------------------
-- 程序功能： 设备域-GooglePlay上报机型ANR-每日增量
-- 程序名： P_dwd_device_gp_app_anr_di
-- 目标表： dwd.dwd_device_gp_app_anr_di
-- 负责人： roger
-- 开发日期：2025/11/26
-- 版本号： v1.0
----------------------------------------------------------------


insert into dwd.dwd_device_gp_app_anr_di
select date_trunc('day', AnrTime)                                             as dt
      ,Id                                                                     as id
      ,'ADs'                                                                  as anr_type
      ,InitTime                                                               as init_time
      ,StartTime                                                              as start_time
      ,ProductId                                                              as product_id
      ,Core                                                                   as core
      ,Lang                                                                   as lang
      ,VersionCode                                                            as version_code
      ,DeviceName                                                             as device_name
      ,split_part(substr(DeviceName, 1, instr(DeviceName, ' (') - 1), ' ', 1) as manufacturer
      ,substr(substr(DeviceName, 1, instr(DeviceName, ' (') - 1)
       , length(split_part(substr(DeviceName, 1, instr(DeviceName, ' (') - 1), ' ', 1)) + 2
       )                                                                      as device_model
      ,AnrCount                                                               as anr_count
      ,AnrRate                                                                as anr_rate
      ,AnrGlobalRate                                                          as anr_global_rate
      ,DeviceGuid                                                             as device_guid
      ,UpdateTime                                                             as update_time
      ,AnrTime                                                                as anr_time
      ,SessionCount                                                           as session_count
      ,null                                                                   as active_count
      ,now()                                                                  as etl_tm
from ods.ods_tidb_qadata_gp_app_version_device_anr
where date(InitTime) = '${bf_1_dt}'
  and date(AnrTime) >= '${bf_3_dt}'
  and date(AnrTime) <= '${bf_1_dt}'

union all
select date_trunc('day', AnrTime)           as dt
      ,Id                                   as id
      ,'PUSH'                               as anr_type
      ,InitTime                             as init_time
      ,StartTime                            as start_time
      ,ProductId                            as product_id
      ,Core                                 as core
      ,Lang                                 as lang
      ,VersionCode                          as version_code
      ,DeviceName                           as device_name
      ,substring_index(DeviceName, ' ', 1)  as manufacturer
      ,substring_index(DeviceName, ' ', -1) as device_model
      ,AnrCount                             as anr_count
      ,AnrRate                              as anr_rate
      ,AnrGlobalRate                        as anr_global_rate
      ,DeviceGuid                           as device_guid
      ,UpdateTime                           as update_time
      ,AnrTime                              as anr_time
      ,null                                 as session_count
      ,ActiveCount                          as active_count
      ,now()                                as etl_tm
from ods.ods_tidb_qadata_gp_app_push_device_anr
where date(InitTime) = '${bf_1_dt}'
  and date(AnrTime) >= '${bf_3_dt}'
  and date(AnrTime) <= '${bf_1_dt}'
;
