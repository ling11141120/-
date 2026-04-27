----------------------------------------------------------------
-- 程序功能：短剧当日是否开启即时通信状态日表
-- 程序名： P_dim_sv_user_device_im_open_status_df
-- 目标表： dim.dim_sv_user_device_im_open_status_df
-- 负责人： xjc
-- 开发日期：2026-04-07
-- 版本号： v0.0.1
----------------------------------------------------------------

insert into dim.dim_sv_user_device_im_open_status_df
select '${bf_1_dt}'                  as dt                           -- 日期
      ,id                            as id                           -- id
      ,appver                        as app_ver                      -- app版本号
      ,sign                          as sign                         -- 签名
      ,corever                       as core                         -- 核心版本
      ,locale                        as locale                       -- 区域设置
      ,userid                        as user_id                      -- 用户ID
      ,sid                           as sid                          -- 会话ID
      ,sh                            as sh                           -- 高度
      ,langid                        as language_id                  -- 语言ID
      ,uniquecdreaderid              as uniquecdreader_id            -- 唯一读卡器ID，UNI索引
      ,timestamp                     as timestamp                    -- 时间戳
      ,from_timestamp                as from_timestamp               -- 创建时间
      ,ver                           as ver                          -- 版本
      ,sendid                        as sendid                       -- 发送ID
      ,device2                       as device2                      -- 设备型号
      ,sw                            as sw                           -- 宽度
      ,chl                           as chl                          -- 渠道
      ,syslanguage                   as syslanguage                  -- 系统语言
      ,mt                            as mt                           -- 类型
      ,osver                         as osver                        -- 操作系统版本
      ,build                         as build                        -- 构建版本
      ,appid                         as app_id                       -- 应用ID
      ,utcoffset                     as utcoffset                    -- UTC偏移量
      ,guid                          as guid                         -- GUID
      ,supportutctime                as supportutctime               -- 支持UTC时间
      ,device                        as device                       -- 设备
      ,androidid                     as androidid                    -- Android ID
      ,devicetoken                   as device_token                 -- device_token
      ,signnotify                    as sign_notify                  -- 是否开启签到推送
      ,appnotify                     as app_notify                   -- 是否开启推送
      ,regionid                      as region_id                    -- 归属区域 id，1：香港，2：北美；
      ,realtimeactivitynotify        as real_time_activity_notify    -- 实时活动启用状态：1不支持，2支持未开启，3支持未授权，4支持
      ,countrycode                   as countrycode                  -- 国家代码
      ,playwindow                    as playwindow                   -- 小窗播放通知权限
      ,apptimesensitivestate         as apptimesensitivestate        -- 即时通信(实时活动)通知权限：1-开启,0-关闭
      ,devicetokenupdatetime         as devicetokenupdatetime        -- deviceToken 上报时间
      ,now()                         as etl_time                     -- ETL时间
  from (select id
              ,appver
              ,sign
              ,corever
              ,locale
              ,userid
              ,sid
              ,sh
              ,langid
              ,uniquecdreaderid
              ,timestamp
              ,from_unixtime(timestamp/1000)    as from_timestamp
              ,ver
              ,sendid
              ,device2
              ,sw
              ,chl
              ,syslanguage
              ,mt
              ,osver
              ,build
              ,appid
              ,utcoffset
              ,guid
              ,supportutctime
              ,device
              ,androidid
              ,devicetoken
              ,signnotify
              ,appnotify
              ,regionid
              ,realtimeactivitynotify
              ,countrycode
              ,playwindow
              ,apptimesensitivestate
              ,devicetokenupdatetime
              ,row_number() over(partition by uniquecdreaderid, corever order by timestamp desc)    as rn
          from ods.ods_tidb_short_video_device_info    as b1
         where apptimesensitivestate is not null
       )    as a1
 where rn=1
;