
insert into dwd.dwd_device_gp_dev_mdl_anr
select a1.Id                                            as evt_id         -- 事件id
      ,''                                               as anr_type       -- ANR类型
      ,date(a1.AnrTime)                                 as anr_dt         -- ANR日期
      ,a1.ProductId                                     as product_id     -- product_id
      ,a1.Core                                          as core           -- core
      ,a1.Lang                                          as lang_abbr      -- 语言缩写
      ,                                                 as lang_name      -- 语言名称
      ,VersionCode                                      as ver_no         -- 版本号
      ,DeviceName                                       as src_dev_mdl    -- 源设备型号
      ,split_part( substr(a1.DeviceName,1,instr(a1.DeviceName, ' (') - 1)
                  ,' '
                  ,1
                 )                                      as mfr            -- 厂商
      ,substr(substr(a1.DeviceName, 1, instr(a1.DeviceName, ' (') - 1)
             ,length(split_part(substr(a1.DeviceName, 1, instr(a1.DeviceName, ' (') - 1), ' ', 1)) + 2
             )                                          as dev_mdl        -- 设备型号
      ,a1.AnrCount                                      as anr_num        -- ANR个数
      ,a1.AnrRate                                       as anr_rt         -- ANR率
      ,a1.AnrGlobalRate                                 as glb_anr_rt     -- 全局ANR率
      ,a1.SessionCount                                  as sess_num       -- 会话数
      ,a1.DeviceGuid                                    as dev_guid       -- 设备GUID
      ,now()                                            as etl_time       -- etl时间
  from ods.ods_tidb_qadata_gp_app_version_device_anr    as a1
 where a1.AnrTime = '${bf_1_dt}'
 union all
select a2.Id                                            as evt_id        -- 事件id
      ,'push'                                           as anr_type      -- ANR类型
      ,date(a2.AnrTime)                                 as anr_dt        -- ANR日期
      ,a2.ProductId                                     as product_id    -- product_id
      ,a2.Core                                          as core          -- core
      ,a2.Lang                                          as lang_abbr     -- 语言缩写
      ,                                                 as lang_name     -- 语言名称
      ,a2.VersionCode                                   as ver_no        -- 版本号
      ,a2.DeviceName                                    as src_dev_mdl   -- 源设备型号
      ,substring_index(a2.DeviceName, ' ', 1)           as mfr           -- 厂商
      ,substring_index(a2.DeviceName, ' ', -1)          as dev_mdl       -- 设备型号
      ,a2.AnrCount                                      as anr_num       -- ANR个数
      ,a2.AnrRate                                       as anr_rt        -- ANR率
      ,a2.AnrGlobalRate                                 as glb_anr_rt    -- 全局ANR率
      ,null                                             as sess_num      -- 会话数
      ,a2.DeviceGuid                                    as dev_guid      -- 设备GUID
      ,now()                                            as etl_time      -- etl时间
  from ods.ods_tidb_qadata_gp_app_push_device_anr       as a2
 where a2.AnrTime = '${bf_1_dt}'