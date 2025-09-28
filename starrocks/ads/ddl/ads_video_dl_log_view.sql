create or replace view ads.ads_short_video_video_dl_log_v1_view (
     id                 comment "自增id"
    ,createtime          comment "创建时间"
    ,appid               comment "应用程序id"
    ,appver              comment "版本号"
    ,chl                 comment "渠道值"
    ,mt                  comment "终端"
    ,core                comment "corever"
    ,rowdata             comment "行数据"
    ,decryptdata         comment "加密数据"
    ,uniquecdreaderid    comment "唯一id"
    ,currentlanguage     comment "语言id"
    ,sdk                 comment "sdk"
    ,regionid            comment "归属区域 id,1:香港,2:北美;"
    ,sr_updatetime       comment "ods同步时间"
    ,sr_createtime       comment "starrocks数据注入时间"
    ,hasopen             comment "客户端上报isOpen,首次打开"
    ,seriesid            comment "拉起短剧id"
    ,defaultdltype       comment "1029上报使用 归因类型 0:DL=0,1: UAC归因 2:IP+UA匹配,3 IP匹配 （归因判断条件就是 sdk=7时候 DefaultDLType 字段类型判断）"
)
comment '短剧服务端表'
as
select id
      ,createtime
      ,appid
      ,appver
      ,chl
      ,mt
      ,core
      ,rowdata
      ,decryptdata
      ,uniquecdreaderid
      ,currentlanguage
      ,sdk
      ,regionid
      ,sr_updatetime
      ,sr_createtime
      ,hasopen
      ,seriesid
      ,defaultdltype
  from ods.ods_tidb_short_video_video_dl_log
 where HasOpen = 1 and SeriesId is not null
;