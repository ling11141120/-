create or replace view dwd.dwd_user_short_video_user_login_view (
     id                    comment "主键"
    ,create_time           comment "创建时间"
    ,dt                    comment "create_time 分区"
    ,product_id            comment "产品id"
    ,appver                comment "版本号"
    ,sign                  comment "签名"
    ,corever               comment "核心版本"
    ,locale                comment "区域设置"
    ,user_id               comment "用户id"
    ,sid                   comment "会话id"
    ,sh                    comment "高度"
    ,lang_id               comment "语言id"
    ,unique_cdreader_id    comment "唯一读卡器id"
    ,time_stamp            comment "时间戳"
    ,ver                   comment "版本"
    ,send_id               comment "发送id"
    ,device2               comment "设备2"
    ,sw                    comment "宽度"
    ,chl                   comment "渠道"
    ,sys_language          comment "系统语言"
    ,mt                    comment "类型"
    ,idfa                  comment "idfa"
    ,osver                 comment "操作系统版本"
    ,build                 comment "构建版本"
    ,appid                 comment "应用id"
    ,x                     comment "x"
    ,utc_offset            comment "utc偏移量"
    ,guid                  comment "guid"
    ,support_utc_time      comment "支持utc时间"
    ,device                comment "设备"
    ,android_id            comment "android id"
    ,etl_time              comment "etl清洗时间"
)
comment "短剧-用户登录记录明细表" 
as
select id
      ,createtime          as create_time
      ,date(createtime)    as dt
      ,6833                as product_id
      ,appver
      ,sign
      ,corever
      ,locale
      ,userid              as user_id
      ,sid
      ,sh
      ,langid              as lang_id
      ,uniquecdreaderid    as unique_cdreader_id
      ,timestamp           as time_stamp
      ,ver
      ,sendid              as send_id
      ,device2
      ,sw
      ,chl
      ,syslanguage         as sys_language
      ,mt
      ,idfa
      ,osver
      ,build
      ,appid
      ,x
      ,utcoffset           as utc_offset
      ,guid
      ,supportutctime      as support_utc_time
      ,device
      ,androidid           as android_id
      ,now()               as etl_time
  from ods.ods_tidb_short_video_log_client_info
 where cast(userid as int) > 0
;